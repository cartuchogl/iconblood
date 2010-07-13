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