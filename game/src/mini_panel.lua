MiniPanel = class('MiniPanel', GuiObject)
MiniPanel._instance_count = 0

function MiniPanel:initialize(parent,bg,mbg,mfg,lbg,lfg)
  MiniPanel._instance_count = MiniPanel._instance_count + 1
  super.initialize(self,elf.SCREEN,'mini_panel'..MiniPanel._instance_count,{Texture={bg}})
  self:addTo(parent)
  self._unit = nil
  
  self._move_bar = ProgressBar(self,'mini_bar_move'..MiniPanel._instance_count,mbg,mfg)
  self._life_bar = ProgressBar(self,'mini_bar_life'..MiniPanel._instance_count,lbg,lfg)
  self._move_bar:set('Position',7,83)
  self._life_bar:set('Position',7,88)
end

function MiniPanel:update()
  if self._unit then
    self._move_bar:max(self._unit.move)
    self._move_bar:current(self._unit._mg)
    self._life_bar:max(1)
    self._life_bar:current(1)
  else
    self._move_bar:max(1)
    self._move_bar:current(0)
    self._life_bar:max(1)
    self._life_bar:current(0)
  end
end
