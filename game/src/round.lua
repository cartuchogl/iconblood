Round = class('Round')
Round:includes(EventDispatcher)

function Round:initialize(game,number)
  self.number = number
  self.players = game:players()
end

function Round:start()
  return self
end
  