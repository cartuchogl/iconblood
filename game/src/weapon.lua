Weapon = class('Weapon')
Weapon:includes(EventDispatcher)

function Weapon:initialize(obj)
  _.extend(self,obj)
  self._current_clip = self.clip
  self._current_total = self.total-self.clip
end


