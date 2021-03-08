local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')
local utils = require('telescope.utils')
local git_ex_previewers = require('telescope._extensions.git_ex_previewers')

local git_ex_b = {}

git_ex_b.compare = function(opts)
    local buf = vim.api.nvim_get_current_buf()
    local syntax = vim.api.nvim_buf_get_option(buf, 'syntax')
    local cwd = opts.cwd
    local file_name = vim.fn.expand('%')
    local nopts = opts
    local results = utils.get_os_command_output({
        'git', 'log', '--pretty=format:%h %aI %s', '--abbrev-commit', '--follow' ,'--', file_name
    }, opts.cwd)
    local render_file = function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.api.nvim_command('botright vsplit new')
        local list = {}
        local selection = action_state.get_selected_entry()
        local stdout, ret, stderr = utils.get_os_command_output({
            'git', 'show',  selection.value .. ':' .. file_name
        }, cwd)
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_name(buf, 'file #' .. buf)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'swapfile', false)
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(buf, 'filetype', 'git_ex_compare_file')
        vim.api.nvim_buf_set_option(buf, 'syntax', syntax)
        for _, v in pairs(stdout) do
            table.insert(list, v)
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, list)
    end
    nopts.file_name = file_name
    pickers.new(opts, {
        prompt_title = 'Git Commits',
        finder = finders.new_table {
            results = results,
            entry_maker = opts.entry_maker or make_entry.gen_from_git_commits(opts),
        },
        previewer = git_ex_previewers.git_commit_single_diff.new(opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function()
            actions.select_default:replace(render_file)
            return true
        end
    }):find()
end

return git_ex_b
