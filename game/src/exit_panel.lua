ExitPanel = class('ExitPanel', ElfObject)
ExitPanel._instance_count = 0

function ExitPanel:initialize(parent,font)
  ExitPanel._instance_count = ExitPanel._instance_count + 1
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  super.initialize(self,SCREEN,'ExitPanel'..ExitPanel._instance_count,{
    Size={200,120},
    Position={(w-200)/2,(h-120)/2},
    Color={1,1,1,0.8}
  })
  self:addTo(parent)
  
  self._label_exit = ElfObject(LABEL,'exit_label'..OptionsPanel._instance_count,{
    Position={32,32},
    Text="Are that game shit?",
    Font=font
  })
  self._label_exit:addTo(self)
  
  self._button_exit = ElfObject(BUTTON,'exit_button_close'..ExitPanel._instance_count,{
    Position={200-16-(70+10)*1,60},
    Text="YES",
    Size={70,40},
    Font=font
  })
  self._button_exit:addTo(self)
  self._button_exit:addEvent("click",function(args) Quit() end)
end

function ExitPanel:update()
  
end
