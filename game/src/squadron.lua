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

function Squadron:reset()
  _.each(self.units,function(i)
    if i:isAlive() then
      i._mg = i.move
      i.action = nil
      SetEntityArmatureFrame(i._elf_obj,1)
    else
      i._mg = 0
      i.action = "dead"
    end
  end)
end

