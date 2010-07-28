CurrentPanel = class('CurrentPanel', GuiObject)

function CurrentPanel:initialize(parent,bg,font,unit)
  local y = elf.GetWindowHeight()-elf.GetTextureHeight(bg)
  super.initialize(self,elf.SCREEN,'current_panel',{Position={0,y},Texture=bg})
  self:addTo(parent)
  self._unit = unit
  
  self.lab_level = GuiObject(elf.LABEL,"lab_level",{Font = font,Text = 'level'})
  self.lab_name = GuiObject(elf.LABEL,"lab_name",{Font = font,Text = 'name',Color={0.22,1,0.53,1}})
  self.lab_cost = GuiObject(elf.LABEL,"lab_cost",{Font = font,Text = 'cost'})
  self.lab_move = GuiObject(elf.LABEL,"lab_move",{Font = font,Text = 'move'})
  self.lab_force = GuiObject(elf.LABEL,"lab_force",{Font = font,Text = 'force'})
  self.lab_skill = GuiObject(elf.LABEL,"lab_skill",{Font = font,Text = 'skill'})
  self.lab_resistance = GuiObject(elf.LABEL,"lab_resistance",{Font = font,Text = 'resistance'})
  self._picture = GuiObject(elf.PICTURE,'large_pic',{Position={10,6}})
  self._picture:addTo(self)
  
  self._null_tex = elf.CreateTextureFromImage(elf.CreateEmptyImage(128,128,8))

  local tmp_y = 0
  _.each({
    self.lab_name,self.lab_level,self.lab_move,
    self.lab_force,self.lab_skill,self.lab_resistance,self.lab_cost
  },function(i)
    i:sets({Position={12,150+tmp_y*14}})
    i:addTo(self)
    tmp_y = tmp_y + 1
  end)
end

function CurrentPanel:update()
  local unit = {name='nobody',exp='0',level='0',cost='0',move='0',force='0',skill='0',resistance='0',_mg='0'}
  if self._unit then
    unit = self._unit
    self._picture:set('Texture',self._unit._large_image)
  else
    self._picture:set('Texture',self._null_tex)
  end
  self.lab_level:set('Text','LEVEL '..unit.level.."/"..unit.exp..'PX')
  self.lab_name:set('Text',string.upper(unit.name))
  self.lab_cost:set('Text','$'..unit.cost)
  self.lab_move:set('Text','M '..unit._mg..'/'..unit.move)
  self.lab_force:set('Text','F'..unit.force)
  self.lab_skill:set('Text','S'..unit.skill)
  self.lab_resistance:set('Text','R'..unit.resistance)
end
