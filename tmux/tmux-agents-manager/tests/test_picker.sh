#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cat > "$TMP_DIR/tmux" <<'EOF'
#!/usr/bin/env bash
case "${1:-}" in
  display-message)
    printf '%s\n' 'test-session'
    ;;
  list-panes)
    printf '%s\n' "${FAKE_TMUX_ROWS:-}"
    ;;
  show-option)
    [ "${*: -1}" = '@agent_commands' ] && printf '%s' "${FAKE_AGENT_COMMANDS:-}"
    ;;
  *)
    printf 'unexpected tmux command: %s\n' "$*" >&2
    exit 1
    ;;
esac
EOF

cat > "$TMP_DIR/ps" <<'EOF'
#!/usr/bin/env bash
field=''
case "$*" in
  *'-o args='*) field='args';;
  *'-o pgid='*) field='pgid';;
  *'-o tpgid='*) field='tpgid';;
esac
pid="${*: -1}"
case "$field:$pid" in
  args:202|args:303|args:404|args:505) printf '%s\n' 'zsh';;
  args:220) printf '%s\n' '/usr/bin/node --require hook.js /usr/local/bin/codex --full-auto';;
  args:330) printf '%s\n' '/usr/bin/vim codex';;
  args:440) printf '%s\n' '/usr/bin/vim README.md';;
  args:441) printf '%s\n' '/usr/local/bin/codex --full-auto';;
  args:550) printf '%s\n' '/usr/bin/node --eval=code codex';;
  tpgid:202) printf '%s\n' '220';;
  tpgid:303) printf '%s\n' '330';;
  tpgid:404) printf '%s\n' '440';;
  tpgid:505) printf '%s\n' '550';;
  pgid:220) printf '%s\n' '220';;
  pgid:330) printf '%s\n' '330';;
  pgid:440) printf '%s\n' '440';;
  pgid:441) printf '%s\n' '441';;
  pgid:550) printf '%s\n' '550';;
esac
EOF

cat > "$TMP_DIR/pgrep" <<'EOF'
#!/usr/bin/env bash
pid="${*: -1}"
case "$pid" in
  202) printf '%s\n' '220';;
  303) printf '%s\n' '330';;
  404) printf '%s\n' '440' '441';;
  505) printf '%s\n' '550';;
esac
EOF

chmod +x "$TMP_DIR/tmux" "$TMP_DIR/ps" "$TMP_DIR/pgrep"
export PATH="$TMP_DIR:$PATH"
export FAKE_AGENT_COMMANDS=''

failures=0

assert_equal() {
  local name="$1" expected="$2" actual="$3"
  if [ "$actual" = "$expected" ]; then
    printf 'PASS: %s\n' "$name"
  else
    printf 'FAIL: %s\nexpected: %q\nactual:   %q\n' "$name" "$expected" "$actual" >&2
    failures=$((failures + 1))
  fi
}

test_direct_codex_command() {
  local output expected
  export FAKE_TMUX_ROWS='%1|codex|101||1.0|Codex direct|~/direct'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  expected=$'%1\t⚪ idle\t◉\t1.0\tCodex direct\t~/direct'
  assert_equal 'detects a direct Codex pane' "$expected" "$output"
}

test_wrapped_codex_command() {
  local output expected
  export FAKE_TMUX_ROWS='%2|zsh|202||2.0|Codex wrapped|~/wrapped'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  expected=$'%2\t⚪ idle\t◉\t2.0\tCodex wrapped\t~/wrapped'
  assert_equal 'detects Codex behind a wrapper process' "$expected" "$output"
}

test_agent_name_argument_is_omitted() {
  local output
  export FAKE_TMUX_ROWS='%3|zsh|303||3.0|Editor argument|~/editor'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  assert_equal 'omits commands with Codex only as an argument' '' "$output"
}

test_background_codex_is_omitted() {
  local output
  export FAKE_TMUX_ROWS='%4|zsh|404||4.0|Background Codex|~/background'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  assert_equal 'omits Codex when another process owns the foreground' '' "$output"
}

test_eval_argument_is_omitted() {
  local output
  export FAKE_TMUX_ROWS='%13|zsh|505||13.0|Node eval|~/eval'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  assert_equal 'omits agent names passed to runtime eval mode' '' "$output"
}

test_existing_identities_remain_available() {
  local output expected
  export FAKE_TMUX_ROWS=$'%5|claude|501||5.0|Claude|~/claude\n%6|pi|601||6.0|Pi|~/pi\n%7|omp|701||7.0|OMP|~/omp\n%8|hermes|801||8.0|Hermes|~/hermes\n%9|feynman.js|901||9.0|Feynman|~/feynman'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  expected=$'%5\t⚪ idle\t◈\t5.0\tClaude\t~/claude\n%6\t⚪ idle\tπ\t6.0\tPi\t~/pi\n%7\t⚪ idle\t✦\t7.0\tOMP\t~/omp\n%8\t⚪ idle\t♞\t8.0\tHermes\t~/hermes\n%9\t⚪ idle\tƒ\t9.0\tFeynman\t~/feynman'
  assert_equal 'preserves existing built-in identities' "$expected" "$output"
}

test_command_alias_replaces_builtin() {
  local output expected
  export FAKE_AGENT_COMMANDS='codex=codex-cli'
  export FAKE_TMUX_ROWS=$'%10|codex-cli|1001||10.0|Custom Codex|~/custom\n%11|codex|1101||11.0|Builtin Codex|~/builtin'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  expected=$'%10\t⚪ idle\t◉\t10.0\tCustom Codex\t~/custom'
  assert_equal 'replaces a built-in command alias' "$expected" "$output"
  export FAKE_AGENT_COMMANDS=''
}

test_empty_command_alias_disables_identity() {
  local output
  export FAKE_AGENT_COMMANDS='codex='
  export FAKE_TMUX_ROWS='%12|codex|1201||12.0|Disabled Codex|~/disabled'
  output="$(bash "$ROOT/scripts/picker.sh" --list)"
  assert_equal 'disables an identity with an empty alias assignment' '' "$output"
  export FAKE_AGENT_COMMANDS=''
}

test_direct_codex_command
test_wrapped_codex_command
test_agent_name_argument_is_omitted
test_background_codex_is_omitted
test_eval_argument_is_omitted
test_existing_identities_remain_available
test_command_alias_replaces_builtin
test_empty_command_alias_disables_identity

if [ "$failures" -ne 0 ]; then
  exit 1
fi
