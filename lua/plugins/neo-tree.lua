return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        bind_to_cwd = true,
        root_marker_list = { ".git", "Cargo.toml", ".gitignore", "package.json", "Makefile" },
      },
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<C-b>"] = "toggle",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      },
    },
  }