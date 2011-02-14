TurnPanel = class('TurnPanel', ElfObject)

function TurnPanel:initialize(parent,loader,round)
  self._loader = loader
  local bg = self._loader:get('img','rect2817.png').target
  local font = self._loader:get('font','fonts/big.ttf').target
  local font2 = self._loader:get('font','fonts/small.ttf').target
  local off = self._loader:get('img','end_turn.png').target
  local over = self._loader:get('img','end_turn_over.png').target
  local on = self._loader:get('img','end_turn_on.png').target
  
  local x = GetTextureWidth(bg)-GetTextureWidth(off)
  super.initialize(self,SCREEN,'turn_panel',{Position={15,28},Texture={bg}})
  self:addTo(parent)
  self._round = round
  
  self._button_end_turn = ElfObject(BUTTON,"btn_end_turn",{
    OffTexture = off,
    OverTexture = over,
    Position = {x,0},
    Text = 'END TURN >',
    Font = font
  })
  self._button_end_turn:addEvent('click',function(args)
    game._round._current_turn:endTurn()
  end)
  self._button_end_turn:addTo(self)
  
  self._label_round = ElfObject(LABEL,"lab_round",{
    Font = font,
    Text = 'Round:0/0',
    Position = {8,7},
    Color = {0.18,0.18,0.19,0.9}
  })
  self._label_round:addTo(self)
  
  self._label_turn = ElfObject(LABEL,"lab_turn",{
    Font = font2,
    Text = 'anybody turn',
    Position = {100,10},
    Color = {0.18,0.18,0.19,0.9}
  })
  self._label_turn:addTo(self)
  
  
end

function TurnPanel:update()
  self._label_round:set('Text',"ROUND "..self._round._current.."/"..self._round.number)
  self._label_turn:set('Text',"/"..self._round._current_turn._player.alias)
end
