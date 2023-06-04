require("util")

-- Configura Niveles

    require("mobdebug").start() 



-- Definición de la clase Block

Block = {}

Block.enemies = 4

Block.startX = 0

Block.nextX = 70

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

local blocks = {block1, block2}



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







levelsCfg = {}

-- Creación de la instancia de la clase LevelConfig

local clevel = LevelConfig.new()

clevel.rows = 1

clevel.speed = 150
clevel.zigzagX = 150

local bs = {}

for i = 1, 2 do

  local b = Block.new(((i - 1) * 390) + 140)

  b.enemies = 2

  print(i)

  table.insert(bs, b)

end

clevel.blocks = bs

table.insert(levelsCfg, clevel) -- nivel 1



clevel = LevelConfig.new()

clevel.rows = 2

clevel.speed = 30

table.insert(levelsCfg, clevel) -- nivel 2



clevel = LevelConfig.new()

clevel.rows = 2

clevel.zigzagX = 150

clevel.speed = 40

table.insert(levelsCfg, clevel) -- nivel 3



clevel = LevelConfig.new()

clevel.zigzag = 200

clevel.speed = 60

table.insert(levelsCfg, clevel) -- nivel 4



clevel = LevelConfig.new()

clevel.rows = 4

clevel.zigzag = 100

clevel.speed = 70

table.insert(levelsCfg, clevel) -- nivel 



TabToFile(levelsCfg, "levels.txt")

