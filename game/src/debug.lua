Debug = class('Debug')

function Debug:initialize(gui)
  print("initialize Debug")
  -- tracked info, in lua all are tables
  self._functions = {
    function() return("FPS: " .. elf.GetFps()) end,
    function() return("Resolution:" .. elf.GetWindowWidth() .. 'x' .. elf.GetWindowHeight()) end,
    function() return("IsFullscreen: " .. (elf.IsFullscreen() and "true" or "false")) end,
    function() return("GetTitle: " .. elf.GetTitle()) end,
    function() return("GetMultisamples: " .. elf.GetMultisamples()) end,
    function() return("GetTime: " .. elf.GetTime()) end,
    function() return("IsWindowOpened: " .. (elf.IsWindowOpened() and "true" or "false")) end,
    function() 
      return("GetMousePosition: " .. elf.GetMousePosition().x .. 'x' .. elf.GetMousePosition().y) 
    end,
    function() return("GetMouseForce: " .. elf.GetMouseForce().x ..'x'.. elf.GetMouseForce().y) end,
    function() return("IsMouseHidden: " .. (elf.IsMouseHidden() and "true" or "false")) end,
    function() return("GetMouseWheel: " .. elf.GetMouseWheel()) end,
    function() return("GetMouseButtonState L: " .. elf.GetMouseButtonState(elf.BUTTON_LEFT)) end,
    function() return("GetMouseButtonState M: " .. elf.GetMouseButtonState(elf.BUTTON_MIDDLE)) end,
    function() return("GetMouseButtonState R: " .. elf.GetMouseButtonState(elf.BUTTON_RIGHT)) end,
    function() return("GetKeyState G: " .. elf.GetKeyState(elf.KEY_G)) end,
    function() return("GetKeyState H: " .. elf.GetKeyState(elf.KEY_H)) end,
    function() return("GetEventCount: " .. elf.GetEventCount()) end
  }
  
  -- create text list for text
  local txt = elf.CreateTextList("TXTlist")
  elf.SetTextListFont(txt,font)
  elf.SetTextListSize(txt, #self._functions, 300)
  elf.SetGuiObjectPosition(txt, 8, 8)
  elf.AddGuiObject(gui, txt)
  self._txt = txt
end

function Debug:update()
  -- update info
  elf.RemoveTextListItems( self._txt )
  if self._active then
    for i,v in ipairs(self._functions) do
      elf.AddTextListItem(self._txt, v() )
    end
  end
end

function Debug:on()
  self._active = true
end

function Debug:off()
  self._active = false
end
