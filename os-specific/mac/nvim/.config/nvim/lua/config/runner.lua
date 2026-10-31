local function run_current_file()
	local buf = vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" or vim.bo[buf].buftype ~= "" then
		vim.notify("Save a source file before running it", vim.log.levels.WARN)
		return
	end
	if vim.bo[buf].modified then
		vim.cmd.update()
	end

	local escaped_file = vim.fn.shellescape(file)
	local ft = vim.bo[buf].filetype
	local commands = {
		python = { "python3", escaped_file },
		javascript = { "node", escaped_file },
		lua = { "lua", escaped_file },
		sh = { "bash", escaped_file },
		bash = { "bash", escaped_file },
		go = { "go", "run " .. escaped_file },
	}
	local command
	if ft == "c" or ft == "cpp" then
		local compiler = ft == "c" and "cc" or "c++"
		if vim.fn.executable(compiler) == 0 then
			vim.notify("Required command not found: " .. compiler, vim.log.levels.ERROR)
			return
		end
		local binary = vim.fn.shellescape(vim.fn.tempname())
		command = string.format("%s %s -o %s && %s; result=$?; rm -f %s; exit $result", compiler, escaped_file, binary, binary, binary)
	elseif ft == "rust" then
		if vim.fn.executable("rustc") == 0 then
			vim.notify("Required command not found: rustc", vim.log.levels.ERROR)
			return
		end
		local binary = vim.fn.shellescape(vim.fn.tempname())
		command = string.format("rustc %s -o %s && %s; result=$?; rm -f %s; exit $result", escaped_file, binary, binary, binary)
	elseif commands[ft] then
		local runner = commands[ft][1]
		if vim.fn.executable(runner) == 0 then
			vim.notify("Required command not found: " .. runner, vim.log.levels.ERROR)
			return
		end
		command = runner .. " " .. commands[ft][2]
	else
		vim.notify("No runner for filetype: " .. (ft ~= "" and ft or "unknown"), vim.log.levels.WARN)
		return
	end

	-- shortcut: runs one source file; use the project's build tool for multi-file builds and test suites.
	command = "cd " .. vim.fn.shellescape(vim.fn.fnamemodify(file, ":h")) .. " && " .. command
	require("config.terminal").run(command)
end

vim.keymap.set("n", "<leader>rr", run_current_file, { desc = "Run current file" })
