local utils = require('utils')
local map = utils.map
local cb = utils.call_bind

local persistence = utils.bind(require, 'persistence')

map("n", "<leader>sl", cb(persistence, 'load'))

