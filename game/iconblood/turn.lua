Turn = class('Turn')
Turn:includes(EventDispatcher)

function Turn:initialize(round,player)
  self._round = round
  self._player = player
  self.steps = {
    'move',
    'wait1',
    'targets',
    'wait2',
    'clean',
    'wait_clean'
  }
  self.current_step = self.steps[1]
  self._current_step_index = 1
  self:addEvent("endturn",_.curry(self.kk,self))
end

function Turn:nextStep()
  local event = self.current_step.."_"
  self._current_step_index = self._current_step_index + 1
  if self._current_step_index > #self.steps then
    self._current_step_index = 1
  end
  self.current_step = self.steps[self._current_step_index]
  event = event..self.current_step
  self:fireEvent(event,self)
end

function Turn:kk(args)
  print(self._player.alias)
end

function Turn:pass(player)
  self._player = player
end

function Turn:endTurn()
  self:fireEvent("endturn",{self})
end


