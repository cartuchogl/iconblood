SetTitle("iconblood alpha1")
dofile("src/includes.lua")
SetFpsLimit(50)
-- create and set a gui
gui = CreateGui()
SetGui(gui)

loader = Loader('data','load.png','fonts/default.ttf',gui,'loader_bg.png','loader_fg.png')

loader:batch({
  img = {
    "rect2816.png",
    "rect2817.png",
    "text_field400.png",
    "help_panel.png",
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
    "factions/humans/weapons/3.png",
    "factions/humans/weapons/4.png",
    "weapon_bg.png",
    "weapon_select.png"
  },
  font = {
    {"fonts/small.ttf",10},
    {"fonts/medium.ttf",13},
    {"fonts/big.ttf",16},
    {"fonts/console.ttf",13}
  }
})

local initime

loader:addEvents({
  inibatch=function(args)
    initime = GetTime()
  end,
  endbatch=function(args)
    print((GetTime()-initime).."sg [Assets loading]")
  end
})

dofile("example.ibg.lua")
game = Game(_local_game,gui,loader)

fps_counter = ElfObject(LABEL,'fps_counter',{Font = loader._default_font,parent=gui,Position={2,4}})

print(GetTime().."sg [To main loop]")
while Run() == true do
  if game:running() then
    game:fireEvent('onframe',{game})
  end
  -- for setTimeout
  setTimeoutLaunch()
  if GetKeyState(KEY_ESC) == PRESSED then Quit() end
  fps_counter:set('Text','FPS: '..GetFps())
end

-- end of file
