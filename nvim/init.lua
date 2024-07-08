local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---------------- SENSIBLE DEFAULTS ----------------

vim.g.mapleader = " "

vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Automatically insert one extra level of indentation in some cases
vim.opt.wrap = false -- Display long lines as just one line
vim.opt.cursorline = true -- Highlight the current line
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't write a backup file before overwriting a file
vim.opt.undofile = true -- Save undo history
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.signcolumn = "yes" -- Always show the sign column

---------------- LAZY ----------------
if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

---------------- LAZY PLUGINS ----------------

require("lazy").setup({
	-- LSP Zero Plugins
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "L3MON4D3/LuaSnip" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "rafamadriz/friendly-snippets" },

	-- Telescope Plugin
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
	},
	-- Oil
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "echasnovski/mini.icons" },
	},
	-- Pairs
	{ "echasnovski/mini.pairs", version = false },
	{ "echasnovski/mini.comment", version = false },
	{ "echasnovski/mini.tabline", version = false },
	-- Copilot
	{ "zbirenbaum/copilot.lua" },
	{ "zbirenbaum/copilot-cmp" },
	-- Conform (Formatter)
	{ "stevearc/conform.nvim", opts = {} },
})

---------------- PAIRS SETUP ----------------

require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.tabline").setup()

---------------- CONFORM SETUP ----------------

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
	},
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		lsp_format = "fallback",
	},
})

---------------- COPILOT SETUP ----------------

require("copilot").setup()
require("copilot_cmp").setup()

---------------- OIL SETUP ----------------

require("oil").setup()
vim.keymap.set("n", "<C-e>", require("oil").open, {})

---------------- TELESCOPE SETUP ----------------

local telescope = require("telescope")

telescope.setup({
	pickers = {
		find_files = {
			theme = "dropdown",
		},
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

---------------- THEME ----------------

-- empty for now

---------------- SETUP LSP ZERO ----------------
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- keybindings are listed here:
	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/api-reference.md#default_keymapsopts
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- technically these are "diagnostic signs"
-- neovim enables them by default.
-- here we are just changing them to fancy icons.
lsp_zero.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

---------------- MASON PLUGIN INSTALL ----------------

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright", "html", "cssls" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})

---------------- EXTRA COMPLETION CONFIG (INTERFACES WITH LSPZERO) ----------------

local cmp = require("cmp")
local cmp_action = lsp_zero.cmp_action()

-- this is the function that loads the extra snippets
-- from rafamadriz/friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	sources = {
		{ name = "path" },
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", keyword_length = 2 },
		{ name = "buffer", keyword_length = 3 },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- confirm completion item
		["<Enter>"] = cmp.mapping.confirm({ select = true }),

		-- trigger completion menu
		["<C-Space>"] = cmp.mapping.complete(),

		-- scroll up and down the documentation window
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),

		-- navigate between snippet placeholders
		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),
		["<CR>"] = cmp.mapping.confirm({
			-- documentation says this is important.
			-- I don't know why.
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
	}),
	-- note: if you are going to use lsp-kind (another plugin)
	-- replace the line below with the function from lsp-kind
	formatting = lsp_zero.cmp_format({ details = true }),
})
