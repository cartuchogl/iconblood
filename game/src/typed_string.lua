TypedString = class("TypedString", ElfObject)

function TypedString:initialize(parent,name)
  super.initialize(self,SCREEN,name,{Position={0,0},Color={1,1,1,0}})
  -- self:set("Size",{200,200})
  self:addTo(parent)
  self._parent = parent
  -- labels
  self._l = {}
end

function TypedString:addLabel(label)
  local pos = #self._l+1
  self._l[pos] = ElfObject(label)
  self._l[pos]:addTo(self)
end

function TypedString:setText(indx,txt)
  self._l[indx]:set("Text",txt)
end

function TypedString:update()
  local c = 0
  _.each(self._l,function(i)
    c = c + i:get('Size').x+4
  end)
  if #self._l>0 then
    self:set("Size",{c,self._l[1]:get("Size").y+8})
  end
  c = 0
  _.each(self._l,function(i)
    i:set("Position",{c,2})
    c = c + i:get('Size').x+6
  end)
end

