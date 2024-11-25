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

-- Автоматическое определение корневой директории проекта
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local path = vim.fn.expand('%:p:h')
    -- Если открыт файл, используем его директорию
    if vim.fn.argc() > 0 then
      vim.cmd('cd ' .. path)
      return
    end
    
    -- Ищем маркеры корневой директории
    local markers = { ".git", "Cargo.toml", ".gitignore", "package.json", "Makefile" }
    for _, dir in ipairs(vim.fn.finddir('.git', path .. ';', -1)) do
      local root = vim.fn.fnamemodify(dir, ':h')
      vim.cmd('cd ' .. root)
      return
    end
  end
})

-- Принудительная установка рабочей директории
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    -- Получаем путь к текущему файлу
    local current_file = vim.fn.expand('%:p')
    if current_file ~= '' then
      -- Устанавливаем директорию
      local dir = vim.fn.fnamemodify(current_file, ':h')
      vim.cmd('cd ' .. dir)
      -- Обновляем neo-tree
      vim.cmd('Neotree reveal')
    end
  end
})

-- Устанавливаем рабочую директорию на директорию текущего файла
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local current_file = vim.fn.expand('%:p')
    if current_file ~= '' then
      local dir = vim.fn.fnamemodify(current_file, ':h')
      vim.cmd('cd ' .. dir)
    end
  end
})
