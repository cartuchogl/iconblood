GuiObject = class('GuiObject')

function GuiObject:initialize(obj)
  print("initialize GuiObject")
  self._elf_obj = obj
  self.__m = {}
  self.__m[elf.SCREEN] = "Screen"
  self.__m[elf.TEXT_FIELD] = "TextField"
  self.__m[elf.BUTTON] = "Button"
  self.__m[elf.LABEL] = "Label"
  self.__p = {'Name','Position','Size','Color','Visible','Script','Event'}
end

function GuiObject:addTo(parent)
  if instanceOf(GuiObject,parent) then
    parent = parent._elf_obj
  end
  elf.AddGuiObject(parent,self._elf_obj)
end

function GuiObject:set(prop,...)
  local func = ''
  if _.include(self.__p,prop) then
    func = "SetGuiObject"..prop
  else
    func = "Set"..self.__m[elf.GetObjectType(self._elf_obj)]..prop
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
  if _.include(self.__p,prop) then
    func = "GetGuiObject"..prop
  else
    func = "Get"..self.__m[elf.GetObjectType(self._elf_obj)]..prop
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

function GuiObject:set_position(x,y)
  elf.SetGuiObjectPosition( self._elf_obj, x, y )
end

function GuiObject:set_color(r,g,b,a)
  elf.SetGuiObjectColor( self._elf_obj, r, g, b, a )
end

function GuiObject:set_visible(visible)
  elf.SetGuiObjectVisible( self._elf_obj, visible )
end

function GuiObject:set_script(script)
  elf.SetGuiObjectScript(self._elf_obj, script)
end



