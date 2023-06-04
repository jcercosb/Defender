require("check")
require("config")



local activeProfiler = false
local activeDebug = true

-- Variables globales

local player = {}  -- Datos del jugador

local projectiles = {}  -- Almacena los proyectiles disparados

local enemies = {} -- Almacena los enemigos

local c = 0

local enemiesY = 0

score = 0

gameover = false

local isPaused = false

local level = 1

local delayShot = 20

local llegoAlFinalFase = 0
local czigzag = 0


love.frame = 0


function creaEnemigo(offx, offy)

  local enemy = {}

  enemy.x = offx
  enemy.y = offy
  enemy.xEnd = offx + enemies.width
  enemy.yEnd = offy + enemies.height

  table.insert(enemies.list, enemy)

end

function creaEnemigos()

    local y = levelsCfg[level].startY

    local nextE = levelsCfg[level].nextY

    local rows = levelsCfg[level].rows

    for j = 1, rows do

      for b = 1, #levelsCfg[level].blocks do

        local bl = levelsCfg[level].blocks[b]

        for i = 1, bl.enemies do

          creaEnemigo(bl.startX + (i * bl.nextX), y)

        end

      end

      y = y + nextE

    end

end  

function setInitValues()

  gameover = false

  score = 0

  level = 1

  llegoAlFinalFase = 0

  -- Configuración inicial de los enemigos

  creaEnemigos()

end

-- Carga de recursos y configuración inicial

function love.load(args)

  
  if  activeDebug or (args and args[#args]=='-debug' and activeDebug) then 
    require("mobdebug").start() 
  end
  if activeProfiler then
    love.profiler = require('Libs/profile') 
    love.profiler.start()
  end
  
  love.window.setMode(900, 900)  -- Cambia el tamaño de la ventana a 800x600
  print("inicializando")

  screenWidth = love.graphics.getWidth()

  screenHeight = love.graphics.getHeight()

  
  -- Carga de imágenes

  player.image = love.graphics.newImage("player.png")

  player.width = 48

  player.height = 48

  projectiles.image = love.graphics.newImage("rocket.png")

  projectiles.width = 3

  projectiles.height = 7

  projectiles.speed = 300

  projectiles.list = {}

  enemies.image = love.graphics.newImage("enemy.png")

  enemies.width = 48

  enemies.height = 48

  enemies.list = {}



  -- Configuración inicial del jugador

  player.x = 400

  player.y = screenHeight - 50



  setInitValues()

end



-- Actualización del juego

function love.update(dt)
  local tot = 0
  local proj
  local list
  if activeProfiler then
    love.frame = love.frame + 1
    if love.frame%100 == 0 then
      love.report = love.profiler.report(20)
      love.profiler.reset()
    end
  end

  if gameover then

      if love.keyboard.isDown("up") then

        setInitValues()

      else

        return

      end

  end
  if isPaused then
        return  -- Si el juego está pausado, no se ejecuta la lógica de actualización
  end
  checkShotsOnEnemy(enemies, enemies.list, projectiles, projectiles.list)

  checkEnemyHitPlayer(enemies, enemies.list, player)

  -- Movimiento del jugador
  if key == "p" or key == "escape" then
      isPaused = not isPaused  -- Cambia el estado de pausa
  end
    
  if love.keyboard.isDown("left") then

      player.x = player.x - 300 * dt

  elseif love.keyboard.isDown("right") then

      player.x = player.x + 300 * dt

  end



  -- Disparo del jugador

  if love.keyboard.isDown("space") then

    c = c + 1

    if c > delayShot then
      local done = false
      tot = #projectiles.list
      local list = projectiles.list
      for i = 1, tot do
        if list[i].removed then
          proj = list[i]
          proj.removed = false
          proj.x = player.x + player.width/2
          proj.y = player.y + player.width/2
          done = true
        end
      end 
      if not done then
        local   projectile = {}

        projectile.x = player.x + player.width/2
        projectile.y = player.y + player.width/2
        projectile.removed = false

        table.insert(projectiles.list, projectile)
      end

      c = 0
    end

  end



  -- Movimiento de los proyectiles
  tot = #projectiles.list
  list = projectiles.list
  local speed = projectiles.speed
  local i = 1
  while i <= tot do
    proj = list[i]
    proj.y = proj.y - speed * dt
    if proj.y < 0 then
      proj.removed = true
    end
    i = i + 1
  end
  --[[for i, projectile in ipairs(projectiles.list) do

      projectile.y = projectile.y - projectiles.speed * dt

      if projectile.y < 0 then

          table.remove(projectiles, i)

      end

  end]]

  local enimesAtEnd = 0

  -- Movimiento básico de los enemigos
  if levelsCfg[level].zigzagX ~= 0 then
    if czigzag == 0 then
      levelsCfg[level].zigzagX = levelsCfg[level].zigzagX * -1
      czigzag  = 1
    else
      czigzag = czigzag + 1
      if czigzag > 40 then
         czigzag = 0
      end
    end
  end
  
  for _, enemy in ipairs(enemies.list) do

      enemy.y = enemy.y + levelsCfg[level].speed * dt
      if czigzag > 0 then
        enemy.x = enemy.x + levelsCfg[level].zigzagX * dt
      end
      
      if enemy.y > screenHeight then
        enimesAtEnd = enimesAtEnd + 1
        enemy.y = levelsCfg[level].startY
      end

end

  if enimesAtEnd == #enemies.list then --Todos los enemigos llegaron al final
    if llegoAlFinalFase >= 1 then
      enemies.list = {}
      llegoAlFinalFase = 0
    else
      llegoAlFinalFase = llegoAlFinalFase + 1
    end
  end

  if not gameover and #enemies.list == 0 then 

    level = level + 1
    czigzag = 0

    if level > 5 then level = 5 end

    creaEnemigos()

  end

end



-- Dibujo en pantalla

function love.draw()
    love.graphics.setColor(1, 1, 1)
    if activeProfiler then
      love.graphics.print(love.report or "Please wait...")
    end
    -- Dibujo del jugador

    love.graphics.draw(player.image, player.x, player.y)

    --love.graphics.rectangle("line",player.x, player.y,48,48)






    -- Dibujo de los enemigos

    for _, enemy in ipairs(enemies.list) do

      love.graphics.draw(enemies.image, enemy.x, enemy.y)

      --love.graphics.rectangle("line",enemy.x, enemy.y,48,48)

    end

    if gameover then

        love.graphics.print("Game Over. Score:"..score, screenWidth/2 - 50, screenHeight/2)

    end
    if isPaused then
        love.graphics.print("Paused"..score, screenWidth/2 - 50, screenHeight/2)  -- Muestra el mensaje de pausa en la pantalla
    end    
    
    love.graphics.setColor(1, 0, 0)
    -- Dibujo de los proyectiles
    tot = #projectiles.list
    list = projectiles.list
    for i = 1, tot do
      proj = list[i]
      --if not proj.removed then
        --love.graphics.draw(projectiles.image, projectile.x, projectile.y)
        love.graphics.rectangle("line", proj.x, proj.y,3,8)
      --end
    end

end


function love.quit()

end
      



