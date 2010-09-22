Unit = class('Unit',ElfObject)

function Unit:initialize(obj,squadron)
  _.extend(self,obj)
  if self.options then
    local tmp = self.options
    self.options = _.map(tmp,function(i) return Option(i) end)
  end
  if self.primary then self.primary = Weapon(self.primary,self) end
  if self.secondary then self.secondary = Weapon(self.secondary,self) end
  self.current_weapon = self.primary
  self:addEvent('select:unit',function(args)
    self:setStand('select')
  end)
  self:addEvent('deselect:unit',function(args)
    self:setStand('normal')
  end)
  self:addEvent('enter',function(args)
    self:setStand('over')
  end)
  self:addEvent('leave',function(args)
    if game:currentPlayer():hasUnit(self) then
      if game._current_unit==self then
        self:setStand('select')
      else
        self:setStand('normal')
      end
    else
      self:setStand('enemy')
    end
  end)
  self:addEvent('update:attributte',_.curry(self.updatedPosition,self))
  self._mg = self.move
  self._squadron = squadron
  self.action = nil
end

function Unit:visibilityPoints()
  -- FIXME: better points
  local model = elf.GetEntityModel(self._elf_stand._elf_obj)
  local min = elf.GetModelBoundingBoxMin(model)
  local max = elf.GetModelBoundingBoxMax(model)
  local s = self._elf_stand:get('Scale')
  local height = self:modelHeight()
  -- harcoding the life ;)
  return {
    {x=min.x*s.x,y=min.y*s.y,z=0.2}, {x=max.x*s.x,y=max.y*s.y,z=0.2},
    {x=-1*min.x*s.x,y=min.y*s.y,z=0.2}, {x=-1*max.x*s.x,y=max.y*s.y,z=0.2},
    {x=min.x*s.x,y=min.y*s.y,z=height}, {x=max.x*s.x,y=max.y*s.y,z=height},
    {x=-1*min.x*s.x,y=min.y*s.y,z=height}, {x=-1*max.x*s.x,y=max.y*s.y,z=height},
    {x=(min.x+max.x)/2*s.x,y=(min.y+max.x)/2*s.y,z=height},
    {x=(min.x+max.x)/2*s.x,y=(min.y+max.x)/2*s.y,z=height/2},
    {x=(min.x+max.x)/2*s.x,y=(min.y+max.x)/2*s.y,z=0.2},
  }
end

function Unit:modelHeight()
  local model = elf.GetEntityModel(self._elf_obj)
  local min = elf.GetModelBoundingBoxMin(model)
  local max = elf.GetModelBoundingBoxMax(model)
  local s = self:get('Scale')
  return math.max(min.z*s.z+self:get('z'),max.z*s.z+self:get('z'))
end

function Unit:seePoint()
  -- FIXME: center?
  local model = elf.GetEntityModel(self._elf_stand._elf_obj)
  local min = elf.GetModelBoundingBoxMin(model)
  local max = elf.GetModelBoundingBoxMax(model)
  local s = self._elf_stand:get('Scale')
  local height = self:modelHeight()
  return {x=(min.x+max.x)/2*s.x,y=(min.y+max.x)/2*s.y,z=height}
end

function Unit:rayWithoutMe(ini,fin)
  local cols = elf.GetSceneRayCastResults(self._scene,
    ini.x, ini.y, ini.z,
    fin.x, fin.y, fin.z
  )
  local ret = array_from_list(cols)
  local tmp = _.reject(ret,function(i) 
    local aa = elf.GetActorName(elf.GetCollisionActor(i))
    aa=aa=="Unit."..self.id or aa=="StandMax."..self.id
    return aa
  end)
  return tmp
end

function Unit:canBe(x,y)
  local points = self:visibilityPoints()
  local funcall = function(v,x,y)
    local ini = {x=v.x+self:get('x'),y=v.y+self:get('y'),z=v.z}
    local fin = {x=v.x+x,y=v.y+y,z=v.z}
    local tmp = self:rayWithoutMe(ini,fin)
    return #tmp>0
  end
  
  for i=1,#points do
    if funcall(points[i],x,y) then return false end
  end
  return true
end

function Unit:seeTo(x,y)
  local center = self:get('Position')
  local c = x-center.x
  local a = y-center.y
  if a~=0 and c~=0 then
    local bpow = a*a+c*c
    local b = math.sqrt(bpow)
    local alpha = math.deg(math.asin(((bpow+c*c)-a*a)/(2*b*c)))
    if a>0 then alpha = 180-alpha end
    self:set('rotz',alpha)
  end
end

function Unit:loadElfObjects(pak,scene)
  self._unit_pak = pak
  self._scene = scene
  self._elf_entity = duplicate_entity(
    elf.GetEntityByName(self._unit_pak, 'unit'),
    "Unit."..self.id
  )
  -- FIXME: temporal hack for model
  -- ElfObject(self._elf_entity):sets({
  --   Scale={0.025,0.025,0.0258},
  --   Rotation={90,0,0},
  --   Position={0,0,1}
  -- })
  self._elf_obj = self._elf_entity
  self._elf_stand = ElfObject(duplicate_entity(
    elf.GetEntityByName(self._unit_pak, "stand"),
    'Stand.'..self.id
  ))
  self._elf_stand:set('Material',0,
    duplicate_material(self._elf_stand:get('Material',0),'Stand.'..self.id..'.Material')
  )
  self._elf_stand_max = ElfObject(duplicate_entity(
    elf.GetEntityByName(self._unit_pak, "stand"),
    'StandMax.'..self.id
  ))
  local path1 = 'factions/'..self.faction_name..'/'..self.name_unit..'.png'
  local path2 = 'factions/'..self.faction_name..'/'..self.name_unit..'.big.png'
  self._mini_image = loader:get('img',path1).target
  self._large_image = loader:get('img',path2).target
  self:addTo(self._scene)
  self._elf_stand:addTo(self._scene)
  self._elf_stand_max:addTo(self._scene)
  
  self:setStand('normal')
end

function Unit:setStand(typ)
  local ary = {1,1,1,1}
  if typ=='normal' then
    ary = {0,1,0,0.9}
    self._elf_stand_max:set('Visible',false)
  elseif typ=='move' then
    ary = {0,0,1,0.9}
    self._elf_stand_max:set('Visible',false)
  elseif typ=='over' then
    ary = {0,0.75,0.75,0.9}
    self._elf_stand_max:set('Visible',false)
  elseif typ=='enemy' then
    ary = {1,0,0,0.9}
    self._elf_stand_max:set('Visible',false)
  elseif typ=='select' then
    ary = {0.75,0.75,0,0.9}
    self._elf_stand_max:set('Visible',true)
  end
  elf.SetMaterialDiffuseColor(elf.GetEntityMaterial(self._elf_stand._elf_obj,0), unpack(ary)) 
end

function Unit:updatedPosition()
  local v = self:get('Position')
  self._elf_stand:set('Position',v.x,v.y,0.02)
  self:setMax(v.x,v.y)
end

function Unit:setMax(x,y)
  self._elf_stand_max:set('Position',x,y,0.01)
end


