Player = class('Player')
Player:includes(EventDispatcher)

function Player:initialize(obj)
  print("initialize Player")
  _.extend(self,obj)
end

function Player:endTurn()
  print("endTurn "..self.alias)
  return self
end


