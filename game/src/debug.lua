Debug = class('Debug')

function Debug:initialize(gui)
  -- tracked info, in lua all are tables
  self._functions = {
    function() return("FPS: " .. GetFps()) end,
    function() return("Resolution:" .. GetWindowWidth() .. 'x' .. GetWindowHeight()) end,
    function() return("GetTitle: " .. GetTitle()) end,
    function() return("GetTime: " .. GetTime()) end,
    function() 
      return("GetMousePosition: " .. GetMousePosition().x .. 'x' .. GetMousePosition().y) 
    end,
    function() return("GetMouseForce: " .. GetMouseForce().x ..'x'.. GetMouseForce().y) end,
    function() return("GetMouseWheel: " .. GetMouseWheel()) end,
    function() return("GetSceneCameraCount: " .. GetSceneCameraCount( self._scene )) end,
    function() return("GetSceneEntityCount: " .. GetSceneEntityCount( self._scene )) end,
    function() return("GetSceneLightCount: " .. GetSceneLightCount( self._scene )) end,
    function() return("GetSceneArmatureCount: " .. GetSceneArmatureCount( self._scene )) end,
    function() return("GetSceneParticlesCount: " .. GetSceneParticlesCount( self._scene )) end,
    function() return("GetSceneSpriteCount: " .. GetSceneSpriteCount( self._scene )) end
  }
  -- self._debug_scene = CreateSceneFromFile("../resources/debug/scene.pak")
  self._track_count = 0
  self._tracked_points = {}
  
  -- create text list for text
  self._txt = ElfObject(TEXT_LIST,'TXTlist',{
    Font=loader._default_font, Position={8,16}, Visible=false, Size={#self._functions, 250}, parent=gui
  })
end

function Debug:update()
  -- update info
  RemoveTextListItems( self._txt._elf_obj )
  if self._active then
    for i,v in ipairs(self._functions) do
      AddTextListItem(self._txt._elf_obj, v() )
    end
  end
end

function Debug:on(scene)
  self._scene = scene
  self._active = true
  self._txt:set('Visible',true)
end

function Debug:off()
  self._active = false
  self._txt:set('Visible',false)
end

function Debug:trackPoint(scene,v,...)
  local name = "Cube"
  if #arg>0 then
    name = arg[1]
  end
  self._track_count = self._track_count+1
  local new_point = duplicate_entity(GetSceneEntity(self._debug_scene, name),
  "Cube."..self._track_count)
  SetActorPosition(new_point,v.x,v.y,v.z)
  AddEntityToScene(scene,new_point)
  table.insert(self._tracked_points,new_point)
  return new_point
end
