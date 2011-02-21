Game = class('Game')
Game:includes(EventDispatcher)

function Game:initialize(ibg,gui,loader)
  if ibg then _.extend(self,ibg) end
  self._gui = gui
  if self.squadrons then
    local tmp = self.squadrons
    self.squadrons = _.map(tmp,function(i) return Squadron(i) end)
  end
  self._gaming = false
  self._factions = {}
  self._current_unit = nil
  self._gui_pull = {}
  self._loader = loader
  loader:addEnvBatch(self.environment)
  loader:addUnitsBatch(uniques(_.flatten(
    _.map(self.squadrons,function(i)
      return _.map(i.units,function(j)
        return(j.faction_name..'/'..j.name_unit)
      end)
    end)
  )))
  loader:addEvent('endbatch',_.curry(self.on_loader_end,self))
  self:addEvent('onframe', _.curry(self.on_frame,self))
  self:addEvent('selected:unit', _.curry(self.on_selected_unit,self))
  self:addEvent("onplane", _.curry(self.on_plane,self))
  self:addEvent("over", _.curry(self.on_over,self))
  self:addEvent("overobject", _.curry(self.on_over_object,self))
  
  self._fix_wheel = 0
  
  self._debug = Debug(gui)
end

function Game:update()
  self._current_unit_panel:update()
end

function Game:on_frame(args)
  self:cameraCheck()
  self:interaction()
  -- save a screenshot on F5
  if GetKeyState(KEY_F5) == PRESSED then
    local name = "screens/screenshot-"..os.time()..".png"
    if SaveScreenShot(name) == true then
      print("screen shot saved to " .. GetCurrentDirectory() .. "/"..name)
    end
  end
  self:update()
  self._turn_panel:update()
  self._current_squadron_panel._units = self._round._current_turn._player.squadron.units
  self._current_squadron_panel:update()
  self._debug:update()
end

function Game:interaction()
  local pos = GetMousePosition()
  self._lab_tooltip:sets({x=pos.x-14,y=pos.y-24})
  local gui_trace = GetGuiTrace(self._gui)
  if gui_trace and IsGuiObject(gui_trace) then
    local guiobj = ElfObject.find(GetGuiObjectName(gui_trace))
    local new_pull = guiobj:selfAndParents()
    _.each(self._gui_pull,function(i) if not table.find(new_pull,i) then i:fireEvent('leave',{i}) end end)
    _.each(new_pull,function(i) if not table.find(self._gui_pull,i) then i:fireEvent('enter',{i}) end end)
    self._gui_pull = new_pull
    if GetMouseButtonState(BUTTON_LEFT) == PRESSED then
      self._gui_pull[1]:fireEvent('click',{self._last_click})
    end
  else
    if #self._gui_pull>0 then
      _.each(self._gui_pull,function(i) i:fireEvent('leave',{i}) end)
      self._gui_pull = {}
    end
    local objs = get_objects_over_mouse(self._scene)
    if #objs > 0 then
      if GetMouseButtonState(BUTTON_LEFT) == PRESSED then
        local capture = false
        local names = _.map(objs,function(i) 
          return(GetActorName(GetCollisionActor(i)))
        end)
        local units = _.select(names,function(i) return string.match(i,"Unit\.(%d+)") end)
        if _.first(units) then
          local unit = game:findUnit(tonumber(string.match(_.first(units),"Unit\.(%d+)")))
          if unit and unit:isAlive() then
            capture = true
            self:fireEvent('selected:unit',{unit})
          end
        end
        if capture == false then
          names = _.map(objs,function(i) 
            local a = GetCollisionActor(i)
            return({GetActorName(a),a,i}) 
          end)
          local plane = _.select(names,function(i) return string.match(i[1],"Plane") end)[1]
          if plane then
            self:fireEvent("onplane",{plane[3]})
          end
        end
      else
        names = _.map(objs,function(i) 
          local a = GetCollisionActor(i)
          return({GetActorName(a),a,i}) 
        end)
        local obj = _.select(names,function(i) 
          return string.match(i[1],"Unit") 
        end)[1]
        if obj then
          self:fireEvent("over",{obj[3]})
        else
          obj = _.select(names,function(i) 
            return string.match(i[1],"Plane")
          end)[1] 
          if obj then
            self:fireEvent("over",{obj[3]})
          end
        end
      end
    end
  end
end

