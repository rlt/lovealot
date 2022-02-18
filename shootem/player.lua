Object = require "classic"

Player = Object:extend()

radius = 0

function Player:new(startX, startY, screenHeight)
  self.image = love.graphics.newImage("assets/images/sheep.png")
  self.width = self.image:getWidth();
  self.height = self.image:getHeight();
  self.x = startX
  self.y = startY + self.height / 2
  self.speed = 500
  self.bullets = {}
  self.angle = 0
  self.cos = 0
  self.sin = 0

  self.screenHeight = screenHeight
  self.bx = startX
  self.by = 0 + self.height
end

function Player:moveLeft(dt)
  self.x = self.x - self.speed * dt
  self.bx = self.bx - self.speed * dt
end

function Player:moveRight(dt)
  self.x = self.x + self.speed * dt
  self.bx = self.bx + self.speed * dt
end

function Player:moveUp(dt)
  self.y = self.y - self.speed * dt
  self.by = self.by - self.speed * dt
end

function Player:moveDown(dt)
  self.y = self.y + self.speed * dt
  self.by = self.by + self.speed * dt
end

function Player:leftSide()
  return self.x - self.width/2
end

function Player:rightSide()
  return self.x + self.width/2
end

function Player:topSide()
  return self.y - self.height/2
end

function Player:bottomSide()
  return self.y + self.height/2
end

function Player:rotateClockwise(dt)
  self.angle = self.angle + 100 * dt
  self:calcCoords(dt)
end

function Player:rotateCounterClockwise(dt)
  self.angle = self.angle - 100 * dt
  self:calcCoords(dt)
end

function Player:shoot()
  self:calcCoords()
  table.insert(self.bullets, { x = self.bx, y = self.by, width = 10, height = 50, angle = self.angle, sin = self.sin, cos = self.cos })
end

function Player:draw()
  love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), 1, 1, self.width/2, self.height/2)
  --love.graphics.rectangle("line", self.x - self.width / 2, self.y - self.height/2, self.width, self.height)
  love.graphics.setColor(1, 0, 0)

  love.graphics.points(self.bx, self.by)
  love.graphics.points(self.x, self.y)

  love.graphics.print("Angle "..self.angle)
  love.graphics.print("Cos "..self.cos, 0, 10)
  love.graphics.print("Sin "..self.sin, 0, 20)
  love.graphics.print("radius "..radius, 0, 30)
  love.graphics.print("x "..self.x, 0, 40)
  love.graphics.print("bx "..self.bx, 0, 50)
  love.graphics.print("y "..self.y, 0, 60)
  love.graphics.print("by "..self.by, 0, 70)

  -- centre to sheep head
  love.graphics.line(self.x, self.y, self.bx, self.by)
  -- centre to floor
  love.graphics.line(self.x, self.y, self.x, screenHeight)

  love.graphics.setColor(1, 1, 1, 1)

  for i,bullet in ipairs(self.bullets) do
    --love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    self:drawRotatedBullet(bullet)
  end
end

function Player:drawRotatedBullet(bullet)
  love.graphics.push()
	love.graphics.translate(bullet.x, bullet.y)
	love.graphics.rotate(math.rad(bullet.angle))
	love.graphics.rectangle('fill', 0, 0, bullet.width, bullet.height) -- origin in the top left corner
	love.graphics.pop()
end

function Player:calcCoords(dt)
  radius = self.height / 2
  radians = math.rad(self.angle + 90)

  self.cos = math.cos(radians)
  self.sin = math.sin(radians)

  self.bx = self.cos * radius + self.x 
  self.by = self.sin * radius + self.y
end
