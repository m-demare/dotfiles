vim.g.node_host_prog = vim.fn.getenv 'HOME' ..
                        "/.nvm/versions/node/" ..
                        vim.fn.getenv 'vim_node_version' ..
                        "/bin/node"

vim.g.python3_host_prog="/usr/bin/python3.8"

require('plugins')

vim.cmd('source ~/.config/vim/globals.vim')

require('lsp')

