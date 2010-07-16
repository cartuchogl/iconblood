dofile("src/underscore.lua")
_ = Underscore.funcs
dofile("src/MiddleClass.lua")
dofile("src/event.lua")
dofile("src/game.lua")
dofile("src/unit.lua")
dofile("src/squadron.lua")
dofile("src/option.lua")
dofile("src/player.lua")
dofile("src/round.lua")
dofile("src/turn.lua")
dofile("src/debug.lua")
dofile("src/functions.lua")
dofile("src/gui_object.lua")

elf.SetTitle("iconblood alpha1")

dofile("example.ibg.lua")

print("Init...")

elf.SetFpsLimit(50)

-- create and set a gui
gui = elf.CreateGui()
elf.SetGui(gui)

main_nav = GuiObject(elf.CreateScreen("edit_menu"))

main_nav:set('Texture',elf.CreateTextureFromFile("../resources/background_v.png"))
main_nav:set_visible(true)
main_nav:set_color(1.0, 1.0, 1.0, 0.95)
main_nav:set_position((elf.GetWindowWidth()-main_nav:size().x)/2, elf.GetWindowHeight()-main_nav:size().y)
main_nav:addTo(gui)

font = elf.CreateFontFromFile("../resources/freemono.ttf", 14)

text_field = GuiObject(elf.CreateTextField("Input"))
text_field:set('Texture', elf.CreateTextureFromFile("../resources/text_field400.png"))
text_field:set('Offset', 3, 2)
text_field:set('Font', font)
text_field:set('Text', 'debug:on()')
text_field:set_position(10, main_nav:size().y-text_field:size().y-20)
text_field:addTo(main_nav)

-- add execute button 
exbtexoff = elf.CreateTextureFromFile("../resources/execute.png") 
exbtexover = elf.CreateTextureFromFile("../resources/execute_over.png") 
exbtexon = elf.CreateTextureFromFile("../resources/execute_on.png") 

exb = GuiObject(elf.CreateButton("ExecuteBtn"))
exb:set('OffTexture', exbtexoff)
exb:set('OverTexture', exbtexover)
exb:set('OnTexture', exbtexon)
pos = text_field:position()
exb:set_position(pos.x+text_field:size().x+4, pos.y) 
exscr = elf.CreateScript('script1') 
elf.SetScriptText(exscr, "elf.RunString(text_field:get('Text'))") 
exb:set_script(exscr) 
exb:addTo(main_nav)

lab1 = GuiObject(elf.CreateLabel("label1"))
lab1:set('Font', font)
lab1:set('Text', 'current selection:')
lab1:set_position(10,10)
lab1:addTo(main_nav)

imfx = 0.0
imfy = 0.0

-- movement with the keyboard
key_move = 12.0

game = Game(_local_game)
scene = game:loadEnvironment()
game:loadUnits()

elf.SetSceneAmbientColor(scene,0.25,0.25,0.45,1.0)

-- get the camera for camera movement
cam = elf.GetSceneActiveCamera(scene)

-- set camera to detect objects
if elf.IsObject(cam) == true then
  local fov = elf.GetCameraFov(cam)
  local aspect = elf.GetCameraAspect(cam)
  local clip = elf.GetCameraClip(cam)
  if clip.x < 0.0001 then clip.x = 0.0001 end
  if clip.y < 100.0 then clip.y = 100.0 end
  elf.SetCameraPerspective(cam, fov, aspect, clip.x, clip.y)
end

debug = Debug(gui,scene)

game:start()

last_wheel = 0

cam_dir = elf.CreateVec3f()
cam_dir.z = -1000.0
while elf.Run() == true and game:running() do
  debug:update()

  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end
  
  local wheel = elf.GetMouseWheel()
  elf.MoveActorLocal(cam, 0.0, 0.0, (last_wheel-wheel)*key_move*4)
  last_wheel = wheel
  
  -- vars for camera moves
  -- TODO: move to an object
  local d = elf.GetActorOrientation(cam)
  local orient = elf.GetActorOrientation(cam)
  local dir = elf.MulQuaVec3f(orient, cam_dir)
  local dir = normalize(dir, key_move)
  -- move camera across
  if elf.GetKeyState(elf.KEY_UP) ~= elf.UP then elf.MoveActor(cam, dir.x, dir.y, 0.0) end
  if elf.GetKeyState(elf.KEY_DOWN) ~= elf.UP then elf.MoveActor(cam, -dir.x, -dir.y, 0.0) end
  if elf.GetKeyState(elf.KEY_LEFT) ~= elf.UP then elf.MoveActorLocal(cam, -key_move, 0.0, 0.0) end
  if elf.GetKeyState(elf.KEY_RIGHT) ~= elf.UP then elf.MoveActorLocal(cam, key_move, 0.0, 0.0) end
  -- move with borders on fullscreen
  if elf.IsFullscreen() then
    local pos = elf.GetMousePosition()
    if pos.x == 0 then elf.MoveActorLocal(cam, -key_move, 0.0, 0.0) end
    if pos.x == elf.GetWindowWidth()-1 then elf.MoveActorLocal(cam, key_move, 0.0, 0.0) end
    if pos.y == 0 then elf.MoveActor(cam, dir.x, dir.y, 0.0) end
    if pos.y == elf.GetWindowHeight()-1 then elf.MoveActor(cam, -dir.x, -dir.y, 0.0) end
  end

  -- rotate the camera
  if elf.GetMouseButtonState(2) == elf.DOWN then
    mf = elf.GetMouseForce()
    imfx = (imfx*2.0+mf.x)/4.0
    imfy = (imfy*2.0+mf.y)/4.0
    elf.RotateActor(cam, 0.0, 0.0, -imfx*10.0)
  end

  -- save a screenshot on F5
  if elf.GetKeyState(elf.KEY_F5) == elf.PRESSED then
    if elf.SaveScreenShot("screenshot.png") == true then
      print("screen shot saved to " .. elf.GetCurrentDirectory() .. "/screenshot.png")
    end
  end
  
  if elf.GetMouseButtonState(elf.BUTTON_LEFT) == elf.PRESSED then
    local objs = get_objects_over_mouse(game._scene)
    if objs ~= nil then
      print("==collision")
      _.each(objs,function(i) print(elf.GetActorName(elf.GetCollisionActor(i))) end)
    end
  end
end

if game:running() then game:stop() end

-- end of file
