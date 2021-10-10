require('plugins')

vim.cmd('source ~/.config/vim/globals.vim')

require('lsp')

vim.g.node_host_prog = vim.fn.getenv 'HOME' ..
                        "/.nvm/versions/node/" ..
                        vim.fn.getenv 'vim_node_version' ..
                        "/bin/node"
