SetTitle("iconblood alpha")
dofile("mooelf/includes.lua")
dofile("iconblood/includes.lua")
-- create and set a gui
gui = CreateGui()
SetGui(gui)

loader = Loader('data','load.png',gui,'loader_bg.png','loader_fg.png')

loader:batch(dofile("load.lua"))
loader:loadAny()

-- dofile("demo_elf.lua")
dofile("iconblood.lua")

game = Game(dofile("example.ibg.lua"),gui,loader)

while Run() == true do
  if game:running() then
    game:fireEvent('onframe',{game})
  end
  -- for setTimeout
  setTimeoutLaunch()
  if GetKeyState(KEY_ESC) == PRESSED then Quit() end
end

-- end of file