function Game:cameraCheck()
  local wheel = GetMouseWheel()
  if GetKeyState(KEY_UP) ~= UP then
    self._fix_wheel = self._fix_wheel+1
  end
  if GetKeyState(KEY_DOWN) ~= UP then
    self._fix_wheel = self._fix_wheel-1
  end
  MoveActorLocal(self._cam, 0.0, 0.0, (self._last_wheel-(wheel+self._fix_wheel))*self._key_move*4)
  self._last_wheel = wheel+self._fix_wheel
  
  local d = GetActorOrientation(self._cam)
  local orient = GetActorOrientation(self._cam)
  local dir = MulQuaVec3f(orient, self._cam_dir)
  local dir = normalize(dir, self._key_move)
  -- move camera across
  if GetKeyState(KEY_W) ~= UP then
    MoveActor(self._cam, dir.x, dir.y, 0.0)
  end
  if GetKeyState(KEY_S) ~= UP then
    MoveActor(self._cam, -dir.x, -dir.y, 0.0)
  end
  if GetKeyState(KEY_A) ~= UP then
    MoveActorLocal(self._cam, -self._key_move, 0.0, 0.0)
  end
  if GetKeyState(KEY_D) ~= UP then
    MoveActorLocal(self._cam, self._key_move, 0.0, 0.0)
  end
  
  if GetKeyState(KEY_K) ~= UP then
    if self._current_unit then
      look_at(self._cam,self._current_unit)
    end
  end
  
  if GetKeyState(KEY_L) ~= UP then
    if self._current_unit then
      local v1 = GetActorPosition(self._current_unit._elf_obj)
      local v2 = GetActorPosition(self._cam)
      SetActorPosition(self._cam,v1.x+13,v1.y+13,v1.z+12)
      look_at(self._cam,self._current_unit)
    end
  end
  
  if GetKeyState(KEY_E) ~= UP then
    if self._current_unit then
      local v1 = GetActorPosition(self._current_unit._elf_obj)
      local v2 = GetActorPosition(self._cam)
      
      local x = v2.x-v1.x
      local y = v2.y-v1.y
      local a = 0.05
      local xp = x*math.cos(a)-y*math.sin(a)+v1.x
      local yp = x*math.sin(a)+y*math.cos(a)+v1.y
      SetActorPosition(self._cam,xp,yp,v2.z)
      look_at(self._cam,self._current_unit)
    end
  end
  
  if GetKeyState(KEY_Q) ~= UP then
    if self._current_unit then
      local v1 = GetActorPosition(self._current_unit._elf_obj)
      local v2 = GetActorPosition(self._cam)
      
      local x = v2.x-v1.x
      local y = v2.y-v1.y
      local a = -0.05
      local xp = x*math.cos(a)-y*math.sin(a)+v1.x
      local yp = x*math.sin(a)+y*math.cos(a)+v1.y
      SetActorPosition(self._cam,xp,yp,v2.z)
      look_at(self._cam,self._current_unit)
    end
  end
  
  -- move with borders on fullscreen
  if IsFullscreen() then
    local pos = GetMousePosition()
    if pos.x == 0 then MoveActorLocal(self._cam, -self._key_move, 0.0, 0.0) end
    if pos.x == GetWindowWidth()-1 then 
      MoveActorLocal(self._cam, self._key_move, 0.0, 0.0) 
    end
    if pos.y == 0 then MoveActor(self._cam, dir.x, dir.y, 0.0) end
    if pos.y == GetWindowHeight()-1 then MoveActor(self._cam, -dir.x, -dir.y, 0.0) end
  end

  -- rotate the camera
  if GetMouseButtonState(2) == DOWN then
    local mf = GetMouseForce()
    self._imfx = (self._imfx*2.0+mf.x)/4.0
    RotateActor(self._cam, 0.0, 0.0, -self._imfx*10.0)
  end
  
  if GetKeyState(KEY_LEFT) ~= UP then
    RotateActor(self._cam, 0.0, 0.0, self._key_move*10.0)
  end
  if GetKeyState(KEY_RIGHT) ~= UP then
    RotateActor(self._cam, 0.0, 0.0, -self._key_move*10.0)
  end
end

