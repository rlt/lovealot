require "classic"

Explosion = Object:extend()

function Explosion:new(x, y)
  self.x = x
  self.y = y
  self.currentFrame = 1
  self.expired = false
end

function Explosion:update(dt)
  self.currentFrame = self.currentFrame + dt * 70
  self.expired = self.currentFrame > 9
end

function Explosion:draw(images)
  if self.currentFrame <= 9 then
    love.graphics.draw(images[math.floor(self.currentFrame)], self.x, self.y, 0, 0.1, 0.1)
  end
end
