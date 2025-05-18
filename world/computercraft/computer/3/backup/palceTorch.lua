local function placeTorch()
  for slot = 1, 16 do
    local item = turtle.getItemDetail(slot)
    if item and item.name:find("torch") then
      turtle.select(slot)
      turtle.turnLeft()
      turtle.turnLeft()
      turtle.place()
      turtle.turnRight()
      turtle.turnRight()
      turtle.select(1)
      return true
    end
  end
  return false
end

placeTorch()