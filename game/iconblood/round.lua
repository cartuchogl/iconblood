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
      self:fireEvent("endrounds",{self})
    end
  else
    self._current = 1
  end
  self._current_turn = Turn(self,self.players[self._current_player_indx])
  self._current_turn:addEvent("move_wait1",function(args)
    _.each(self.players[self._current_player_indx].squadron.units,function(unit)
      unit.moves[#unit.moves+1] = unit.turn_moves
      unit.turn_moves = {}
      print(".")
    end)
    -- el otro no hace nada
    self._current_turn:nextStep()
  end)
  
  self._current_turn:addEvent("wait1_targets",function(args)
    -- make moves of other player
  end)
  
  self._current_turn:addEvent("targets_wait2",function(args)
    _.each(self.players[self._current_player_indx].squadron.units,function(unit)
      unit.targets[#unit.targets+1] = unit.turn_targets
      unit.turn_targets = {}
      print("..")
    end)
    -- el otro no hace nada
    self._current_turn:nextStep()
  end)
  
  self._current_turn:addEvent("wait2_clean",function(args)
    _.each(self.players[self._current_player_indx].squadron.units,function(unit)
      print(unit.targets[#unit.targets][1])
      if unit.targets[#unit.targets][1] then
        unit:fire(unit.targets[#unit.targets][1])
      end
    end)
  end)
  
  self._current_turn:addEvent("clean_wait_clean",function(args)
    -- nothing yet
    _.each(self.players[self._current_player_indx].squadron.units,function(unit)
      if unit:isAlive() then
        unit:reset()
      end
    end)
    -- el otro no hace nada
    self._current_turn:nextStep()
  end)
  
  self._current_turn:addEvent("wait_clean_move", function(args)
    self:start(self._current+1)
  end)
  
  self._current_turn:addEvent("endturn",function(args)
    print("endturn")
    args[1]._player.squadron:reset()
    if self._current_player_indx+1>#self.players then
      self:fireEvent("endround",{self})
    else
      self._current_player_indx = self._current_player_indx+1
      self._current_turn:pass(self.players[self._current_player_indx])
    end
    self:fireEvent("endturn",args)
  end)
end
  