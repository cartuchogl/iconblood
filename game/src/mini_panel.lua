MiniPanel = class('MiniPanel', ElfObject)
MiniPanel._instance_count = 0

function MiniPanel:initialize(parent,bg,select,mbg,mfg,lbg,lfg,font)
  MiniPanel._instance_count = MiniPanel._instance_count + 1
  super.initialize(self,SCREEN,'mini_panel'..MiniPanel._instance_count,{Texture=bg,parent=parent})
  self._unit = nil
  
  self._move_bar = ProgressBar(self,'mini_bar_move'..MiniPanel._instance_count,mbg,mfg)
  self._move_bar:direction("ver")
  self._life_bar = ProgressBar(self,'mini_bar_life'..MiniPanel._instance_count,lbg,lfg)
  self._life_bar:direction("ver")
  self._move_bar:set('Position',7,3)
  self._life_bar:set('Position',13,3)
  
  self._picture = ElfObject(PICTURE,'mini_pic'..MiniPanel._instance_count,{
    Position = {24,6},
    parent = self,
    events = {
      click = function(args)
        if self._unit then
          -- FIXME: global use
          game:fireEvent('selected:unit',{self._unit})
        end
      end
    }
  })

  self._picture_action = ElfObject(PICTURE,'current_action_pic'..MiniPanel._instance_count,{
    Position = {67,9},
    Texture = game._loader:get('img','action.png').target,
    parent = self
  })
  
  self._select_pic = ElfObject(PICTURE,'select_pic'..MiniPanel._instance_count,{
    Position = {24,6},
    Texture = select,
    parent = self
  })
  
  self._weapon_name = ElfObject(LABEL,'weapon_name'..MiniPanel._instance_count,{
    Position = {88,6},
    Font = font,
    Color = {1,1,1,1},
    Text = "Arma",
    parent = self
  })
  
  self._weapon_clip_damage = ElfObject(LABEL,'weapon_clip_damage'..MiniPanel._instance_count,{
    Position = {88,20},
    Font = font,
    Color = {0,1,1,1},
    Text = "0/0  1+1d4",
    parent = self
  })
  
  self._status = ElfObject(LABEL,'unit_status'..MiniPanel._instance_count,{
    Position = {88,40},
    Font = font,
    Color = {1,1,1,1},
    Text = "not ready",
    parent = self
  })
  
  self._status = ElfObject(LABEL,'unit_bonus'..MiniPanel._instance_count,{
    Position = {88,54},
    Font = font,
    Color = {1,1,1,1},
    Text = "Ninguno",
    parent = self
  })
end

function MiniPanel:update()
  if self._unit then
    self._move_bar:max(self._unit.move)
    self._move_bar:current(self._unit._mg)
    self._life_bar:max(self._unit.resistance*10)
    self._life_bar:current(self._unit._pv)
    self._picture:set('Texture',self._unit._mini_image)
    self._select_pic:set('Visible',self._unit == game._current_unit)
    self._picture_action:set('Visible',self._unit.action==nil)
    
    self._weapon_name:set('Text', self._unit.current_weapon.name)
    self._weapon_clip_damage:set('Text',
      self._unit.current_weapon._current_clip..
      '/'..self._unit.current_weapon._current_total..
      " "..self._unit.current_weapon.damage
    )
    if self._unit:isAlive() then
      self:set("Color",{1,1,1,1})
      self._picture:set("Color",{1,1,1,1})
      self._picture_action:set("Color",{1,1,1,1})
    else
      self:set("Color",{1,1,1,0.45})
      self._picture:set("Color",{1,1,1,0.25})
      self._picture_action:set("Color",{1,1,1,0})
    end
  else
    self._move_bar:max(1)
    self._move_bar:current(0)
    self._life_bar:max(1)
    self._life_bar:current(0)
    self._select_pic:set('Visible',false)
    self._picture_action:set('Visible',false)
    
    self._weapon_name:set('Text', 'nothing')
    self._weapon_clip_damage:set('Text','nothing')
  end
end
