require("check")

require("config")


-- ____________________         Variables globales     ____________________

local activeProfiler = false
local activeDebug = true



local player = {}      -- Datos del jugador

local projectiles = {} -- Almacena los proyectiles disparados :)

local enemies = {}     -- Almacena los enemigos

local record = {}      -- Almacena los records


local c = 0

local enemiesY = 0

local lives = 3

Nivel = 1

score = 0

gameover = false

pantallaInicio = true

local isPaused = false

local level = 1

local delayShot = 20

local llegoAlFinalFase = 0

local czigzag = 0

love.frame = 0


function creaEnemigo(offx, offy, img)
  local enemy = {}
  enemy.death = 0
  enemy.x = offx
  enemy.y = offy
  enemy.xEnd = offx + enemies.width
  enemy.yEnd = offy + enemies.height
  enemy.image = img

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
        creaEnemigo(bl.startX + (i * bl.nextX), y, bl.image)
      end
    end

    y = y + nextE
  end
end

function setInitValues()
  --gameplay = false

  gameover = false

  score = 0

  level = 1

  lives = 3

  llegoAlFinalFase = 0

  -- Configuración inicial de los enemigos
  --borramos enemigos
  enemies.list = {}

  creaEnemigos()
end

function deathPlayer()
  love.audio.play(finVida)

  lives = lives - 1

  if lives <= 0 then
    gameover = true
  else
    -- Limpiar Proyectiles
    projectiles.list = {}
    -- Limpiar Enemigos
    enemies.list = {}

    -- Configuración inicial de los enemigos

    creaEnemigos()
    -- pone sonido
    --love.audio.play(finalPartida)
    love.timer.sleep(1)
  end
end

-- introducir texto

function love.textinput(t)
  text = text .. t
end

-- Carga de recursos y configuración inicial _____________________ LOAD _________________________________________________

