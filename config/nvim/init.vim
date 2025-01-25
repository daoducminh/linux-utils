set guicursor=v-c-sm:block,n-i-ci-ve:ver25,r-cr-o:hor2

call plug#begin()

Plug 'kaicataldo/material.vim', { 'branch': 'main' }

call plug#end()

let g:material_theme_style = 'palenight'
colorscheme material
