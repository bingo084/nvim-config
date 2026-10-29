---@type LazySpec
return {
  {
    "windwp/nvim-ts-autotag",
    opts = {},
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot.lua",
    dependencies = { "copilotlsp-nvim/copilot-lsp" },
    opts = {
      nes = {
        enabled = true,
        keymap = { accept_and_goto = "<Tab>", dismiss = "<Esc>" },
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-f>",
          accept_word = "<A-f>",
          accept_line = "<C-l>",
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-b>",
        },
      },
      filetypes = {
        ["*"] = true,
      },
    },
    event = "InsertEnter",
    keys = {
      { "<leader>cp", function () require("copilot.panel").open({}) end, desc = "Copilot Panel" },
    },
  },
}
