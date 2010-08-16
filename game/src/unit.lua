Unit = class('Unit',ElfObject)

function Unit:initialize(obj,squadron)
  _.extend(self,obj)
  if self.options then
    local tmp = self.options
    self.options = _.map(tmp,function(i) return Option(i) end)
  end
  self:addEvent('select:unit',function(args)
    print("select:"..self.name)
    self:setStand('select')
  end)
  self:addEvent('deselect:unit',function(args)
    print("deselect:"..self.name)
    self:setStand('normal')
  end)
  self:addEvent('enter',function(args)
    print("enter:"..self.name)
    self:setStand('over')
  end)
  self:addEvent('leave',function(args)
    print("leave:"..self.name)
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
end

function Unit:canBe(x,y)
  local model = elf.GetEntityModel(self._elf_stand._elf_obj)
  local min = elf.GetModelBoundingBoxMin(model)
  local max = elf.GetModelBoundingBoxMax(model)
  local s = self._elf_stand:get('Scale')
  local funcall = function(v,s,x,y)
    ini = {x=v.x*s.x+self:get('x'),y=v.y*s.y+self:get('y'),z=v.z*s.z}
    fin = {x=v.x*s.x+x,y=v.y*s.y+y,z=v.z*s.z}
    local cols = elf.GetSceneRayCastResults(self._scene,
      ini.x, ini.y, ini.z,
      fin.x, fin.y, fin.z
    )
    local ret = array_from_list(cols)
    local tmp = _.reject(ret,function(i) 
      local aa = elf.GetActorName(elf.GetCollisionActor(i))
      return aa=="Unit."..self.id or aa=="StandMax."..self.id
    end)
    return #tmp>0
  end
  
  min.z = 0.2
  max.z = 0.2
  if funcall(min,s,x,y) then return false end
  if funcall(max,s,x,y) then return false end
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
  ElfObject(self._elf_entity):sets({
    Scale={0.025,0.025,0.0258},
    Rotation={90,0,0},
    Position={0,0,1}
  })
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


