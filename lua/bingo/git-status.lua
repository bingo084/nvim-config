local M = {}

M.status = {
	ahead = 0,
	behind = 0,
}

local function update_status()
	vim.system({ "git", "status", "--porcelain=2", "--branch" }, { text = true }, function(job)
		if job.code ~= 0 then
			M.status = { ahead = 0, behind = 0 }
			return
		end

		local new_status = { ahead = 0, behind = 0 }
		for _, line in ipairs(vim.split(job.stdout, "\n")) do
			if line:find("^# branch.ab") then
				local ahead, behind = line:match("^# branch.ab %+(%d+) %-(%d+)")
				new_status.ahead = tonumber(ahead) or 0
				new_status.behind = tonumber(behind) or 0
				break
			end
		end
		M.status = new_status
	end)
end

local function fetch_and_update()
	vim.system({ "git", "fetch" }, { text = true }, function(job)
		if job.code == 0 then
			update_status()
		end
	end)
end

local debounce_timer = nil

local debounced_update = function()
	if debounce_timer then
		debounce_timer:stop()
		debounce_timer:close()
	end
	debounce_timer = vim.loop.new_timer()
	if debounce_timer then
		debounce_timer:start(100, 0, vim.schedule_wrap(update_status))
	end
end

M.watchers = {}

local function watch_git_dir()
	vim.system({ "git", "rev-parse", "--git-dir" }, { text = true }, function(job)
		if job.code ~= 0 then
			return
		end

		local git_dir = vim.trim(job.stdout)
		local paths_to_watch = {
			git_dir .. "/HEAD",
			git_dir .. "/refs/heads",
			git_dir .. "/refs/remotes",
		}

		for _, watcher in ipairs(M.watchers) do
			if not watcher:is_closing() then
				watcher:close()
			end
		end
		M.watchers = {}

		for _, path in ipairs(paths_to_watch) do
			local watcher = vim.uv.new_fs_event()
			if watcher then
				table.insert(M.watchers, watcher)
				watcher:start(path, {}, debounced_update)
			end
		end
	end)
end

watch_git_dir()

local timer = vim.loop.new_timer()

function M.pause()
	if timer and not timer:is_closing() then
		timer:stop()
	end
end

function M.resume()
	update_status()
	if timer and not timer:is_closing() then
		timer:start(0, 60000, fetch_and_update)
	end
end

M.resume()

vim.api.nvim_create_autocmd({ "DirChanged" }, {
	group = vim.api.nvim_create_augroup("BingoGitStatus", { clear = true }),
	pattern = "*",
	callback = function()
		watch_git_dir()
		fetch_and_update()
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		if timer and not timer:is_closing() then
			timer:stop()
			timer:close()
		end
		if M.watchers then
			for _, watcher in ipairs(M.watchers) do
				if not watcher:is_closing() then
					watcher:close()
				end
			end
		end
		if debounce_timer then
			debounce_timer:stop()
			debounce_timer:close()
		end
	end,
})

function M.get_status() return M.status end

function M.get_text()
	local ahead = M.status.ahead
	local behind = M.status.behind
	local ahead_str = ahead > 0 and ("↑" .. ahead) or ""
	local behind_str = behind > 0 and ("↓" .. behind) or ""
	return ahead_str .. behind_str
end

function M.get_level()
	local max = math.max(M.status.ahead, M.status.behind)
	return max > 15 and 3 or max > 10 and 2 or 1
end

return M
