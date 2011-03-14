SetTitle("iconblood alpha")
dofile("src/includes.lua")
SetFpsLimit(50)
-- create and set a gui
gui = CreateGui()
SetGui(gui)

loader = Loader('data','load.png',gui,'loader_bg.png','loader_fg.png')

loader:batch(dofile("load.lua"))

local initime

loader:addEvents({
  inibatch=function(args)
    initime = GetTime()
  end,
  endbatch=function(args)
    print((math.ceil((GetTime()-initime)*1000)/1000).."sg [Assets loading]")
  end
})

game = Game(dofile("example.ibg.lua"),gui,loader)

print(GetTime().."sg [To main loop]")
while Run() == true do
  if game:running() then
    game:fireEvent('onframe',{game})
  end
  -- for setTimeout
  setTimeoutLaunch()
  if GetKeyState(KEY_ESC) == PRESSED then Quit() end
end

-- end of file
