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

function EventDispatcher:fireEvent(type, args, delay)
  if self._events and self._events[type] then
    _.each(self._events[type],function(i) i(args) end)
  end
  return self
end
