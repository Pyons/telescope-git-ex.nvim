local git_ex_builtin = require('telescope._extensions.git_ex_builtin')

return require('telescope').register_extension {
    exports= {
      compare = git_ex_builtin.compare,
    },
}


