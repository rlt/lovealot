package.path = "./lua_modules/share/lua/5.4/?.lua"
package.cpath = "./lua_modules/lib/lua/5.4/?.so"
io.stdout:setvbuf("no")

require "player"
require "opponent"

function love.load()
  screenWidth = love.graphics.getWidth();
  screenHeight = love.graphics.getHeight();

  player = Player(screenWidth/2, 0, screenHeight)
  opponent = Opponent(screenWidth/2, screenHeight)

  --backtrack = love.audio.newSource("song.ogg", "stream")
  --backtrack:setLooping(true)
  --backtrack:setVolume(0.5)
  --backtrack:play()

  --hit = love.audio.newSource("sfx.ogg", "static")
end

function love.update(dt)
  for i,v in ipairs(player.bullets) do
    if v.cos >= 0 then
      new_x = v.x + 1000 * dt * v.cos
    else
      new_x = v.x - 1000 * dt * -v.cos
    end

    if v.sin >= 0 then
      new_y = v.y + 1000 * dt * v.sin
    else 
      new_y = v.y - 1000 * dt * -v.sin
    end

    if new_y > screenHeight or new_x > screenWidth or new_y < 0 or new_x < 0 then
      table.remove(player.bullets, i)
    else
      v.y = new_y
      v.x = new_x
    end 
  end

  if love.keyboard.isDown("d") then
    if player:rightSide() < screenWidth then
      player:moveRight(dt)
    end
  end

  if love.keyboard.isDown("a") then
    if player:leftSide() > 0 then
      player:moveLeft(dt)
    end
  end

  if love.keyboard.isDown("s") then
    if player:bottomSide() < screenHeight - opponent.height - 10 then
      player:moveDown(dt)
    end
  end

  if love.keyboard.isDown("w") then
    if player:topSide() > 0 then
      player:moveUp(dt)
    end
  end

  if love.keyboard.isDown("q") then
    player:rotateClockwise(dt)
  end

  if love.keyboard.isDown("e") then
    player:rotateCounterClockwise(dt)
  end

  if opponent.dead then
    opponent.furballs = {}
    opponent.rads = math.max(90, opponent.rads + 1)
    opponent.y = opponent.y + 100 * dt
    return
  end

  for i=#player.bullets, 1, -1 do
    bullet = player.bullets[i]
    if opponent:isHit(bullet, dt) or opponent:isFurballHit(bullet) then
      table.remove(player.bullets,i)
      if opponent.dead then break end
    end
  end

  for i,furball in ipairs(opponent.furballs) do
    local angle = math.atan2(player.y - furball.y, player.x - furball.x)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    furball.x = furball.x + 750 * cos * dt
    furball.y = furball.y + 750 * sin * dt
  end

  opponent:move(dt, screenWidth)

end

function love.keypressed(key, scancode, isRepeat)
  if key == "space" then
    player:shoot()
    --hit:play()
  end

  -- debugging
  if key == "f3" then
    love.event.quit("restart")
  end

  if key == "p" then
    opponent.speed = 500
    opponent.hitCount = 0
  end
  if key == "l" then
    opponent.speed = 0
    opponent.hitCount = 0
  end
end

function love.draw()
  player:draw()
  opponent:draw()
end
