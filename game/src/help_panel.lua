HelpPanel = class('HelpPanel', ElfObject)

function HelpPanel:initialize(parent,img,font)
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  super.initialize(self,SCREEN,'HelpPanel',{
    Texture = game._loader:get('img',"gui_bg.png").target,
    Size = {600,300},
    Position = {(w-600)/2,(h-300)/2},
    Color = {1,1,1,0.8},
    parent = parent
  })
  
  self._labels = {}
  
  local sep = 20
  local ini = 64
  local iniy = 32
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy},
    Text = "Move camera across : A,W,S and D"
  })
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy+#self._labels*sep},
    Text = "Next unit : TAB"
  })
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy+#self._labels*sep},
    Text = "Move camera to current unit : SPACE" 
  })
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy+#self._labels*sep},
    Text = "Zoom : Mouse Wheel, key up and down"
  })
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy+#self._labels*sep},
    Text = "Rotate over current unit : Q and E"
  })
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy+#self._labels*sep},
    Text = "Select, move and fire : Left Click"
  })
  
  self._labels[#self._labels+1] = ElfObject(LABEL,'help_label'..(#self._labels),{parent=self,Font=font,
    Position = {ini,iniy+#self._labels*sep},
    Text = "Rotate camera : Right Click and move, key left and right"
  })
  
  self._button_close = ElfObject(BUTTON,'help_button_close',{
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
