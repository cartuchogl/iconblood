Turn = class('Turn')
Turn:includes(EventDispatcher)

function Turn:initialize(obj)
  print("initialize Turn")
  -- _.extend(self,obj)
end

function Turn:endTurn()
  return self
end


