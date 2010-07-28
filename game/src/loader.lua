Loader = class('Loader')
Loader:includes(EventDispatcher)

function Loader:initialize(path,img,font,gui,pbg,pfg)
  self._path = path
  self._gui = gui
  self._assets = {img={},font={},env={},fac={},unit_img={}}
  self._status = "Initialized"
  self._progress = 0
  self:load('img',img)
  self:load('img',pbg)
  self:load('img',pfg)
  self:load('font',font,14)
  
  local image = self:get('img',img).target
  local bg = self:get('img',pbg).target
  local fg = self:get('img',pfg).target
  local font = self:get('font',font).target
  
  self._loader_gui = GuiObject(elf.SCREEN,"loader",{
    Texture = image,
    Visible = true,
    Color = {1.0, 1.0, 1.0, 0.95},
    Position = {
      (elf.GetWindowWidth()-elf.GetTextureWidth(image))/2, 
      (elf.GetWindowHeight()-elf.GetTextureHeight(image))/2
    }
  })
  self._loader_gui:addTo(gui)
  
  self._loader_bar = ProgressBar(self._loader_gui,'loader_bar',bg,fg)
  self._loader_bar:sets({Position={39,180}})
end

function Loader:load(type,name,...)
  self._assets[type][name] = self["_load_"..type](self,name,arg)
end

function Loader:_load_unit_img(name,args)
  print("[Loader][font] "..self._path..'/'..name)
end

function Loader:_load_img(name,args)
  print("[Loader][img] "..self._path..'/'..name)
  return elf.CreateTextureFromFile(self._path..'/'..name)
end

function Loader:_load_font(name,args)
  print("[Loader][font] "..self._path..'/'..name)
  return elf.CreateFontFromFile(self._path..'/'..name,args[1])
end

function Loader:_load_env(id,args)
  local path = findPath("../environments/","0*"..id.."_*.*").."/level.pak"
  print("[Loader][env] "..path)
  return elf.CreateSceneFromFile(path)
end

function Loader:_load_fac(id,args)
  local path = findPath("../factions/","0*"..id.."_*.*").."/units.pak"
  print("[Loader][fac] "..path)
  return elf.CreateSceneFromFile(path)
end

function Loader:get(type,name)
  return {
    target=self._assets[type][name]
  }
end

function Loader:status()
  return self._status, self._progress
end

function Loader:restLoad()
  return #self._loading.img+#self._loading.env+#self._loading.fac+#self._loading.font
end

function Loader:batch(options)
  self._loaded = 0
  self._loading = _.extend({img={},font={},env={},fac={}},options)
  self:loadAny()
end

function Loader:addEnvBatch(env)
  self._loading.env = {env}
end

function Loader:addFactionsBatch(factions)
  self._loading.fac = factions
end

function Loader:loadAny()
  self._loader_bar:max(self._loaded+self:restLoad())
  self._loader_bar:current(self._loaded)
  self._next_type = nil
  if #self._loading.img>0 then
    self._next_type = 'img'
  elseif #self._loading.env>0 then
    self._next_type = 'env'
  elseif #self._loading.fac>0 then
    self._next_type = 'fac'
  elseif #self._loading.font>0 then
    self._next_type = 'font'
  else
    self:fireEvent('endbatch',{self},0)
  end
  if self._next_type then 
    setTimeout(function()
      if self._loaded == 0 then
        self:fireEvent('inibatch',{self},0)
      end
      local ele = self._loading[self._next_type][1]
      if type(ele) == 'table' then
        self:load(self._next_type,ele[1],ele[2])
      else
        self:load(self._next_type,ele)
      end
      table.remove(self._loading[self._next_type],1)
      self._loaded = self._loaded+1
      self.loadAny(self)
    end,10)
  end
end
