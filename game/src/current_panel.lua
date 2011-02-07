CurrentPanel = class('CurrentPanel', ElfObject)

function CurrentPanel:initialize(parent,bg,font,unit)
  local y = GetWindowHeight()-GetTextureHeight(bg)
  super.initialize(self,SCREEN,'current_panel',{Position={0,y},Texture=bg})
  self:addTo(parent)
  self._unit = unit
  
  self.lab_level = ElfObject(LABEL,"lab_level",{Font = font,Text = 'level'})
  self.lab_name = ElfObject(LABEL,"lab_name",{Font = font,Text = 'name',Color={0.22,1,0.53,1}})
  self.lab_cost = ElfObject(LABEL,"lab_cost",{Font = font,Text = 'cost'})
  self.lab_move = ElfObject(LABEL,"lab_move",{Font = font,Text = 'move'})
  self.lab_attr = ElfObject(LABEL,"lab_attr",{Font = font,Text = 'attr'})
  self._picture = ElfObject(PICTURE,'large_pic',{Position={5,44}})
  self._picture:addTo(self)
  self._picture_action = ElfObject(PICTURE,'current_action_pic',{
    Position={118,7},Texture=game._loader:get('img','action.png').target
  })
  self._picture_action:addTo(self)
    
  self._button_chars = ElfObject(BUTTON,"btn_chars",{
    OffTexture = game._loader:get('img','chars.png').target,
    OverTexture = game._loader:get('img','chars_over.png').target,
    OnTexture = game._loader:get('img','chars_on.png').target,
    Position = {160,100}
  })
  self._button_chars:addTo(self)
  
  self._button_habs = ElfObject(BUTTON,"btn_habs",{
    OffTexture = game._loader:get('img','habs.png').target,
    OverTexture = game._loader:get('img','habs_over.png').target,
    OnTexture = game._loader:get('img','habs_on.png').target,
    Position = {160+46,100}
  })
  self._button_habs:addTo(self)
  
  self._button_inv = ElfObject(BUTTON,"btn_inv",{
    OffTexture = game._loader:get('img','inv.png').target,
    OverTexture = game._loader:get('img','inv_over.png').target,
    OnTexture = game._loader:get('img','inv_on.png').target,
    Position = {160+46*2,100}
  })
  self._button_inv:addTo(self)
  
  self.primary_panel = WeaponPanel(self,game._loader:get('img','weapon_bg.png').target,font,
  game._loader:get('img','reload.png').target,
  game._loader:get('img','reload_on.png').target,
  game._loader:get('img','reload_over.png').target,
  game._loader:get('img','weapon_select.png').target)
  self.primary_panel:set('Position',{134,39})
  
  self.secondary_panel = WeaponPanel(self,game._loader:get('img','weapon_bg.png').target,font,
  game._loader:get('img','reload.png').target,
  game._loader:get('img','reload_on.png').target,
  game._loader:get('img','reload_over.png').target,
  game._loader:get('img','weapon_select.png').target)
  self.secondary_panel:set('Position',{134,120})
  
  self._null_tex = CreateTextureFromImage('null',CreateEmptyImage(124,122,8))

  local tmp_y = 0
  _.each({
    self.lab_name,self.lab_level,self.lab_cost,
    self.lab_attr,
    self.lab_move
  },function(i)
    i:sets({Position={277,45+tmp_y*18}})
    i:addTo(self)
    tmp_y = tmp_y + 1
  end)
end

function CurrentPanel:update()
  local unit = {name='nobody',exp='0',level='0',cost='0',move='0',force='0',skill='0',resistance='0',_mg='0',agility='0',intelligence='0',action=1}
  if self._unit then
    unit = self._unit
    self._picture:set('Texture',self._unit._large_image)
  else
    self._picture:set('Texture',self._null_tex)
  end
  self.lab_level:set('Text','Level '..unit.level.." ("..unit.exp..'px)')
  self.lab_name:set('Text',string.upper(unit.name))
  self.lab_cost:set('Text','$'..unit.cost)
  self.lab_move:set('Text','Move: '..unit._mg..'/'..unit.move)
  self.lab_attr:set('Text','F'..unit.force..' A'..unit.agility..' R'..unit.resistance..' S'..unit.skill..' I'..unit.intelligence)
  self._picture_action:set('Visible',unit.action==nil)
  if unit.primary then self.primary_panel.weapon = unit.primary else self.primary_panel.weapon = nil end
  if unit.secondary then self.secondary_panel.weapon = unit.secondary else self.secondary_panel.weapon = nil end
  self.primary_panel:update()
  self.secondary_panel:update()
end
