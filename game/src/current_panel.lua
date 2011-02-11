CurrentPanel = class('CurrentPanel', ElfObject)

function CurrentPanel:initialize(parent,loader,unit)
  self._loader = loader
  local bg = self._loader:get('img',"current_bg.png").target
  local font = self._loader:get('font','fonts/big.ttf').target
  local font2 = self._loader:get('font','fonts/medium.ttf').target
  
  local y = GetWindowHeight()-GetTextureHeight(bg)
  local x = (GetWindowWidth()-GetTextureWidth(bg))/2
  super.initialize(self,SCREEN,'current_panel',{Position={x,y},Texture=bg})
  self:addTo(parent)
  self._unit = unit
  
  self.lab_level = ElfObject(LABEL,"lab_level",{Font = font2,Text = 'level', Color={0.21,0.21,0.21,1}})
  self.lab_name = ElfObject(LABEL,"lab_name",{Font = font,Text = 'name',Color={0.21,0.21,0.21,1}})
  self.lab_cost = ElfObject(LABEL,"lab_cost",{Font = font2,Text = 'cost',Color={0,1,1,1}})
  
  self.title_line = TypedString(self,"current_title")
  self.title_line:set("Position",{14,6})
  self.title_line:addLabel(self.lab_name._elf_obj)
  self.title_line:addLabel(self.lab_level._elf_obj)
  self.title_line:addLabel(self.lab_cost._elf_obj)
  
  self.lab_life = ElfObject(LABEL,"lab_life",{Font=font,Text="0/0 LIFE", Color={1,0,0,1},Position={412,8}})
  self.lab_life:addTo(self)
  
  self.lab_force = ElfObject(LABEL,"lab_force",{Font = font2,Text = 'FORCE 0'})
  self.lab_resis = ElfObject(LABEL,"lab_resis",{Font = font2,Text = 'RESISTENCE 0'})
  self.lab_agili = ElfObject(LABEL,"lab_agili",{Font = font2,Text = 'AGILITY 0'})
  self.lab_skill = ElfObject(LABEL,"lab_skill",{Font = font2,Text = 'SKILLS 0'})
  self.lab_intel = ElfObject(LABEL,"lab_intel",{Font = font2,Text = 'INTELLIGENCY 0'})
  self.lab_move  = ElfObject(LABEL,"lab_move",{Font = font2,Text = 'MOVE 0'})
  
  local c = 0
  _.each({self.lab_force,
  self.lab_resis,
  self.lab_agili,
  self.lab_skill,
  self.lab_intel,
  self.lab_move},function(i)
    i:set("Position",{278,47+c*15})
    c = c + 1
    i:addTo(self)
  end)
  self.lab_move:set("Position",{278,47+c*15})
  
  self.lab_attr = ElfObject(LABEL,"lab_attr",{Font = font,Text = 'attr'})
  self._picture = ElfObject(PICTURE,'large_pic',{Position={5,44}})
  self._picture:addTo(self)
  self._picture_action = ElfObject(PICTURE,'current_action_pic',{
    Position={117,49},Texture=game._loader:get('img','action.png').target
  })
  self._picture_action:addTo(self)
    
  self._button_chars = ElfObject(BUTTON,"btn_chars",{
    OffTexture = game._loader:get('img','chars.png').target,
    OverTexture = game._loader:get('img','chars_over.png').target,
    Text = "ATTRIBUTES",
    Font = font2,
    Position = {413,39+33+33}
  })
  self._button_chars:addTo(self)
  
  self._button_habs = ElfObject(BUTTON,"btn_habs",{
    OffTexture = game._loader:get('img','habs.png').target,
    OverTexture = game._loader:get('img','habs_over.png').target,
    Text = "HABILITIES",
    Font = font2,
    Position = {413,39}
  })
  self._button_habs:addTo(self)
  
  self._button_inv = ElfObject(BUTTON,"btn_inv",{
    OffTexture = game._loader:get('img','inv.png').target,
    OverTexture = game._loader:get('img','inv_over.png').target,
    Text = "EQUIPAMENT",
    Font = font2,
    Position = {413,39+33}
  })
  self._button_inv:addTo(self)
  
  self._button_run = ElfObject(BUTTON,"btn_run",{
    OffTexture = game._loader:get('img','inv.png').target,
    OverTexture = game._loader:get('img','inv_over.png').target,
    Text = "RUN",
    Font = font2,
    Position = {413,39+33*3}
  })
  self._button_run:addTo(self)
  
  self.primary_panel = WeaponPanel(self,game._loader:get('img','weapon_bg.png').target,font2,
  game._loader:get('img','reload.png').target,
  game._loader:get('img','reload_on.png').target,
  game._loader:get('img','reload_over.png').target,
  game._loader:get('img','weapon_select.png').target)
  self.primary_panel:set('Position',{134,39})
  
  self.secondary_panel = WeaponPanel(self,game._loader:get('img','weapon_bg.png').target,font2,
  game._loader:get('img','reload.png').target,
  game._loader:get('img','reload_on.png').target,
  game._loader:get('img','reload_over.png').target,
  game._loader:get('img','weapon_select.png').target)
  self.secondary_panel:set('Position',{134,39+70})
  
  self._null_tex = CreateTextureFromImage('null',CreateEmptyImage(124,122,8))

  local tmp_y = 0
  _.each({
    self.lab_level,self.lab_cost,
    self.lab_attr,
    self.lab_move
  },function(i)
    -- i:sets({Position={277,45+tmp_y*18}})
    -- i:addTo(self)
    tmp_y = tmp_y + 1
  end)
end

function CurrentPanel:update()
  local unit = {name='nobody',exp='0',level='0',cost='0',move='0',force='0',skill='0',resistance='0',_mg='0',_pv='0',agility='0',intelligence='0',action=1}
  if self._unit then
    unit = self._unit
    self._picture:set('Texture',self._unit._large_image)
    self._picture:set('Color',{1,1,1,1})
  else
    self._picture:set('Texture',self._null_tex)
    self._picture:set('Color',{1,1,1,0})
  end
  self.lab_level:set('Text','/LEVEL '..unit.level.."."..unit.exp..'PX')
  self.lab_name:set('Text',string.upper(unit.name))
  self.lab_cost:set('Text','+'..unit.cost.."PX")
  self.title_line:update()
  self.lab_life:set("Text",unit._pv..'/'..(unit.resistance*10).." LIFE")
  self.lab_move:set('Text','Move: '..unit._mg..'/'..unit.move)
  self.lab_attr:set('Text','F'..unit.force..' A'..unit.agility..' R'..unit.resistance..' S'..unit.skill..' I'..unit.intelligence)
  self._picture_action:set('Visible',unit.action==nil)
  if unit.primary then self.primary_panel.weapon = unit.primary else self.primary_panel.weapon = nil end
  if unit.secondary then self.secondary_panel.weapon = unit.secondary else self.secondary_panel.weapon = nil end
  self.primary_panel:update()
  self.secondary_panel:update()
end
