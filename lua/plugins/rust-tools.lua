---@type LazySpec
return {
    {
      "simrat39/rust-tools.nvim",
      ft = "rust",
      dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
      },
      opts = {
        tools = {
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            -- Включаем поддержку hover
            vim.keymap.set("n", "K", function()
              require("rust-tools").hover_actions.hover_actions()
            end, { buffer = bufnr })
            
            -- Действия с кодом
            vim.keymap.set("n", "<Leader>ca", function()
              require("rust-tools").code_action_group.code_action_group()
            end, { buffer = bufnr, desc = "Code Action" })
            
            -- Разворачивание макросов
            vim.keymap.set("n", "<Leader>rm", function()
              require("rust-tools").expand_macro.expand_macro()
            end, { buffer = bufnr, desc = "Expand Macro" })
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      },
  },
}
