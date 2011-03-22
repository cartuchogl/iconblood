EventDispatcher = {
  included = function(class)
  end
}

function EventDispatcher:addEvent(type,fn,...)
  local fn = arg[1] and _.curry(fn,arg[1]) or fn
  
  if not self._events then
    self._events = {}
  end
  if not self._events[type] then
    self._events[type] = {fn}
  else
    table.insert(self._events[type],fn)
  end
  return self
end

function EventDispatcher:removeEvent(type,fn)
  if self._events then
    if self._events[type] then
      local indx = table.find(self._events[type],fn)
      if indx then
        return fn == table.remove(self._events[type],indx)
      end
    end
  end
  return false
end

function EventDispatcher:addEvents(events)
  for k,v in pairs(events) do
    self:addEvent(k,v)
  end
  return self
end

function EventDispatcher:removeEvents(events)
  for k,v in pairs(events) do
    self:removeEvent(k,v)
  end
  return self
end

function EventDispatcher:fireEvent(etype, args, delay)
  if self._events and self._events[etype] then
    if type(delay)=='number' and delay>0 then
      _.each(self._events[etype],function(i) setTimeout(function() i(args) end,delay) end)
    else
      _.each(self._events[etype],function(i) i(args) end)
    end
  end
  return self
end
