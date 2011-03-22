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
  
  self.lab_life = ElfObject(LABEL,"lab_life",{
    Font = font,
    Text = "0/0 LIFE",
    Color = {1,0,0,1},
    Position = {412,8},
    parent = self
  })
  
  self.lab_force = ElfObject(LABEL,"lab_force",{parent = self,Font = font2,Text = 'FORCE 0'})
  self.lab_resis = ElfObject(LABEL,"lab_resis",{parent = self,Font = font2,Text = 'RESISTENCE 0'})
  self.lab_agili = ElfObject(LABEL,"lab_agili",{parent = self,Font = font2,Text = 'AGILITY 0'})
  self.lab_skill = ElfObject(LABEL,"lab_skill",{parent = self,Font = font2,Text = 'SKILLS 0'})
  self.lab_intel = ElfObject(LABEL,"lab_intel",{parent = self,Font = font2,Text = 'INTELLIGENCY 0'})
  self.lab_move  = ElfObject(LABEL,"lab_move",{ parent = self,Font = font2,Text = 'MOVE 0/0'})
  
  local c = 0
  _.each({
    self.lab_force,
    self.lab_resis,
    self.lab_agili,
    self.lab_skill,
    self.lab_intel,
    self.lab_move
  },function(i)
    i:set("Position",{278,47+c*15})
    c = c + 1
  end)
  self.lab_move:set("Position",{278,47+c*15})
  
  self._picture = ElfObject(PICTURE,'large_pic',{
    Position = {5,44},
    parent = self
  })
  
  self._picture_action = ElfObject(PICTURE,'current_action_pic',{
    Position = {117,49},
    Texture = game._loader:get('img','action.png').target,
    parent = self
  })
    
  self._button_chars = ElfObject(BUTTON,"btn_chars",{
    OffTexture = game._loader:get('img','chars.png').target,
    OverTexture = game._loader:get('img','chars_over.png').target,
    Text = "RELOAD",
    Font = font2,
    Position = {413,39+33+33},
    parent = self
  })
  
  self._button_habs = ElfObject(BUTTON,"btn_habs",{
    OffTexture = game._loader:get('img','habs.png').target,
    OverTexture = game._loader:get('img','habs_over.png').target,
    Text = "HABILITIES",
    Font = font2,
    Position = {413,39},
    parent = self,
    events = {
      click = function(args)
        local request
        request = Request({Url="http://www.google.com",Method="GET",events={
          completed = function(args)
            print(args.response)
          end
        }})
        request:send()
      end
    }
  })
  
  self._button_inv = ElfObject(BUTTON,"btn_inv",{
    OffTexture = game._loader:get('img','inv.png').target,
    OverTexture = game._loader:get('img','inv_over.png').target,
    Text = "crouch",
    Font = font2,
    Position = {413,39+33},
    parent = self
  })
  
  self._button_run = ElfObject(BUTTON,"btn_run",{
    OffTexture = game._loader:get('img','inv.png').target,
    OverTexture = game._loader:get('img','inv_over.png').target,
    Text = "RUN",
    Font = font2,
    Position = {413,39+33*3},
    parent = self
  })
  
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
end

function CurrentPanel:update()
  local unit = {
    name='nobody',exp='0',level='0',cost='0',
    move='0',force='0',skill='0',resistance='0',agility='0',intelligence='0',
    action=1,_mg='0',_pv='0'
  }
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
  self.lab_force:set('Text', 'FORCE '..unit.force)
  self.lab_resis:set('Text', 'RESISTENCE '..unit.resistance)
  self.lab_agili:set('Text', 'AGILITY '..unit.agility)
  self.lab_skill:set('Text', 'SKILLS '..unit.skill)
  self.lab_intel:set('Text', 'INTELLIGENCY '..unit.intelligence)
  self.lab_move:set('Text', 'MOVE '..unit._mg.."/"..unit.move)
  self._picture_action:set('Visible',unit.action==nil)
  if unit.primary then self.primary_panel.weapon = unit.primary else self.primary_panel.weapon = nil end
  if unit.secondary then self.secondary_panel.weapon = unit.secondary else self.secondary_panel.weapon = nil end
  self.primary_panel:update()
  self.secondary_panel:update()
end
