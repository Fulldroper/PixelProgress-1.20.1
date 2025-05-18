-- log_receiver.lua
local logFileName = "logs.txt"
local protocol = "log_channel"
local rednetOpen = false

-- Визначення кольорів для рівнів
local function getColorForLevel(level)
  if level == "INFO" then
    return colors.lightBlue
  elseif level == "WARN" then
    return colors.yellow
  elseif level == "ERROR" then
    return colors.red
  else
    return colors.white
  end
end

-- Відкриває rednet
local function ensureRednet()
  if rednetOpen then return end
  for _, side in ipairs({"left", "right", "top", "bottom", "back", "front"}) do
    if peripheral.getType(side) == "modem" then
      rednet.open(side)
      rednetOpen = true
      return
    end
  end
  error("Modem not connected!")
end

-- Запис у файл
local function writeToFile(msg)
  local file = fs.open(logFileName, "a")
  if file then
    file.writeLine(msg)
    file.close()
  end
end

-- Вивід з кольором
local function printColored(msg, level)
  local color = getColorForLevel(level)
  local oldColor = term.getTextColor()
  term.setTextColor(color)
  print(msg)
  term.setTextColor(oldColor)
end

-- Основний цикл
local function listen()
  ensureRednet()
  print("Waitings logs...")

  while true do
    local id, msg, proto = rednet.receive(protocol)
    if proto == protocol then
      -- Спробуємо виявити рівень логу: [INFO], [WARN], [ERROR]
      local level = msg:match("^%[(%u+)%]")
      printColored("[" .. id .. "] " .. msg, level)
      writeToFile("[" .. id .. "] " .. msg)
    end
  end
end

listen()
