-- 
-- Yuichi Tateno. <hotchpotch@N0!spam@gmail.com>
-- http://rails2u.com/
-- 
-- Carlos Bolaños aka cartuchogl
-- Port to lua
-- 
-- The MIT License
-- --------
-- Copyright (c) 2007 Yuichi Tateno.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

Tweener = class('Tweener')

function Tweener:initialize()
  self.looping= false
  self.frameRate= 60
  self.objects= {}
  self.defaultOptions= {
    time= 1,
    transition= 'easeoutexpo',
    delay= 0,
    prefix= {},
    suffix= {},
    onStart= nil,
    onStartParams= nil,
    onUpdate= nil,
    onUpdateParams= nil,
    onComplete= nil,
    onCompleteParams= nil
  }
  self.easingFunctionsLowerCase= {}
  for k,v in pairs(Tweener.easingFunctions) do
    self.easingFunctionsLowerCase[string.lower(k)] = Tweener.easingFunctions[k]
  end
end

function Tweener:addTween(obj, options)
  local this = self
  local o = {}
  o.target = obj;
  o.targetPropeties = {};

  for k,v in pairs(self.defaultOptions) do
    if (options[k] ~= nil) then
      o[k] = options[k]
      options[k] = nil
    else
      o[k] = self.defaultOptions[k]
    end
  end

  if (type(o.transition) == 'function') then
    o.easing = o.transition
  else
    o.easing = self.easingFunctionsLowerCase[string.lower(o.transition)]
  end

  for key,v in pairs(options) do
    if(type(v)~='function') then
      if (not o.prefix[key]) then o.prefix[key] = '' end
      if (not o.suffix[key]) then o.suffix[key] = '' end
      local ov = 0
      if type(obj['get'])=='function' then
        ov = obj:get(key)
      else
        ov = obj[key]
      end
      local sB = Tweener.toNumber(ov, o.prefix[key],  o.suffix[key])
      o.targetPropeties[key] = {
        b= sB,
        c= options[key] - sB
      }
    else
      o[key] = v
    end
  end

  setTimeout(function()
    o.startTime = getTime()
    o.endTime = o.time * 1000 + o.startTime;

    if (type(o.onStart) == 'function') then
      if (o.onStartParams) then
        _.curry(o.onStart,o)(o.onStartParams)
      else
        o.onStart()
      end
    end

    table.insert(this.objects,o)
    if (not this.looping) then 
      this.looping = true
      _.curry(Tweener.eventLoop,this)()
    end
  end, o.delay * 1000)
  return o
end
      
function Tweener:eventLoop()
  local now = getTime()
  local tmp = {}
  for i = 1,#self.objects,1 do
    local o = self.objects[i]
    local t = now - o.startTime
    local d = o.endTime - o.startTime

    if (t >= d) or o.canceled then
      if not o.canceled then
        for property,v in pairs(o.targetPropeties) do
          local tP = o.targetPropeties[property]
          pcall(function()
            local val = o.prefix[property] .. (tP.b + tP.c) .. o.suffix[property]
            if type(o.target['set'])=='function' then
              o.target:set(property,val)
            else
              o.target[property] = val
            end
          end)
        end
      end
      -- mark to eliminate
      table.insert(tmp,i)

      if (type(o.onUpdate) == 'function') then
        if (o.onUpdateParams) then
          _.curry(o.onUpdate,o)(o.onUpdateParams)
        else
          o.onUpdate()
        end
      end

      if (type(o.onComplete) == 'function') then
        if (o.onCompleteParams) then
          _.curry(o.onComplete,o)(o.onCompleteParams)
        else
          o.onComplete()
        end
      end
    else
      for property,v in pairs(o.targetPropeties) do
        local tP = o.targetPropeties[property]
        local val = o.easing(t, tP.b, tP.c, d)
        pcall(function()
          local tmp = o.prefix[property] .. val .. o.suffix[property]
          if type(o.target['set'])=='function' then
            o.target:set(property,tmp)
          else
            o.target[property] = tmp
          end
        end)
      end

      if (type(o.onUpdate) == 'function') then
        if (o.onUpdateParams) then
          _.curry(o.onUpdate,o)(o.onUpdateParams)
        else
          o.onUpdate()
        end
      end
    end
  end
  -- eliminate marked
  _.each(_.reverse(tmp),function(i) table.remove(self.objects,i) end)
  
  if (#self.objects > 0) then
    local this = self
    setTimeout(function() this:eventLoop() end, 1000/this.frameRate)
  else
    self.looping = false
  end
end

Tweener.toNumber = function(value, prefix, suffix)
  -- for style
  if (not suffix) then suffix = 'px' end
  if string.match(tostring(value),"[0-9]") then
    local kk = string.gsub(
      string.gsub(
        tostring(value), suffix.."$", ''
      ),"^"..(prefix and prefix or ''),''
    )
  return tonumber(
    kk
  )
  else return 0 end
end

Tweener.Utils = {
  bezier2= function(t, p0, p1, p2)
    return (1-t) * (1-t) * p0 + 2 * t * (1-t) * p1 + t * t * p2;
  end,
  bezier3= function(t, p0, p1, p2, p3)
    return math.pow(1-t, 3) * p0 + 3 * t * math.pow(1-t, 2) * p1 + 3 * t * t * (1-t) * p2 + t * t * t * p3;
  end
}

-- 
-- Tweener.easingFunctions is
-- Tweener's easing functions (Penner's Easing Equations) porting to JavaScript.
-- http://code.google.com/p/tweener/
-- 

