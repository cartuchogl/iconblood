Round = class('Round')
Round:includes(EventDispatcher)

function Round:initialize(game,number)
  self.number = number
  self.players = game:players()
  self:addEvent("endround",function(args)
    print("endround")
    self:start(self._current+1)
  end)
  self:addEvent("endrounds",function(args)
    print("endrounds")
    game:stop()
  end)
end

function Round:start(...)
  self._current_player_indx = 1
  if #arg>0 then
    self._current = arg[1]
    if self._current > self.number then
      self:fireEvent("endrounds",{self},0)
    end
  else
    self._current = 1
  end
  self._current_turn = Turn(self,self.players[self._current_player_indx])
  self._current_turn:addEvent("endturn",function(args)
    print("endturn")
    args[1]._player.squadron:resetMove()
    if self._current_player_indx+1>#self.players then
      self:fireEvent("endround",{self},0)
    else
      self._current_player_indx = self._current_player_indx+1
      self._current_turn:pass(self.players[self._current_player_indx])
    end
    self:fireEvent("endturn",args,0)
  end)
end
  