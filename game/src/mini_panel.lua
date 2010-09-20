MiniPanel = class('MiniPanel', ElfObject)
MiniPanel._instance_count = 0

function MiniPanel:initialize(parent,bg,select,mbg,mfg,lbg,lfg)
  MiniPanel._instance_count = MiniPanel._instance_count + 1
  super.initialize(self,elf.SCREEN,'mini_panel'..MiniPanel._instance_count,{Texture=bg})
  self:addTo(parent)
  self._unit = nil
  
  self._move_bar = ProgressBar(self,'mini_bar_move'..MiniPanel._instance_count,mbg,mfg)
  self._life_bar = ProgressBar(self,'mini_bar_life'..MiniPanel._instance_count,lbg,lfg)
  self._move_bar:set('Position',7,93)
  self._life_bar:set('Position',7,82)
  self._picture = ElfObject(elf.PICTURE,'mini_pic'..MiniPanel._instance_count,{Position={6,4}})
  self._picture:addEvent('click',function(args)
    if self._unit then
      -- FIXME: global use
      game:fireEvent('selected:unit',{self._unit})
    end
  end)
  self._picture:addTo(self)
  self._picture_action = ElfObject(elf.PICTURE,'current_action_pic'..MiniPanel._instance_count,{Position={57,8},Texture=game._loader:get('img','action.png').target})
  self._picture_action:addTo(self)
  self._select_pic = ElfObject(elf.PICTURE,'select_pic'..MiniPanel._instance_count,{Position={6,4},Texture=select})
  self._select_pic:addTo(self)
end

function MiniPanel:update()
  if self._unit then
    self._move_bar:max(self._unit.move)
    self._move_bar:current(self._unit._mg)
    self._life_bar:max(1)
    self._life_bar:current(1)
    self._picture:set('Texture',self._unit._mini_image)
    self._select_pic:set('Visible',self._unit == game._current_unit)
    self._picture_action:set('Visible',self._unit.action==nil)
  else
    self._move_bar:max(1)
    self._move_bar:current(0)
    self._life_bar:max(1)
    self._life_bar:current(0)
    self._select_pic:set('Visible',false)
    self._picture_action:set('Visible',false)
  end
end
