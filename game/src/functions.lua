settimeout_table = {}

-- this function must be call on render loop for setTimeout
function setTimeoutLaunch()
  local now = getTime()
  local tmp = {}
  for i=1,#settimeout_table do
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
  return math.ceil(GetTime()*1000)
end

-- if found expreg in directory on path return full path otherside return false
function findPath(path,expreg)
  local kk = ReadDirectory(path)
  local l = GetDirectoryItemCount(kk)
  for i = 0,l-1 do
    local object = GetDirectoryItem(kk, i)
    local name = GetDirectoryItemName(object)
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

-- return a ElfList as lua array
function array_from_list(list)
  ret = {}
  if list and GetListLength(list) > 0 then
    for i = 0,GetListLength(list)-1 do
      ret[i+1] = GetListObject(list,i)
    end
  end
  return ret
end

-- normalize elf_vec3f, if pass a second param then return the vector scaled to that length
function normalize(v,size)
  local n = CreateVec3f(0,0,0)
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

-- normalize elf_vec2f, if pass a second param then return the vector scaled to that length
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
  local scale =  GetEntityScale(ent)
  local ret = CreateEntity(new_name)
  local armature = GetEntityArmature(ent)
  SetEntityModel(ret,GetEntityModel(ent))
  if armature then SetEntityArmature(ret,armature) end
  for i=0,GetEntityMaterialCount(ent)-1 do
    SetEntityMaterial(ret,i,GetEntityMaterial(ent,i))
  end
  SetEntityScale(ret, scale.x, scale.y, scale.z)
  SetActorPhysics(ret,true)
  SetActorShape(ret,GetActorShape(ent))
  SetActorMass(ret,GetActorMass(ent))
  return ret
end

-- return a copy of material
function duplicate_material(mat,new_name)
  local ret = CreateMaterial(new_name)
  local d = GetMaterialDiffuseColor( mat )
  local s = GetMaterialSpecularColor( mat )
  local a = GetMaterialAmbientColor( mat )
  local power = GetMaterialSpecularPower( mat )
  local lighting = GetMaterialLighting( mat )
  
  SetMaterialDiffuseColor( ret, d.r, d.g, d.b, d.a )
  SetMaterialSpecularColor( ret, s.r, s.g, s.b, s.a )
  SetMaterialAmbientColor( ret, a.r, a.g, a.b, a.a )
  SetMaterialSpecularPower( ret, power )
  SetMaterialLighting( ret, lighting )
  
  local difusse = GetMaterialDiffuseMap(mat)
  if difusse then
    SetMaterialDiffuseMap(ret,difusse)
  end
  return ret
end

-- set camera perspective for detect objects
function set_camera(cam)
  if cam then
    local fov = GetCameraFov(cam)
    local aspect = GetCameraAspect(cam)
    local clip = GetCameraClip(cam)
    if clip.x < 0.0001 then clip.x = 0.0001 end
    if clip.y < 100.0 then clip.y = 100.0 end
    SetCameraMode(cam,PERSPECTIVE)
    SetCameraFov(cam,fov)
    SetCameraAspect(cam,aspect)
    SetCameraClip(cam,clip.x,clip.y)
  end
end

-- return objects over mouse of passed scene
function get_objects_over_mouse(scn)

  -- get active camero from passed scene
  local camera = GetSceneActiveCamera(scn)
  
  -- get the ray starting position
  local raystart = GetActorPosition(camera)

  -- next we calculate the end position of the ray
  local mouse_pos = GetMousePosition()
  local wwidth = GetWindowWidth()
  local wheight = GetWindowHeight()
  local clip = GetCameraClip(camera)
  local fpsize = GetCameraFarPlaneSize(camera)

  local rayend = CreateVec3f(0,0,0)
  rayend.x = mouse_pos.x/wwidth*fpsize.x-fpsize.x/2
  rayend.y = (wheight-mouse_pos.y)/wheight*fpsize.y-fpsize.y/2
  rayend.z = -clip.y

  -- now we have the end position of the ray, but we still have to positon and orient it according 
  -- to the camera
  local orient = GetActorOrientation(camera)
  rayend = MulQuaVec3f(orient, rayend)
  rayend = AddVec3fVec3f(raystart, rayend)
  -- perform raycast
  local col = GetSceneRayCastResults(scn, 
    raystart.x, raystart.y, raystart.z,
    rayend.x,   rayend.y,   rayend.z
  )
  return array_from_list(col)
end

-- calculate a dice launch as for 2d6
-- val can be nil normal launch, 'max' for the max possible result and 'min' for the min result
function calculate_token(str,val)
  local ret = 0
  local pos = string.find(str,'d')
  if pos then
    local i = tonumber(string.sub(str,1,pos-1))
    local t = tonumber(string.sub(str,pos+1))
    for j=1,i do
      if val and val == 'max' then
        ret = ret + t
      elseif val and val == 'min' then
        ret = ret + 1
      else
        ret = ret + math.random(t)
      end
    end
  else
    ret = tonumber(str)
  end
  return ret
end

-- calculate a string with for as 10+2d6-1d4
-- use calculate_token params
function calculate_string(str,val)
  local ret = {}
  local pos = string.find(str,'[+-]')
  while pos do
    ret[#ret+1] = calculate_token(string.sub(str,1,pos-1),val)
    ret[#ret+1] = string.sub(str,pos,pos)
    str = string.sub(str,pos+1)
    pos = string.find(str,'[+-]')
  end
  if string.len(str)>0 then
    ret[#ret+1] = calculate_token(str,val)
  end
  local final = 0
  local mod = 1
  _.each(ret,function(i)
    if type(tonumber(i)) == "number" then
      final = final + mod*i
    elseif i == '+' then
      mod = 1
    elseif i == '-' then
      mod = -1
    end
  end)
  return final
end

function distance(v1,v2)
  return math.sqrt((v1.x-v2.x)^2+(v1.y-v2.y)^2+(v1.z-v2.z)^2)
end

-- from http://otfans.net/showthread.php?112204-table.find-%28matching-isInArray%29
FIND_NOCASE = 0
FIND_PATTERN = 1
FIND_PATTERN_NOCASE = 2
-- Function by Colandus 
function table.find(t, v, c)
  if type(t) == "table" and v then
    v = (c==0 or c==2) and v:lower() or v
    for k, val in pairs(t) do
      val = (c==0 or c==2) and val:lower() or val
      if (c==1 or c==2) and val:find(v) or v == val then 
        return k
      end 
    end 
  end 
  return false 
end

