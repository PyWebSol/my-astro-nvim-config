-- Автоматическое восстановление сессии
local resession = require("resession")

-- Настройка resession
resession.setup({
  autosave = {
    enabled = true,
    interval = 60,
    notify = false,
  },
  options = {
    -- Не сохраняем буферы со стартовым экраном
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      return buftype ~= "nofile" and buftype ~= "terminal"
    end,
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Восстанавливаем сессию только если:
    -- 1. Нет аргументов командной строки
    -- 2. Текущий буфер существует
    if vim.fn.argc() == 0 and vim.api.nvim_buf_is_valid(1) then
      vim.defer_fn(function()
        pcall(function()
          resession.load("last", { silent = true })
        end)
      end, 0)
    end
  end,
})

-- Автоматическое сохранение сессии при выходе
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    resession.save("last", { notify = false })
  end,
})

-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}

-- Улучшенная обработка вставки
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})
