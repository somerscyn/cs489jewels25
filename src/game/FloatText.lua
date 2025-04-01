local Class = require "libs.hump.class"
local Timer = require "libs.hump.timer"
local tween = require "libs.tween"

local FloatText = Class{}
function FloatText:init(text,x,y)
    self.x = x
    self.y = y
    self.text = text
    self.tweenObj = nil
end

function FloatText:tween(newX,newY)
    self.tweenObj = tween.new(1,self,{x=newX,y=newY})
end

function FloatText:draw()
    love.graphics.print(self.text, self.x, self.y)
end

function FloatText:update(dt)
    if self.tweenObj then
        self.tweenObj:update(dt) 
    end
end

return FloatText