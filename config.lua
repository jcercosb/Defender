require("util")

-- Configura Niveles

require("mobdebug").start()



-- Definición de la clase Block

Block = {}

Block.enemies = 4

Block.startX = 0

Block.nextX = 70

Block.image = 2

Block.__index = Block --  para que las instancias de Block puedan acceder a los métodos y propiedades definidos  clases



function Block.new(sx)
  local self = setmetatable({}, Block)

  if sx then self.startX = sx end

  return self
end

-- Creación de instancias de la clase Block

local block1 = Block.new()

local block2 = Block.new(390)



-- Creación de la tabla blocks

local blocks = { block1, block2 }


-- Definición de la clase LevelConfig

LevelConfig = {}

LevelConfig.rows = 3

LevelConfig.startY = 0

LevelConfig.nextY = 50

LevelConfig.zigzagX = 0

LevelConfig.speed = 100

LevelConfig.blocks = blocks

LevelConfig.__index = LevelConfig



function LevelConfig.new()
  local self = setmetatable({}, LevelConfig)

  return self
end

-- Creación de la instancia de la clase LevelConfig

levelsCfg = {}

-- ___________________ nivel 1 ___________________
local clevel = LevelConfig.new()

clevel.rows = 1

clevel.speed = 150

clevel.zigzagX = 150

--clevel.tipo = 2

local bs = {} -- array de bloques para nivel 1

for i = 1, 3 do
  local b = Block.new(((i - 1) * 140) + 140)

  b.enemies = 2  -- nº filas por bloque

  if i == 2 then -- Cambia imagen
    b.image = 2
  end

  table.insert(bs, b)
end

clevel.blocks = bs


table.insert(levelsCfg, clevel)

-- ___________________nivel 2 ___________________
clevel = LevelConfig.new()

clevel.rows = 2

clevel.speed = 100

clevel.zigzagX = 150

local bs2 = {} -- array de bloques para nivel 2

for i = 1, 2 do
  local b2 = Block.new(((i - 1) * 390) + 140)

  b2.enemies = 3

  b2.image = 5


  table.insert(bs2, b2)
end

clevel.blocks = bs2


table.insert(levelsCfg, clevel)

-- _________________nivel 3  ___________________
clevel = LevelConfig.new()

clevel.rows = 3

clevel.zigzagX = 150

clevel.speed = 50

local bs3 = {} -- array de bloques para nivel 3

for i = 1, 3 do
  local b3 = Block.new(((i - 1) * 190) + 100)

  b3.enemies = 3

  b3.image = 3

  if i == 2 then -- Cambia filas 3º bloque
    b3.enemies = 5
    b3.image = 4
  end

  table.insert(bs3, b3)
end

clevel.blocks = bs3


table.insert(levelsCfg, clevel)

-- _________________nivel 4 _______________

clevel = LevelConfig.new()

clevel.rows = 4

clevel.zigzag = 200

clevel.speed = 60

local bs4 = {} -- array de bloques para nivel 4

for i = 1, 3 do
  local b4 = Block.new(((i - 1) * 200) + 100)

  b4.enemies = 2
  b4.image = 4
  if i == 2 then -- Cambia imagen
    b4.image = 10
  end

  table.insert(bs4, b4)
end

clevel.blocks = bs4


table.insert(levelsCfg, clevel)

-- _________________nivel 5 _______________

clevel = LevelConfig.new()

clevel.rows = 4

clevel.zigzagX = 100

clevel.speed = 70

local bs5 = {} -- array de bloques para nivel 5

for i = 1, 4 do
  local b5 = Block.new(((i - 1) * 200) + 60)

  b5.enemies = 2

  b5.image = 5
  if i == 2 or i == 3 then -- Cambia imagen
    b5.image = 11
    clevel.zigzagX = 200
  end


  table.insert(bs5, b5)
end

clevel.blocks = bs5

table.insert(levelsCfg, clevel) -- nivel

-- _________________nivel 6 _______________

clevel = LevelConfig.new()

clevel.speed = 100

clevel.zigzagX = 150

local bs6 = {} -- array de bloques para nivel 6

for i = 1, 3 do
  local b6 = Block.new(((i - 1) * 260) + 50)

  b6.enemies = 4
  b6.image = 6
  b6.zigzagX = 200


  table.insert(bs6, b6)
end

clevel.blocks = bs6


table.insert(levelsCfg, clevel)

-- _________________nivel 7 _______________

clevel = LevelConfig.new()

clevel.speed = 100

clevel.zigzagX = 150

local bs7 = {} -- array de bloques para nivel 7

for i = 1, 3 do
  local b7 = Block.new(((i - 1) * 260) + 50)

  b7.enemies = 4
  b7.image = 7
  b7.zigzagX = 200


  table.insert(bs7, b7)
end

clevel.blocks = bs7


table.insert(levelsCfg, clevel)

-- _________________nivel 8 _______________

clevel = LevelConfig.new()

clevel.speed = 100

clevel.zigzagX = 150

local bs8 = {} -- array de bloques para nivel 8

for i = 1, 3 do
  local b8 = Block.new(((i - 1) * 260) + 50)

  b8.enemies = 4
  b8.image = 8
  b8.zigzagX = 200


  table.insert(bs8, b8)
end

clevel.blocks = bs8


table.insert(levelsCfg, clevel)

-- _________________nivel 9 _______________

clevel = LevelConfig.new()

clevel.speed = 100

clevel.zigzagX = 150

local bs9 = {} -- array de bloques para nivel 9

for i = 1, 3 do
  local b9 = Block.new(((i - 1) * 260) + 50)

  b9.enemies = 4
  b9.image = 9
  b9.zigzagX = 200


  table.insert(bs9, b9)
end

clevel.blocks = bs9


table.insert(levelsCfg, clevel)


--TabToFile(levelsCfg, "levels.txt")
