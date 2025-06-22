return {
  {
    "tiesen243/vercel.nvim",
    lazy = false,
    priority = 1001, -- Đặt ưu tiên cao hơn để load trước nếu cần
  },

  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    config = function()
      local themes = {
        "vercel", -- gộp theme đầu tiên vào đây
        "solarized-osaka",
        "catppuccin",
        "tokyonight-night",
        "kanagawa",
        "rose-pine",
      }

      local current_theme_index = 1

      -- Nếu theme là "vercel", thì cần gọi setup riêng của nó
      local function load_theme(index)
        local theme = themes[index]
        if theme == "vercel" then
          require("vercel").setup({ theme = "dark", transparent = true })
        end
        vim.cmd.colorscheme(theme)
        print("Change nvim theme to: " .. theme)
      end

      load_theme(current_theme_index)

      vim.keymap.set("n", "<leader>nt", function()
        current_theme_index = current_theme_index + 1
        if current_theme_index > #themes then
          current_theme_index = 1
        end
        load_theme(current_theme_index)
      end, { noremap = true, silent = true })
    end,
  },

  { "catppuccin/nvim", name = "catppuccin", priority = 900 },
  { "rebelot/kanagawa.nvim", name = "kanagawa", priority = 900 },
  { "rose-pine/neovim", name = "rose-pine", priority = 900 },
  { "craftzdog/solarized-osaka.nvim", name = "solarized-osaka", priority = 900 },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
    lazy = false,
    keys = {
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
      { "<leader>bP", "<cmd>BufferLinePickClose<cr>", desc = "Pick Close Buffer" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Left Buffers" },
      { "<leader>bh", "<cmd>BufferLineCloseRight<cr>", desc = "Close Right Buffers" },
    },
    opts = {
      highlights = function()
        local status_ok, vercel = pcall(require, "vercel")
        if not status_ok then
          return {}
        end
        return vercel.highlights.bufferline
      end,
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = " File Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        always_divide_middle = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "snacks_dashboard", "neo-tree" },
      },
      -- stylua: ignore start
      sections = {
        lualine_a = { { 'mode', fmt = function(str) return ' ' .. str end } },
        lualine_b = { "branch" },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", file_status = true, path = 1 },
          { "diagnostics", symbols = Yuki.icons.diagnostics },
        },
        lualine_x = {
          {
            "diff",
            symbols =  Yuki.icons.git,
            sources = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then return gitsigns end
            end,
          },
          { "selectioncount", padding = { left = 1, right = 1 } },
          { "searchcount", padding = { left = 1, right = 1 } },
        },
        lualine_y = {
          { "progress", separator = "" },
          { "location" },
        },
        lualine_z = { Yuki.utils.get_time }
      },
      -- stylua: ignore end
      inactive_sections = {},
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>q", group = "Quit" },
        { "<leader>u", group = "UI" },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      signs = Yuki.icons.git_signs,
      signs_staged = Yuki.icons.git_signs_staged,
      current_line_blame_opts = { delay = 500, ignore_whitespace = true },
    },
  },
}
