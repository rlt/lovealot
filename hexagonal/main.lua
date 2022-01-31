
local debug = false

local mouseX, mouseY, sector, sectorX, sectorY, lookX, lookY

local tiles = {}
local size = 13

local height = 48
local sectorHeight = height * 3 / 4
local width = math.sqrt(3)/2 * height

local cameraX = (love.graphics.getWidth() - (size * width) - (width / 2)) / 2
local cameraY = (love.graphics.getHeight() - (size * height) + (height / 4 * (size - 1))) / 2

local sizes = {}

sizes[5] = {
  { 1,0,0,0,1 },
  { 0,0,0,0,1 },
  { 0,0,0,0,0 },
  { 0,0,0,0,1 },
  { 1,0,0,0,1 }
}

sizes[13] = {
  { 1,1,1,0,0,0,0,0,0,0,1,1,1 },
  { 1,1,0,0,0,0,0,0,0,0,1,1,1 },
  { 1,1,0,0,0,0,0,0,0,0,0,1,1 },
  { 1,0,0,0,0,0,0,0,0,0,0,1,1 },
  { 1,0,0,0,0,0,0,0,0,0,0,0,1 },
  { 0,0,0,0,0,0,0,0,0,0,0,0,1 },
  { 0,0,0,0,0,0,0,0,0,0,0,0,0 },
  { 0,0,0,0,0,0,0,0,0,0,0,0,1 },
  { 1,0,0,0,0,0,0,0,0,0,0,0,1 },
  { 1,0,0,0,0,0,0,0,0,0,0,1,1 },
  { 1,1,0,0,0,0,0,0,0,0,0,1,1 },
  { 1,1,0,0,0,0,0,0,0,0,1,1,1 },
  { 1,1,1,0,0,0,0,0,0,0,1,1,1 }
}

-- load tile map
for x = 0, size - 1 do
  tiles[x] = {}
  for y = 0, size - 1 do
    local type = 'tile'

    if sizes[size][y + 1][x + 1] == 1 then type = 'empty' end

    tiles[x][y] = {
      x = x,
      y = y,
      type = type
    }

    local px, py

    if y % 2 == 0 then
      px = x * width
      py = y * sectorHeight
    else
      local xo = width / 2
      px = x * width + xo
      py = y * sectorHeight
    end

    tiles[x][y].vertices = {
      { x = px + width / 2, y = py }, 
      { x = px + width, y = py + height / 4 }, 
      { x = px + width, y = py + height / 4 * 3 },
      { x = px + width / 2, y = py + height }, 
      { x = px, y = py + height / 4 * 3 },
      { x = px, y = py + height / 4 } 
    }
  end
end

-- create hexagon data structure
for y = 0, size - 1 do
  for x = 0, size - 1 do

    if y ~= size - 1 then

      -- if even, link tiles below and below-left
      if y % 2 == 0 then
        -- when not on the left
        -- link bottom left
        if x ~= 0 then 
          tiles[x][y].bl = tiles[x - 1][y + 1]
          tiles[x - 1][y + 1].tr = tiles[x][y]
        end

        -- link bottom right
        tiles[x][y].br = tiles[x][y + 1]
        tiles[x][y + 1].tl = tiles[x][y]

      -- if odd, link tiles below and below-right
      else
        -- when not on the right
        -- link bottom right
        if x ~= size - 1 then
          tiles[x][y].br = tiles[x + 1][y + 1]
          tiles[x + 1][y + 1].tl = tiles[x][y]
        end

        -- link bottom left
        tiles[x][y].bl = tiles[x][y + 1]
        tiles[x][y + 1].tr = tiles[x][y]
      end

    end

    -- link left and right for convenience
    if x ~= size - 1 then
      tiles[x][y].r = tiles[x + 1][y]
    end

    if x ~= 0 then
      tiles[x][y].l = tiles[x - 1][y]
    end

  end
end



function insidePolygon(p, x, y) 
  local j = #p
  local inside = false
  
  for i = 1, #p do
    if(((p[i].y > y) ~= (p[j].y > y)) and
      (x < (p[j].x-p[i].x) * (y-p[i].y) / (p[j].y-p[i].y) + p[i].x)) then
        inside = not inside
    end
    j = i
  end

  return inside
end

