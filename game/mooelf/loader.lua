Loader = class('Loader')
Loader:includes(EventDispatcher)

function Loader:initialize(path,img,gui,pbg,pfg)
  self._path = path
  self._gui = gui
  self._assets = {img={},font={},scn={}}
  self._status = "Initialized"
  self._progress = 0
  self._loaded = 0
  self:load('img',img)
  self:load('img',pbg)
  self:load('img',pfg)
  
  local image = self:get('img',img).target
  local bg = self:get('img',pbg).target
  local fg = self:get('img',pfg).target
  
  self._loader_gui = ElfObject(SCREEN,"loader",{
    Texture = image,
    Visible = true,
    Color = {1.0, 1.0, 1.0, 0.95},
    Position = {
      (GetWindowWidth()-GetTextureWidth(image))/2, 
      (GetWindowHeight()-GetTextureHeight(image))/2
    },
    parent = gui
  })
  
  self._loader_bar = ProgressBar(self._loader_gui,'loader_bar',bg,fg)
  self._loader_bar:sets({Position={50,399}})
  
  self._default_font = GetDefaultFont()
end

function Loader:load(type,name,...)
  self._assets[type][name] = self["_load_"..type](self,name,...)
end

function Loader:_load_img(name,args)
  print("[Loader][img] "..self._path..'/'..name)
  return CreateTextureFromFile(self._path..'/'..name,self._path..'/'..name)
end

function Loader:_load_font(name,args)
  print("[Loader][font] "..self._path..'/'..name)
  return CreateFontFromFile(self._path..'/'..name,args)
end

function Loader:_load_scn(name,args)
  print("[Loader][scn] "..self._path..'/'..name)
  return CreateSceneFromFile(name,self._path..'/'..name)
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
  return #self._loading.img+#self._loading.font+#self._loading.scn
end

function Loader:batch(options)
  self._loading = self._loading and self._loading or {}
  local img = options.img and options.img or {}
  local font = options.font and options.font or {}
  local scn = options.scn and options.scn or {}
  self._loading = {
    img = array_concat(self._loading.img,img),
    font = array_concat(self._loading.font,font),
    scn = array_concat(self._loading.scn,scn)
  }
end

function Loader:loadAny()
  self._loader_bar:max(self._loaded+self:restLoad())
  self._loader_bar:current(self._loaded)
  self._next_type = nil
  if #self._loading.img>0 then
    self._next_type = 'img'
  elseif #self._loading.font>0 then
    self._next_type = 'font'
  elseif #self._loading.scn>0 then
    self._next_type = 'scn'
  else
    self:fireEvent('endbatch',{self})
  end
  if self._next_type then 
    setTimeout(function()
      if self._loaded == 0 then
        self:fireEvent('inibatch',{self})
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
