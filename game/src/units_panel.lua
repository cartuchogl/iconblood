UnitsPanel = class('UnitsPanel', ElfObject)

function UnitsPanel:initialize(parent,loader)
  self._loader = loader
  local x = 154
  self._ubg = self._loader:get('img',"mini_panel.png").target
  self._select = self._loader:get('img',"select_mini_panel.png").target
  self._mbg = self._loader:get('img',"move_mini_progress_bg.png").target
  self._mfg = self._loader:get('img',"move_mini_progress.png").target
  self._lbg = self._loader:get('img',"life_mini_progress_bg.png").target
  self._lfg = self._loader:get('img',"life_mini_progress.png").target
  self._font = self._loader:get('font','fonts/small.ttf').target
  
  self._width = GetTextureWidth(self._ubg) 
  self._height = GetWindowHeight()
  self._bg_pic = CreateEmptyImage(self._width,self._height,24)
  self._bg_tex = CreateTextureFromImage('null',self._bg_pic)
  
  super.initialize(self,SCREEN,'units_panel',{
    Size = {self._width,100},
    Color = {1,1,1,0.0},
    Position = {0,0},
    parent = parent
  })
  
  self._units = nil
  self._panels = {}
end

function UnitsPanel:update()
  if type(self._units)=='table' then
    self:set('y',self._height-GetTextureHeight(self._ubg)*#self._units)
    self:set('Size',self._width,GetTextureHeight(self._ubg)*#self._units)
    local cont = 1
    _.each(self._units,function(i)
      if self._panels[cont] then
        self._panels[cont]._unit = i
        self._panels[cont]:set('Visible',true)
      else
        self._panels[cont] = MiniPanel(self,self._ubg,self._select,self._mbg,self._mfg,self._lbg,self._lfg,self._font)
        self._panels[cont]:set('Position',0,GetTextureHeight(self._ubg)*(cont-1))
      end
      cont = cont + 1
    end)
  else
    _.each(self._panels,function(i) i:set('Visible',false) end)
  end
  _.each(self._panels,function(i) i:update() end)
end
