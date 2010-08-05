
function get_object()
  -- don't allow picking through GUI
  if elf.IsObject(elf.GetGuiTrace(gui)) == true then return nil end

  local camera = elf.GetSceneActiveCamera(scn)
  
  -- get the ray starting position
  local raystart = elf.GetActorPosition(camera)

  -- next we calculate the end position of the ray
  local mouse_pos = elf.GetMousePosition()
  local wwidth = elf.GetWindowWidth()
  local wheight = elf.GetWindowHeight()
  local clip = elf.GetCameraClip(camera)
  local fpsize = elf.GetCameraFarPlaneSize(camera)

  local rayend = elf.CreateVec3f()
  rayend.x = mouse_pos.x/wwidth*fpsize.x-fpsize.x/2
  rayend.y = (wheight-mouse_pos.y)/wheight*fpsize.y-fpsize.y/2
  rayend.z = -clip.y

  -- now we have the end position of the ray, but we still have to positon and orient it according to the camera
  local orient = elf.GetActorOrientation(camera)
  rayend = elf.MulQuaVec3f(orient, rayend)
  rayend = elf.AddVec3fVec3f(raystart, rayend)
  -- perform raycast
  local col = elf.GetSceneRayCastResult(scn, raystart.x, raystart.y, raystart.z, rayend.x, rayend.y, rayend.z)
  if elf.IsObject(col) == true then
    return elf.GetCollisionActor(col)
  end

  return nil
end

function user_interaction()

  if imfx then
    -- move the camera WSAD
    if elf.GetKeyState(elf.KEY_W) ~= elf.UP then elf.MoveActorLocal(cam, 0.0, 0.0, -key_move) end
    if elf.GetKeyState(elf.KEY_S) ~= elf.UP then elf.MoveActorLocal(cam, 0.0, 0.0, key_move) end
    if elf.GetKeyState(elf.KEY_A) ~= elf.UP then elf.MoveActorLocal(cam, -key_move, 0.0, 0.0) end
    if elf.GetKeyState(elf.KEY_D) ~= elf.UP then elf.MoveActorLocal(cam, key_move, 0.0, 0.0) end
    -- move camera across
    if elf.GetKeyState(elf.KEY_UP) ~= elf.UP then elf.MoveActorLocal(cam, 0.0, key_move, 0.0) end
    if elf.GetKeyState(elf.KEY_DOWN) ~= elf.UP then elf.MoveActorLocal(cam, 0.0, -key_move, 0.0) end
    if elf.GetKeyState(elf.KEY_LEFT) ~= elf.UP then elf.MoveActorLocal(cam, -key_move, 0.0, 0.0) end
    if elf.GetKeyState(elf.KEY_RIGHT) ~= elf.UP then elf.MoveActorLocal(cam, key_move, 0.0, 0.0) end

    -- rotate the camera when space is pressed
    if elf.GetKeyState(elf.KEY_SPACE) ~= elf.UP then
      elf.HideMouse(true)
      mf = elf.GetMouseForce()
      imfx = (imfx*3.0+mf.x)/4.0
      imfy = (imfy*3.0+mf.y)/4.0
      elf.RotateActorLocal(cam, -imfy*10.0, 0.0, 0.0)
      elf.RotateActor(cam, 0.0, 0.0, -imfx*10.0)
      -- center the mouse to allow continuous panning
      elf.SetMousePosition(elf.GetWindowWidth()/2, elf.GetWindowHeight()/2)
    else
      elf.HideMouse(false)
    end
    -- take a screen shot with key X
    if elf.GetKeyState(elf.KEY_X) == elf.PRESSED then elf.SaveScreenShot("screenshot.jpg") end
    -- exit with key ESC
    if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end
  else
    -- declare mouse rotation interpolation values
    imfx = 0.0
    imfy = 0.0

    -- movement with the keyboard
    key_move = 5.0
  end
end

-- load level, set window title and hide mouse
scn = elf.LoadScene("demo.pak")
elf.SetTitle("BlendELF Hello, World?")
elf.HideMouse(false)

-- set some bloom
elf.SetBloom(0.35)

-- elf.SetDebugDraw( true )

-- create and set a gui
gui = elf.CreateGui()
elf.SetGui(gui)

-- add the elf logo to the gui
tex = elf.CreateTextureFromFile("resources/elf.png")
pic = elf.CreatePicture("ELFLogo")
elf.SetPictureTexture(pic, tex)
elf.AddGuiObject(gui, pic)
size = elf.GetGuiObjectSize(pic)
elf.SetGuiObjectPosition(pic, elf.GetWindowWidth()-size.x, 0)

-- add fps display
font = elf.CreateFontFromFile("resources/freesans.ttf", 14)
fpslab = elf.CreateLabel("FPSLabel")
elf.SetLabelFont(fpslab, font)
elf.SetLabelText(fpslab, "FPS: ")
elf.SetGuiObjectPosition(fpslab, 10, 10)
elf.AddGuiObject(gui, fpslab)

-- add over label
over = elf.CreateLabel("Over")
elf.SetLabelFont(over, font)
elf.SetLabelText(over, "Object over: ")
elf.SetGuiObjectPosition(over, 10, 30)
elf.AddGuiObject(gui, over)

-- get the camera for camera movement
cam = elf.GetSceneActiveCamera(scn)

-- set camera to detect objects
if elf.IsObject(cam) == true then
  local fov = elf.GetCameraFov(cam)
  local aspect = elf.GetCameraAspect(cam)
  local clip = elf.GetCameraClip(cam)
  if clip.x < 0.0001 then clip.x = 0.0001 end
  if clip.y < 100.0 then clip.y = 100.0 end
  elf.SetCameraPerspective(cam, fov, aspect, clip.x, clip.y)
end

while elf.Run() == true do
  -- update the fps display
  elf.SetLabelText(fpslab, "FPS: " .. elf.GetFps())

  -- make move with keyboard or mouse
  user_interaction()
  
  -- detect objects over mouse
  obj = get_object()
  if obj == nil then
    elf.SetLabelText(over, "Object over: nil")
  else
    elf.SetLabelText(over, "Object over: " .. elf.GetActorName(obj))
  end
end

