Unit = class('Unit')
Unit:includes(EventDispatcher)

function Unit:initialize(obj)
  print("initialize Unit")
  _.extend(self,obj)
  _.each(_.keys(self),function(i) print(i,self[i]) end)
  if self.options then
    local tmp = self.options
    self.options = _.map(tmp,function(i) return Option(i) end)
  end
  self:addEvent('select:unit',function(args)
    print("select:"..self.name)
    self:showStand(true)
  end)
  self:addEvent('deselect:unit',function(args)
    print("deselect:"..self.name)
    self:showStand(false)
  end)
end

function Unit:loadElfObjects(scene)
  self._scene = scene
  self._elf_entity = duplicate_entity(
    elf.GetEntityByName(self._faction, self.name_unit),
    "Unit."..self.id
  )
  local tmp = ""
  tmp = string.match(self.name_unit,'%a+\.(%d+)')
  print("Stand."..tmp)
  self._elf_stand = duplicate_entity(
    elf.GetEntityByName(self._faction, "Stand."..tmp),
    'Stand.'..self.id
  )
  elf.AddEntityToScene(self._scene, self._elf_entity)
  elf.AddEntityToScene(self._scene, self._elf_stand)
  self:showStand(false)
end

function Unit:setPosition(x,y)
  elf.SetActorPosition(self._elf_entity,x,y,0)
  elf.SetActorPosition(self._elf_stand,x,y,0.1)
end

function Unit:showStand(val)
  elf.SetEntityVisible(self._elf_stand,val)
end

