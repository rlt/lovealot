Object = require "classic"

Shape = Object:extend()

function Shape:new(x, y, windowWidth, windowHeight)
  self.x = x
  self.y = y
  self.maxWidth = windowWidth
  self.maxHeight = windowHeight
  self.minHeight = 0
  self.minWidth = 0
end

function Shape:moveDown(dt)
  new_y = self.y + 100 * dt
  self.y = math.min(new_y, self.maxHeight)
end

function Shape:moveUp(dt)
  new_y = self.y - 100 * dt
  self.y = math.max(new_y, self.minHeight)
end

function Shape:moveLeft(dt)
  new_x = self.x - 100 * dt
  self.x = math.max(new_x, self.minWidth)
end

function Shape:moveRight(dt)
  new_x = self.x + 100 * dt
  self.x = math.min(new_x, self.maxWidth)
end
