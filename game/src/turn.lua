Turn = class('Turn')
Turn:includes(EventDispatcher)

function Turn:initialize(round,player)
  self._round = round
  self._player = player
end

function Turn:pass(player)
  self._player = player
end

function Turn:endTurn()
  self:fireEvent("endturn",{self},0)
end


