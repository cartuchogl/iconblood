DebugPanel = class('DebugPanel', ElfObject)

function DebugPanel:initialize(parent,font)
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  super.initialize(self,SCREEN,'DebugPanel', {
    Texture = game._loader:get('img',"gui_bg.png").target,
    Size = {250+16,220},
    Position = {16,72},
    Color = {1,1,1,0.8},
    parent = parent
  })
  
  -- tracked info, in lua all are tables
  self._functions = {
    function() return(GetTitle()) end,
    function() return(GetVersion() .. " on " .. GetPlatform()) end,
    function() return("FPS: " .. GetFps()) end,
    function() return("Resolution:" .. GetWindowWidth() .. 'x' .. GetWindowHeight()) end,
    function() return("Time: " .. (math.floor(GetTime()*10)/10)) end,
    function() 
      return("Mouse Position: " .. GetMousePosition().x .. 'x' .. GetMousePosition().y) 
    end,
    function() return("Mouse Force: " .. GetMouseForce().x ..'x'.. GetMouseForce().y) end,
    function() return("Mouse Wheel: " .. GetMouseWheel()) end,
    function() return("Scene Camera Count: " .. GetSceneCameraCount( self._scene )) end,
    function() return("Scene Entity Count: " .. GetSceneEntityCount( self._scene )) end,
    function() return("Scene Light Count: " .. GetSceneLightCount( self._scene )) end,
--    function() return("Scene Armature Count: " .. GetSceneArmatureCount( self._scene )) end,
    function() return("Scene Particles Count: " .. GetSceneParticlesCount( self._scene )) end,
    function() return("Scene Sprite Count: " .. GetSceneSpriteCount( self._scene )) end,
  }
  -- self._debug_scene = CreateSceneFromFile("../resources/debug/scene.pak")
  self._track_count = 0
  self._tracked_points = {}
  
  -- create text list for text
  self._txt = ElfObject(TEXT_LIST,'TXTlist',{
    Font=font, Position={8,8}, Visible=false, Size={#self._functions, 250}, parent=self
  })
end

function DebugPanel:update()
  -- update info
  RemoveTextListItems( self._txt._elf_obj )
  if self._active then
    for i,v in ipairs(self._functions) do
      AddTextListItem(self._txt._elf_obj, v() )
    end
  end
end

function DebugPanel:on(scene)
  self._scene = scene
  self._active = true
  self._txt:set('Visible',true)
end

function DebugPanel:off()
  self._active = false
  self._txt:set('Visible',false)
end

function DebugPanel:trackPoint(scene,v,...)
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
