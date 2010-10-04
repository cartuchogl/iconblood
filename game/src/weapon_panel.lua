WeaponPanel = class('WeaponPanel', ElfObject)
WeaponPanel._instance_count = 0

function WeaponPanel:initialize(parent,bg,font,off,over,on,select)
  WeaponPanel._instance_count = WeaponPanel._instance_count + 1
  super.initialize(self,SCREEN,'weapon_panel'..WeaponPanel._instance_count,{Texture=bg})
  self:addTo(parent)
  self.weapon = nil
  
  self._picture = ElfObject(PICTURE,'weapon_pic'..WeaponPanel._instance_count,{Position={0,0}})
  self._picture:addTo(self)
  self._label_clip = ElfObject(LABEL,'label_clip'..WeaponPanel._instance_count,{
    Position={1,32},
    Text='0/0',
    Font=font,
    Color={0.15,0.93,1,1}
  })
  self._label_clip:addTo(self)
  self._button_reload = ElfObject(BUTTON,'button_reload'..WeaponPanel._instance_count,{
    OffTexture = off,
    OverTexture = over,
    OnTexture = on,
    Position={105,0},
    Visible=false
  })
  self._button_reload:addTo(self)
  
  self._weapon_select = ElfObject(PICTURE,'weapon_select'..WeaponPanel._instance_count,{
    Texture = select,
    Position={0,0},
    Visible=false
  })
  self._weapon_select:addTo(self)
  
  self._null_tex = CreateTextureFromImage(CreateEmptyImage(101,30,8))
  
  self._picture:addEvent('click',function(args)
    if self.weapon then
      self.weapon._parent.current_weapon = self.weapon
    end
  end)
end

function WeaponPanel:update()
  if self.weapon then
    self._label_clip:set('Text',self.weapon._current_clip..'/'..self.weapon._current_total)
    self._button_reload:set('Visible',true)
    self._picture:set('Texture',game._loader:get('img',"factions/humans/weapons/"..self.weapon.id..".png").target)
    self._weapon_select:set('Visible',self.weapon==self.weapon._parent.current_weapon)
  else
    self._label_clip:set('Text','0/0')
    self._button_reload:set('Visible',false)
    self._picture:set('Texture',self._null_tex)
    self._weapon_select:set('Visible',false)
  end
end
