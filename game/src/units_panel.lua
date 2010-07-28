UnitsPanel = class('UnitsPanel', ElfObject)

function UnitsPanel:initialize(parent,x,ubg,select,mbg,mfg,lbg,lfg)
  self._width = elf.GetWindowWidth()-x-10
  self._height = elf.GetTextureHeight(ubg)
  self._bg_pic = elf.CreateEmptyImage(self._width,self._height,24)
  self._bg_tex = elf.CreateTextureFromImage(self._bg_pic)
  super.initialize(self,elf.SCREEN,'units_panel',{Texture=self._bg_tex,Color={1,1,1,0.3}})
  self:set('Position',x,elf.GetWindowHeight()-self._height)
  self:addTo(parent)
  self._units = nil
  self._panels = {}
  self._ubg = ubg
  self._select = select
  self._mbg = mbg
  self._mfg = mfg
  self._lbg = lbg
  self._lfg = lfg
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
        self._panels[cont]:set('Position',elf.GetTextureWidth(self._ubg)*(cont-1),0)
      end
      cont = cont + 1
    end)
  else
    _.each(self._panels,function(i) i:set('Visible',false) end)
  end
  _.each(self._panels,function(i) i:update() end)
end
