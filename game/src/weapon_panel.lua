WeaponPanel = class('WeaponPanel', ElfObject)
WeaponPanel._instance_count = 0

function WeaponPanel:initialize(parent,bg,font,off,over,on)
  WeaponPanel._instance_count = WeaponPanel._instance_count + 1
  super.initialize(self,elf.SCREEN,'weapon_panel'..WeaponPanel._instance_count,{Texture=bg})
  self:addTo(parent)
  self.weapon = nil
  
  self._picture = ElfObject(elf.PICTURE,'weapon_pic'..WeaponPanel._instance_count,{Position={0,0}})
  self._picture:addTo(self)
  self._label_clip = ElfObject(elf.LABEL,'label_clip'..WeaponPanel._instance_count,{
    Position={1,32},
    Text='0/0',
    Font=font,
    Color={0.15,0.93,1,1}
  })
  self._label_clip:addTo(self)
  self._button_reload = ElfObject(elf.BUTTON,'button_reload'..WeaponPanel._instance_count,{
    OffTexture = off,
    OverTexture = over,
    OnTexture = on,
    Position={105,0},
    Visible=false
  })
  self._button_reload:addTo(self)
  
  self._null_tex = elf.CreateTextureFromImage(elf.CreateEmptyImage(101,30,8))
end

function WeaponPanel:update()
  if self.weapon then
    self._label_clip:set('Text',self.weapon._current_clip..'/'..self.weapon._current_total)
    self._button_reload:set('Visible',true)
    self._picture:set('Texture',game._loader:get('img',"factions/humans/weapons/"..self.weapon.id..".png").target)
  else
    self._label_clip:set('Text','0/0')
    self._button_reload:set('Visible',false)
    self._picture:set('Texture',self._null_tex)
  end
end
