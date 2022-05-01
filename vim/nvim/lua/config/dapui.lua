require('dapui').setup {
  sidebar = {
    elements = {
      { id = "breakpoints", size = 0.20 },
      { id = "stacks", size = 0.45 },
      { id = "watches", size = 0.35 },
    },
    size = 40,
    position = "right",
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom"
  },
}

