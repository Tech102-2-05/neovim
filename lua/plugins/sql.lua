return {
  "Kurren123/mssql.nvim",
  dependencies = {
    "folke/which-key.nvim", -- tùy chọn, nếu dùng which-key
  },
  opts = {
    keymap_prefix = "<leader>m", -- hoặc thay đổi tùy bạn muốn
    max_rows = 100,
    max_column_width = 80,
  },
  config = function(_, opts)
    require("mssql").setup(opts)
  end,
}
