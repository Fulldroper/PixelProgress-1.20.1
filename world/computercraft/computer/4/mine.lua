-- mine.lua w×h [depth]
-- приклад: mine.lua 3x3 20
local log = require("./utils/logger")
-- Зчитування аргументів командного рядка
local tArgs = { ... }

-- Перевірка наявності обов'язкового аргументу (розмір)
if #tArgs < 1 then
  print("Use: mine.lua WIDTHxHEIGHT [DEEPTH]")
  log.error("\n- Use: mine.lua WIDTHxHEIGHT [DEEPTH]")
  return
end

-- Витягуємо ширину та висоту з першого аргументу (наприклад, 3x3)
local width, height = string.match(tArgs[1], "(%d+)x(%d+)")
width = tonumber(width)
height = tonumber(height)
if not width or not height then
  print("Wrong size. Example: 3x3")
  log.error("\n- Wrong size. Example: 3x3")
  return
end

-- Глибина копання (другий аргумент або нескінченність, якщо не вказано)
local depth = tonumber(tArgs[2]) or math.huge -- нескінченність, якщо не вказано

log.info("\n- M: " .. width .. "x" .. height .. "/" .. depth .. " E: " .. turtle.getFuelLevel())
-- Список руд, які потрібно зберігати (інші предмети будуть викидатися)
local keepItems = {
  ["minecraft:coal"] = true,
  ["minecraft:raw_iron"] = true,
  ["minecraft:raw_gold"] = true,
  ["minecraft:coal"] = true, -- дублюється, але не завадить
  ["minecraft:lapis_lazuli"] = true,
  ["minecraft:torch"] = true,
  ["create:raw_zinc"] = true
}

-- Функція копання одного ряду висотою height
local function digRow(height)
  -- Якщо попереду блок, копаємо його
  if turtle.detect() then
    turtle.dig()
  end
  
  -- Рухаємось вперед
  turtle.forward()

  -- Копаємо вгору на (height-1) блоків
  for i = 1, height-1 do
    if turtle.detectUp() then
      turtle.digUp()
    end
    turtle.up()
  end
  -- Повертаємось вниз на початковий рівень
  for i = 1, height-1 do
    if turtle.detectDown() then
      turtle.digDown()
    end
    turtle.down()
  end

  -- Повертаємось назад (на вихідну позицію)
  turtle.back()
end

-- Функція для переходу на одну клітинку вправо (з копанням блоку, якщо є)
local function walkRightOnes()
  turtle.turnRight()
  while turtle.detect() do
    turtle.dig()
  end
  turtle.forward()
  turtle.turnLeft()
end

-- Функція копання всієї матриці (прямокутника) розміром height x width
local function digMatrix(height, width)
  digRow(height) -- копаємо перший стовпець
  for i = 1, width-1 do
    walkRightOnes() -- переходимо вправо
    digRow(height)  -- копаємо наступний стовпець
  end

  -- Повертаємось у вихідну позицію (ліворуч)
  turtle.turnLeft()
  for i = 1, width do
    turtle.forward()
  end
  turtle.turnRight()
end

-- Функція для викидання всього сміття (залишає тільки корисні руди)
local function dropTrash()
  for slot = 1, 16 do
    local detail = turtle.getItemDetail(slot)
    -- Якщо слот зайнятий і предмет не зі списку keepItems — викидаємо
    if detail and not keepItems[detail.name] then
      turtle.select(slot)
      turtle.drop()
    end
  end
  turtle.select(1) -- повертаємо вибір на перший слот
end

-- Функція для встановлення факела (torch) позаду turtle
local function placeTorch()
  for slot = 1, 16 do
    local item = turtle.getItemDetail(slot)
    -- Якщо знайдено факел у слоті
    if item and item.name:find("torch") then
      turtle.select(slot)
      -- Повертаємось назад, ставимо факел, повертаємось у вихідне положення
      turtle.turnLeft()
      turtle.turnLeft()
      turtle.place()
      turtle.turnRight()
      turtle.turnRight()
      turtle.select(1)
      return true -- факел поставлено
    end
  end
  log.warn("\n- No torches found!")
  return false -- факелів немає
end

-- основний цикл копання вперед на задану глибину
local step = 0
while step < depth do
  digMatrix(height, width) -- копаємо матрицю
  turtle.forward()         -- просуваємось вперед
  dropTrash()              -- викидаємо сміття
  if step % 8 == 0 then placeTorch() end -- ставимо факел кожні 8 кроків
  step = step + 1
  log.info("\n- S: " .. step .. "/" .. depth .. " E: " .. turtle.getFuelLevel())
end
