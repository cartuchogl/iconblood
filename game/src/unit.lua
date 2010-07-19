Unit = class('Unit')
Unit:includes(EventDispatcher)

function Unit:initialize(obj)
  _.extend(self,obj)
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

function Unit:canBe(x,y)
  local model = elf.GetEntityModel(self._elf_entity)
  local min = elf.GetModelBoundingBoxMin(model)
  local max = elf.GetModelBoundingBoxMax(model)
  local min2 = elf.GetModelBoundingBoxMin(model)
  local max2 = elf.GetModelBoundingBoxMax(model)
  local s = elf.GetEntityScale(self._elf_entity)
  min.x = min.x*s.x+self._real_pos.x
  min.y = min.y*s.y+self._real_pos.y
  min.z = 0.1
  max.x = max.x*s.x+self._real_pos.x
  max.y = max.y*s.y+self._real_pos.y
  max.z = max.z*s.z
  
  min2.x = min2.x*s.x+x
  min2.y = min2.y*s.y+y
  min2.z = 0.1
  max2.x = max2.x*s.x+x
  max2.y = max2.y*s.y+y
  max2.z = max2.z*s.z

  -- debug:trackPoint(min,'Cube')
  -- debug:trackPoint(min2,'Cube')
  -- debug:trackPoint(max,'Cube.002')
  -- debug:trackPoint(max2,'Cube.001')
  -- print(min.x,min.y,min.z,'x',max.x,max.y,max.z)
  -- print(min2.x,min2.y,min2.z,'x',max2.x,max2.y,max2.z)

  local cols = elf.GetSceneRayCastResults(self._scene, 
    min.x, min.y, min.z,
    min2.x,   min2.y,   min2.z
  )
  if elf.IsObject(cols) and elf.GetListLength(cols) > 0 then
    return false
  end
  
  cols = elf.GetSceneRayCastResults(self._scene, 
    max.x, max.y, max.z,
    max2.x,   max2.y,   max2.z
  )
  if elf.IsObject(cols) and elf.GetListLength(cols) > 0 then
    return false
  end
  
  return true
end

function Unit:loadElfObjects(scene)
  self._scene = scene
  self._elf_entity = duplicate_entity(
    elf.GetEntityByName(self._faction, self.name_unit),
    "Unit."..self.id
  )
  local tmp = string.match(self.name_unit,'%a+\.(%d+)')
  self._elf_stand = duplicate_entity(
    elf.GetEntityByName(self._faction, "Stand."..tmp),
    'Stand.'..self.id
  )
  elf.AddEntityToScene(self._scene, self._elf_entity)
  elf.AddEntityToScene(self._scene, self._elf_stand)
  self:showStand(false)
end

function Unit:setPosition(x,y)
  self._real_pos = {x=x,y=y}
  elf.SetActorPosition(self._elf_entity,x,y,0)
  elf.SetActorPosition(self._elf_stand,x,y,0.1)
end

function Unit:showStand(val)
  elf.SetEntityVisible(self._elf_stand,val)
end