Tweener.easingFunctions = {
  easeNone= function(t, b, c, d)
    return c*t/d + b
  end,    
  easeInQuad= function(t, b, c, d)
    t=t/d
    return c*t*t + b
  end,    
  easeOutQuad= function(t, b, c, d)
    t=t/d
    return -c*t*(t-2) + b
  end,    
  easeInOutQuad= function(t, b, c, d)
    t=t/d/2
    if t < 1 then return c/2*t*t + b end
    t = t-1
    return -c/2 *((t)*(t-2) - 1) + b
  end,    
  easeInCubic= function(t, b, c, d)
    t=t/d
    return c*t*t*t + b
  end,    
  easeOutCubic= function(t, b, c, d)
    t=t/d-1
    return c*(t*t*t + 1) + b
  end,    
  easeInOutCubic= function(t, b, c, d)
    t=t/d/2
    if t < 1 then return c/2*t*t*t + b end
    t=t-2
    return c/2*(t*t*t + 2) + b
  end,    
  easeOutInCubic= function(t, b, c, d)
    if (t < d/2) then return Tweener.easingFunctions.easeOutCubic(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInCubic((t*2)-d, b+c/2, c/2, d)
  end,    
  easeInQuart= function(t, b, c, d)
    t=t/d
    return c*t*t*t*t + b
  end,    
  easeOutQuart= function(t, b, c, d)
    t=t/d-1
    return -c *(t*t*t*t - 1) + b
  end,    
  easeInOutQuart= function(t, b, c, d)
    t=t/d/2
    if t < 1 then return c/2*t*t*t*t + b end
    t=t-2
    return -c/2 *(t*t*t*t - 2) + b
  end,    
  easeOutInQuart= function(t, b, c, d)
    if (t < d/2) then return Tweener.easingFunctions.easeOutQuart(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInQuart((t*2)-d, b+c/2, c/2, d)
  end,    
  easeInQuint= function(t, b, c, d)
    t=t/d
    return c*t*t*t*t*t + b
  end,    
  easeOutQuint= function(t, b, c, d)
    t=t/d-1
    return c*(t*t*t*t*t + 1) + b
  end,    
  easeInOutQuint= function(t, b, c, d)
    t=t/d/2
    if t < 1 then return c/2*t*t*t*t*t + b end
    t=t-2
    return c/2*(t*t*t*t*t + 2) + b
  end,    
  easeOutInQuint= function(t, b, c, d)
    if (t < d/2) then return Tweener.easingFunctions.easeOutQuint(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInQuint((t*2)-d, b+c/2, c/2, d)
  end,    
  easeInSine= function(t, b, c, d)
    return -c * math.cos(t/d *(math.pi/2)) + c + b
  end,    
  easeOutSine= function(t, b, c, d)
    return c * math.sin(t/d *(math.pi/2)) + b
  end,
  easeInOutSine= function(t, b, c, d)
    return -c/2 *(math.cos(math.pi*t/d) - 1) + b
  end,    
  easeOutInSine= function(t, b, c, d)
    if (t < d/2) then return Tweener.easingFunctions.easeOutSine(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInSine((t*2)-d, b+c/2, c/2, d)
  end,    
  easeInExpo= function(t, b, c, d)
    return t==0 and b or c * math.pow(2, 10 *(t/d - 1)) + b - c * 0.001
  end,    
  easeOutExpo= function(t, b, c, d)
    return t==d and b+c or c * 1.001 *(-math.pow(2, -10 * t/d) + 1) + b
  end,    
  easeInOutExpo= function(t, b, c, d)
    if (t==0) then return b end
    if (t==d) then return b+c end
    t=t/d/2
    if (t) < 1 then return c/2 * math.pow(2, 10 *(t - 1)) + b - c * 0.0005 end
    t = t-1
    return c/2 * 1.0005 *(-math.pow(2, -10 * t) + 2) + b
  end,    
  easeOutInExpo= function(t, b, c, d)
    if (t < d/2) then return Tweener.easingFunctions.easeOutExpo(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInExpo((t*2)-d, b+c/2, c/2, d)
  end,    
  easeInCirc= function(t, b, c, d)
    t=t/d
    return -c *(math.sqrt(1 -(t)*t) - 1) + b
  end,    
  easeOutCirc= function(t, b, c, d)
    t=t/d-1
    return c * math.sqrt(1 -(t)*t) + b
  end,    
  easeInOutCirc= function(t, b, c, d)
    t=t/d/2
    if (t) < 1 then return -c/2 *(math.sqrt(1 - t*t) - 1) + b end
    t=t-2
    return c/2 *(math.sqrt(1 -(t)*t) + 1) + b
  end,    
  easeOutInCirc= function(t, b, c, d)
    if (t < d/2) then return Tweener.easingFunctions.easeOutCirc(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInCirc((t*2)-d, b+c/2, c/2, d)
  end,    
  easeInElastic= function(t, b, c, d, a, p)
    local s
    if (t==0) then return b end
    t=t/d
    if (t)==1 then return b+c end
    if not p then p=d*.3 end
    if (not a or a < math.abs(c)) then a,s=c,p/4 else s = p/(2*math.pi) * math.asin(c/a) end
    t=t-1
    return -(a*math.pow(2,10*(t)) * math.sin((t*d-s)*(2*math.pi)/p )) + b
  end,    
  easeOutElastic= function(t, b, c, d, a, p)
    local s
    if t==0 then return b end
    t=t/d
    if (t)==1 then return b+c end
    if not p then p=d*.3 end
    if(not a or a < math.abs(c)) then a,s=c,p/4 else s = p/(2*math.pi) * math.asin(c/a) end
    return(a*math.pow(2,-10*t) * math.sin((t*d-s)*(2*math.pi)/p ) + c + b)
  end,    
  easeInOutElastic= function(t, b, c, d, a, p)
    local s
    if t==0 then return b end
    t=t/d/2
    if (t)==2 then return b+c end
    if not p then p=d*(.3*1.5) end
    if (not a or a < math.abs(c)) then a,s=c,p/4 else s = p/(2*math.pi) * math.asin(c/a) end
    if (t < 1) then 
      t=t-1
      return -.5*(a*math.pow(2,10*(t)) * math.sin((t*d-s)*(2*math.pi)/p )) + b
    end
    t=t-1
    return a*math.pow(2,-10*(t)) * math.sin((t*d-s)*(2*math.pi)/p )*.5 + c + b
  end,    
  easeOutInElastic= function(t, b, c, d, a, p)
    if (t < d/2) then return Tweener.easingFunctions.easeOutElastic(t*2, b, c/2, d, a, p) end
    return Tweener.easingFunctions.easeInElastic((t*2)-d, b+c/2, c/2, d, a, p)
  end,    
  easeInBack= function(t, b, c, d, s)
    if(s == nil) then s = 1.70158 end
    t=t/d
    return c*(t)*t*((s+1)*t - s) + b
  end,    
  easeOutBack= function(t, b, c, d, s)
    if(s == nil) then s = 1.70158 end
    t=t/d-1
    return c*((t)*t*((s+1)*t + s) + 1) + b
  end,    
  easeInOutBack= function(t, b, c, d, s)
    if(s == nil) then s = 1.70158 end
    t=t/d/2
    if((t) < 1) then 
      s=s*(1.525)
      return c/2*(t*t*(((s)+1)*t - s)) + b 
    end
    t=t-2
    s=s*(1.525)
    return c/2*((t)*t*(((s)+1)*t + s) + 2) + b
  end,    
  easeOutInBack= function(t, b, c, d, s)
    if(t < d/2) then return Tweener.easingFunctions.easeOutBack(t*2, b, c/2, d, s) end
    return Tweener.easingFunctions.easeInBack((t*2)-d, b+c/2, c/2, d, s)
  end,    
  easeInBounce= function(t, b, c, d)
    return c - Tweener.easingFunctions.easeOutBounce(d-t, 0, c, d) + b
  end,    
  easeOutBounce= function(t, b, c, d)
    t=t/d
    if((t) <(1/2.75)) then
        return c*(7.5625*t*t) + b
    elseif(t <(2/2.75)) then
        t=t-(1.5/2.75)
        return c*(7.5625*(t)*t + .75) + b
    elseif(t <(2.5/2.75)) then
        t=t-(2.25/2.75)
        return c*(7.5625*(t)*t + .9375) + b
    else
        t=t-(2.625/2.75)
        return c*(7.5625*(t)*t + .984375) + b
    end
  end,    
  easeInOutBounce= function(t, b, c, d)
    if(t < d/2) then return Tweener.easingFunctions.easeInBounce(t*2, 0, c, d) * .5 + b
    else return Tweener.easingFunctions.easeOutBounce(t*2-d, 0, c, d) * .5 + c*.5 + b end
  end,    
  easeOutInBounce= function(t, b, c, d)
    if(t < d/2) then return Tweener.easingFunctions.easeOutBounce(t*2, b, c/2, d) end
    return Tweener.easingFunctions.easeInBounce((t*2)-d, b+c/2, c/2, d)
  end
}

Tweener.easingFunctions.linear = Tweener.easingFunctions.easeNone

tweener = Tweener()