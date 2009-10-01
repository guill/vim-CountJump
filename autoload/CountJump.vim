" CountJump.vim: Move to a buffer position via repeated jumps (or searches). 
"
" DEPENDENCIES:
"
" Copyright: (C) 2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	004	14-Feb-2009	Renamed from 'custommotion.vim' to
"				'CountJump.vim' and split off motion and
"				text object parts. 
"	003	13-Feb-2009	Added functionality to create inner/outer text
"				objects delimited by the same begin and end
"				patterns. 
"	002	13-Feb-2009	Now also allowing end match for the
"				patternToEnd. 
"	001	12-Feb-2009	file creation

function! CountJump#CountSearch( count, searchArguments )
    for l:i in range(1, a:count)
	let l:lineNum = call('search', a:searchArguments)
	if ! l:lineNum
	    " Ring the bell to indicate that no further match exists. This is
	    " unlike the old vi-compatible motions, but consistent with newer
	    " movements like ]s. 
	    "
	    " As long as this mapping does not exist, it causes a beep in both
	    " normal and visual mode. This is easier than the customary "normal!
	    " \<Esc>", which only works in normal mode. 
	    execute "normal \<Plug>RingTheBell"

	    return l:lineNum
	endif
    endfor

    " Open the fold at the final search result. This makes the search work like
    " the built-in motions, and avoids that some visual selections get stuck at
    " a match inside a closed fold. 
    normal! zv

    return l:lineNum
endfunction
function! CountJump#CountJump( mode, ... )
"*******************************************************************************
"* PURPOSE:
"   Implement a custom motion by jumping to the <count>th occurrence of the
"   passed pattern. 
"
"* ASSUMPTIONS / PRECONDITIONS:
"   None. 
"
"* EFFECTS / POSTCONDITIONS:
"   Normal mode: Jumps to the <count>th occurrence. 
"   Visual mode: Extends the selection to the <count>th occurrence. 
"   If the pattern doesn't match (<count> times), a beep is emitted. 
"
"* INPUTS:
"   a:mode  Mode in which the search is invoked. Either 'n' or 'v'. 
"   ...	    Arguments to search(). 
"
"* RETURN VALUES: 
"   Line number of match or 0, like search(). 
"*******************************************************************************
    normal! m'
    if a:mode ==# 'v'
	normal! gv
    endif
    return CountJump#CountSearch(v:count1, a:000)
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
