-- digger.lua
local digger = {}

function digger.digRow(height)
  if turtle.detect() then turtle.dig() end
  turtle.forward()
  for i = 1, height-1 do
    if turtle.detectUp() then turtle.digUp() end
    turtle.up()
  end
  for i = 1, height-1 do
    if turtle.detectDown() then turtle.digDown() end
    turtle.down()
  end
  turtle.back()
end

return digger
