package.path = "./lua_modules/share/lua/5.4/?.lua"
package.cpath = "./lua_modules/lib/lua/5.4/?.so"

local inspect = require "inspect"
require "ellipse"
require "circle"

function love.load()
  sheep = love.graphics.newImage("sheep.png")
  sheepWidth = sheep:getWidth()
  sheepHeight = sheep:getHeight()
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()

  X, Y, RX, RY, SG = 50, 50, 50, 50, 5 
  SZ, SX, r = 1, 1, 0

  shapes = {}
  for i = 1, 4, 1 do
    table.insert(shapes, Circle(100 * i , 50, 50, windowWidth, windowHeight))
  end
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.quit()
  end

  if love.keyboard.isDown("s") and love.keyboard.isDown("d") then
    for i,v in ipairs(shapes) do
      v:moveDown(dt)
      v:moveRight(dt)
    end
  end

  if love.keyboard.isDown("s") and love.keyboard.isDown("a") then
    for i,v in ipairs(shapes) do
      v:moveDown(dt)
      v:moveLeft(dt)
    end
  end

  if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
    for i,v in ipairs(shapes) do
      v:moveUp(dt)
      v:moveRight(dt)
    end
  end

  if love.keyboard.isDown("w") and love.keyboard.isDown("a") then
    for i,v in ipairs(shapes) do
      v:moveUp(dt)
      v:moveLeft(dt)
    end
  end

  if love.keyboard.isDown("s") then
    for i,v in ipairs(shapes) do
      v:moveDown(dt)
    end
  elseif love.keyboard.isDown("w") then
    for i,v in ipairs(shapes) do
      v:moveUp(dt)
    end
  elseif love.keyboard.isDown("a") then
    for i,v in ipairs(shapes) do
      v:moveLeft(dt)
    end
  elseif love.keyboard.isDown("d") then
    for i,v in ipairs(shapes) do
      v:moveRight(dt)
    end
  end

  if love.keyboard.isDown("z") then
    SX = SX + 1 * dt
    SZ = SZ + 1 * dt

    for i,v in ipairs(shapes) do
      v.radius = v.radius + 1 * dt
    end
  end

  if love.keyboard.isDown("x") then
    SX = SX - 1 * dt
    SZ = SZ - 1 * dt

    for i,v in ipairs(shapes) do
      v.radius = v.radius - 1 * dt
    end
  end

  if love.keyboard.isDown("q") then
    r = r + 1 * dt
  end

  if love.keyboard.isDown("e") then
    r = r - 1 * dt
  end

  for i,v in ipairs(shapes) do
    if #shapes ~= i then
      v:collision(shapes[i+1])
    else
      v:collision(shapes[i-1])
    end
  end

end

function love.draw()
  for i,v in ipairs(shapes) do
    v:draw()
  end

  love.graphics.draw(sheep, 200, 300, r, SX, SZ, sheepWidth/2, sheepHeight/2)
end
