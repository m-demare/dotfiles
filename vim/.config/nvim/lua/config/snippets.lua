local ls = require "luasnip"
require("luasnip.loaders.from_vscode").lazy_load()

vim.defer_fn(function ()
    ls.config.setup {}

    for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/config/snippets/*.lua", true)) do
        dofile(ft_path)(ls)
    end
end, 50)
