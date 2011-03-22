Request = class('Request',ElfObject)
Request._instance_count = 0
Request._waiting = {}
Request._current = nil
Request._initiliaze = false;

Request._onframe = function()
  if GetRequestState()==0 then
    if Request._current then
      Request._current.response = ""
      local fh = io.open("tmp-response.txt","r")
      while true do
        local line = fh.read(fh)
        if not line then break end
        Request._current.response = Request._current.response .. line
      end
      
      Request._current.headers = ""
      fh = io.open("tmp-headers.txt","r")
      while true do
        local line = fh.read(fh)
        if not line then break end
        Request._current.headers = Request._current.headers .. line
      end
      Request._current:fireEvent("completed",Request._current,100)
      Request._current = nil
    elseif #Request._waiting>0 then
      table.remove(Request._waiting,1):send()
    end
  else
    -- request waiting
  end
end

function Request:initialize(options)
  if not Request._initiliaze then
    game:addEvent("onframe",Request._onframe)
    Request._initiliaze = true
  end
    
  Request._instance_count = Request._instance_count + 1
  super.initialize(self,REQUEST,'Request_'..Request._instance_count,options)
end

function Request:send(options)
  if GetRequestState()==0 and not Request._current then
    SendRequest(self._elf_obj)
    Request._current = self
    self:fireEvent("start",self)
  else
    Request._waiting[#Request._waiting+1] = self
  end
end
