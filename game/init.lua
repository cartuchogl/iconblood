elf.SetTitle("iconblood alpha1")
dofile("includes.lua")
elf.SetFpsLimit(50)
-- create and set a gui
gui = elf.CreateGui()
elf.SetGui(gui)

loader = Loader('../resources','load.png','fonts/default.ttf',gui,'loader_bg.png','loader_fg.png')
loader:batch({
  img = {
    "rect2816.png",
    "rect2817.png",
    "text_field400.png",
    "execute.png",
    "execute_over.png",
    "execute_on.png",
    "end_turn.png",
    "end_turn_over.png",
    "end_turn_on.png",
    "current_bg.png"
  }
})

loader:addEvent('inibatch',function(args)
  initime = elf.GetTime()
end)

loader:addEvent('endbatch',function(args)
  print(elf.GetTime()-initime)
end)

dofile("example.ibg.lua")
game = Game(_local_game,gui,loader)

local ctime = elf.GetTime()
print(ctime.."sg")
while elf.Run() == true do
  if game:running() then
    game:fireEvent('onframe',{game},0)
  end
  -- for setTimeout
  setTimeoutLaunch()
  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end
end

-- end of file
