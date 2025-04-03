local Class = require "libs.hump.class"
local Timer = require "libs.hump.timer"
local tween = require "libs.tween"

local comboText = Class{}
function comboText:init(text,x,y)
    self.x = x
    self.y = y
    self.text = text
    self.tweenObj = nil
end

function comboText:draw()
    -- Draw the black text
    love.graphics.setColor(0, 0, 0, 1) -- RGBA (1 = fully opaque)
    love.graphics.print(self.text, self.x, self.y, 0, 2,2)
    love.graphics.setColor(1, 1, 1, 1) -- RGBA (1 = fully opaque)

end

function comboText:tween(newY)
    oldY = self.y -- store the old Y position
    self.tweenObj = tween.new(1,self,{y=newY})
    self.tweenObj = tween.new(1,self,{y=oldY})
end

return comboText