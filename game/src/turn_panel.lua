TurnPanel = class('TurnPanel', GuiObject)

function TurnPanel:initialize(parent,bg,font,off,over,on,round)
  local x = (elf.GetWindowWidth()-elf.GetTextureWidth(bg))/2
  super.initialize(self,elf.SCREEN,'turn_panel',{Position={x,0},Texture={bg}})
  self:addTo(parent)
  self._round = round
  
  local exscr = elf.CreateScript('script1') 
  elf.SetScriptText(exscr, "game._round._current_turn:endTurn()")
  
  self._button_end_turn = GuiObject(elf.BUTTON,"btn_end_turn",{
    OffTexture = {off},
    OverTexture = {over},
    OnTexture = {on},
    Position = {159,10},
    Script = {exscr}
  })
  self._button_end_turn:addTo(self)
  
  self._label_round = GuiObject(elf.LABEL,"lab_round",{
    Font = {font},
    Text = {'Round:0/0'},
    Position = {16,10}
  })
  self._label_round:addTo(self)
  
  self._label_turn = GuiObject(elf.LABEL,"lab_turn",{
    Font = {font},
    Text = {'anybody turn'},
    Position = {16,28}
  })
  self._label_turn:addTo(self)
  
  
end

function TurnPanel:update()
  self._label_round:set('Text',"Round: "..self._round._current.."/"..self._round.number)
  self._label_turn:set('Text',self._round._current_turn._player.alias.."'s turn")
end
