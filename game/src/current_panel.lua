CurrentPanel = class('CurrentPanel', ElfObject)

function CurrentPanel:initialize(parent,bg,font,unit)
  local y = elf.GetWindowHeight()-elf.GetTextureHeight(bg)
  super.initialize(self,elf.SCREEN,'current_panel',{Position={0,y},Texture=bg})
  self:addTo(parent)
  self._unit = unit
  
  self.lab_level = ElfObject(elf.LABEL,"lab_level",{Font = font,Text = 'level'})
  self.lab_name = ElfObject(elf.LABEL,"lab_name",{Font = font,Text = 'name',Color={0.22,1,0.53,1}})
  self.lab_cost = ElfObject(elf.LABEL,"lab_cost",{Font = font,Text = 'cost'})
  self.lab_move = ElfObject(elf.LABEL,"lab_move",{Font = font,Text = 'move'})
  self.lab_attr = ElfObject(elf.LABEL,"lab_attr",{Font = font,Text = 'attr'})
  self._picture = ElfObject(elf.PICTURE,'large_pic',{Position={10,6}})
  self._picture:addTo(self)
  
  self._null_tex = elf.CreateTextureFromImage(elf.CreateEmptyImage(128,128,8))

  local tmp_y = 0
  _.each({
    self.lab_name,self.lab_level,self.lab_cost,
    self.lab_attr,
    self.lab_move
  },function(i)
    i:sets({Position={161,6+tmp_y*18}})
    i:addTo(self)
    tmp_y = tmp_y + 1
  end)
end

function CurrentPanel:update()
  local unit = {name='nobody',exp='0',level='0',cost='0',move='0',force='0',skill='0',resistance='0',_mg='0',agility='0',intelligence='0'}
  if self._unit then
    unit = self._unit
    self._picture:set('Texture',self._unit._large_image)
  else
    self._picture:set('Texture',self._null_tex)
  end
  self.lab_level:set('Text','LEVEL '..unit.level.." ("..unit.exp..'px)')
  self.lab_name:set('Text',string.upper(unit.name))
  self.lab_cost:set('Text','$'..unit.cost)
  self.lab_move:set('Text','Move: '..unit._mg..'/'..unit.move)
  self.lab_attr:set('Text','F'..unit.force..' A'..unit.agility..' R'..unit.resistance..' S'..unit.skill..' I'..unit.intelligence)
end