function Game:on_loader_end(args)
  self:loadEnvironment()
  self:loadUnits()
  setTimeout(function() self._loader._loader_gui:set('Visible',false) end,100)
  -- get the camera for camera movement
  self._cam = GetSceneActiveCamera(self._scene)
  
  self._options_panel = OptionsPanel(self._gui,
    self._loader:get('font','fonts/medium.ttf').target
  )
  self._options_panel:set("Visible",false)
  self._help_panel = HelpPanel(self._gui,
    self._loader:get('img','help_panel.png').target,
    self._loader:get('font','fonts/medium.ttf').target
  )
  self._help_panel:set("Visible",false)
  self._exit_panel = ExitPanel(self._gui,
    self._loader:get('font','fonts/medium.ttf').target
  )
  self._exit_panel:set("Visible",false)
  
  self._menu_panel = MenuPanel(self._gui, self._loader)
  
  -- set camera to detect objects
  set_camera(self._cam)
  self:start()
  self._turn_panel = TurnPanel(self._gui,
    self._loader,
    self._round
  )
  self._current_unit_panel = CurrentPanel(self._gui,self._loader,nil)
  self._current_squadron_panel = UnitsPanel(self._gui,self._loader)
  self._lab_tooltip = ElfObject(LABEL,"lab_tooltip",{
    Font = self._loader:get('font','fonts/big.ttf').target,
    x = 270,
    y = 10,
    Text = ''
  })
  self._lab_tooltip:addTo(self._gui)
  self._last_wheel = 0

  self._cam_dir = CreateVec3f(0,0,-1000)
  self._key_move = 12.0
  self._imfx = 0
end

function Game:enemy_unit(unit)
  return unit._squadron.player ~= self._round._current_turn._player
end

function Game:on_selected_unit(args)
  if args[1]._squadron.player == self._round._current_turn._player then
    if self._current_unit then
      self._current_unit:fireEvent("deselect:unit",self._current_unit)
    end
    if args[1]:isAlive() then
      self._current_unit = args[1]
      self._current_unit_panel._unit = self._current_unit
      self._current_unit:fireEvent("select:unit",self._current_unit)
    end
  else
    if self._current_unit then
      if self:enemy_unit(args[1]) and args[1]:isAlive() then
        local cu = self._current_unit
        if cu.action then
          print('already fire...')
        else
          local v,l = self:visibility(cu,args[1])
          local s = (cu:calculatedSkill()+cu.current_weapon:skillMod(l))/10
          s = 100*v*s
          if s > 0 then
            cu:seeTo(args[1]:get('x'),args[1]:get('y'))
            PlayEntityArmature(cu._elf_obj,375,384,25)
            cu.action = 'fire'
            local dice = math.random(100)
            if dice <= s then
              args[1]:seeTo(cu:get('x'),cu:get('y'))
              PlayEntityArmature(args[1]._elf_obj,651,671,25)
              local damage = cu.current_weapon:damage_fire(l)
              args[1]:takeDamage(damage)
              print('('..dice..')Hit:'..damage)
            else
              print("("..dice..")Fail")
            end
          else
            print('could not target')
          end
        end
      end
      print(self._current_unit.name,args[1].name,self:visibility(self._current_unit,args[1]))
    end
  end
  -- print("game:track event "..args[1].name)
end

function Game:on_plane(args)
  print("onplane")
  if self._current_unit and self._current_unit:isAlive() then
    local v = GetCollisionPosition(args[1])
    if self._current_unit:canBe(v.x,v.y) then
      local x = v.x-self._current_unit:get('x')
      local y = v.y-self._current_unit:get('y')
      local cost = math.ceil(math.sqrt(x*x+y*y)*10)/10.0
      if cost > self._current_unit._mg then
        cost = self._current_unit._mg
        if cost > 0 then
          local kk = normalize2d({x=x,y=y},self._current_unit._mg)
          v.x = self._current_unit:get('x')+kk.x
          v.y = self._current_unit:get('y')+kk.y
        end
      end
      self._current_unit:seeTo(v.x,v.y)
      local unit = self._current_unit
      if cost > 0 then
        tweener:addTween(self._current_unit,{x=v.x,y=v.y,
          time = cost/8,
          transition = 'linear',
          onComplete=function()
            StopEntityArmature(unit._elf_entity)
            if unit:isAlive() then
              SetEntityArmatureFrame(unit._elf_entity,1)
            end
          end,
          onStart=function()
            LoopEntityArmature(unit._elf_entity,580,595,25)
          end
        })
      end
      self._current_unit._mg = self._current_unit._mg-cost
    end
  end
end

