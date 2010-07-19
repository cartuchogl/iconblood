GuiObject = class('GuiObject')
-- mapping the world!
GuiObject.__m = {}
GuiObject.__m[elf.SCREEN] = {"Screen",{'Texture'}}
GuiObject.__m[elf.TEXT_FIELD] = {"TextField",{'Texture','Font','TextColor','Offset','CursorPosition','Text'}}
GuiObject.__m[elf.BUTTON] = {"Button",{'OffTexture','OverTexture','OnTexture'}}
GuiObject.__m[elf.LABEL] = {"Label",{'Font','Text'}}
GuiObject.__p = {'Name','Position','Size','Color','Visible','Script','Event'}

function GuiObject:initialize(obj,...)
  if #arg == 0 then
    self._elf_obj = obj
  else
    self._elf_obj = elf["Create"..GuiObject.__m[obj][1]](arg[1])
    if #arg==2 then
      self:sets(arg[2])
    end
  end
end

function GuiObject:addTo(parent)
  if instanceOf(GuiObject,parent) then
    parent = parent._elf_obj
  end
  elf.AddGuiObject(parent,self._elf_obj)
end

function GuiObject:set(prop,...)
  local func = ''
  if _.include(GuiObject.__p,prop) then
    func = "SetGuiObject"..prop
  else
    func = "Set"..GuiObject.__m[elf.GetObjectType(self._elf_obj)][1]..prop
  end
  if #arg==1 then
    elf[func](self._elf_obj,arg[1])
  elseif #arg==2 then
    elf[func](self._elf_obj,arg[1],arg[2])
  elseif #arg==3 then
    elf[func](self._elf_obj,arg[1],arg[2],arg[3])
  elseif #arg==4 then
    elf[func](self._elf_obj,arg[1],arg[2],arg[3],arg[4])
  end
end

function GuiObject:sets(vars)
  for k,v in pairs(vars) do
    if #v==1 then
      self:set(k,v[1])
    elseif #v==2 then
      self:set(k,v[1],v[2])
    elseif #v==3 then
      self:set(k,v[1],v[2],v[3])
    elseif #v==4 then
      self:set(k,v[1],v[2],v[3],v[4])
    end
  end
end

function GuiObject:get(prop)
  local func = ''
  if _.include(GuiObject.__p,prop) then
    func = "GetGuiObject"..prop
  else
    func = "Get"..GuiObject.__m[elf.GetObjectType(self._elf_obj)][1]..prop
  end
  return elf[func](self._elf_obj)
end

function GuiObject:name()
  return elf.GetGuiObjectName( self._elf_obj )
end

function GuiObject:position()
  return elf.GetGuiObjectPosition( self._elf_obj )
end

function GuiObject:size()
  return elf.GetGuiObjectSize( self._elf_obj )
end

function GuiObject:color()
  return elf.GetGuiObjectColor( self._elf_obj )
end

function GuiObject:visible()
  return elf.GetGuiObjectVisible( self._elf_obj )
end

function GuiObject:script()
  return elf.GetGuiObjectScript( self._elf_obj )
end

function GuiObject:event()
  return elf.GetGuiObjectEvent( self._elf_obj )
end

