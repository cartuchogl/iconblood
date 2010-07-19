Debug = class('Debug')

function Debug:initialize(gui,scene)
  -- tracked info, in lua all are tables
  self._functions = {
    function() return("FPS: " .. elf.GetFps()) end,
    function() return("Resolution:" .. elf.GetWindowWidth() .. 'x' .. elf.GetWindowHeight()) end,
    function() return("IsFullscreen: " .. (elf.IsFullscreen() and "true" or "false")) end,
    function() return("GetTitle: " .. elf.GetTitle()) end,
    function() return("GetMultisamples: " .. elf.GetMultisamples()) end,
    function() return("GetTime: " .. elf.GetTime()) end,
    function() return("IsWindowOpened: " .. (elf.IsWindowOpened() and "true" or "false")) end,
    function() return("IsOcclusionCulling: " .. (elf.IsOcclusionCulling() and "true" or "false")) end,
    function() 
      return("GetMousePosition: " .. elf.GetMousePosition().x .. 'x' .. elf.GetMousePosition().y) 
    end,
    function() return("GetMouseForce: " .. elf.GetMouseForce().x ..'x'.. elf.GetMouseForce().y) end,
    function() return("IsMouseHidden: " .. (elf.IsMouseHidden() and "true" or "false")) end,
    function() return("GetMouseWheel: " .. elf.GetMouseWheel()) end,
    function() return("GetMouseButtonState L: " .. elf.GetMouseButtonState(elf.BUTTON_LEFT)) end,
    function() return("GetMouseButtonState M: " .. elf.GetMouseButtonState(elf.BUTTON_MIDDLE)) end,
    function() return("GetMouseButtonState R: " .. elf.GetMouseButtonState(elf.BUTTON_RIGHT)) end,
    function() return("GetKeyState G: " .. elf.GetKeyState(elf.KEY_G)) end,
    function() return("GetKeyState H: " .. elf.GetKeyState(elf.KEY_H)) end,
    function() return("GetEventCount: " .. elf.GetEventCount()) end,
    function() return("GetSceneCameraCount: " .. elf.GetSceneCameraCount( self._scene )) end,
    function() return("GetSceneEntityCount: " .. elf.GetSceneEntityCount( self._scene )) end,
    function() return("GetSceneLightCount: " .. elf.GetSceneLightCount( self._scene )) end,
    function() return("GetSceneArmatureCount: " .. elf.GetSceneArmatureCount( self._scene )) end,
    function() return("GetSceneParticlesCount: " .. elf.GetSceneParticlesCount( self._scene )) end,
    function() return("GetSceneSpriteCount: " .. elf.GetSceneSpriteCount( self._scene )) end
  }
  self._scene = scene
  self._debug_scene = elf.CreateSceneFromFile("../resources/debug/scene.pak")
  self._track_count = 0
  self._tracked_points = {}
  
  -- create text list for text
  local txt = elf.CreateTextList("TXTlist")
  elf.SetTextListFont(txt,font)
  elf.SetTextListSize(txt, #self._functions, 300)
  elf.SetGuiObjectPosition(txt, 8, 8)
  elf.SetGuiObjectVisible(txt, false)
  elf.AddGuiObject(gui, txt)
  self._txt = txt
end

function Debug:update()
  -- update info
  elf.RemoveTextListItems( self._txt )
  if self._active then
    for i,v in ipairs(self._functions) do
      elf.AddTextListItem(self._txt, v() )
    end
  end
end

function Debug:on()
  self._active = true
  elf.SetGuiObjectVisible(self._txt, true)
end

function Debug:off()
  self._active = false
  elf.SetGuiObjectVisible(self._txt, false)
end

function Debug:trackPoint(v,...)
  local name = "Cube"
  if #arg>0 then
    name = arg[1]
  end
  self._track_count = self._track_count+1
  local new_point = duplicate_entity(elf.GetEntityByName(self._debug_scene, name),"Cube."..self._track_count)
  elf.SetActorPosition(new_point,v.x,v.y,v.z)
  elf.AddEntityToScene(self._scene,new_point)
  table.insert(self._tracked_points,new_point)
end