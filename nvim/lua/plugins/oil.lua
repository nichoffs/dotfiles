return {
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    require("oil").setup()
  end,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
