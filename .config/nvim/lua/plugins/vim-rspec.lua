return {
  -- vim-rspec plugin
  {
    "thoughtbot/vim-rspec",
    ft = { "ruby", "eruby", "rake" },
    config = function()
      -- Lua function exposed globally
      _G.RunRSpecWithToggleTerm = function(spec_command)
        local ok, Terminal = pcall(require, "toggleterm.terminal")
        if not ok then
          vim.notify("ToggleTerm not found. Please install toggleterm.nvim", vim.log.levels.ERROR)
          return
        end

        -- Check for bin/rspec, fallback to rspec
        local rspec_cmd = vim.fn.executable "bin/rspec" == 1 and "bin/rspec" or "rspec"
        local cmd = rspec_cmd .. " " .. spec_command

        local rspec_term = Terminal.Terminal:new {
          cmd = cmd,
          close_on_exit = false,
          direction = "horizontal",
          hidden = false,
          on_exit = function() vim.notify("RSpec finished.", vim.log.levels.INFO) end,
        }
        rspec_term:toggle()
      end

      -- Vim wrapper to call the Lua function
      vim.cmd [[
        function! RunRSpecWithToggleTerm(spec) abort
          execute 'lua _G.RunRSpecWithToggleTerm("' . a:spec . '")'
        endfunction
      ]]

      -- Tell vim-rspec to use the new command
      vim.g.rspec_command = "call RunRSpecWithToggleTerm('{spec}')"
    end,

    keys = {
      { "<leader>s", desc = "+test" },
      { "<leader>st", ":call RunNearestSpec()<CR>", desc = "Run nearest test", mode = "n" },
      { "<leader>sf", ":call RunCurrentSpecFile()<CR>", desc = "Run current file", mode = "n" },
      { "<leader>sl", ":call RunLastSpec()<CR>", desc = "Run last test", mode = "n" },
      { "<leader>so", ":ToggleTerm direction=vertical<CR>", desc = "Open test output", mode = "n" },
      { "<leader>ss", ":ToggleTermToggleAll<CR>", desc = "Toggle all terminals", mode = "n" },
    },
  },
}
