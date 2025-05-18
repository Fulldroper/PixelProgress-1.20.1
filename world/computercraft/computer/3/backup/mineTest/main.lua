-- main.lua
local args = require("args")
local movement = require("movement")
local inventory = require("inventory")
local torch = require("torch")

local tArgs = { ... }
local width, height, depth = args.parseArgs(tArgs)

local step = 0
while step < depth do
  movement.digMatrix(height, width)
  turtle.forward()
  inventory.dropTrash()
  if step % 8 == 0 then
    torch.placeTorch()
  end
  step = step + 1
end
