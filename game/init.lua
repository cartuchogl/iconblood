print("compile dependencies...")
dofile("includes.lua")

local ctime = elf.GetTime()
print(ctime.."sg")

elf.SetTitle("iconblood alpha1")

dofile("example.ibg.lua")

print("Init...")
elf.SetFpsLimit(50)

-- create and set a gui
gui = elf.CreateGui()
elf.SetGui(gui)

-- load assets
print("loading assets")
ctime = elf.GetTime()

font = elf.CreateFontFromFile("../resources/freemono.ttf", 14)
font18 = elf.CreateFontFromFile("../resources/freemono.ttf", 20)
lod_text = elf.CreateTextureFromFile("../resources/rect2816.png")
turn_bg = elf.CreateTextureFromFile("../resources/rect2817.png")
text_field400 = elf.CreateTextureFromFile("../resources/text_field400.png")
exbtexoff = elf.CreateTextureFromFile("../resources/execute.png") 
exbtexover = elf.CreateTextureFromFile("../resources/execute_over.png") 
exbtexon = elf.CreateTextureFromFile("../resources/execute_on.png")
endturnoff = elf.CreateTextureFromFile("../resources/end_turn.png")
endturnover = elf.CreateTextureFromFile("../resources/end_turn_over.png")
endturnon = elf.CreateTextureFromFile("../resources/end_turn_on.png")
currentbg = elf.CreateTextureFromFile("../resources/current_bg.png")

print((elf.GetTime()-ctime).."sg")
ctime = elf.GetTime()
print('building gui')
main_nav = GuiObject(elf.SCREEN,"edit_menu",{
  Texture = {lod_text},
  Visible = {true},
  Color = {1.0, 1.0, 1.0, 0.95},
  Position = {
    (elf.GetWindowWidth()-elf.GetTextureWidth(lod_text))/2, 
    elf.GetWindowHeight()-elf.GetTextureHeight(lod_text)
  }
})
main_nav:addTo(gui)

text_field = GuiObject(elf.TEXT_FIELD,"Input",{
  Texture = {text_field400},
  Offset = {3, 2},
  Font = {font},
  Position = {0, 0}
})
text_field:set('Text', "debug:on()")
text_field:addTo(main_nav)

-- add execute button 
pos = text_field:position()
exscr = elf.CreateScript('script1') 
elf.SetScriptText(exscr, "elf.RunString(text_field:get('Text'))")

exb = GuiObject(elf.BUTTON,"ExecuteBtn",{
  OffTexture = {exbtexoff},
  OverTexture = {exbtexover},
  OnTexture = {exbtexon},
  Position = {pos.x+text_field:size().x+4, pos.y},
  Script = {exscr}
})
exb:addTo(main_nav)

lab_tooltip = GuiObject(elf.LABEL,"lab_tooltip",{Font = {font18},Position = {270,10},Text = {''}})
lab_tooltip:addTo(gui)

imfx = 0.0
imfy = 0.0

-- movement with the keyboard
key_move = 12.0
print((elf.GetTime()-ctime).."sg")
ctime = elf.GetTime()
game = Game(_local_game,gui,currentbg,font,nil)
scene = game:loadEnvironment()
print((elf.GetTime()-ctime).."sg")
ctime = elf.GetTime()
game:loadUnits()
print((elf.GetTime()-ctime).."sg")
ctime = elf.GetTime()
print('going to scene...')
elf.SetSceneAmbientColor(scene,0.25,0.25,0.45,1.0)

-- get the camera for camera movement
cam = elf.GetSceneActiveCamera(scene)

-- set camera to detect objects
set_camera(cam)

debug = Debug(gui,scene)

game:start()

turn_panel = TurnPanel(gui,turn_bg,font,endturnoff,endturnover,endturnon,game._round)

last_wheel = 0

cam_dir = elf.CreateVec3f()
cam_dir.z = -1000.0

-- for cool anims ;)
tweener = Tweener()

print((elf.GetTime()-ctime).."sg")
print("Total time to first render "..elf.GetTime().."sg")

while elf.Run() == true and game:running() do
  debug:update()
  local pos = elf.GetMousePosition()
  
  lab_tooltip:set('Position',pos.x-24,pos.y-24)
  game:update()
  turn_panel:update()

  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end
  
  local wheel = elf.GetMouseWheel()
  elf.MoveActorLocal(cam, 0.0, 0.0, (last_wheel-wheel)*key_move*4)
  last_wheel = wheel
  
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
    if pos.x == 0 then elf.MoveActorLocal(cam, -key_move, 0.0, 0.0) end
    if pos.x == elf.GetWindowWidth()-1 then elf.MoveActorLocal(cam, key_move, 0.0, 0.0) end
    if pos.y == 0 then elf.MoveActor(cam, dir.x, dir.y, 0.0) end
    if pos.y == elf.GetWindowHeight()-1 then elf.MoveActor(cam, -dir.x, -dir.y, 0.0) end
  end

  -- rotate the camera
  if elf.GetMouseButtonState(2) == elf.DOWN then
    mf = elf.GetMouseForce()
    imfx = (imfx*2.0+mf.x)/4.0
    elf.RotateActor(cam, 0.0, 0.0, -imfx*10.0)
  end

  -- save a screenshot on F5
  if elf.GetKeyState(elf.KEY_F5) == elf.PRESSED then
    if elf.SaveScreenShot("screenshot.png") == true then
      print("screen shot saved to " .. elf.GetCurrentDirectory() .. "/screenshot.png")
    end
  end
  
  
  if elf.IsObject(elf.GetGuiTrace(gui)) == false then
    local objs = get_objects_over_mouse(game._scene)
    if objs ~= nil then
      if elf.GetMouseButtonState(elf.BUTTON_LEFT) == elf.PRESSED then
        local capture = false
        local names = _.map(objs,function(i) return(elf.GetActorName(elf.GetCollisionActor(i))) end)
        local units = _.select(names,function(i) return string.match(i,"Unit\.(%d+)") end)
        if _.first(units) then
          local unit = game:findUnit(tonumber(string.match(_.first(units),"Unit\.(%d+)")))
          if unit then
            capture = true
            game:fireEvent('selected:unit',{unit},0)
          end
        end
        if capture == false then
          names = _.map(objs,function(i) 
            local a = elf.GetCollisionActor(i)
            return({elf.GetActorName(a),a,i}) 
          end)
          local plane = _.select(names,function(i) return string.match(i[1],"Plane") end)[1]
          if plane then
            game:fireEvent("onplane",{plane[3]},0)
          end
        end
      else
        names = _.map(objs,function(i) 
          local a = elf.GetCollisionActor(i)
          return({elf.GetActorName(a),a,i}) 
        end)
        local obj = _.select(names,function(i) return string.match(i[1],"Plane") or string.match(i[1],"Unit") end)[1]
        if obj then
          game:fireEvent("over",{obj[3]},0)
        end
      end
    end
  end
  -- for setTimeout
  setTimeoutLaunch()
end

if game:running() then game:stop() end

-- end of file
