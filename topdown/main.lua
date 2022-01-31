
local world, objects

local rad90 = math.rad(90)
local rad180 = math.rad(180)

function physicsObject(x, y, w, h, type, density, color)
  local o = {}
  o.color = color or {0.1, 0.9, 0.5}
  o.body = love.physics.newBody(world, x, y, type)
  o.shape = love.physics.newRectangleShape(w, h)
  o.fixture = love.physics.newFixture(o.body, o.shape, density)
  table.insert(objects.all, o)
  return o
end

function love.load()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 0, true)

  objects = {}
  objects.all = {}

  objects.ground = physicsObject(400, 600, 650, 50, 'static', 1, {0.8, 0.5, 0.7})

  objects.player = physicsObject(300, 200, 40, 40, 'dynamic', 1, {0.1, 0.5, 0.9})
  objects.player.body:setLinearDamping(5)
  objects.player.fixture:setRestitution(0.5)
  objects.player.body:setAngularDamping(5)

  objects.block1 = physicsObject(200, 525, 200, 100, 'dynamic', 2)
  objects.block2 = physicsObject(200, 150, 100, 50, 'dynamic', 2)
end


function love.update(dt)
  if love.keyboard.isDown('escape') then love.event.quit() end

  local mag = 300
  local angle = math.atan2(
    love.mouse.getY() - objects.player.body:getY(),
    love.mouse.getX() - objects.player.body:getX()
  )
  objects.player.body:setAngle(angle)

  if love.keyboard.isDown('w') then
    objects.player.body:applyForce(math.cos(angle) * mag, math.sin(angle) * mag)
  end

  if love.keyboard.isDown('s') then
    objects.player.body:applyForce(math.cos(angle - rad180) * mag, math.sin(angle - rad180) * mag)
  end

  if love.keyboard.isDown('a') then
    objects.player.body:applyForce(math.cos(angle - rad90) * mag, math.sin(angle - rad90) * mag)
  end

  if love.keyboard.isDown('d') then
    objects.player.body:applyForce(math.cos(angle + rad90) * mag, math.sin(angle + rad90) * mag)
  end

  world:update(dt)
end

function love.draw()
  -- background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  -- player view
  local angle = objects.player.body:getAngle()
  local x1, y1 = objects.player.body:getPosition()
  local x2 = x1 + (150 * math.cos(angle))
  local y2 = y1 + (150 * math.sin(angle))

  love.graphics.setColor(1, 1, 1)
  love.graphics.line(x1, y1, x2, y2)

  for k, o in pairs(objects.all) do
    love.graphics.setColor(unpack(o.color))
    love.graphics.polygon("fill", o.body:getWorldPoints(o.shape:getPoints()))
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.print(angle, 10, 10)
end
