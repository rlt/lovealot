require "shape"

Ellipse = Shape:extend()

function Ellipse:new(i)
  self.super.new(self, 150 * i, 50)
  self.position = i
  self.rx = 75
  self.ry = 50
end

function Ellipse:draw()
  love.graphics.ellipse("line", self.x, self.y, self.rx, self.ry)
end
