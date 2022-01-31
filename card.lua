
-- copy card onto base copy
function copyTable(card, base)
  card = card or {}
  base = base or {}

  for k, v in pairs(card) do
    if type(v) == 'table' then
      base[k] = copyTable(v)
    else
      base[k] = v
    end
  end

  return base
end

-- data access mt
local mt = {}

-- private data or meta function
function mt.__index(t, k)
  return t.data[k] or mt[k]
end

-- set private data
function mt.__newindex(t, k, v)
  t.data[k] = v
end

-- create a copy of card with new data
function mt.new(self, data)
  data = data or {}

  local card = {}
  card.data = copyTable(data, copyTable(self.data))

  setmetatable(card, mt)

  return card
end

-- on data change
function mt:onChange(k)
  print(inspect(self), inspect(k))
end


local Card = mt.new({})

return Card
