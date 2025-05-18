-- inventory.lua
local config = require("config")

local M = {}

function M.dropTrash()
  for slot = 1, 16 do
    local item = turtle.getItemDetail(slot)
    if item and not config.keepItems[item.name] then
      turtle.select(slot)
      turtle.drop()
    end
  end
  turtle.select(1)
end

return M
