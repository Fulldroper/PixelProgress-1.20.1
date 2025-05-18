local function dropTrash()
  for slot = 1, 16 do
    local detail = turtle.getItemDetail(slot)
    print("Slot: " .. slot .. " - " .. (detail and detail.name or "empty"))
  end
  turtle.select(1)
end

dropTrash()