settimeout_table = {}

-- this function must be call on render loop for setTimeout
function setTimeoutLaunch()
  local now = getTime()
  local tmp = {}
  for i=1,#settimeout_table,1 do
    local item = settimeout_table[i]
    local diff = now-item[1]
    if diff >= item[2] then
      table.insert(tmp,i)
      item[3]()
    end
  end
  _.each(_.reverse(_.sort(tmp)),function(i) table.remove(settimeout_table,i) end)
end

-- javascript setTimeout like function
function setTimeout(func,delay)
  table.insert(settimeout_table,{getTime(),delay,func})
end

-- return current game time in ms
function getTime()
  return math.ceil(elf.GetTime()*1000)
end

-- if found expreg in directory on path return full path otherside return false
function findPath(path,expreg)
  local kk = elf.ReadDirectory(path)
  local l = elf.GetDirectoryItemCount(kk)
  for i = 0,l-1,1 do
    local object = elf.GetDirectoryItem(kk, i)
    local name = elf.GetDirectoryItemName(object)
    if string.byte(name) ~= string.byte(".") then
      if string.match(name,expreg) then
        return path..name
      end
    end
  end
  return false
end

-- return uniques elements on array, for number
function uniques(array)
  local uniq = {}
  local kk_list = _.select(array, function(i)
    if uniq[i] then
      return false
    else
      uniq[i] = 1
      return true
    end
  end)
  return kk_list
end

-- normalize elf_vec3f, if pass a second param then return the vector scaled to that length
function normalize(v,size)
  local n = elf.CreateVec3f()
  local a = math.sqrt(v.x*v.x+v.y*v.y+v.z*v.z)
  if size then
    q = size
  else
    q=1
  end
  n.x = v.x/a*q
  n.y = v.y/a*q
  n.z = v.z/a*q
  return n
end

function normalize2d(v,size)
  local a = math.sqrt(v.x*v.x+v.y*v.y)
  if size then
    q = size
  else
    q=1
  end
  local n = {}
  n.x = v.x/a*q
  n.y = v.y/a*q
  return n
end

-- return a copy of entity
function duplicate_entity(ent,new_name)
  local scale =  elf.GetEntityScale(ent)
  local ret = elf.CreateEntity(new_name)
  local armature = elf.GetEntityArmature(ent)
  elf.SetEntityModel(ret,elf.GetEntityModel(ent))
  if elf.IsObject(armature) then elf.SetEntityArmature(ret,armature) end
  for i=0,elf.GetEntityMaterialCount(ent)-1 do
    elf.SetEntityMaterial(ret,i,elf.GetEntityMaterial(ent,i))
  end
  elf.SetEntityScale(ret, scale.x, scale.y, scale.z)
  elf.SetEntityPhysics(ret,elf.GetActorShape(ent),elf.GetActorMass(ent))
  return ret
end

-- set camera perspective for detect objects
function set_camera(cam)
  if elf.IsObject(cam) == true then
    local fov = elf.GetCameraFov(cam)
    local aspect = elf.GetCameraAspect(cam)
    local clip = elf.GetCameraClip(cam)
    if clip.x < 0.0001 then clip.x = 0.0001 end
    if clip.y < 100.0 then clip.y = 100.0 end
    elf.SetCameraPerspective(cam, fov, aspect, clip.x, clip.y)
  end
end

-- return objects over mouse of passed scene
function get_objects_over_mouse(scn)

  -- get active camero from passed scene
  local camera = elf.GetSceneActiveCamera(scn)
  
  -- get the ray starting position
  local raystart = elf.GetActorPosition(camera)

  -- next we calculate the end position of the ray
  local mouse_pos = elf.GetMousePosition()
  local wwidth = elf.GetWindowWidth()
  local wheight = elf.GetWindowHeight()
  local clip = elf.GetCameraClip(camera)
  local fpsize = elf.GetCameraFarPlaneSize(camera)

  local rayend = elf.CreateVec3f()
  rayend.x = mouse_pos.x/wwidth*fpsize.x-fpsize.x/2
  rayend.y = (wheight-mouse_pos.y)/wheight*fpsize.y-fpsize.y/2
  rayend.z = -clip.y

  -- now we have the end position of the ray, but we still have to positon and orient it according 
  -- to the camera
  local orient = elf.GetActorOrientation(camera)
  rayend = elf.MulQuaVec3f(orient, rayend)
  rayend = elf.AddVec3fVec3f(raystart, rayend)
  -- perform raycast
  local col = elf.GetSceneRayCastResults(scn, 
    raystart.x, raystart.y, raystart.z,
    rayend.x,   rayend.y,   rayend.z
  )
  
  if elf.IsObject(col) and elf.GetListLength(col) > 0 then
    ret = {}
    for i = 0,elf.GetListLength(col)-1,1 do
      ret[i+1] = elf.GetItemFromList(col,i)
    end
    return ret
  else
    return nil
  end
  
end

