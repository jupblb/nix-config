function YankToSystemClipboard()
  if v:event.operator is 'y' && v:event.regname is ''
    execute 'OSCYankReg "'
  endif
endfunction

autocmd TextYankPost * call YankToSystemClipboard()

