-- movement.lua
local M = {}
local digger = require("digger")

function M.walkRight()
  turtle.turnRight()
  while turtle.detect() do
    turtle.dig()
  end
  turtle.forward()
  turtle.turnLeft()
end

function M.digMatrix(height, width)
  digger.digRow(height)
  for i = 1, width do
    M.walkRight()
    digger.digRow(height)
  end
  -- повертаємось вліво
  turtle.turnLeft()
  for i = 1, width do
    turtle.forward()
  end
  turtle.turnRight()
end

return M
