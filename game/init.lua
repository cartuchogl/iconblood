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

debug = Debug(gui)

game = Game(_local_game)
game:loadEnvironment():loadUnits()

game:start()

while elf.Run() == true and game:running() do
  debug:update()

  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end

  -- save a screenshot on F5
  if elf.GetKeyState(elf.KEY_F5) == elf.PRESSED then
    if elf.SaveScreenShot("screenshot.png") == true then
      print("screen shot saved to " .. elf.GetCurrentDirectory() .. "/screenshot.png")
    end
  end
end

game:stop()
