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
    i._mg = i.move
    i.action = nil
    if i:isAlive() then
      SetEntityArmatureFrame(i._elf_obj,1)
    end
  end)
end

