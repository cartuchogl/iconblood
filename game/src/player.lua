Player = class('Player')
Player:includes(EventDispatcher)

function Player:initialize(squadron,obj)
  _.extend(self,obj)
  self.squadron = squadron
end

function Player:endTurn()
  print("endTurn "..self.alias)
  return self
end


