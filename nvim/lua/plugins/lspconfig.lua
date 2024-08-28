return {
	"neovim/nvim-lspconfig",
	config = function()
		require("lspconfig").lua_ls.setup({})
		require("lspconfig").jedi_language_server.setup({})
	end,
}
