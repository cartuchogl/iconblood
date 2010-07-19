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

-- load assets
font = elf.CreateFontFromFile("../resources/freemono.ttf", 14)
lod_text = elf.CreateTextureFromFile("../resources/rect2816.png")
text_field400 = elf.CreateTextureFromFile("../resources/text_field400.png")
exbtexoff = elf.CreateTextureFromFile("../resources/execute.png") 
exbtexover = elf.CreateTextureFromFile("../resources/execute_over.png") 
exbtexon = elf.CreateTextureFromFile("../resources/execute_on.png")

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
  Position = {254, main_nav:size().y-elf.GetTextureHeight(text_field400)-24}
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

lab_exp = GuiObject(elf.LABEL,"lab_exp",{Font = {font},Position = {270,10},Text = {'exp:'}})
lab_exp:addTo(main_nav)
lab_level = GuiObject(elf.LABEL,"lab_level",{Font = {font},Position = {270,25},Text = {'level:'}})
lab_level:addTo(main_nav)
lab_name = GuiObject(elf.LABEL,"lab_name",{Font = {font},Position = {270,40},Text = {'name:'}})
lab_name:addTo(main_nav)
lab_cost = GuiObject(elf.LABEL,"lab_cost",{Font = {font},Position = {270,55},Text = {'cost:'}})
lab_cost:addTo(main_nav)
lab_move = GuiObject(elf.LABEL,"lab_move",{Font = {font},Position = {270,70},Text = {'move:'}})
lab_move:addTo(main_nav)
lab_force = GuiObject(elf.LABEL,"lab_force",{Font = {font},Position = {270,85},Text = {'force:'}})
lab_force:addTo(main_nav)
lab_skill = GuiObject(elf.LABEL,"lab_skill",{Font = {font},Position = {270,100},Text = {'skill:'}})
lab_skill:addTo(main_nav)
lab_resistance = GuiObject(elf.LABEL,"lab_resistance",{Font = {font},Position = {270,115},Text = {'resistance:'}})
lab_resistance:addTo(main_nav)


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
debug:trackPoint({x=1,y=0,z=0})
debug:trackPoint({x=0,y=1,z=0},'Cube.001')
debug:trackPoint({x=0,y=0,z=1},'Cube.002')

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
  
  
  if elf.IsObject(elf.GetGuiTrace(gui)) == false then
    local objs = get_objects_over_mouse(game._scene)
    if objs ~= nil then
      if elf.GetMouseButtonState(elf.BUTTON_LEFT) == elf.PRESSED then
        local capture = false
        -- print("==collision")
        local names = _.map(objs,function(i) return(elf.GetActorName(elf.GetCollisionActor(i))) end)
        -- _.each(names,function(i) print(i) end)
        local units = _.select(names,function(i) return string.match(i,"Unit\.(%d+)") end)
        if _.first(units) then
          local unit = game:findUnit(tonumber(string.match(_.first(units),"Unit\.(%d+)")))
          if unit then
            capture = true
            game:fireEvent('selected:unit',{unit},0)
            lab_exp:set('Text','exp: '..unit.exp)
            lab_level:set('Text','level: '..unit.level)
            lab_name:set('Text','name: '..unit.name)
            lab_cost:set('Text','cost: '..unit.cost)
            lab_move:set('Text','move: '..unit.move)
            lab_force:set('Text','force: '..unit.force)
            lab_skill:set('Text','skill: '..unit.skill)
            lab_resistance:set('Text','resistance: '..unit.resistance)
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
        
      end
    end
  end
end

if game:running() then game:stop() end

-- end of file
