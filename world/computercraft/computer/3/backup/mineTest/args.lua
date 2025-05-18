-- args.lua
local M = {}

function M.parseArgs(tArgs)
  if #tArgs < 1 then
    error("Use: mine.lua WIDTHxHEIGHT [DEPTH]")
  end

  local width, height = string.match(tArgs[1], "(%d+)x(%d+)")
  width = tonumber(width)
  height = tonumber(height)
  if not width or not height then
    error("Wrong size. Example: 3x3")
  end

  local depth = tonumber(tArgs[2]) or math.huge
  return width, height, depth
end

return M
