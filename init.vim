if exists('g:vscode')
  " Visual mode indenting stays in visual
  let mapleader = " "
  vnoremap < <gv
  vnoremap > >gv
  " Move lines
  vnoremap J :call VSCodeNotify('editor.action.moveLinesDownAction')<CR>
  vnoremap K :call VSCodeNotify('editor.action.moveLinesUpAction')<CR>

  " Normal + leader mappings
  nnoremap <silent> <leader>/ :call VSCodeNotify('editor.action.commentLine')<CR>

  " Buffer nav
  nnoremap <S-h> :bprevious<CR>
  nnoremap <S-l> :bnext<CR>

  " Splits
  nnoremap <leader>v :vsplit<CR>
  nnoremap <leader>s :split<CR>

  " Pane focuses
  nnoremap <leader>h :call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
  nnoremap <leader>j :call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
  nnoremap <leader>k :call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
  nnoremap <leader>l :call VSCodeNotify('workbench.action.focusRightGroup')<CR>

  " Explorer, save, close tab, run tests...
  nnoremap <leader>ne :call VSCodeNotify('workbench.explorer.fileView.focus')<CR>
  nnoremap <leader>w :call VSCodeNotify('workbench.action.file.save')<CR>
  nnoremap gh :call VSCodeNotify('editor.action.showDefinitionPreviewHover')<CR>
  nnoremap <leader>1 :call VSCodeNotify('workbench.action.openEditorAtIndex1')<CR>
  nnoremap <leader>2 :call VSCodeNotify('workbench.action.openEditorAtIndex2')<CR>
  nnoremap <leader>3 :call VSCodeNotify('workbench.action.openEditorAtIndex3')<CR>
  nnoremap <leader>f :call VSCodeNotify('actions.find')<CR>
  nnoremap <leader>r :call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
  nnoremap <leader>F :call VSCodeNotify('workbench.action.findInFiles')<CR>
  nnoremap <leader>e :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
  nnoremap <leader>c :call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
  nnoremap <leader>t :call VSCodeNotify('testing.runAtCursor')<CR>
  nnoremap <leader>T :call VSCodeNotify('testing.runCurrentFile')<CR>
endif
