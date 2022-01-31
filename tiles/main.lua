function love.load()
  tilemap = {
    {1, 6, 6, 2, 1, 6, 6, 2},
    {3, 0, 0, 4, 5, 0, 0, 3},
    {3, 0, 0, 0, 0, 0, 0, 3},
    {4, 2, 0, 0, 0, 0, 1, 5},
    {1, 5, 0, 0, 0, 0, 4, 2},
    {3, 0, 0, 0, 0, 0, 0, 3},
    {3, 0, 0, 1, 2, 0, 0, 3},
    {4, 6, 6, 5, 4, 6, 6, 5}
  }

  tileset = love.graphics.newImage("tileset.png")
  tileset_width = tileset:getWidth()
  tileset_height = tileset:getHeight()

  tile_width = tileset_width / 3 - 2
  tile_height = tileset_height / 2 - 2

  quads = {}
  for i=0,1 do
    for j=0,2 do
      table.insert(quads,
        love.graphics.newQuad(1 + j * (tile_width + 2), 1 + i * (tile_height + 2), tile_width, tile_height, tileset_width, tileset_height)
      )
    end
  end

  player = { image  = love.graphics.newImage("player.png"), tile_x = 2, tile_y = 2 }
end

function love.update(dt)
  
end

function love.draw()
  for i,row in ipairs(tilemap) do
    for j,col in ipairs(row) do
      -- fill, x, y, width, height
      if col ~= 0 then
        love.graphics.draw(tileset, quads[col], j * tile_width, i * tile_height)
        --love.graphics.rectangle('line', j * 32, i * 32, 32, 32)
      end
    end
  end

  
    love.graphics.draw(player.image, player.tile_x * tile_width, player.tile_y * tile_height)
  
end

function love.keypressed(key)
  local x = player.tile_x
  local y = player.tile_y

  if key == "left" then
      x = x - 1
  elseif key == "right" then
      x = x + 1
  elseif key == "up" then
      y = y - 1
  elseif key == "down" then
      y = y + 1
  end

  if tilemap[y][x] == 0 then
    player.tile_x = x
    player.tile_y = y
  end
end
