function love.load()
  circle = {}
  circle.x = 100
  circle.y = 100
  circle.radius = 50
  circle.speed = 200
end

function love.update(dt)
  mouse_x, mouse_y = love.mouse.getPosition()

  angle = math.atan2(mouse_y - circle.y, mouse_x - circle.x)

  cos = math.cos(angle)
  sin = math.sin(angle)

  distance_a = (mouse_x - circle.x) ^ 2
  distance_o = (mouse_y - circle.y) ^ 2
  distance_h = math.sqrt((distance_a + distance_o))

  circle.x = circle.x + circle.speed * cos * distance_h / 100 * dt
  circle.y = circle.y + circle.speed * sin * distance_h / 100 * dt
end

function love.draw()

  love.graphics.print("a: " .. distance_a .. ", o: " .. distance_o)

  love.graphics.circle("line", circle.x, circle.y, circle.radius)
  love.graphics.circle("line", circle.x, circle.y, distance_h)

  
  love.graphics.line(circle.x, circle.y, mouse_x, circle.y)
  love.graphics.line(circle.x, circle.y, circle.x, mouse_y)

  --The angle
  love.graphics.line(circle.x, circle.y, mouse_x, mouse_y)

  love.graphics.line(mouse_x, mouse_y, circle.x, mouse_y)
  love.graphics.line(mouse_x, mouse_y, mouse_x, circle.y)


end
