OptionsPanel = class('OptionsPanel', ElfObject)
OptionsPanel._instance_count = 0

function OptionsPanel:initialize(parent,font)
  OptionsPanel._instance_count = OptionsPanel._instance_count + 1
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  super.initialize(self,SCREEN,'OptionsPanel'..OptionsPanel._instance_count,{
    Size={600,250},
    Position={(w-600)/2,(h-250)/2},
    Color={1,1,1,0.8}
  })
  self:addTo(parent)
  
  self._label_resolution = ElfObject(LABEL,'opts_label_res'..OptionsPanel._instance_count,{
    Position={16,8},
    Text='Resolution',
    Font=font
  })
  self._label_resolution:addTo(self)
  
  self._text_list_resolution = ElfObject(TEXT_LIST,'opts_text_list_res'..OptionsPanel._instance_count,{
    Position={16,32},
    Font=font
  })
  self._text_list_resolution:addTo(self)
  
  for i=0,GetVideoModeCount()-1 do
    AddTextListItem(self._text_list_resolution._elf_obj,GetVideoMode(i).x.."x"..GetVideoMode(i).y)
  end
  
  SetTextListSelection(self._text_list_resolution._elf_obj, 2)
  
  self._label_fullscreen = ElfObject(LABEL,'opts_label_full_screen'..OptionsPanel._instance_count,{
    Position={300,8},
    Text='Fullscreen',
    Font=font
  })
  self._label_fullscreen:addTo(self)
  
  self._check_fullscreen = ElfObject(CHECK_BOX,'opts_check_full_screen'..OptionsPanel._instance_count,{
    Position={300,24},
    Size={20,20}
  })
  self._check_fullscreen:addTo(self)
  
  self._label_ani = ElfObject(LABEL,'opts_label_ani'..OptionsPanel._instance_count,{
    Position={300,46+20},
    Text='Anisotropy',
    Font=font
  })
  self._label_ani:addTo(self)
  
  self._slider_ani = ElfObject(SLIDER,'opts_slider_ani'..OptionsPanel._instance_count,{
    Position={300,66+20},
    Size={200,28}
  })
  self._slider_ani:addTo(self)
  
  self._label_shadow = ElfObject(LABEL,'opts_label_shadow'..OptionsPanel._instance_count,{
    Position={300,86+40},
    Text='Shadow resolution',
    Font=font
  })
  self._label_shadow:addTo(self)
  
  self._slider_shadow = ElfObject(SLIDER,'opts_slider_shadow'..OptionsPanel._instance_count,{
    Position={300,106+40},
    Size={200,28}
  })
  self._slider_shadow:addTo(self)
  
  self._button_cancel = ElfObject(BUTTON,'opts_button_cancel'..OptionsPanel._instance_count,{
    Position={600-16-(70+10)*2,190},
    Text="CANCEL",
    Size={70,40},
    Font=font
  })
  self._button_cancel:addTo(self)
  self._button_cancel:addEvent("click",function(args) self:set("Visible",false) end)
  
  self._button_save = ElfObject(BUTTON,'opts_button_save'..OptionsPanel._instance_count,{
    Position={600-16-(70+10)*1,190},
    Text="SAVE",
    Size={70,40},
    Font=font
  })
  self._button_save:addTo(self)
  
end

function OptionsPanel:update()
  
end
