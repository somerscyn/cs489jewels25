local Class = require "libs.hump.class"
local Matrix = require "libs.matrix"

local Gem = require "src.game.Gem"

local Board = Class{}
Board.MAXROWS = 8
Board.MAXCOLS = 8
function Board:init(x,y)
    self.x = x
    self.y = y

    self.tiles = Matrix:new(Board.MAXROWS,Board.MAXCOLS)
    for i=0, Board.MAXROWS do
        for j=0, Board.MAXCOLS do
            self.tiles[i][j] = self:createGem(i,j)
        end -- end for j
    end -- end for i
end

function Board:createGem(row,col)

end

return Board