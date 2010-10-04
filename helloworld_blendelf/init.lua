
function get_object()
  -- don't allow picking through GUI
  if GetGuiTrace(gui) ~= nil then return nil end

  local camera = GetSceneActiveCamera(scn)
  
  -- get the ray starting position
  local raystart = GetActorPosition(camera)

  -- next we calculate the end position of the ray
  local mouse_pos = GetMousePosition()
  local wwidth = GetWindowWidth()
  local wheight = GetWindowHeight()
  local clip = GetCameraClip(camera)
  local fpsize = GetCameraFarPlaneSize(camera)

  local rayend = CreateVec3f(0,0,0)
  rayend.x = mouse_pos.x/wwidth*fpsize.x-fpsize.x/2
  rayend.y = (wheight-mouse_pos.y)/wheight*fpsize.y-fpsize.y/2
  rayend.z = -clip.y

  -- now we have the end position of the ray, but we still have to positon and orient it according to the camera
  local orient = GetActorOrientation(camera)
  rayend = MulQuaVec3f(orient, rayend)
  rayend = AddVec3fVec3f(raystart, rayend)
  -- perform raycast
  local col = GetSceneRayCastResult(scn, raystart.x, raystart.y, raystart.z, rayend.x, rayend.y, rayend.z)
  if col ~= nil then
    return GetCollisionActor(col)
  end

  return nil
end

function user_interaction()

  if imfx then
    -- move the camera WSAD
    if GetKeyState(KEY_W) ~= UP then MoveActorLocal(cam, 0.0, 0.0, -key_move) end
    if GetKeyState(KEY_S) ~= UP then MoveActorLocal(cam, 0.0, 0.0, key_move) end
    if GetKeyState(KEY_A) ~= UP then MoveActorLocal(cam, -key_move, 0.0, 0.0) end
    if GetKeyState(KEY_D) ~= UP then MoveActorLocal(cam, key_move, 0.0, 0.0) end
    -- move camera across
    if GetKeyState(KEY_UP) ~= UP then MoveActorLocal(cam, 0.0, key_move, 0.0) end
    if GetKeyState(KEY_DOWN) ~= UP then MoveActorLocal(cam, 0.0, -key_move, 0.0) end
    if GetKeyState(KEY_LEFT) ~= UP then MoveActorLocal(cam, -key_move, 0.0, 0.0) end
    if GetKeyState(KEY_RIGHT) ~= UP then MoveActorLocal(cam, key_move, 0.0, 0.0) end

    -- rotate the camera when space is pressed
    if GetKeyState(KEY_SPACE) ~= UP then
      HideMouse(true)
      mf = GetMouseForce()
      imfx = (imfx*3.0+mf.x)/4.0
      imfy = (imfy*3.0+mf.y)/4.0
      RotateActorLocal(cam, -imfy*10.0, 0.0, 0.0)
      RotateActor(cam, 0.0, 0.0, -imfx*10.0)
      -- center the mouse to allow continuous panning
      SetMousePosition(GetWindowWidth()/2, GetWindowHeight()/2)
    else
      HideMouse(false)
    end
    -- take a screen shot with key X
    if GetKeyState(KEY_X) == PRESSED then SaveScreenShot("screenshot.jpg") end
    -- exit with key ESC
    if GetKeyState(KEY_ESC) == PRESSED then Quit() end
  else
    -- declare mouse rotation interpolation values
    imfx = 0.0
    imfy = 0.0

    -- movement with the keyboard
    key_move = 5.0
  end
end

-- load level, set window title and hide mouse
scn = LoadScene("demo.pak")
SetTitle("BlendELF Hello, World?")
HideMouse(false)

-- set some bloom
SetBloom(0.35)

-- elf.SetDebugDraw( true )

-- create and set a gui
gui = CreateGui()
SetGui(gui)

-- add the elf logo to the gui
tex = CreateTextureFromFile("resources/elf.png")
pic = CreatePicture("ELFLogo")
SetPictureTexture(pic, tex)
AddGuiObject(gui, pic)
size = GetGuiObjectSize(pic)
SetGuiObjectPosition(pic, GetWindowWidth()-size.x, 0)

-- add fps display
font = CreateFontFromFile("resources/freesans.ttf", 14)
fpslab = CreateLabel("FPSLabel")
SetLabelFont(fpslab, font)
SetLabelText(fpslab, "FPS: ")
SetGuiObjectPosition(fpslab, 10, 10)
AddGuiObject(gui, fpslab)

-- add over label
over = CreateLabel("Over")
SetLabelFont(over, font)
SetLabelText(over, "Object over: ")
SetGuiObjectPosition(over, 10, 30)
AddGuiObject(gui, over)

-- get the camera for camera movement
cam = GetSceneActiveCamera(scn)

-- set camera to detect objects
if IsActor(cam) == true then
  local fov = GetCameraFov(cam)
  local aspect = GetCameraAspect(cam)
  local clip = GetCameraClip(cam)
  if clip.x < 0.0001 then clip.x = 0.0001 end
  if clip.y < 100.0 then clip.y = 100.0 end
  SetCameraPerspective(cam, fov, aspect, clip.x, clip.y)
end

while Run() == true do
  -- update the fps display
  SetLabelText(fpslab, "FPS: " .. GetFps())

  -- make move with keyboard or mouse
  user_interaction()
  
  -- detect objects over mouse
  obj = get_object()
  if obj == nil then
    SetLabelText(over, "Object over: nil")
  else
    SetLabelText(over, "Object over: " .. GetActorName(obj))
  end
end

