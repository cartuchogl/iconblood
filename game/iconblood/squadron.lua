Squadron = class('Squadron')
Squadron:includes(EventDispatcher)

function Squadron:initialize(obj)
  _.extend(self,obj)
  if self.units then
    local tmp = self.units
    self.units = _.map(tmp,function(i) return Unit(i,self) end)
  end
  if self.player then
    local tmp = self.player
    self.player = Player(self,tmp)
  end
end

function Squadron:nextUnit(unit)
  local found
  if not unit then
    found = 0
  else
    for i=1,#self.units do
      if self.units[i]==unit then
        found = i
        break
      end
    end
  end
  if found then
    found = found +1
    if found>#self.units then
      found = 1
    end
    while not self.units[found]:isAlive() do
      found = found +1
      if found>#self.units then
        found = 1
      end
    end
    return self.units[found]
  else
    return nil
  end
end

function Squadron:reset()
  _.each(self.units,function(i)
    if i:isAlive() then
      i:reset()
    else
      i._mg = 0
      i.action = "dead"
    end
  end)
end

