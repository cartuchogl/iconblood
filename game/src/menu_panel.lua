MenuPanel = class('MenuPanel', ElfObject)

function MenuPanel:initialize(parent,loader)
  self._loader = loader
  local off = self._loader:get('img','end_turn.png').target
  local over = self._loader:get('img','end_turn_over.png').target
  local font = self._loader:get('font','fonts/medium.ttf').target
  local w = GetWindowWidth()
  super.initialize(self,SCREEN,'menu_panel',{Position={w-120*3,28},Size={120*3,31},Color={1,1,1,0}})
  self:addTo(parent)
  
  self._button_help = ElfObject(BUTTON,"btn_help",{
    OffTexture = off,
    OverTexture = over,
    Position = {0,0},
    Text = 'HELP',
    Font = font
  })
  self._button_help:addTo(self)
  self._button_help:addEvent('click',function(args)
    game._help_panel:set("Visible",not game._help_panel:get("Visible"))
    game._options_panel:set("Visible",false)
    game._exit_panel:set("Visible",false)
  end)
  
  self._button_options = ElfObject(BUTTON,"btn_options",{
    OffTexture = off,
    OverTexture = over,
    Position = {120,0},
    Text = 'OPTIONS',
    Font = font
  })
  self._button_options:addTo(self)
  self._button_options:addEvent('click',function(args)
    game._options_panel:set("Visible",not game._options_panel:get("Visible"))
    game._help_panel:set("Visible",false)
    game._exit_panel:set("Visible",false)
  end)
  
  self._button_exit = ElfObject(BUTTON,"btn_exit",{
    OffTexture = off,
    OverTexture = over,
    Position = {240,0},
    Text = 'EXIT >',
    Font = font
  })
  self._button_exit:addTo(self)
  self._button_exit:addEvent('click',function(args)
    game._exit_panel:set("Visible",not game._exit_panel:get("Visible"))
    game._help_panel:set("Visible",false)
    game._options_panel:set("Visible",false)
  end)
end

function MenuPanel:update()

end
