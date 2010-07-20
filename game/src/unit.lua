Unit = class('Unit')
Unit:includes(EventDispatcher)

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
  self._mg = self.move
  self._squadron = squadron
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
  local tmp = string.match(self.name_unit,'%a+\.(%d+)')
  self._elf_stand = duplicate_entity(
    elf.GetEntityByName(self._faction, "Stand."..tmp),
    'Stand.'..self.id
  )
  self._elf_stand_max = duplicate_entity(
    elf.GetEntityByName(self._faction, "Move."..tmp),
    'StandMax.'..self.id
  )
  self._elf_over = duplicate_entity(
    elf.GetEntityByName(self._faction, "Over."..tmp),
    'Over.'..self.id
  )
  self._elf_enemy = duplicate_entity(
    elf.GetEntityByName(self._faction, "Enemy."..tmp),
    'Enemy.'..self.id
  )
  elf.AddEntityToScene(self._scene, self._elf_entity)
  elf.AddEntityToScene(self._scene, self._elf_stand)
  elf.AddEntityToScene(self._scene, self._elf_stand_max)
  elf.AddEntityToScene(self._scene, self._elf_over)
  elf.AddEntityToScene(self._scene, self._elf_enemy)
  self:showStand(false)
  self:showMove(false)
  self:showOver(false)
  self:showEnemy(false)
end

function Unit:setPosition(x,y)
  self._real_pos = {x=x,y=y}
  elf.SetActorPosition(self._elf_entity,x,y,0)
  elf.SetActorPosition(self._elf_stand,x,y,0.1)
  elf.SetActorPosition(self._elf_stand_max,x,y,0.11)
  elf.SetActorPosition(self._elf_over,x,y,0.12)
  elf.SetActorPosition(self._elf_enemy,x,y,0.13)
end

function Unit:setMax(x,y)
  elf.SetActorPosition(self._elf_stand_max,x,y,0.11)
end

function Unit:showStand(val)
  elf.SetEntityVisible(self._elf_stand,val)
end

function Unit:showMove(val)
  elf.SetEntityVisible(self._elf_stand_max,val)
end

function Unit:showOver(val)
  elf.SetEntityVisible(self._elf_over,val)
end

function Unit:showEnemy(val)
  elf.SetEntityVisible(self._elf_enemy,val)
end


