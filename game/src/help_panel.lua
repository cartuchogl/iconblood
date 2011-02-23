HelpPanel = class('HelpPanel', ElfObject)
HelpPanel._instance_count = 0

function HelpPanel:initialize(parent,img,font)
  HelpPanel._instance_count = HelpPanel._instance_count + 1
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  super.initialize(self,SCREEN,'HelpPanel'..HelpPanel._instance_count,{
    Texture = game._loader:get('img',"gui_bg.png").target,
    Size = {600,300},
    Position = {(w-600)/2,(h-300)/2},
    Color = {1,1,1,0.8},
    parent = parent
  })
  
  self._pic_help = ElfObject(PICTURE,'help_pic'..OptionsPanel._instance_count,{
    Position = {0,0},
    Texture = img,
    parent = self
  })
  
  self._button_close = ElfObject(BUTTON,'help_button_close'..HelpPanel._instance_count,{
    Position = {600-16-(70+10)*1,230},
    Text = "CLOSE",
    Size = {70,40},
    Font = font,
    parent = self,
    events = {
      click = function(args) self:set("Visible",false) end
    }
  })
end

function HelpPanel:update()
  
end
