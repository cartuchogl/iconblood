Player = class('Player')
Player:includes(EventDispatcher)

function Player:initialize(obj)
  _.extend(self,obj)
end

function Player:endTurn()
  print("endTurn "..self.alias)
  return self
end


