Unit = class('Unit')
Unit:includes(EventDispatcher)

function Unit:initialize(obj)
  print("initialize Unit")
  _.extend(self,obj)
  _.each(_.keys(self),function(i) print(i,self[i]) end)
  if self.options then
    local tmp = self.options
    self.options = _.map(tmp,function(i) return Option(i) end)
  end
end

