GuiObject = class('GuiObject')

function GuiObject:initialize(obj)
  print("initialize GuiObject")
  self._elf_obj = obj
end

function GuiObject:addTo(parent)
  if instanceOf(GuiObject,parent) then
    parent = parent._elf_obj
  end
  elf.AddGuiObject(parent,self._elf_obj)
end

function GuiObject:set(prop,...)
  local map = {}
  map[elf.SCREEN] = "Screen"
  map[elf.TEXT_FIELD] = "TextField"
  map[elf.BUTTON] = "Button"
  if #arg==1 then
    elf["Set"..map[elf.GetObjectType(self._elf_obj)]..prop](self._elf_obj,arg[1])
  elseif #arg>1 then
    elf["Set"..map[elf.GetObjectType(self._elf_obj)]..prop](self._elf_obj,arg[1],arg[2])
  end
end

function GuiObject:get(prop)
  local map = {}
  map[elf.SCREEN] = "Screen"
  map[elf.TEXT_FIELD] = "TextField"
  map[elf.BUTTON] = "Button"
  return elf["Get"..map[elf.GetObjectType(self._elf_obj)]..prop](self._elf_obj)
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



