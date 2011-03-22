Weapon = class('Weapon')
Weapon:includes(EventDispatcher)

function Weapon:initialize(obj,parent)
  _.extend(self,obj)
  self._current_clip = self.clip
  self._current_total = self.total-self.clip
  self._parent = parent
end

function Weapon:skillMod(distance)
  if distance<self.vshort then
    return tonumber(self.vshort_bonus)
  elseif distance<self.short then
    return tonumber(self.short_bonus)
  elseif distance<self.long then
    return tonumber(self.long_bonus)
  elseif distance<self.vlong then
    return tonumber(self.vlong_bonus)
  else
    return 0
  end
end

function Weapon:damage_range(distance)
  local mod = ''
  if distance<self.vshort then
    mod = self.vshort_damage
  elseif distance<self.short then
    mod = self.short_damage
  elseif distance<self.long then
    mod = self.long_damage
  elseif distance<self.vlong then
    mod = self.vlong_damage
  end
  local d = self.damage
  if type(mod)=="string" then
    d = d..mod
  end
  return {calculate_string(d,'min'),calculate_string(d,'max')}
end

function Weapon:damage_fire(distance)
  local mod = ''
  if distance<self.vshort then
    mod = self.vshort_damage
  elseif distance<self.short then
    mod = self.short_damage
  elseif distance<self.long then
    mod = self.long_damage
  elseif distance<self.vlong then
    mod = self.vlong_damage
  end
  local d = self.damage
  if type(mod)=="string" then
    d = d..mod
  end
  return calculate_string(d)
end

