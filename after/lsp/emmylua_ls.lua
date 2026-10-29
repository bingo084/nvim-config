local library = { vim.env.VIMRUNTIME .. "/lua" }
for _, plugin in pairs(require("lazy.core.config").plugins) do
  local path = plugin.dir .. "/lua"
  if vim.fn.isdirectory(path) == 1 then
    library[#library + 1] = path
  end
end

---@type vim.lsp.Config
return {
  settings = {
    emmylua = {
      -- https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_CN.md
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        workspaceRoots = { "./lua" },
        library = library,
      },
      strict = {
        requirePath = true,
      },
      completion = {
        callSnippet = true,
      },
      hint = {
        indexHint = false,
      },
    },
  },
}
