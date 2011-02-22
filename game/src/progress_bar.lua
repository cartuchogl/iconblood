ProgressBar = class('ProgressBar', ElfObject)

function ProgressBar:initialize(parent,name,bg,fg)
  super.initialize(self,SCREEN,name,{
    Position = {0,0},
    Texture = bg,
    parent = parent
  })
  self._parent = parent
  self._max = 1
  self._current = 0.5
  self._bar = ElfObject(PICTURE,name..'_bar',{
    Texture=fg,
    parent = self
  })
  self._direction = "hor"
  self:update()
end

function ProgressBar:max(...)
  if #arg>0 then
    if arg[1]>=1 then self._max = arg[1] end
  else
    return self._max
  end
end

function ProgressBar:direction(...)
  if #arg>0 then
    self._direction = arg[1]
  else
    return self._direction
  end
end

function ProgressBar:current(...)
  if #arg>0 then
    if arg[1]>self._max then 
      self._current = self._max
    elseif arg[1]<0 then
      self._current = 0
    else
      self._current = arg[1]
    end
  else
    return self._current
  end
  self:update()
end

function ProgressBar:update()
  if self._direction == "hor" then
    local w = GetTextureWidth(self._bar:get('Texture'))
    self._bar:set('Position',-w+w*self._current/self._max,0)
  else
    local h = GetTextureHeight(self._bar:get('Texture'))
    self._bar:set('Position',0,h-h*self._current/self._max)
  end
end


