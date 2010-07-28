EventDispatcher = {
  included = function(class)
  end
}

function EventDispatcher:addEvent(type,fn)
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
  return self
end

function EventDispatcher:addEvents(events)
  return self
end

function EventDispatcher:removeEvents(events)
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
