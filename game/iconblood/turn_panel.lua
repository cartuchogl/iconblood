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
  super.initialize(self,SCREEN,'turn_panel',{
    Position = {15,28},
    Texture = bg,
    parent = parent
  })
  self._round = round
  
  self._button_end_turn = ElfObject(BUTTON,"btn_end_turn",{
    OffTexture = off,
    OverTexture = over,
    Position = {x,0},
    Text = 'NEXT STEP >',
    Font = font,
    parent = self,
    events = {
      click = function(args)
        game._round._current_turn:nextStep()
      end
    }
  })
  
  self._label_round = ElfObject(LABEL,"lab_round",{
    Font = font,
    Text = 'Round:0/0',
    Position = {8,7},
    Color = {0.18,0.18,0.19,0.9},
    parent = self
  })
  
  self._label_turn = ElfObject(LABEL,"lab_turn",{
    Font = font2,
    Text = 'anybody turn',
    Position = {100,10},
    Color = {0.18,0.18,0.19,0.9},
    parent = self
  })
end

function TurnPanel:update()
  local turn = self._round._current_turn
  self._label_round:set('Text',"ROUND "..self._round._current.."/"..self._round.number)
  self._label_turn:set('Text',"/"..turn._player.alias.." "..turn.current_step)
end