function love.load()
  love.graphics.setFont(love.graphics.newFont(10))
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.quit()
  end

  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()

  if sector ~= nil then
    sector.highlight = false
  end

  if mouseY - cameraY < height then
    sectorY = 0
  else
    sectorY = math.floor((mouseY - cameraY) / sectorHeight)

    if (mouseY - cameraY) % sectorHeight < height / 4 then
      sectorY = sectorY - 1
    end
  end

  if (mouseY - cameraY) - (sectorY * sectorHeight) > height / 4 * 3 then
    lookY = true
  else
    lookY = false
  end
  
  if sectorY % 2 == 0 then
    sectorX = math.floor((mouseX - cameraX) / width)

    if (mouseX - cameraX) % width < width / 2 then
      lookX = 'left'
    else
      lookX = 'right'
    end
  else
    sectorX = math.floor(((mouseX - cameraX) - (width / 2)) / width)

    if ((mouseX - cameraX) - (width / 2)) % width < width / 2 then
      lookX = 'left'
    else
      lookX = 'right'
    end
  end

  if sectorX >= 0 and sectorX < size and sectorY >= 0 and sectorY < size then
    
    if tiles[sectorX][sectorY].type == 'tile' then

      local x = mouseX - cameraX
      local y = mouseY - cameraY

      if insidePolygon(tiles[sectorX][sectorY].vertices, x, y) then
        tiles[sectorX][sectorY].highlight = true
        sector = tiles[sectorX][sectorY]
      else
        if lookY and lookX == 'left' and tiles[sectorX][sectorY].bl then
          if insidePolygon(tiles[sectorX][sectorY].bl.vertices, x, y) then
            tiles[sectorX][sectorY].bl.highlight = true
            sector = tiles[sectorX][sectorY].bl
          end
        elseif lookY and lookX == 'right' and tiles[sectorX][sectorY].br then
          if insidePolygon(tiles[sectorX][sectorY].br.vertices, x, y) then
            tiles[sectorX][sectorY].br.highlight = true
            sector = tiles[sectorX][sectorY].br
          end
        end
      end
    end
  end

end

function drawHexagon(tx, ty, x, y, width, height)
  if debug then
    if tiles[tx][ty].highlight then
      love.graphics.setColor(0, 0, 255)
    else
      love.graphics.setColor(255, 255, 255)
    end

    love.graphics.rectangle('line', x, y, width, height)
  end

  if tiles[tx][ty].type ~= 'tile' then
    return
  end

  local vertices = {
    x + width / 2, y, 
    x + width, y + height / 4, 
    x + width, y + height / 4 * 3,
    x + width / 2, y + height, 
    x, y + height / 4 * 3,
    x, y + height / 4, 
  }

  if tiles[tx][ty].highlight then
    love.graphics.setColor(0, 0, 255)
  else
    love.graphics.setColor(255, 255, 255)
  end

  love.graphics.polygon('line', vertices)

  if debug then
    love.graphics.setColor(255, 255, 255)

    -- self  
    love.graphics.print(tx .. ',' .. ty, x + width / 2 - 10, y + height / 2 - 5)

    -- left
    if tiles[tx][ty].l and tiles[tx][ty].l.type == 'tile' then
      love.graphics.print(tiles[tx][ty].l.x .. ',' .. tiles[tx][ty].l.y, 
        x + 5, y + height / 2 - 5)
    end

    -- right
    if tiles[tx][ty].r and tiles[tx][ty].r.type == 'tile' then
      love.graphics.print(tiles[tx][ty].r.x .. ',' .. tiles[tx][ty].r.y, 
        x + width - 25, y + height / 2 - 5)
    end

    -- top left
    if tiles[tx][ty].tl and tiles[tx][ty].tl.type == 'tile' then
      love.graphics.print(tiles[tx][ty].tl.x .. ',' .. tiles[tx][ty].tl.y, 
        x + width / 6 + 5, y + height / 6)
    end

    -- top right
    if tiles[tx][ty].tr and tiles[tx][ty].tr.type == 'tile' then
      love.graphics.print(tiles[tx][ty].tr.x .. ',' .. tiles[tx][ty].tr.y, 
        x + width / 6 * 3 + 10, y + height / 6)
    end

    -- bottom left
    if tiles[tx][ty].bl and tiles[tx][ty].bl.type == 'tile' then
      love.graphics.print(tiles[tx][ty].bl.x .. ',' .. tiles[tx][ty].bl.y, 
        x + width / 6 + 5, y + height / 6 * 4 + 5)
    end

    -- bottom right
    if tiles[tx][ty].br and tiles[tx][ty].br.type == 'tile' then
      love.graphics.print(tiles[tx][ty].br.x .. ',' .. tiles[tx][ty].br.y, 
        x + width / 6 * 3 + 10, y + height / 6 * 4 + 5)
    end
  end
end

function love.draw()

  love.graphics.push()
  love.graphics.translate(cameraX, cameraY)
  love.graphics.setColor(255, 255, 255)

  for x = 0, size - 1 do
    for y = 0, size - 1 do
      if y % 2 == 0 then
        drawHexagon(x, y, x * width, y * sectorHeight, width, height)
      else
        local xo = width / 2
        drawHexagon(x, y, x * width + xo, y * sectorHeight, width, height)
      end
    end 
  end

  love.graphics.pop()

  if debug then
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('line', 0, 0, width * size, sectorHeight * size)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print('mx: ' .. mouseX - cameraX, 10, 10) 
    love.graphics.print('my: ' .. mouseY - cameraY, 10, 30) 
    love.graphics.print('sx: ' .. sectorX, 10, 50) 
    love.graphics.print('sy: ' .. sectorY, 10, 70)
    love.graphics.print('lx: ' .. lookX, 10, 90)
    love.graphics.print('ly: ' .. tostring(lookY), 10, 110)
  end
end
