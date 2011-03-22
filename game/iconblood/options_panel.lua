OptionsPanel = class('OptionsPanel', ElfObject)
OptionsPanel._instance_count = 0

function OptionsPanel:initialize(parent,font)
  OptionsPanel._instance_count = OptionsPanel._instance_count + 1
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  self._font = font
  super.initialize(self,SCREEN,'OptionsPanel'..OptionsPanel._instance_count,{
    Texture = game._loader:get('img',"gui_bg.png").target,
    Size={600,250},
    Position={(w-600)/2,(h-250)/2},
    parent = parent
  })
  
  self._label_resolution = ElfObject(LABEL,'opts_label_res'..OptionsPanel._instance_count,{
    Position={16,8},
    Text='Resolution',
    Font=font,
    parent = self
  })
  
  self._text_list_resolution = ElfObject(TEXT_LIST,'opts_text_list_res'..OptionsPanel._instance_count,{
    Position={16,32},
    Font=font,
    parent = self
  })
  self._skip = 0
  for i=0,GetVideoModeCount()-1 do
    if GetVideoMode(i).x>800 then
      AddTextListItem(self._text_list_resolution._elf_obj,GetVideoMode(i).x.."x"..GetVideoMode(i).y)
    else
      self._skip = self._skip+1
    end
  end
  
  self._label_fullscreen = ElfObject(LABEL,'opts_label_full_screen'..OptionsPanel._instance_count,{
    Position={300,8},
    Text='Fullscreen',
    Font=font,
    parent = self
  })
  
  self._check_fullscreen = ElfObject(CHECK_BOX,'opts_check_full_screen'..OptionsPanel._instance_count,{
    Position={300,24},
    Size={20,20},
    parent = self
  })
  
  self._label_ani = ElfObject(LABEL,'opts_label_ani'..OptionsPanel._instance_count,{
    Position={300,46+20},
    Text='Anisotropy',
    Font=font,
    parent = self
  })
  
  self._slider_ani = ElfObject(SLIDER,'opts_slider_ani'..OptionsPanel._instance_count,{
    Position={300,66+20},
    Size={200,28},
    parent = self
  })
  self._slider_label_ani = ElfObject(LABEL,'opts_slider_label_ani'..OptionsPanel._instance_count, {
    Position = {300+200+10,66+20},
    parent = self,
    Text = '1x',
    Font = font
  })
  self._table_ani = {1,2,4,8,16}
  
  self._label_shadow = ElfObject(LABEL,'opts_label_shadow'..OptionsPanel._instance_count,{
    Position={300,86+40},
    Text='Shadow resolution',
    Font=font,
    parent = self
  })
  
  self._slider_shadow = ElfObject(SLIDER,'opts_slider_shadow'..OptionsPanel._instance_count,{
    Position={300,106+40},
    Size={200,28},
    parent = self
  })
  self._slider_label_shadow = ElfObject(LABEL,'opts_slider_label_shadow'..OptionsPanel._instance_count, {
    Position = {300+200+10,106+40},
    parent = self,
    Text = '2048',
    Font = font
  })
  self._table_shadow = {256,1024,2048,4096}
  
  self._button_cancel = ElfObject(BUTTON,'opts_button_cancel'..OptionsPanel._instance_count,{
    Position={600-16-(70+10)*2,190},
    Text="CANCEL",
    Size={70,40},
    Font=font,
    parent = self,
    events = {
      click = function(args) self:set("Visible",false) end
    }
  })
  
  self._button_save = ElfObject(BUTTON,'opts_button_save'..OptionsPanel._instance_count,{
    Position={600-16-(70+10)*1,190},
    Text="SAVE",
    Size={70,40},
    Font=font,
    parent = self,
    events = {
      click = _.curry(self.on_save, self)
    }
  })
  
  self:load_config()
end

function OptionsPanel:load_config()
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  local full = IsFullscreen()
  local ani = GetTextureAnisotropy()
  local shadow = GetShadowMapSize()
  
  for i=0,GetVideoModeCount()-1 do
    if GetVideoMode(i).x==w and GetVideoMode(i).y==h then
      self._text_list_resolution:set("Selection",i)
      break
    end
  end
  
  self._check_fullscreen:set("State",full)
  
  local found = table.find(self._table_ani, math.floor(ani))
  if found then
    self._slider_ani:set("Value",found/#self._table_ani)
  end
  
  found = table.find(self._table_shadow, math.floor(shadow))
  if found then
    self._slider_shadow:set("Value",found/#self._table_shadow)
  end
end

function OptionsPanel:on_save()
  print("Not saved really made...")
  self:set("Visible",false)
  
  local file = io.open ("config.txt", "w+")
  local i = self._text_list_resolution:get("SelectionIndex")+self._skip
  file:write("windowSize "..GetVideoMode(i).x.." "..GetVideoMode(i).y.."\n")
  file:write("fullscreen "..(self._check_fullscreen:get("State") and "TRUE" or "FALSE").."\n")
  file:write("textureAnisotropy "..self._table_ani[math.floor(self._slider_ani:get('Value')*(#self._table_ani-1))+1]..".0\n")
  file:write("shadowMapSize "..self._table_shadow[math.floor(self._slider_shadow:get('Value')*(#self._table_shadow-1))+1].."\n")
  file:close()
  
  Message:modal("Will be restart to take effect.")
end

function OptionsPanel:update()
  if self:get("Visible") then
    self._slider_label_shadow:set('Text',self._table_shadow[math.floor(self._slider_shadow:get('Value')*(#self._table_shadow-1))+1])
    self._slider_label_ani:set('Text',self._table_ani[math.floor(self._slider_ani:get('Value')*(#self._table_ani-1))+1])
  end
end
