Message = class('Message')
Message._instance_count = 0

function Message:init(gui,font)
  Message._gui = gui
  Message._font = font
end

function Message:modal(message)
  Message._instance_count = Message._instance_count + 1
  
  local w = GetWindowWidth()
  local h = GetWindowHeight()
  
  local msg = {}
  
  -- msg._panel = ElfObject(SCREEN,"panel_msg_"..Message._instance_count,{
  --   Size = {w,h},
  --   Color = {1,1,1,0},
  --   parent = Message._gui
  -- })
  msg._panel_mini = ElfObject(SCREEN,"panel_mini_msg_"..Message._instance_count, {
    Texture = game._loader:get('img',"gui_bg.png").target,
    Size = {500,200},
    Position = {(w-500)/2,(h-200)/2},
    parent = Message._gui,
    Color = {1,1,1,1}
  })
  msg._panel_label = ElfObject(LABEL,"panel_label_msg_"..Message._instance_count, {
    Position = {32,32},
    parent = msg._panel_mini,
    Text = message,
    Font = Message._font
  })
  msg._panel_btn = ElfObject(BUTTON,"panel_btn_msg_"..Message._instance_count, {
    Text = "OK",
    Size = {70,40},
    Position = {500-70-10,200-40-10},
    parent = msg._panel_mini,
    Font = Message._font,
    events = {
      click = function(args)
        -- msg._panel:set("Visible",false)
        msg._panel_mini:set("Visible",false)
      end
    }
  })
end

