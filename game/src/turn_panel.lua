TurnPanel = class('TurnPanel', ElfObject)

function TurnPanel:initialize(parent,bg,font,off,over,on,round)
  local x = (GetWindowWidth()-GetTextureWidth(bg))
  super.initialize(self,SCREEN,'turn_panel',{Position={x,0},Texture={bg}})
  self:addTo(parent)
  self._round = round
  
  local exscr = CreateScript('script1') 
  SetScriptText(exscr, "game._round._current_turn:endTurn()")
  
  self._button_end_turn = ElfObject(BUTTON,"btn_end_turn",{
    OffTexture = off,
    OverTexture = over,
    OnTexture = on,
    Position = {0,self:get('Size').y-GetTextureHeight(off)},
    Script = exscr
  })
  self._button_end_turn:addEvent('click',function(args)
    game._round._current_turn:endTurn()
  end)
  self._button_end_turn:addTo(self)
  
  self._label_round = ElfObject(LABEL,"lab_round",{
    Font = font,
    Text = 'Round:0/0',
    Position = {8,7},
    Color = {0.85,1,0,1}
  })
  self._label_round:addTo(self)
  
  self._label_turn = ElfObject(LABEL,"lab_turn",{
    Font = font,
    Text = 'anybody turn',
    Position = {8,40}
  })
  self._label_turn:addTo(self)
  
  
end

function TurnPanel:update()
  self._label_round:set('Text',"ROUND "..self._round._current.."/"..self._round.number)
  self._label_turn:set('Text',self._round._current_turn._player.alias.."'s turn")
end
