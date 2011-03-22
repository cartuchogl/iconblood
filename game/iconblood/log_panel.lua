LogPanel = class('LogPanel', ElfObject)

function LogPanel:initialize(parent,font)
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  self._font = font
  self._parent = parent
  super.initialize(self,SCREEN,'LogPanel', {
    Texture = game._loader:get('img',"gui_bg.png").target,
    Size={370,80},
    Position={w-370-10,70},
    parent = parent,
    Color = {1,1,1,0}
  })
  
  self._text_list_log = ElfObject(TEXT_LIST,'log_panel_list',{
    Position={10,0},
    Font=font,
    parent = self,
    Size = {5,350}
  })
  self._log = {}
end

function LogPanel:game(str)
  self._log[#self._log+1] = str
end

function LogPanel:update()
  if self:get("Visible") then
    RemoveTextListItems( self._text_list_log._elf_obj )
    for i=math.max(0,#self._log-4),#self._log do
      if self._log[i] then
        AddTextListItem(self._text_list_log._elf_obj,self._log[i])
      end
    end
    self._text_list_log:set('Selection',-1)
  end
end
