Object = require "classic"

Player = Object:extend()

function Player:new(startX, startY)
  self.image = love.graphics.newImage("sheep.png")
  self.width = self.image:getWidth();
  self.height = self.image:getHeight();
  self.x = startX
  self.y = startY + self.height / 2
  self.speed = 500
  self.bullets = {}
  self.rads = 0
end

function Player:moveLeft(dt)
  self.x = self.x - self.speed * dt
end

function Player:moveRight(dt)
  self.x = self.x + self.speed * dt
end

function Player:moveUp(dt)
  self.y = self.y - self.speed * dt
end

function Player:moveDown(dt)
  self.y = self.y + self.speed * dt
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
  self.rads = self.rads + 100 * dt
end

function Player:rotateCounterClockwise(dt)
  self.rads = self.rads - 100 * dt
end

function Player:shoot()
  table.insert(self.bullets, { x = self.x, y = self:bottomSide(), width = 10, height = 50, rads = self.rads })
end

function Player:draw()
  love.graphics.draw(self.image, self.x, self.y, math.rad(self.rads), 1, 1, self.width/2, self.height/2)

  for i,bullet in ipairs(self.bullets) do
    --love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.width, bullet.height)
    self:drawRotatedBullet(bullet)
  end
end

function Player:drawRotatedBullet(bullet)
  love.graphics.push()
	love.graphics.translate(bullet.x, bullet.y)
	love.graphics.rotate(bullet.rads)
	love.graphics.rectangle('fill', 0, 0, bullet.width, bullet.height) -- origin in the top left corner
	love.graphics.pop()
end
