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
  
  self._width = GetTextureWidth(self._ubg) 
  self._height = GetWindowHeight()-10
  self._bg_pic = CreateEmptyImage(self._width,self._height,24)
  self._bg_tex = CreateTextureFromImage('null',self._bg_pic)
  super.initialize(self,SCREEN,'units_panel',{Texture=self._bg_tex,Color={1,1,1,0.17}})
  self:set('Position',GetWindowWidth()-self._width,0)
  self:addTo(parent)
  self._units = nil
  self._panels = {}
end

function UnitsPanel:update()
  if type(self._units)=='table' then
    local cont = 1
    _.each(self._units,function(i)
      if self._panels[cont] then
        self._panels[cont]._unit = i
        self._panels[cont]:set('Visible',true)
      else
        self._panels[cont] = MiniPanel(self,self._ubg,self._select,self._mbg,self._mfg,self._lbg,self._lfg)
        self._panels[cont]:set('Position',0,GetWindowHeight()-GetTextureHeight(self._ubg)*(cont)-10)
      end
      cont = cont + 1
    end)
  else
    _.each(self._panels,function(i) i:set('Visible',false) end)
  end
  _.each(self._panels,function(i) i:update() end)
end
