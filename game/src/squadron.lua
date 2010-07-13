Squadron = class('Squadron')
Squadron:includes(EventDispatcher)

function Squadron:initialize(obj)
  print("initialize Squadron")
  _.extend(self,obj)
  if self.units then
    local tmp = self.units
    self.units = _.map(tmp,function(i) return Unit(i) end)
  end
  if self.player then
    local tmp = self.player
    self.player = Player(tmp)
  end
end

