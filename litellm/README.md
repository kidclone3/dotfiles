# LiteLLM Proxy for Z.AI Coding Plan

LiteLLM sits between Claude Code and Z.AI, providing **fallback routing**, **latency-based load balancing**, and **spend tracking** — all while keeping the native Anthropic `/v1/messages` format intact (no format translation).

```
Claude Code → LiteLLM (localhost:4000) → Z.AI (/api/anthropic)
```

---

## 1. Install LiteLLM

```bash
pip install 'litellm[proxy]'
```

Verify:

```bash
litellm --version
```

> **Note:** Requires Python 3.9+. If you use `uv`, run `uv pip install 'litellm[proxy]'` instead.

---

## 2. Set your Z.AI API key

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export ZAI_API_KEY="your-z-ai-api-key-here"
```

Then reload:

```bash
source ~/.zshrc   # or ~/.bashrc
```

---

## 3. Apply the config

The config lives at `litellm/.litellm/config.yaml` in this repo. LiteLLM looks for a config file at startup.

**Option A — Symlink (recommended):**

```bash
mkdir -p ~/.litellm
ln -sf "$HOME/Documents/tools/dotfiles/litellm/.litellm/config.yaml" ~/.litellm/config.yaml
```

**Option B — Copy:**

```bash
mkdir -p ~/.litellm
cp "$HOME/Documents/tools/dotfiles/litellm/.litellm/config.yaml" ~/.litellm/config.yaml
```

> Symlinking is preferred — any updates you pull from the repo are automatically applied.

---

## 4. Start the proxy

```bash
litellm --config ~/.litellm/config.yaml --port 4000
```

To run in the background:

```bash
nohup litellm --config ~/.litellm/config.yaml --port 4000 > ~/.litellm/proxy.log 2>&1 &
```

Or with Docker:

```bash
docker run -d \
  --name litellm-proxy \
  -p 4000:4000 \
  -e ZAI_API_KEY=$ZAI_API_KEY \
  -v ~/.litellm/config.yaml:/app/config.yaml \
  ghcr.io/berriai/litellm:main-latest \
  --config /app/config.yaml --port 4000
```

Verify it's running:

```bash
curl http://localhost:4000/health
```

---

## 5. Configure Claude Code to use LiteLLM

Edit `~/.claude/settings.json` and add the `env` block:

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "sk-litellm-local",
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "API_TIMEOUT_MS": "3000000",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-opus",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-sonnet",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-haiku"
  }
}
```

**What each setting does:**

| Setting | Purpose |
|---------|---------|
| `ANTHROPIC_AUTH_TOKEN` | Matches `master_key` in config — authenticates to the local proxy |
| `ANTHROPIC_BASE_URL` | Routes all Claude Code requests through the local proxy |
| `API_TIMEOUT_MS` | 50-minute timeout for long-running tasks |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Maps the Opus tier to `glm-opus` model group |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Maps the Sonnet tier to `glm-sonnet` model group |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Maps the Haiku tier to `glm-haiku` model group |

After saving, **restart Claude Code** for the changes to take effect.

---

## 6. Verify the setup end-to-end

```bash
# 1. Check proxy is healthy
curl http://localhost:4000/health

# 2. List available models through the proxy
curl -H "Authorization: Bearer sk-litellm-local" http://localhost:4000/v1/models

# 3. Test a simple completion
curl -X POST http://localhost:4000/v1/messages \
  -H "Authorization: Bearer sk-litellm-local" \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model":"glm-haiku","max_tokens":50,"messages":[{"role":"user","content":"Say hi"}]}'
```

If all three return valid responses, Claude Code will work through the proxy.

---

## Model mapping reference

| Claude Code tier | Proxy model | Z.AI model | Fallback chain |
|-----------------|-------------|------------|----------------|
| Opus | `glm-opus` | glm-5.1, glm-5-turbo | → glm-sonnet → glm-haiku |
| Sonnet | `glm-sonnet` | glm-4.7, glm-4.6 | → glm-haiku |
| Haiku | `glm-haiku` | glm-4.5-air | — |

---

## Troubleshooting

**`/v1/responses 404` errors:** This config uses the Anthropic-native endpoint (`/api/anthropic`), so the Responses API is never called. If you see 404s, make sure the config hasn't been changed to use an OpenAI-compatible endpoint.

**Proxy not starting:** Check that `ZAI_API_KEY` is set (`echo $ZAI_API_KEY`). Check the log output for port conflicts.

**Claude Code still hitting Anthropic directly:** Verify `~/.claude/settings.json` has the `env` block and you restarted Claude Code after saving.

**Connection refused on localhost:4000:** The proxy isn't running. Start it with the command in step 4.
