local M = {}
local colors

local function kitty_colors()
  if not vim.env.KITTY_WINDOW_ID or vim.fn.executable("kitten") ~= 1 then
    return
  end
  local result = vim.system({
    "kitten",
    "@",
    "get-colors",
    "--match",
    "id:" .. vim.env.KITTY_WINDOW_ID,
  }, { text = true }):wait(1000)
  if result.code ~= 0 then
    return
  end
  local parsed_colors = {}
  for name, color in result.stdout:gmatch("([%w_]+)%s+#(%x%x%x%x%x%x)") do
    parsed_colors[name] = color
  end
  return parsed_colors
end

-- Sidekick calls this before starting Codex, outside its short query deadline.
function M.prepare()
  colors = kitty_colors()
end

function M.setup()
  -- Nvim 0.12's default handler reports white/black rather than the host colors.
  -- Replace only that handler, retaining its behavior for other terminals.
  for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = "TermRequest" })) do
    local fallback = autocmd.callback
    if autocmd.group_name == "nvim.terminal" and autocmd.desc == "Handles OSC foreground/background color requests"
      and type(fallback) == "function" then
      vim.api.nvim_del_autocmd(autocmd.id)
      vim.api.nvim_create_autocmd("TermRequest", {
        group = autocmd.group,
        desc = "Report Kitty colors to Sidekick Codex",
        callback = function (ev)
          local tool = vim.b[ev.buf].sidekick_cli
          local command = ev.data.sequence:match("^\27%](1[01]);%?$")
          if tool and tool.name == "codex" and command then
            local color = colors and colors[command == "10" and "foreground" or "background"]
            local channel = vim.bo[ev.buf].channel
            if color and channel ~= 0 then
              local r, g, b = color:match("(%x%x)(%x%x)(%x%x)")
              vim.api.nvim_chan_send(
                channel, string.format("\27]%s;rgb:%s%s/%s%s/%s%s%s", command, r, r, g, g, b, b, ev.data.terminator)
              )
              return
            end
          end
          return fallback(ev)
        end,
      })
    end
  end
end

return M
