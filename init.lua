-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable highlight groups
vim.opt.termguicolors = true
vim.o.termguicolors = true

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager

  -- LSP Configuration & Plugins
  use { 'neovim/nvim-lspconfig',
    requires = { -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim', -- Useful status updates for LSP
      'folke/neodev.nvim', -- Additional lua configuration, makes nvim stuff amazing
    },
  }

  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' }} -- Autocomplete
  use { 'nvim-treesitter/nvim-treesitter', run = function() pcall(require('nvim-treesitter.install').update{ with_sync = true }) end } -- Highlight, edit, and navigate code
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' } -- Additional text objects via treesitter
  use { 'akinsho/toggleterm.nvim', tag = '*', config = function() require("toggleterm").setup() end } -- terminal

  -- debugger
  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use "ellisonleao/gruvbox.nvim" -- Theme
  use "RRethy/vim-illuminate" -- destacar variavel que o cursor esta em cima
  use 'lewis6991/impatient.nvim' -- iniciar mais rapido os modulos
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- comments
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } } -- Fuzzy Finder (files, lsp, etc)

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')

  if has_plugins then plugins(use) end
  if is_bootstrap then require('packer').sync() end
end)

pcall(require('impatient'))

-- reiniciar para as att funcionarem.
if is_bootstrap then print 'restart nvim' return end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Setting options `:help vim.o`
vim.o.hlsearch = true     -- Set highlight on search
vim.wo.number = true      -- Make line numbers default
vim.o.mouse = 'a'         -- Enable mouse mode
vim.o.breakindent = true  -- Enable break indent
vim.o.undofile = true     -- Save undo history

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 200
vim.wo.signcolumn = 'yes'

---------------------------------------------------------------------------
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Basic Keymaps Set <space> as the leader key`:help mapleader` NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear highlights
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true })

-- better paste
vim.keymap.set("v", "p", '"_dP', { silent = true })
vim.keymap.set('n', '<leader>p', 'i<C-R>+')
vim.keymap.set('i', '<leader>p', '<C-R>+')
vim.keymap.set('i', '<leader>P', '<C-r>"')

-- ctrl-s to save
vim.keymap.set("n", "<C-s>", ':w<CR>', { silent = true })

-- move whole line up/down
vim.keymap.set('n', '<A-j>', ':m +1<CR>', { silent = true })
vim.keymap.set('n', '<A-k>', ':m -2<CR>', { silent = true })

-- put/remove tabs
vim.keymap.set("n", "<tab>", ":><CR>", { silent = true })
vim.keymap.set("n", "\\", ":<<CR>", { silent = true })

-- cursor always on center of window
vim.cmd("nnoremap k kzz")
vim.cmd("nnoremap j jzz")
vim.cmd("nnoremap { {zz")
vim.cmd("nnoremap } }zz")

vim.cmd("vs") -- start with vertical layout split

