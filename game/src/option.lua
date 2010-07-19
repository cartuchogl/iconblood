Option = class('Option')
Option:includes(EventDispatcher)

function Option:initialize(obj)
  _.extend(self,obj)
end


