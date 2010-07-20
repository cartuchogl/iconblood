Game = class('Game')
Game:includes(EventDispatcher)

function Game:initialize(ibg,gui)
  if ibg then _.extend(self,ibg) end
  self._gui = gui
  if self.squadrons then
    local tmp = self.squadrons
    self.squadrons = _.map(tmp,function(i) return Squadron(i) end)
  end
  self._gaming = false
  self._factions = {}
  self._current_unit = nil
  self:addEvent('selected:unit', _.curry(self.on_selected_unit,self))
  self:addEvent("onplane", _.curry(self.on_plane,self))
  self:addEvent("over", _.curry(self.on_over,self))
  self:addEvent("overobject", _.curry(self.on_over_object,self))
end

function Game:on_selected_unit(args)
  if args[1]._squadron.player == self._round._current_turn._player then
    if self._current_unit then
      self._current_unit:fireEvent("deselect:unit",self._current_unit,0)
    end
    self._current_unit = args[1]
    self._current_unit:fireEvent("select:unit",self._current_unit,0)
  end
  print("game:track event"..args[1].name)
end

function Game:on_plane(args)
  print("onplane")
  if self._current_unit then
    local v = elf.GetCollisionPosition(args[1])
    if self._current_unit:canBe(v.x,v.y) then
      local x = v.x-self._current_unit._real_pos.x
      local y = v.y-self._current_unit._real_pos.y
      local cost = math.ceil(math.sqrt(x*x+y*y)*10)/10.0
      if cost > self._current_unit._mg then
        local kk = normalize2d({x=x,y=y},self._current_unit._mg)
        kk.x = self._current_unit._real_pos.x+kk.x
        kk.y = self._current_unit._real_pos.y+kk.y
        self._current_unit:setPosition(kk.x,kk.y)
        self._current_unit._mg = 0
        return false
      end
      self._current_unit:setPosition(v.x,v.y)
      self._current_unit._mg = self._current_unit._mg-cost
    end
  end
end

function Game:on_over_object(args)
  if instanceOf(Game,args[1]) then
    if self._current_unit then
      local v = elf.GetCollisionPosition(args[2])
      if self._current_unit:canBe(v.x,v.y) then
        local x = v.x-self._current_unit._real_pos.x
        local y = v.y-self._current_unit._real_pos.y
        local cost = math.ceil(math.sqrt(x*x+y*y)*10)/10.0
        lab_tooltip:set('Text',''..cost)
        if cost > self._current_unit._mg then
          local kk = normalize2d({x=x,y=y},self._current_unit._mg)
          kk.x = self._current_unit._real_pos.x+kk.x
          kk.y = self._current_unit._real_pos.y+kk.y
          self._current_unit:setMax(kk.x,kk.y)
          return false
        end
        self._current_unit:setMax(v.x,v.y)
      else
        lab_tooltip:set('Text','')
      end
    end
  elseif instanceOf(Unit,args[1]) then
    if self._current_unit then
      self._current_unit:setMax(self._current_unit._real_pos.x,self._current_unit._real_pos.y)
      lab_tooltip:set('Text','')
    end
  end
end

function Game:on_over(args)
  local col = args[1]
  local actor = elf.GetCollisionActor(col)
  local name = elf.GetActorName(actor)
  local new_current = nil
  if string.match(name,"Plane") then
    new_current = self
  elseif string.match(name,"Unit") then
    new_current = self:findUnit(tonumber(string.match(name,"Unit\.(%d+)")))
  end
  if self._current_over then
    if self._current_over == new_current then
      self:fireEvent("overobject",{self._current_over,col},0)
      return false
    else
      self._current_over:fireEvent("leave",{self._current_over},0)
    end
  end
  self._current_over = new_current
  self._current_over:fireEvent("enter",self._current_over)
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

function Game:currentPlayer()
  return self._round._current_turn._player
end

function Game:start()
  self._gaming = true
  self._round = Round(self,20)
  self._round:addEvent("endturn",function(args)
    if self._current_unit then
      self._current_unit:fireEvent("deselect:unit",self._current_unit,0)
    end
    self._current_unit = nil
  end)
  self._round:start()
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