--------------------------------------------------------------------------- theme
require("gruvbox").setup({
  palette_overrides = {
    -- dark0_hard = "#000000",
    dark0 = "#252525", ---------- background
    -- dark0_soft = "#000000",
    dark1 = "#303030", ---------- barra lateral esquerda onde fica os breakpoints e infos sobre a linha
    dark2 = "#555555", ---------- barra de indentacao
    dark3 = "#3f3f3f", ---------- selecao de linhas
    dark4 = "#777777", ---------- numeracao da linha
    -- light0_hard = "#000000",
    -- light0 = "#000000",
    -- light0_soft = "#000000",
    light1 = "#bfbfbf", --------- palavras principais(nome de variaveis criadas)
    light2 = "#dddddd", --------- cor padrao de icone sem cor especifica
    -- light3 = "#000000",
    light4 = "#aa9989", --------- letras marcadas para chamar atencao nos menus
    bright_red = "#ab3fff", ----- palavras reservadas da linguagem(keywords)
    bright_green = "#b4ad4a", --- funcoes
    bright_yellow = "#60b34e", -- Tipos de variaveis(int, float...)
    bright_blue = "#909090", ---- nome de parametro de func e parametro de struct
    bright_purple = "#b8b773", -- numeros e constantes
    bright_aqua = "#a153d1", ---- include e defines
    bright_orange = "#a66dc8", -- pontuacao
    neutral_red = "#ff1111", ---- erro no terminal
    neutral_green = "#aa5555", -- nome de arquivo .sh no explorer
    neutral_yellow = "#ff0000",-- arquivos com erro mp explorer
    neutral_blue = "#bfbfbf", --- cor da pasta no explorer
    neutral_purple = "#cccccc",-- pasta root do explorer
    neutral_aqua = "#aa5555", --- nome de arquivo (desconhecido eu acho) no explorer
    -- neutral_orange = "#000000",
    -- faded_red = "#000000",
    -- faded_green = "#000000",
    -- faded_yellow = "#000000",
    -- faded_blue = "#000000",
    -- faded_purple = "#000000",
    -- faded_aqua = "#000000",
    -- faded_orange = "#000000",
    gray = "#5d7759", ---------- comentarios
  },
  -- transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")
-- vim.opt.guifont = { "JetBrains Mono:h13" } 
vim.opt.guifont = { "JetBrains Mono" } -- font
vim.g.neovide_transparency = 0.87
vim.g.neovide_refresh_rate = 60
vim.g.neovide_fullscreen = true
vim.g.neovide_cursor_trail_size = 0.5

--------------------------------------------------------------------------- terminal
vim.keymap.set({'n', 't'}, '<leader>t', "<cmd>ToggleTerm<CR>", { silent = true })
vim.keymap.set({'n', 't'}, '<leader>t', "<cmd>ToggleTerm<CR>", { silent = true })

local lazy = require("toggleterm.lazy")
local ui = lazy.require("toggleterm.ui")

-- open/close terminal
local function set_terminal(open)
  if (open and not ui.find_open_windows()) or (not open and ui.find_open_windows()) then
    vim.cmd("ToggleTerm")
  end
end

--------------------------------------------------------------------------- comments
require('Comment').setup{ ignore = '^$' }

vim.keymap.set("i", "<C-c>", require('Comment.api').toggle.linewise.current, { silent = true })
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

--------------------------------------------------------------------------- windows
vim.keymap.set('n', "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set('n', "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set('n', "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set('n', "<C-l>", "<C-w>l", { silent = true })

--------------------------------------------------------------------------- buffers
vim.keymap.set("n", "<C-tab>", ":bn<CR>", { silent = true })
vim.keymap.set("n", "<S-tab>", ":bp<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":bn<CR>:bd #<CR>", { silent = true })

-- Switch between header and source files
vim.keymap.set("n", "<A-o>", function()
  local extension = vim.api.nvim_command_output(":echo expand('%:e')")

  if extension == "c" then
    vim.cmd(":e %<.h")
  elseif extension == "h" then
    vim.cmd(":e %<.c")
  end
end, { silent = true })

--------------------------------------------------------------------------- highlight
local illuminate = require('illuminate')

illuminate.configure{
  providers = { 'lsp', 'treesitter' },
  delay = 0,
  under_cursor = true,
  min_count_to_highlight = 1,
}

-- vim.keymap.set({'n', 'v', 'i', 'x'}, "<leader>g", illuminate.goto_prev_reference, { silent = true })
-- vim.keymap.set({'n', 'v', 'i', 'x'}, "<leader>j", illuminate.goto_next_reference, { silent = true })
-- vim.keymap.set({'n', 'v', 'i', 'x'}, "<leader>dd", illuminate.textobj_select, { silent = true })

-- Highlight on yank `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = vim.highlight.on_yank,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

--------------------------------------------------------------------------- DAP
local dap = require('dap')
local dapui = require('dapui')
local current_os = vim.loop.os_uname().sysname

dapui.setup()

-- read launch.json from folder .vscode
require('dap.ext.vscode').load_launchjs(nil, { cppdbg = {'c', 'cpp'} })

if current_os == 'Linux' then
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
  }
elseif current_os == 'Windows' then
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    -- TODO: VERSAO PARA WINDOWS
    command = os.getenv("USER") .. '\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
    options = { detached = false }
  }
end

local function start_debug()
  if vim.api.nvim_get_mode().mode == 't' then set_terminal(false) end

  dap.continue()
  local started = type(dap.session()) == 'table'

  if not started then
    print('cannot debug an empty file!')
  end
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  set_terminal(false)
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local function run(clear_console)
  if clear_console then vim.cmd('TermExec cmd="clear"') end
  vim.cmd('TermExec cmd="task run"')
end

local function build(run_app)
  if run_app then
    vim.cmd('TermExec cmd="task build_all_run"')
  else
    vim.cmd('TermExec cmd="task build_all"')
  end
end

vim.keymap.set('n', "<leader>4", dapui.eval, { silent = true })                               -- inspect values
vim.keymap.set({'n', 't'}, "<esc>", function() set_terminal(false) end, { silent = true })    -- close terminal
vim.keymap.set({'n', 't'}, "<leader>5", start_debug, { silent = true })                       -- run debug
vim.keymap.set({'n', 't'}, "<leader>6", function() build(false) end, { silent = true })       -- build
vim.keymap.set({'n', 't'}, "<leader>7", function() build(true) end, { silent = true })        -- build and run
vim.keymap.set({'n', 't'}, "<leader>8", function() run(true) end, { silent = true })          -- run

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { silent = true })
vim.keymap.set("n", "<C-1>", dap.step_into, { silent = true })
vim.keymap.set("n", "<C-2>", dap.step_over, { silent = true })
vim.keymap.set("n", "<C-3>", dap.step_out, { silent = true })
vim.keymap.set("n", "<C-4>", dap.repl.toggle, { silent = true })
vim.keymap.set("n", "<C-5>", dap.run_last, { silent = true })
vim.keymap.set("n", "<C-6>", dapui.toggle, { silent = true })
vim.keymap.set("n", "<C-7>", dap.terminate, { silent = true })

---------------------------------------------------------------------------
-- Set lualine as statusline `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable `lukas-reineke/indent-blankline.nvim `:help indent_blankline.txt`
require('indent_blankline').setup {
    show_end_of_line = true,
    -- char = '', -- desabilitar/trocar barras de indentacao
    space_char_blankline = " ",
    show_trailing_blankline_indent = false,
}

-- Gitsigns `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Configure Telescope `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = { mappings = {
    i = {
      ['<C-u>'] = false,
      ['<C-d>'] = false,
    }},
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

local telescope = require('telescope.builtin')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', telescope.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', telescope.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>f', function()
  telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', 'gi', telescope.lsp_references, { desc = '[/] [G]oto [I]mplementation' })
vim.keymap.set('n', '<leader>sf', telescope.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', telescope.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
--
-- Configure Treesitter `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'help', 'vim' },
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings. This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', vim.lsp.buf.format, { desc = 'Format current buffer with LSP' })
end

-- Setup neovim lua configuration
require('neodev').setup{
  library = { plugins = { "nvim-dap-ui" }, types = true }
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason').setup() -- Setup mason so it can manage external tooling

local mason_lspconfig = require("mason-lspconfig") -- Ensure the servers above are installed

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}

require('fidget').setup() -- Turn on lsp status information

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
