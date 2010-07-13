Game = class('Game')
Game:includes(EventDispatcher)

function Game:initialize(ibg)
  print("initialize Game")
  if ibg then _.extend(self,ibg) end
  _.each(_.keys(self),function(i) print(i,self[i]) end)
  if self.squadrons then
    local tmp = self.squadrons
    self.squadrons = _.map(tmp,function(i) return Squadron(i) end)
  end
  self._gaming = false
end

function Game:loadEnvironment()
  print("Game:loadEnvirontment")
  return self
end

function Game:loadUnits()
  print("Game:loadUnits")
  return self
end

function Game:players()
  return _.map(self.squadrons,function(i) return i.player end)
end

function Game:start()
  self._gaming = true
end

function Game:stop()
  self._gaming = false
end

function Game:running()
  return self._gaming
end

