Game = class('Game')
Game:includes(EventDispatcher)

function Game:initialize(ibg)
  print("initialize Game")
  if ibg then _.extend(self,ibg) end
  _.each(_.keys(self),function(i) print(i,self[i]) end)
  if self.squadrons then
    local tmp = self.squadrons
    self.squadrons = _.map(tmp,function(i) return Squadron(i) end)
  end
  self._gaming = false
  self._factions = {}
  self._current_unit = nil
  self:addEvent('selected:unit',function(args)
    if self._current_unit then
      self._current_unit:fireEvent("deselect:unit",self._current_unit,0)
    end
    self._current_unit = args[1]
    self._current_unit:fireEvent("select:unit",self._current_unit,0)
    print("game:track event"..args[1].name)
  end)
end

function Game:loadEnvironment()
  print("Game:loadEnvirontment")
  self._scene = elf.LoadScene(findPath("../environments/","0*"..self.environment.."_*.*").."/level.pak")
  self._plane = elf.GetEntityByName(self._scene,'Plane') 
  local kk = elf.GetActorBoundingLengths(self._plane)
  local ss = elf.GetEntityScale(self._plane)
  self._resolution = { x = ss.x*kk.x, y = ss.y*kk.y }
  return self._scene
end

function Game:loadUnits()
  print("Game:loadUnits")
  _.each(self.squadrons,function(i)
    _.each(i.units,function(j)
      if self._factions[j.faction_id] then
        j._faction = self._factions[j.faction_id]
      else
        j._faction = elf.CreateSceneFromFile(findPath("../factions/","0*"..j.faction_id.."_*.*").."/units.pak")
        self._factions[j.faction_id] = j._faction
      end
      j:loadElfObjects(self._scene)
      j:setPosition(j.position[1]*self:width(),j.position[2]*self:height())
    end)
  end)
  return self
end

function Game:findUnit(id)
  for i=1,#self.squadrons,1 do
    local squadron = self.squadrons[i]
    for j=1,#squadron.units,1 do
      local unit = squadron.units[j]
      if unit.id == id then
        return unit
      end
    end
  end
  return nil
end

function Game:players()
  return _.map(self.squadrons,function(i) return i.player end)
end

function Game:start()
  self._gaming = true
end

function Game:stop()
  self._gaming = false
end

function Game:running()
  return self._gaming
end

function Game:width()
  return self._resolution.x
end

function Game:height()
  return self._resolution.y
end

