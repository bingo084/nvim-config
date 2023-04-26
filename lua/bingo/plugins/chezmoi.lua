return {
	"alker0/chezmoi.vim",
	cond = function()
		return vim.fn.expand('%:p'):match("chezmoi") ~= nil
	end,
	config = function()
		vim.g["chezmoi#use_tmp_buffer"] = true
	end,
}
