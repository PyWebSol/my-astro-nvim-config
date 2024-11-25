return {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        -- Включаем поиск корня проекта
        bind_to_cwd = true,
        -- Файлы, которые указывают на корень проекта
        root_marker_list = { ".git", "Cargo.toml", ".gitignore", "package.json", "Makefile" },
        -- Автоматически находить корень проекта
        find_by_full_path_words = true,
        -- Использовать более быстрый механизм наблюдения за файлами
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<C-b>"] = "toggle",
        },
      },
    },
  }