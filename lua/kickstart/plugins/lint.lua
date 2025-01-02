return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        cpp = { 'cppcheck' },
        go = { 'golint' },
        python = { 'flake8' },
      }

      -- 如果需要其他插件添加 linters，可以这样设置：
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['cpp'] = { 'cppcheck' }
      -- lint.linters_by_ft['go'] = { 'golint' }
      -- lint.linters_by_ft['python'] = { 'flake8' }

      -- 禁用默认的 linters
      lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['dockerfile'] = nil
      lint.linters_by_ft['inko'] = nil
      lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['json'] = nil
      lint.linters_by_ft['markdown'] = nil
      lint.linters_by_ft['rst'] = nil
      lint.linters_by_ft['ruby'] = nil
      lint.linters_by_ft['terraform'] = nil
      lint.linters_by_ft['text'] = nil

      -- 创建自动命令以在指定事件上执行实际的 linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- 仅在可修改的缓冲区中运行 linter，以避免不必要的噪音
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
