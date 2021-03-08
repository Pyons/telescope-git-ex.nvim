local previewers = require('telescope.previewers')
local utils = require('telescope.utils')
local putils = require('telescope.previewers.utils')

local defaulter = utils.make_default_callable
local P = {}

P.git_commit_single_diff = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      putils.job_maker({ 'git', '--no-pager', 'diff', entry.value .. '^!', opts.file_name }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd
      })
      putils.regex_highlighter(self.state.bufnr, 'diff')
    end
  }
end, {})

return P
