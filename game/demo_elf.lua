Game = class('Game',BaseGame)

function Game:initialize()
  super.initialize(self,gui,loader)
end

game = Game(gui,loader)

loader:addEvent("endbatch",function(args)
  demo_button = ElfObject(BUTTON,"demo_btn",{
    Text = "Push me",
    parent = gui,
    Size = {100, 50},
    events = {
      click = function(args)
        local tween
        local request = Request({
          Url = "http://www.google.com",
          Method = "GET",
          events = {
            completed = function(args)
              tween.canceled = true,
              print(args.response)
            end,
            start = function(args)
              tween = tweener:addTween(demo_button,{
                x = GetWindowWidth() - 100,
                y = GetWindowHeight() - 50,
                time = 6,
                transition = 'easeOutQuad'
              })
            end
          }
        })
        request:send()
      end
    }
  })
end)