function Game:on_over_object(args)
  if instanceOf(Game,args[1]) then
    if self._current_unit then
      local v = GetCollisionPosition(args[2])
      if self._current_unit:canBe(v.x,v.y) then
        local x = v.x-self._current_unit:get('x')
        local y = v.y-self._current_unit:get('y')
        local cost = math.ceil(math.sqrt(x*x+y*y)*10)/10.0
        self._lab_tooltip:set('Text',''..cost)
        if cost > self._current_unit._mg then
          local kk = normalize2d({x=x,y=y},self._current_unit._mg)
          kk.x = self._current_unit:get('x')+kk.x
          kk.y = self._current_unit:get('y')+kk.y
          self._current_unit:setMax(kk.x,kk.y)
          return false
        end
        self._current_unit:setMax(v.x,v.y)
      else
        self._lab_tooltip:set('Text','')
      end
    end
  elseif instanceOf(Unit,args[1]) then
    if self._current_unit and self._current_unit:isAlive() then
      self._current_unit:setMax(self._current_unit:get('x'),self._current_unit:get('y'))
      if self:enemy_unit(args[1]) then
        local cu = self._current_unit
        local v,l = self:visibility(cu,args[1])
        local s = (cu:calculatedSkill()+cu.current_weapon:skillMod(l))/10
        s = 100*v*s
        if s > 0 then
          local d = cu.current_weapon:damage_range(l)
          self._lab_tooltip:set('Text',math.ceil(l)..'m '..math.ceil(s)..'%,d['..d[1]..'-'..d[2]..']')
        else
          self._lab_tooltip:set('Text',math.ceil(l)..'m '..math.ceil(s)..'%')
        end
      else
        self._lab_tooltip:set('Text','')
      end
    end
  end
end

function Game:on_over(args)
  local col = args[1]
  local actor = GetCollisionActor(col)
  local name = GetActorName(actor)
  local new_current = nil
  if string.match(name,"Plane") then
    new_current = self
  elseif string.match(name,"Unit") then
    new_current = self:findUnit(tonumber(string.match(name,"Unit\.(%d+)")))
  end
  if self._current_over then
    if self._current_over == new_current then
      self:fireEvent("overobject",{self._current_over,col})
      return false
    else
      self._current_over:fireEvent("leave",{self._current_over})
    end
  end
  self._current_over = new_current
  self._current_over:fireEvent("enter",self._current_over)
end

function Game:loadEnvironment()
  self._scene = self._loader:get('env',self.environment).target
  SetScene(self._scene)
  SetSceneAmbientColor(self._scene,0.25,0.25,0.45,1.0)
  self._plane = GetSceneEntity(self._scene,'Plane') 
  local kk = GetActorBoundingLengths(self._plane)
  local ss = GetEntityScale(self._plane)
  self._resolution = { x = ss.x*kk.x, y = ss.y*kk.y }
  return self._scene
end

function Game:loadUnits()
  _.each(self.squadrons,function(i)
    _.each(i.units,function(j)
      j:loadElfObjects(
        self._loader:get('unit', j.faction_name..'/'..j.name_unit).target, self._scene
      )
      j:sets({x=j.position[1]*self:width(),y=j.position[2]*self:height()})
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

function Game:updateStands()
  local current_units = self._round._current_turn._player.squadron.units
  local tmp = _.map(self.squadrons,function(i) return i.units end)
  local all_units = {}
  for i=1, #self.squadrons do
    local squadron = self.squadrons[i]
    for j=1, #squadron.units do
      table.insert(all_units,squadron.units[j])
    end
  end
  _.each(all_units,function(i) i:setStand('enemy') end)
  _.each(current_units,function(i) i:setStand('normal') end)
end

function Game:visibility(from,to)
  local orig = from:seePoint()
  local destinations = to:visibilityPoints()
  orig.x = orig.x+from:get('x')
  orig.y = orig.y+from:get('y')
  local cont = 0
  _.each(destinations,function(i)
    local kk = {x=i.x+to:get('x'),y=i.y+to:get('y'),z=i.z}
    local tmp = from:rayWithoutMe(orig,kk)
    tmp = _.reject(tmp,function(i) 
      local aa = GetActorName(GetCollisionActor(i))
      aa=aa=="Unit."..to.id or aa=="StandMax."..to.id
      return aa
    end)
    if #tmp==0 then cont = cont + 1 end
  end)
  local dest = to:seePoint()
  dest.x = dest.x+to:get('x')
  dest.y = dest.y+to:get('y')
  return cont/#destinations, distance(orig,dest)
end

function Game:start()
  self._gaming = true
  self._round = Round(self,20)
  self._round:addEvent("endturn",function(args)
    if self._current_unit then
      self._current_unit:fireEvent("deselect:unit",self._current_unit)
    end
    self._current_unit = nil
    self._current_unit_panel._unit = nil
    self._current_squadron_panel._units = self._round._current_turn._player.squadron.units
    self:updateStands()
  end)
  self._round:start()
  self:updateStands()
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

