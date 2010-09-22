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
    "current_bg.png",
    "mini_panel.png",
    "move_mini_progress.png",
    "move_mini_progress_bg.png",
    "life_mini_progress.png",
    "life_mini_progress_bg.png",
    "select_mini_panel.png",
    "chars.png",
    "chars_over.png",
    "chars_on.png",
    "habs.png",
    "habs_over.png",
    "habs_on.png",
    "inv.png",
    "inv_over.png",
    "inv_on.png",
    "action.png",
    "reload.png",
    "reload_over.png",
    "reload_on.png",
    "factions/humans/weapons/1.png",
    "factions/humans/weapons/2.png",
    "weapon_bg.png",
    "weapon_select.png"
  },
  font = {
    {"fonts/small.ttf",12},
    {"fonts/medium.ttf",14},
    {"fonts/big.ttf",15}
  }
})

local initime

loader:addEvents({
  inibatch=function(args)
    initime = elf.GetTime()
  end,
  endbatch=function(args)
    print((elf.GetTime()-initime).."sg [Assets loading]")
  end
})

dofile("example.ibg.lua")
game = Game(_local_game,gui,loader)

fps_counter = ElfObject(elf.LABEL,'fps_counter',{Font = loader._default_font,parent=gui})

print(elf.GetTime().."sg [To main loop]")
while elf.Run() == true do
  if game:running() then
    game:fireEvent('onframe',{game})
  end
  -- for setTimeout
  setTimeoutLaunch()
  if elf.GetKeyState(elf.KEY_ESC) == elf.PRESSED then elf.Quit() end
  fps_counter:set('Text','FPS: '..elf.GetFps())
end

-- end of file
