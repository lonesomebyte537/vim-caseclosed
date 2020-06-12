function! CaseClosed(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\w'
      let start -= 1
    endwhile
    return start
  else
    " Build a list of words over all open buffers
    let buffers = map(filter(copy(getbufinfo()), 'v:val.listed'), 'v:val.bufnr')
    let words = []
    for bufIdx in buffers
      let words = words + split(join(getbufline(bufIdx, 1, '$')), '\W\+')
    endfor
    if 1
      let scannedFiles=[]
      let filesToScan=[]
      let lines = getline(1, '$')
      " Check for included files
      while 1
        for line in lines
          let matches = matchlist(line, "\\s*#include\\s\\+[<\"]\\+\\([^>\"]\\+\\)[<\"]")
          if empty(matches)==0
            let filename = findfile(matches[1])
            if filename!=""
              if index(scannedFiles, filename)<0
                call add(filesToScan, filename)
                call add(scannedFiles, filename)
              endif
            endif
          endif
        endfor
        if empty(filesToScan)
          break
        endif
        let filename = filesToScan[0]
        let filesToScan = filesToScan[1:]
        echo "Scanning ".filename."..."
        let lines = readfile(filename)
        let words = words + split(join(lines), '\W\+')
      endwhile
    endif

    " Remove duplicates
    let words = filter(copy(words), 'index(words, v:val, v:key+1)==-1')
    let result = []

    let fragments = split(a:base, '\ze[A-Z]')
    let query1 = join(fragments, ".*")
    call map(fragments, {idx, val -> tolower(val)})
    let query2 = join(fragments, ".*_")
    let query = "\\<\\(".query1."\\|".query2."\\).*"

    for word in words
      let match = matchstr(word, query)
      if empty(match)
      else
        call add(result, word)
      endif
    endfor

    return result
  endif
endfunction
set completefunc=CaseClosed
