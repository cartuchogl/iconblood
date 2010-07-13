Round = class('Round')
Round:includes(EventDispatcher)

function Round:initialize(game,number)
  print("initialize Round")
  self.number = number
  self.players = game:players()
end

function Round:start()
  return self
end
  