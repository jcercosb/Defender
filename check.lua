function checkCollision(obj1, obj2)
    -- Obtener las coordenadas y tamaños de las áreas de colisión
    local x1, y1, w1, h1 = obj1.x, obj1.y, obj1.width, obj1.height
    local x2, y2, w2, h2 = obj2.x, obj2.y, obj2.width, obj2.height

    -- Verificar si las áreas de colisión se superponen
    if x1 < x2 + w2 and
       x1 + w1 > x2 and
       y1 < y2 + h2 and
       y1 + h1 > y2 then
        return true -- Hay colisión
    end

    return false -- No hay colisión
end
--[[function checkShotsOnEnemy(enemies, listEnemies, playerShots, listShots)
    -- Verificar colisiones entre disparos y naves enemigas
  for i, shot in ipairs(listShots) do
      for j, enemy in ipairs(listEnemies) do   
        if shot.x + playerShots.width > enemy.x and
          shot.x + playerShots.width < enemy.x + enemies.width and
          shot.y > enemy.y and
          shot.y < enemy.y + enemies.height then
              table.remove(listShots, i)
              table.remove(listEnemies, j)
              score = score + 1
              --love.timer.sleep(5)
              break
          end
      end
  end
end]]
function checkShotsOnEnemy(enemies, listEnemies, playerShots, listShots)
  local enemyCount = #listEnemies
  local shotCount = #listShots
  local i = 1

  while i <= shotCount do
    local shot = listShots[i]
    if not shot.removed then
      local shotX = shot.x + playerShots.width/2

      local j = 1
      local enemyRemoved = false

      while j <= enemyCount do
        local enemy = listEnemies[j]

        if shotX > enemy.x and shotX < enemy.x+48 and shot.y > enemy.y and shot.y < enemy.y+48 then
          shot.removed = true
          table.remove(listEnemies, j)
          enemyCount = enemyCount - 1
          shotCount = shotCount - 1
          score = score + 1
          enemyRemoved = true
          break
        end

        j = j + 1
      end

      if not enemyRemoved then
        i = i + 1 --saltamos al siguiente si no hay borrado
      end
    else
      i = i + 1
    end
  end
end
function checkEnemyHitPlayer(enemies, listEnemies, player)
  -- Verificar colisiones entre jugador y naves enemigas
  local px = player.x
  local py = player.y
  local pxEnd = player.x + player.width
  local pyEnd = player.y + player.height
  local enemyCount = #listEnemies
  local enemyRemoved = false
  local j = 1
  while j <= enemyCount do
    local enemy = listEnemies[j]

    if px > enemy.x and px < enemy.x+48 and py > enemy.y and py < enemy.y+48 then
      gameover = true
      enemies.list = {}
      break
    end

    j = j + 1
  end
end
--[[function checkEnemyHitPlayer(enemies, listEnemies, player)
  -- Verificar colisiones entre jugador y naves enemigas
  for i, enemy in ipairs(listEnemies) do
      if ((player.x > enemy.x and
          player.x < enemy.x + enemies.width) or
          (player.x + player.width > enemy.x and
          player.x + player.width < enemy.x + enemies.width)) and
          player.y > enemy.y and
          player.y < enemy.y + enemies.height then
            love.timer.sleep(1)
          gameover = true
          enemies.list = {}
          break
      end
  end
end]]