" File: ftplugin/swift.vim
" Author: Elias Toivanen
" Description: Filetype plugin for Swift
" Last Change: 2019-10-13

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

" Settings {{{1
setlocal formatoptions-=t formatoptions+=croqnl
silent! setlocal formatoptions+=j

" cc=+1 is common, but showing it for the comment width kind of sucks.
" Let's pick 120 characters instead, that's a good length.
setlocal colorcolumn=121
setlocal suffixesadd=.swift
setlocal comments=s1:/**,mb:*,ex:*/,s1:/*,mb:*,ex:*/,:///,://
setlocal commentstring=//%s

if !exists("b:swift_last_swift_args") || !exists("b:swift_last_args")
    let b:swift_last_swift_args = []
    let b:swift_last_args = []
endif

" Miscellaneous {{{1

" Add support to NERDCommenter
if !exists('g:swift_setup_NERDCommenter')
    let g:swift_setup_NERDCommenter = 1

    let s:delimiter_map = { 'swift': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' } }

    if exists('g:NERDDelimiterMap')
        call extend(g:NERDDelimiterMap, s:delimiter_map)
    elseif exists('g:NERDCustomDelimiters')
        call extend(g:NERDCustomDelimiters, s:delimiter_map)
    else
        let g:NERDCustomDelimiters = s:delimiter_map
    endif
    unlet s:delimiter_map
endif

" Check for 'showmatch' because it doesn't work right with \()
if &showmatch && !get(g:, 'swift_suppress_showmatch_warning', 0)
    echohl WarningMsg
    echomsg "Swift string interpolations do not work well with 'showmatch'"
    echohl None
    echomsg "It is recommended that you turn it off and use matchparen instead"
    let g:swift_suppress_showmatch_warning = 1
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sw=4 ts=4:
