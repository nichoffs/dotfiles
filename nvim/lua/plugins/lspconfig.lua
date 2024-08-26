return {
	"neovim/nvim-lspconfig",
	config = function()
		require("lspconfig").ruff.setup({})
		require("lspconfig").lua_ls.setup({})
	end,
}
