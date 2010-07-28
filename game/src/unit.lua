Unit = class('Unit',ElfObject)

function Unit:initialize(obj,squadron)
  _.extend(self,obj)
  if self.options then
    local tmp = self.options
    self.options = _.map(tmp,function(i) return Option(i) end)
  end
  self:addEvent('select:unit',function(args)
    print("select:"..self.name)
    self:showStand(true)
    self:showMove(true)
  end)
  self:addEvent('deselect:unit',function(args)
    print("deselect:"..self.name)
    self:showStand(false)
    self:showMove(false)
  end)
  self:addEvent('enter',function(args)
    print("enter:"..self.name)
    if game:currentPlayer():hasUnit(self) then
      self:showOver(true)
    else
     self:showEnemy(true)
    end 
    
  end)
  self:addEvent('leave',function(args)
    print("leave:"..self.name)
    self:showOver(false)
    self:showEnemy(false)
  end)
  self:addEvent('update:attributte',_.curry(self.updatedPosition,self))
  self._mg = self.move
  self._squadron = squadron
end

function Unit:canBe(x,y)
  local model = elf.GetEntityModel(self._elf_entity)
  local min = elf.GetModelBoundingBoxMin(model)
  local max = elf.GetModelBoundingBoxMax(model)
  local min2 = elf.GetModelBoundingBoxMin(model)
  local max2 = elf.GetModelBoundingBoxMax(model)
  local s = self:get('Scale')
  min.x = min.x*s.x+self:get('x')
  min.y = min.y*s.y+self:get('y')
  min.z = 0.1
  max.x = max.x*s.x+self:get('x')
  max.y = max.y*s.y+self:get('y')
  max.z = max.z*s.z
  
  min2.x = min2.x*s.x+x
  min2.y = min2.y*s.y+y
  min2.z = 0.1
  max2.x = max2.x*s.x+x
  max2.y = max2.y*s.y+y
  max2.z = max2.z*s.z

  local cols = elf.GetSceneRayCastResults(self._scene, 
    min.x, min.y, min.z,
    min2.x,   min2.y,   min2.z
  )
  if elf.IsObject(cols) and elf.GetListLength(cols) > 0 then
    ret = {}
    for i = 0,elf.GetListLength(cols)-1,1 do
      ret[i+1] = elf.GetItemFromList(cols,i)
    end
    local tmp = _.reject(ret,function(i) 
      local aa = elf.GetActorName(elf.GetCollisionActor(i))
      return aa=="Unit."..self.id or aa=="StandMax."..self.id
    end)
    if #tmp>0 then
      return false
    end
  end
  
  cols = elf.GetSceneRayCastResults(self._scene, 
    max.x, max.y, max.z,
    max2.x,   max2.y,   max2.z
  )
  if elf.IsObject(cols) and elf.GetListLength(cols) > 0 then
    ret = {}
    for i = 0,elf.GetListLength(cols)-1,1 do
      ret[i+1] = elf.GetItemFromList(cols,i)
    end
    local tmp = _.reject(ret,function(i) 
      local aa = elf.GetActorName(elf.GetCollisionActor(i))
      return aa=="Unit."..self.id or aa=="StandMax."..self.id
    end)
    if #tmp>0 then
      return false
    end
  end
  return true
end

function Unit:loadElfObjects(scene)
  self._scene = scene
  self._elf_entity = duplicate_entity(
    elf.GetEntityByName(self._faction, self.name_unit),
    "Unit."..self.id
  )
  self._elf_obj = self._elf_entity
  local tmp = string.match(self.name_unit,'%a+\.(%d+)')
  self._elf_stand = ElfObject(duplicate_entity(
    elf.GetEntityByName(self._faction, "Stand."..tmp),
    'Stand.'..self.id
  ))
  self._elf_stand_max = ElfObject(duplicate_entity(
    elf.GetEntityByName(self._faction, "Move."..tmp),
    'StandMax.'..self.id
  ))
  self._elf_over = ElfObject(duplicate_entity(
    elf.GetEntityByName(self._faction, "Over."..tmp),
    'Over.'..self.id
  ))
  self._elf_enemy = ElfObject(duplicate_entity(
    elf.GetEntityByName(self._faction, "Enemy."..tmp),
    'Enemy.'..self.id
  ))
  local path = findPath("../factions/","0*"..self.faction_id.."_*.*").."/unit."..tmp..'.png'
  local path2 = findPath("../factions/","0*"..self.faction_id.."_*.*").."/unit."..tmp..'.big.png'
  print(path,path2)
  self._mini_image = elf.CreateTextureFromFile(path)
  self._large_image = elf.CreateTextureFromFile(path2)
  self:addTo(self._scene)
  self._elf_stand:addTo(self._scene)
  self._elf_stand_max:addTo(self._scene)
  self._elf_over:addTo(self._scene)
  self._elf_enemy:addTo(self._scene)
  
  self:showStand(false)
  self:showMove(false)
  self:showOver(false)
  self:showEnemy(false)
end

function Unit:updatedPosition()
  local v = self:get('Position')
  self._elf_stand:set('Position',v.x,v.y,0.1)
  self._elf_stand_max:set('Position',v.x,v.y,0.11)
  self._elf_over:set('Position',v.x,v.y,0.12)
  self._elf_enemy:set('Position',v.x,v.y,0.13)
end

-- function Unit:setPosition(x,y)
--   self.:get('x') = {x=x,y=y}
--   self:updatePosition()
-- end

function Unit:setMax(x,y)
  self._elf_stand_max:set('Position',x,y,0.11)
end

function Unit:showStand(val)
  self._elf_stand:set('Visible',val)
end

function Unit:showMove(val)
  self._elf_stand_max:set('Visible',val)
end

function Unit:showOver(val)
  self._elf_over:set('Visible',val)
end

function Unit:showEnemy(val)
  self._elf_enemy:set('Visible',val)
end


