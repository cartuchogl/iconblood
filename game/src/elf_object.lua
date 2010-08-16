ElfObject = class('ElfObject')
ElfObject:includes(EventDispatcher)
-- mapping the world!
ElfObject.__m = {}
ElfObject.__m[elf.SCREEN] = {n="Screen",t={'GuiObject'},f={}}
ElfObject.__m[elf.PICTURE] = {n="Picture",t={'GuiObject'},f={}}
ElfObject.__m[elf.TEXT_FIELD] = {n="TextField",t={'GuiObject'},f={}}
ElfObject.__m[elf.TEXT_LIST] = {n="TextList",t={'GuiObject'},f={}}
ElfObject.__m[elf.BUTTON] = {n="Button",t={'GuiObject'},f={}}
ElfObject.__m[elf.LABEL] = {n="Label",t={'GuiObject'},f={}}
ElfObject.__m[elf.ENTITY] = {n="Entity",t={'Actor'},f={}}
ElfObject.__m["Object"] = {n="Object",t={},f={}}
ElfObject.__m["GuiObject"] = {n="GuiObject",t={},f={}}
ElfObject.__m["Actor"] = {n="Actor",t={},f={}}

ElfObject.__esp = {
  {
    properties={'x','y','z'},
    func=function(self,t,prop,val)
      if t=='Get' then
        return self:get('Position')[prop]
      else
        local get = self:get('Position')
        get[prop] = val
        local a = {}
        if get.x then a[#a+1] =  get.x end
        if get.y then a[#a+1] =  get.y end
        if get.z then a[#a+1] =  get.z end
        self:set('Position',unpack(a))
      end
    end
  },
  {
    properties={'rotx','roty','rotz'},
    func=function(self,t,prop,val)
      if t=='Get' then
        return self:get('Rotation')[string.gsub(prop,'rot','')]
      else
        local get = self:get('Rotation')
        get[string.gsub(prop,'rot','')] = val
        local a = {}
        if get.x then a[#a+1] =  get.x end
        if get.y then a[#a+1] =  get.y end
        if get.z then a[#a+1] =  get.z end
        self:set('Rotation',unpack(a))
      end
    end
  },
  {
    properties={'parent'},
    func=function(self,t,prop,val)
      if t=='Get' then
        return nil -- TODO: return parent
      else
        self:addTo(val)
      end
    end
  }
}

for k,v in pairs(ElfObject.__m) do
  ElfObject.__m[k].r = "^[S|G]et"..v.n
  table.insert(ElfObject.__m[k].t,'Object')
end
for k,v in pairs(elf) do
  if type(v)=='function' then
    for k2,v2 in pairs(ElfObject.__m) do
      if string.find(k,v2.r) then
        table.insert(ElfObject.__m[k2].f,k)
      end
    end
  end
end

function ElfObject:initialize(obj,...)
  if #arg == 0 then
    self._elf_obj = obj
  else
    self._elf_obj = elf["Create"..ElfObject.__m[obj].n](arg[1])
    if #arg==2 then
      self:sets(arg[2])
    end
  end
end

function ElfObject:method(t,prop)
  local tp = ElfObject.__m[elf.GetObjectType(self._elf_obj)]
  local m = _.detect(tp.f,function(i) return string.find(i,t..tp.n..prop..'$') end)
  if m then
    return m
  else
    _.detect(tp.t,function(i)
      local kk = _.detect(ElfObject.__m[i].f,function(j)
        return string.find(j,t..ElfObject.__m[i].n..prop..'$')
      end)
      if kk then
        m = kk
      end
      return kk
    end)
    return m
  end
end

function ElfObject:set(prop,...)
  local ret
  local esp = _.detect(ElfObject.__esp,function(i) return _.include(i.properties,prop) end)
  if esp then
    esp.func(self,'Set',prop,...)
  else
    local func = self:method('Set',prop)
    if func then
      if type(...)=='table' then
        elf[func](self._elf_obj,unpack(...))
      else
        elf[func](self._elf_obj,...)
      end
      self:fireEvent('update:attributte',{obj=self,attr=prop})
    end
  end
end

function ElfObject:sets(vars)
  for k,v in pairs(vars) do
    if type(v)=='table' then
      self:set(k,unpack(v))
    else
      self:set(k,v)
    end
  end
end

function ElfObject:get(prop,...)
  local esp = _.detect(ElfObject.__esp,function(i) return _.include(i.properties,prop) end)
  if esp then
    return esp.func(self,'Get',prop)
  end
  local func = self:method('Get',prop)
  if func then
    if ... and type(...)=='table' then
      return elf[func](self._elf_obj,unpack(...))
    else
      return elf[func](self._elf_obj,...)
    end
  end
end

function ElfObject:addTo(parent)
  if parent and parent._elf_obj then
    parent = parent._elf_obj
  end
  if _.include(ElfObject.__m[elf.GetObjectType(self._elf_obj)].t,'GuiObject') then
    elf.AddGuiObject(parent,self._elf_obj)
  elseif ElfObject.__m[elf.GetObjectType(self._elf_obj)].n=='Entity' then
    elf.AddEntityToScene(parent,self._elf_obj)
  else
    print('Unknow add',ElfObject.__m[elf.GetObjectType(self._elf_obj)].n)
  end
  self._parent = parent
end


