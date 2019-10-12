"**********************************************************
" Vim colorscheme that emulates the default GUI colorscheme
"        Requires a terminal with 256 color support
"                Author: Elias Toivanen
"**********************************************************

hi clear
set background=light

if exists("syntax_on")
  syntax reset
endif

hi SpecialKey      ctermfg=21 guifg=#0000ff
hi NonText         cterm=bold ctermfg=21 gui=bold guifg=#0000ff
hi Directory       ctermfg=21 guifg=#0000ff
hi ErrorMsg        ctermfg=231 ctermbg=196 guifg=#ffffff guibg=#ff0000
hi IncSearch       cterm=reverse gui=reverse
hi Search          ctermbg=226 guibg=#ffff00
hi MoreMsg         cterm=bold ctermfg=29 gui=bold guifg=#2e8b57
hi ModeMsg         cterm=bold gui=bold
hi LineNr          ctermfg=124 guifg=#a52a2a
hi Question        cterm=bold ctermfg=29 gui=bold guifg=#2e8b57
hi StatusLine      cterm=bold ctermfg=231 ctermbg=16 gui=bold guifg=#ffffff guibg=#000000
hi VertSplit       ctermfg=231 ctermbg=16 guifg=#ffffff guibg=#000000
hi Title           cterm=bold ctermfg=201 gui=bold guifg=#ff00ff
hi Visual          ctermbg=251 guibg=#d3d3d3
hi VisualNOS       cterm=bold gui=bold
hi WarningMsg      ctermfg=196 guifg=#ff0000
hi WildMenu        ctermfg=16 ctermbg=226 guifg=#000000 guibg=#ffff00
hi Folded          ctermfg=18 ctermbg=251 guifg=#00008b guibg=#d3d3d3
hi FoldColumn      ctermfg=18 ctermbg=249 guifg=#00008b guibg=#bebebe
hi DiffAdd         ctermbg=152 guibg=#add8e6
hi DiffChange      ctermbg=219 guibg=#ffbbff
hi DiffDelete      cterm=bold ctermfg=21 ctermbg=195 gui=bold guifg=#0000ff guibg=#e0ffff
hi DiffText        cterm=bold ctermbg=196 ctermfg=16 gui=bold guibg=#ff0000
hi SignColumn      ctermfg=18 ctermbg=249 guifg=#00008b guibg=#bebebe
hi Conceal         ctermfg=7 ctermbg=242 guifg=LightGrey guibg=DarkGrey
hi SpellBad        ctermbg=196 ctermfg=231 term=reverse  gui=undercurl guisp=Red
hi SpellCap        term=reverse ctermfg=231 ctermbg=81 gui=undercurl guisp=Blue
hi SpellRare       term=reverse ctermbg=225 gui=undercurl guisp=Magenta
hi SpellLocal      term=underline ctermbg=14 gui=undercurl guisp=DarkCyan
hi Pmenu           ctermbg=219 guibg=#ffbbff  
hi PmenuSel        cterm=reverse ctermbg=219 guibg=#bebebe 
hi PmenuSbar       ctermbg=249 guibg=#bebebe 
hi PmenuThumb      ctermfg=231 ctermbg=16 guifg=#ffffff guibg=#000000
hi TabLine         cterm=NONE ctermbg=251 guibg=#d3d3d3
hi TabLineSel      ctermbg=251 ctermfg=256
hi TabLineFill     ctermfg=251 ctermbg=251
hi CursorColumn    ctermbg=253 guibg=#e5e5e5
hi CursorLine      ctermbg=253 guibg=#e5e5e5
hi ColorColumn     ctermbg=217 guibg=#ffbbbb
hi Cursor          ctermfg=231 ctermbg=16 guifg=#ffffff guibg=#000000
hi lCursor         ctermfg=231 ctermbg=16 guifg=#ffffff guibg=#000000
hi MatchParen      ctermbg=51 guibg=#00ffff
hi Comment         ctermfg=21 guifg=#0000ff
hi Constant        ctermfg=201 guifg=#ff00ff
hi Special         ctermfg=62 guifg=#6a5acd
hi Identifier      ctermfg=30 guifg=#008b8b
hi Statement       cterm=bold ctermfg=124 gui=bold guifg=#a52a2a
hi PreProc         ctermfg=129 guifg=#a020f0
hi Type            cterm=bold ctermfg=29 gui=bold guifg=#2e8b57
hi Underlined      cterm=underline ctermfg=62 gui=underline guifg=#6a5acd
hi Ignore          ctermfg=231 guifg=#ffffff
hi Error           ctermfg=231 ctermbg=196 guifg=#ffffff guibg=#ff0000
hi Todo            ctermfg=21 ctermbg=226 guifg=#0000ff guibg=#ffff00

let colors_name = "terminal"
