Object = require "classic"

Opponent = Object:extend()

MAX_SPEED = 1000

function Opponent:new(startX, startY)
  self.image = love.graphics.newImage("cat.png") -- 900 x 577
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = startX
  self.y = startY - self.height
  self.speed = MAX_SPEED
  self.direction = "left"
  self.hitCount = 0
  self.furballs = {}
  self.rads = 0
  self.dead = false
end

function Opponent:move(dt, screenWidth)
  if self.dead then return end

  new_x = self.x
  if self.direction == "left" then
    new_x = new_x - self.speed * dt
    if new_x <= 0 then
      self.x = 0
      self.direction = "right"
    else
      self.x = new_x
    end
  else
    new_x = new_x + self.speed * dt
    if new_x >= screenWidth - 90 then
      self.x = screenWidth - 90
      self.direction = "left"
    else
      self.x = new_x
    end
  end
end

function Opponent:isHit(bullet)
  if bullet.x < self.x + 90 and 
     bullet.x + bullet.width > self.x and 
     bullet.y < self.y and 
     bullet.height + bullet.y > self.y then
    self.hitCount = self.hitCount + 1
    self:calculateSpeed()
    self:checkIfDead()

    if self.dead ~= true then
      self:coughFurball()
    end
    return true
  end
end

function Opponent:isFurballHit(bullet)
  for i=#self.furballs, 1, -1 do
    furball = self.furballs[i]
    if bullet.x < furball.x + furball.radius and 
      bullet.x + bullet.width > furball.x - furball.radius and 
      bullet.y < furball.y + furball.radius and 
      bullet.height + bullet.y > furball.y then
        table.remove(self.furballs, i)
      return true
    end
  end
end

function Opponent:checkIfDead()
  if self.hitCount == 4 then
    self.dead = true
  end
end

function Opponent:calculateSpeed()
  print(self.hitCount)
  self.speed = math.max(0, MAX_SPEED - (250 * self.hitCount))
end

function Opponent:coughFurball()
  table.insert(self.furballs, { x = self.x - 45, y = self.y, radius = 20 })
end

function Opponent:draw()
  love.graphics.draw(self.image, self.x, self.y, math.rad(self.rads))

  for i,furball in ipairs(self.furballs) do
    love.graphics.circle('fill', furball.x, furball.y, furball.radius)
  end
end
