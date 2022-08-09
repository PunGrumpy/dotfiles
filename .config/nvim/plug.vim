if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

if has("nvim")
  Plug 'https://github.com/hoob3rt/lualine.nvim'
  Plug 'https://github.com/kristijanhusak/defx-git'
  Plug 'https://github.com/kristijanhusak/defx-icons'
  Plug 'https://github.com/Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'https://github.com/neovim/nvim-lspconfig'
  Plug 'https://github.com/williamboman/nvim-lsp-installer'
  Plug 'https://github.com/tami5/lspsaga.nvim'
  Plug 'https://github.com/folke/lsp-colors.nvim'
  Plug 'https://github.com/L3MON4D3/LuaSnip'
  Plug 'https://github.com/hrsh7th/cmp-nvim-lsp'
  Plug 'https://github.com/hrsh7th/cmp-buffer'
  Plug 'https://github.com/hrsh7th/nvim-cmp'
  Plug 'https://github.com/nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'https://github.com/kyazdani42/nvim-web-devicons'
  Plug 'https://github.com/onsails/lspkind-nvim'
  Plug 'https://github.com/nvim-lua/popup.nvim'
  Plug 'https://github.com/nvim-lua/plenary.nvim'
  Plug 'https://github.com/nvim-telescope/telescope.nvim'
  Plug 'https://github.com/windwp/nvim-autopairs'
  Plug 'https://github.com/windwp/nvim-ts-autotag'
endif

Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }

call plug#end()
