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

-- normalize elf_vec3f, if pass a second param then return the vector scaled to that length
function normalize(v,...)
  local n = elf.CreateVec3f()
  local a = math.sqrt(v.x*v.x+v.y*v.y+v.z*v.z)
  if #arg>=1 then
    q = arg[1]
  else
    q=1
  end
  n.x = v.x/a*q
  n.y = v.y/a*q
  n.z = v.z/a*q
  return n
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
    return col
  else
    return nil
  end
  
end