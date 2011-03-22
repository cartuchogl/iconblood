BaseGame = class('BaseGame')
BaseGame:includes(EventDispatcher)

function BaseGame:initialize(gui,loader)
  self._gui = gui
  self._gaming = false
  self._gui_pull = {}
  self._loader = loader
  self._loader:addEvent('endbatch',_.curry(self.on_loader_end,self))
  self:addEvent('onframe', _.curry(self.on_frame,self))
end

function BaseGame:update()

end

function BaseGame:on_frame(args)
  self:interaction()
  -- save a screenshot on F5
  if GetKeyState(KEY_F5) == PRESSED then
    local name = "screens/screenshot-"..os.time()..".png"
    if SaveScreenShot(name) == true then
      print("screen shot saved to " .. GetCurrentDirectory() .. "/"..name)
    end
  end
  self:update()
end

function BaseGame:interaction()
  local pos = GetMousePosition()
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
    if self._scene then
      local objs = get_objects_over_mouse(self._scene)
      if #objs > 0 then
        local names = _.map(objs,function(i) 
          return(GetActorName(GetCollisionActor(i)))
        end)
        -- made anything with that
        _.each(names, function(i) print(i) end)
      end
    end
  end
end

function BaseGame:on_loader_end(args)
  setTimeout(function() self._loader._loader_gui:set('Visible',false) end,100)
  -- get the camera for camera movement
  if self._scene then
    self._cam = GetSceneActiveCamera(self._scene)
    -- set camera to detect objects
    set_camera(self._cam)
  end
  
  Message:init(self._gui,self._loader_default_font)
end

function BaseGame:start()
  self._gaming = true
end

function BaseGame:stop()
  self._gaming = false
end

function BaseGame:running()
  return self._gaming
end


