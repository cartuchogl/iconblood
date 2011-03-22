MenuPanel = class('MenuPanel', ElfObject)

function MenuPanel:initialize(parent,loader)
  self._loader = loader
  local off = self._loader:get('img','inv.png').target
  local over = self._loader:get('img','inv_over.png').target
  local font = self._loader:get('font','fonts/medium.ttf').target
  
  local w = GetWindowWidth()
  
  super.initialize(self,SCREEN,'menu_panel',{
    Position = {w-96*4,28},
    Size = {96*4,31},
    Color = {1,1,1,0},
    parent = parent
  })
  
  self._button_help = ElfObject(BUTTON,"btn_help",{
    OffTexture = off,
    OverTexture = over,
    Position = {0,0},
    Text = 'HELP',
    Font = font,
    parent = self,
    events = {
      click = function(args)
        game._help_panel:set("Visible",not game._help_panel:get("Visible"))
        game._options_panel:set("Visible",false)
        game._exit_panel:set("Visible",false)
      end
    }
  })
  
  self._button_debug = ElfObject(BUTTON,"btn_debug",{
    OffTexture = off,
    OverTexture = over,
    Position = {95,0},
    Text = 'DEBUG',
    Font = font,
    parent = self,
    events = {
      click = function(args)
        game._debug:set("Visible",not game._debug:get("Visible"))
      end
    }
  })
  
  self._button_options = ElfObject(BUTTON,"btn_options",{
    OffTexture = off,
    OverTexture = over,
    Position = {95*2,0},
    Text = 'OPTIONS',
    Font = font,
    parent = self,
    events = {
      click = function(args)
        game._options_panel:set("Visible",not game._options_panel:get("Visible"))
        game._help_panel:set("Visible",false)
        game._exit_panel:set("Visible",false)
      end
    }
  })
  
  self._button_exit = ElfObject(BUTTON,"btn_exit",{
    OffTexture = off,
    OverTexture = over,
    Position = {95*3,0},
    Text = 'EXIT >',
    Font = font,
    parent = self,
    events = {
      click = function(args)
        game._exit_panel:set("Visible",not game._exit_panel:get("Visible"))
        game._help_panel:set("Visible",false)
        game._options_panel:set("Visible",false)
      end
    }
  })
end

function MenuPanel:update()

end
