" Elias' custom TeX bindings

let custom_template = expand('$HOME').'/.vim/after/ftplugin/tex_skeleton.tex.custom'

setlocal tw=72 sw=2
setlocal tabstop=8 

noremap <buffer><silent> <C-F>  :silent! /\(end{\)\@<!\(section\\|chapter\)<CR>
noremap <buffer><silent> <C-B>  :silent! ?\(end{\)\@<!\(section\\|chapter\)<CR>
"noremap <buffer><silent> <F1> :call tex_nine#InsertSkeleton(custom_template)<CR>

" Change between boldface, italics, typewriter...
vmap <buffer><expr> bf tex_nine#ChangeFontStyle('bf')
vmap <buffer><expr> it tex_nine#ChangeFontStyle('it')
vmap <buffer><expr> rm tex_nine#ChangeFontStyle('rm')
vmap <buffer><expr> sf tex_nine#ChangeFontStyle('sf')
vmap <buffer><expr> tt tex_nine#ChangeFontStyle('tt')
vmap <buffer> up di\text{}<Left><C-R>"
