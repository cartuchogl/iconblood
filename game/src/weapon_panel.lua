WeaponPanel = class('WeaponPanel', ElfObject)
WeaponPanel._instance_count = 0

function WeaponPanel:initialize(parent,bg,font,off,over,on,select)
  WeaponPanel._instance_count = WeaponPanel._instance_count + 1
  super.initialize(self,SCREEN,'weapon_panel'..WeaponPanel._instance_count,{Texture=bg})
  self:addTo(parent)
  self.weapon = nil
  
  self._label_clip = ElfObject(LABEL,'label_clip'..WeaponPanel._instance_count,{
    Position={8,46},
    Text='0/0',
    Font=font,
    Color={0.15,0.93,1,1},
    parent = self
  })
  
  self._label_name = ElfObject(LABEL,'label_name'..WeaponPanel._instance_count,{
    Position={8,32},
    Text='no name',
    Font=font,
    parent = self
  })
  
  self._picture = ElfObject(PICTURE,'weapon_pic'..WeaponPanel._instance_count,{
    Position = {6,0},
    parent = self,
    events = {
      click = function(args)
        if self.weapon then
          self.weapon._parent.current_weapon = self.weapon
        end
      end
    }
  })
  
  self._weapon_select = ElfObject(PICTURE,'weapon_select'..WeaponPanel._instance_count,{
    Texture = select,
    Position = {0,0},
    Visible = false,
    parent = self
  })
  
  self._null_tex = CreateTextureFromImage('null',CreateEmptyImage(101,30,8))
end

function WeaponPanel:update()
  if self.weapon then
    self._label_clip:set('Text',self.weapon._current_clip..'/'..self.weapon._current_total.."  "..self.weapon.damage)
    self._label_name:set('Text',self.weapon.name)
    self._picture:set('Texture',game._loader:get('img',"factions/humans/weapons/"..self.weapon.id..".png").target)
    self._picture:set('Color',{1,1,1,1})
    self._weapon_select:set('Visible',self.weapon==self.weapon._parent.current_weapon)
  else
    self._label_clip:set('Text','0/0')
    self._label_name:set('Text',"no name")
    self._picture:set('Texture',self._null_tex)
    self._picture:set('Color',{1,1,1,0})
    self._weapon_select:set('Visible',false)
  end
end
