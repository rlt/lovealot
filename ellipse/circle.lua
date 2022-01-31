-- require "shape"

Circle = Shape:extend()

function Circle:new(x, y, r, windowWidth, windowHeight)
  self.super.new(self, x, y, windowWidth, windowHeight)
  self.radius = r
  self.drawMode = 'line'
  self.minWidth = r
  self.maxWidth = windowWidth - r
  self.minHeight = r
  self.maxHeight = windowHeight - r
end

function Circle:draw()
  love.graphics.circle(self.drawMode, self.x, self.y, self.radius)
end

function Circle:xc()
  return (self.x + self.radius)
end

function Circle:yc()
  return (self.y + self.radius)
end

function Circle:collision(otherCircle)
  local dx = self:xc() - otherCircle:xc()
  local dy = self:yc() - otherCircle:yc()
  local distance = math.sqrt(dx * dx - dy * dy)

  if distance < (self.radius + otherCircle.radius) then
    self.drawMode = 'fill'
  else
    self.drawMode = 'line'
  end
end
