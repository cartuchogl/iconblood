Option = class('Option')
Option:includes(EventDispatcher)

function Option:initialize(obj)
  print("initialize Option")
  _.extend(self,obj)
end


