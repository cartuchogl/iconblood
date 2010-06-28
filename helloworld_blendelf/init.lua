
-- load level, set window title and hide mouse
scn = elf.LoadScene("demo.pak")
elf.SetTitle("BlendELF Hello, World?")
elf.HideMouse(false)

-- set some bloom and declare mouse rotation interpolation values
elf.SetBloom(0.35)
imfx = 0.0
imfy = 0.0

-- movement with the keyboard
key_move = 6.0

-- elf.SetDebugDraw( true )

-- create and set a gui
gui = elf.CreateGui()
elf.SetGui(gui)

-- add the elf logo to the gui
tex = elf.CreateTextureFromFile("resources/elf.png")
pic = elf.CreatePicture("ELFLogo")
elf.SetPictureTexture(pic, tex)

exscr = elf.CreateScript()
elf.SetScriptText(exscr, "elf.Quit()")
elf.SetGuiObjectScript(pic, exscr)
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

-- get the camera for camera movement
cam = elf.GetSceneActiveCamera(scn)

while elf.Run() == true do
  -- update the fps display
  elf.SetLabelText(fpslab, "FPS: " .. elf.GetFps())

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
    mf = elf.GetMouseForce()
    imfx = (imfx*3.0+mf.x)/4.0
    imfy = (imfy*3.0+mf.y)/4.0
    elf.RotateActorLocal(cam, -imfy*10.0, 0.0, 0.0)
    elf.RotateActor(cam, 0.0, 0.0, -imfx*10.0)
  end	
  -- take a screen shot with key X
  if elf.GetKeyState(elf.KEY_X) == elf.PRESSED then elf.SaveScreenShot("screenshot.jpg") end
  -- exit with key ESC
  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end
end