function love.load(args)
  if activeDebug or (args and args[#args] == '-debug' and activeDebug) then
    require("mobdebug").start()
  end
  if activeProfiler then
    love.profiler = require('Libs/profile')
    love.profiler.start()
  end

  love.window.setMode(900, 900) -- Cambia el tamaño de la ventana a 800x600
  print("inicializando")

  screenWidth = love.graphics.getWidth()

  screenHeight = love.graphics.getHeight()

  love.graphics.print("Inicialiazando", screenWidth / 2 - 50, screenHeight / 2)

  text = "Type away! -- "

  -- ___________________  Sonidos _____________________

  inicioPartida = love.audio.newSource("sonidos/inicioPartida.mp3", "stream")

  bum = love.audio.newSource("sonidos/big-impact-1.mp3", "static")

  disparo = love.audio.newSource("sonidos/disparoPew.mp3", "static")

  finVida = love.audio.newSource("sonidos/Oops.mp3", "static")

  finalPartida = love.audio.newSource("sonidos/VideoGameFin.mp3", "stream")

  -- ___________________ Carga de imágenes  __________________

  player.image = love.graphics.newImage("imagenes/player.png")

  player.width = 48

  player.height = 48

  projectiles.image = love.graphics.newImage("imagenes/rocket.png")

  projectiles.width = 3

  projectiles.height = 7

  projectiles.speed = 300

  projectiles.list = {}

  enemies.imageList = { love.graphics.newImage("imagenes/Bum-48.png"),
    love.graphics.newImage("imagenes/nave2.png"), love.graphics.newImage("imagenes/nave3.png"),
    love.graphics.newImage("imagenes/nave4.png"), love.graphics.newImage("imagenes/nave5.png"),
    love.graphics.newImage("imagenes/nave6.png"), love.graphics.newImage("imagenes/nave7.png"),
    love.graphics.newImage("imagenes/nave8.png"), love.graphics.newImage("imagenes/nave9.png"),
    love.graphics.newImage("imagenes/nave10.png"), love.graphics.newImage("imagenes/Bum-48.png") }

  enemies.width = 48

  enemies.height = 48

  enemies.list = {}




  -- Configuración inicial del jugador

  player.x = 400

  player.y = screenHeight - 50

  if not pantallaInicio then
    love.audio.play(inicioPartida)
    setInitValues()
  end
end

-- __________________________Actualización del juego _________________________ UpDate _____________________

function love.update(dt)
  local tot = 0
  local proj
  local list
  if activeProfiler then
    love.frame = love.frame + 1
    if love.frame % 100 == 0 then
      love.report = love.profiler.report(20)
      love.profiler.reset()
    end
  end



  -- _________________________ iniciar partida _______________________

  if pantallaInicio then
    love.audio.play(inicioPartida)
    if love.keyboard.isDown("1") then
      setInitValues()
      love.audio.stop(inicioPartida)
    else
      return
    end
  end
  if gameover then
    if love.keyboard.isDown("j") then
      setInitValues()
      love.audio.stop(finalPartida)
    else
      return
    end
  end
  -- _____________________ Detecta pausa __________________

  if love.keyboard.isDown("p") or love.keyboard.isDown("escape") then
    isPaused = not isPaused -- Cambia el estado de pausa
  end

  if isPaused then
    return -- Si el juego está pausado, no se ejecuta la lógica de actualización
  end

  --  _____________________ Chekea impactos  _________________

  checkShotsOnEnemy(enemies, enemies.list, projectiles, projectiles.list)

  checkEnemyHitPlayer(enemies, enemies.list, player)

  -- Movimiento del jugador

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
          proj.x = player.x + player.width / 2
          proj.y = player.y + player.width / 2
          done = true
        end
      end
      if not done then
        local projectile = {}

        projectile.x = player.x + player.width / 2
        projectile.y = player.y + player.width / 2
        projectile.removed = false

        table.insert(projectiles.list, projectile)
      end
      love.audio.play(disparo)
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
      czigzag                  = 1
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

  -- Los enemigos llegaron al final

  if enimesAtEnd == #enemies.list then
    if llegoAlFinalFase >= 1 then
      enemies.list = {}
      llegoAlFinalFase = 0
    else
      llegoAlFinalFase = llegoAlFinalFase + 1
    end
  end
  --   Los enemigos mueren
  if not gameover and #enemies.list == 0 then
    level = level + 1
    czigzag = 0

    if level > 9 then level = 1 end

    creaEnemigos()
  end
end

--       ___________________________       Dibujo en pantalla   ____________________ LoveDraw ______________________

function love.draw()
  love.graphics.setColor(1, 1, 1)

  if activeProfiler then
    love.graphics.print(love.report or "Please wait...")
  end

  --              Cabezera

  love.graphics.print("Vidas:" .. lives, 25, 25)
  love.graphics.print("Puntuacion:" .. score, screenWidth / 2 - 50, 25)
  love.graphics.print("Nivel:" .. level, screenWidth - 75, 25)
  -- _______________________ inicio partida __________________

  if pantallaInicio then
    love.audio.play(inicioPartida)
    love.graphics.print("Pulsa 1 para iniciar", screenWidth / 2 - 50, screenHeight / 2)
    --love.graphics.print("Score .-  " .. score, screenWidth / 2 - 50, screenHeight / 2 + 25)
    if love.keyboard.isDown("1") then
      pantallaInicio = false
      setInitValues()
      love.audio.stop(inicioPartida)
    end
  elseif gameover then --    _______________________  GAME OVER _________________
    love.audio.play(inicioPartida)
    love.graphics.print("GAME OVER", screenWidth / 2 - 50, screenHeight / 2)
    love.graphics.print("Score .-  " .. score, screenWidth / 2 - 50, screenHeight / 2 + 25)

    if score > 100 then
      love.graphics.print("Introduce tu nombre .-  " .. score, screenWidth / 2 - 50, screenHeight / 2 + 50)
    end
  elseif isPaused then --  _______________ PAUSA ___________________
    love.graphics.print("Pausa", screenWidth / 2 - 50, screenHeight / 2) -- Muestra el mensaje de pausa en la pantalla

  else
    -- Dibujo del jugador

    love.graphics.draw(player.image, player.x, player.y)

    --love.graphics.rectangle("line",player.x, player.y,48,48)


    --              Dibujo de los enemigos
    local listEnemies = enemies.list
    local enemyCount = #listEnemies
    local j = 1
    while j <= enemyCount do
      local enemy = listEnemies[j]
      if enemy.death == 0 then
        love.graphics.draw(enemies.imageList[enemy.image], enemy.x, enemy.y)
        --love.graphics.rectangle("line", enemy.x, enemy.y, 48, 48)
      else
        if enemy.death > 10 then
          table.remove(listEnemies, j)
          enemyCount = enemyCount - 1
        else
          enemy.death = enemy.death + 1
          love.graphics.draw(enemies.imageList[1], enemy.x, enemy.y)
        end
      end
      j = j + 1
    end


    --              Dibujo de los proyectiles

    love.graphics.setColor(1, 0, 0)
    -- Dibujo de los proyectiles
    tot = #projectiles.list
    list = projectiles.list
    for i = 1, tot do
      proj = list[i]
      --if not proj.removed then
      --love.graphics.draw(projectiles.image, projectile.x, projectile.y)
      love.graphics.rectangle("fill", proj.x, proj.y, 3, 8)
      --end
    end
  end



end

-- ______________  QUIT _____________________
function love.quit()

end
