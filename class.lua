local Class = {}


function Class:new(t)
  t = t or {}
  setmetatable(t, self)
  self.__index = self
  t:init()
  return t
end


function Class:init()
  print('Class:init')
end


return Class
