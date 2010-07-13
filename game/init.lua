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

elf.SetTitle("iconblood alpha1")

dofile("example.ibg.lua")

print("Init...")

elf.SetFpsLimit(50)

-- create and set a gui
gui = elf.CreateGui()
elf.SetGui(gui)

handle = elf.CreateScreen("edit_menu")

elf.SetScreenTexture(handle, elf.CreateTextureFromFile("../resources/background.png"))
elf.SetGuiObjectVisible(handle, true)
elf.SetGuiObjectColor(handle, 1.0, 1.0, 1.0, 0.85)
elf.SetGuiObjectPosition(handle, elf.GetWindowWidth()-elf.GetGuiObjectSize(handle).x, 0)

elf.AddGuiObject(gui, handle)

font = elf.CreateFontFromFile("../resources/freemono.ttf", 14)

text_field = elf.CreateTextField("Input")
elf.SetTextFieldTexture(text_field, elf.CreateTextureFromFile("../resources/text_field236.png"))
elf.SetTextFieldOffset(text_field, 3, 2)
elf.SetTextFieldFont(text_field, font)
elf.SetGuiObjectPosition(text_field, 10, 10)

elf.AddGuiObject(handle, text_field)

-- add execute button 
exbtexoff = elf.CreateTextureFromFile("../resources/execute.png") 
exbtexover = elf.CreateTextureFromFile("../resources/execute_over.png") 
exbtexon = elf.CreateTextureFromFile("../resources/execute_on.png") 
exb = elf.CreateButton("ExecuteBtn") 
elf.SetButtonOffTexture(exb, exbtexoff) 
elf.SetButtonOverTexture(exb, exbtexover) 
elf.SetButtonOnTexture(exb, exbtexon) 
elf.SetGuiObjectPosition(exb, 10, 30) 
exscr = elf.CreateScript('script1') 
elf.SetScriptText(exscr, "elf.RunString(elf.GetTextFieldText(text_field))") 
elf.SetGuiObjectScript(exb, exscr) 
elf.AddGuiObject(handle, exb)

-- tracked info, in lua all are tables
functions = {
  function() return("FPS: " .. elf.GetFps()) end,
  function() return("Resolution:" .. elf.GetWindowWidth() .. 'x' .. elf.GetWindowHeight()) end,
  function() return("IsFullscreen: " .. (elf.IsFullscreen() and "true" or "false")) end,
  function() return("GetTitle: " .. elf.GetTitle()) end,
  function() return("GetMultisamples: " .. elf.GetMultisamples()) end,
  function() return("GetTime: " .. elf.GetTime()) end,
  function() return("IsWindowOpened: " .. (elf.IsWindowOpened() and "true" or "false")) end,
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
  function() return("GetEventCount: " .. elf.GetEventCount()) end
}

-- create text list for text
txt = elf.CreateTextList("TXTlist")
elf.SetTextListFont(txt,font)
elf.SetTextListSize(txt,# functions,300)
elf.SetGuiObjectPosition(txt, 8, 8)
elf.AddGuiObject(gui, txt)

game = Game(_local_game)
game:loadEnvironment():loadUnits()

game:start()

while elf.Run() == true and game:running() do
  -- update info
  elf.RemoveTextListItems( txt )
  for i,v in ipairs(functions) do
    elf.AddTextListItem(txt, v() )
  end

  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end

  -- save a screenshot on F5
  if elf.GetKeyState(elf.KEY_F5) == elf.PRESSED then
    if elf.SaveScreenShot("screenshot.png") == true then
      print("screen shot saved to " .. elf.GetCurrentDirectory() .. "/screenshot.png")
    end
  end
end

game:stop()
