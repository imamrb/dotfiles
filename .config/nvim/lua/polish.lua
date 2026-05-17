-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- ~/.config/nvim/lua/polish.lua

-- Your Rails console keymap
vim.keymap.set(
  "n",
  "<leader>tr",
  function()
    require("toggleterm.terminal").Terminal
      :new({
        cmd = "rails c",
        direction = "horizontal",
        close_on_exit = false,
      })
      :toggle()
  end,
  { desc = "Toggle Rails Console" }
)

-- Any other custom keymaps or configurations can go here
