-- logger.lua
local M = {}
local rednetOpen = false
local logFileName = "logs.txt"

local colorsMap = {
  info  = colors.lightBlue,
  warn  = colors.yellow,
  error = colors.red
}

-- Відкриває модем на доступній стороні
local function ensureModemOpen()
  if not rednetOpen then
    for _, side in ipairs({ "top", "bottom", "left", "right", "front", "back" }) do
      if peripheral.getType(side) == "modem" then
        rednet.open(side)
        rednetOpen = true
        break
      end
    end
  end
end

-- Локальний вивід з кольором
local function printColored(msg, level)
  local color = colorsMap[level] or colors.white
  local oldColor = term.getTextColor()
  term.setTextColor(color)
  print(msg)
  term.setTextColor(oldColor)
end

-- Запис у файл
local function writeToFile(msg)
  local file = fs.open(logFileName, "a")
  if file then
    file.writeLine(msg)
    file.close()
  end
end

-- Основна лог-функція
function M.log(level, msg)
  local time = textutils.formatTime(os.time(), true)
  local fullMsg = string.format("[%s][%s] %s", level:upper(), time, msg)

  printColored(fullMsg, level)
  writeToFile(fullMsg)

  ensureModemOpen()
  if rednetOpen then
    rednet.broadcast(fullMsg, "log_channel")
  end
end

-- Зручні обгортки
function M.info(msg)
  M.log("info", msg)
end

function M.warn(msg)
  M.log("warn", msg)
end

function M.error(msg)
  M.log("error", msg)
end

return M
