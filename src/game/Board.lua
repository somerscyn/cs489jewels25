local Class = require "libs.hump.class"
local Matrix = require "libs.matrix"

local Gem = require "src.game.Gem"
local Cursor = require "src.game.Cursor"

local Board = Class{}
Board.MAXROWS = 8
Board.MAXCOLS = 8
Board.TILESIZE = Gem.SIZE*Gem.SCALE 
function Board:init(x,y)
    self.x = x
    self.y = y
    self.cursor = Cursor(self.x,self.y,Board.TILESIZE+1)

    self.tiles = Matrix:new(Board.MAXROWS,Board.MAXCOLS)
    for i=1, Board.MAXROWS do
        for j=1, Board.MAXCOLS do
            self.tiles[i][j] = self:createGem(i,j)
        end -- end for j
    end -- end for i
end

function Board:createGem(row,col)
    return Gem(self.x+(col-1)*Board.TILESIZE,
               self.y+(row-1)*Board.TILESIZE,
               math.random(4,8) )
end

function Board:update(dt)
    for i=1, Board.MAXROWS do
        for j=1, Board.MAXCOLS do
            if self.tiles[i][j] then -- tile is not nil
                self.tiles[i][j]:update(dt)
            end -- end if
        end -- end for j
    end -- end for i
end

function Board:draw()
    for i=1, Board.MAXROWS do
        for j=1, Board.MAXCOLS do
            if self.tiles[i][j] then -- tile is not nil
                self.tiles[i][j]:draw()
            end -- end if
        end -- end for j
    end -- end for i

    self.cursor:draw()
end

function Board:mousepressed(x,y)
    if x > self.x and y > self.y 
       and x < self.x+Board.MAXCOLS*Board.TILESIZE
       and y < self.y+Board.MAXROWS*Board.TILESIZE then
        -- Click inside the board coords
        local row, col = self:convertPixelToMatrix(x,y)

        if self.cursor.row == row and self.cursor.col == col then
            self.cursor:clear()
        elseif self:isAdjacentToCursor(row,col) then
            local temp = self.tiles[row][col]
            local tx = self.tiles[row][col].x
            local ty = self.tiles[row][col].y

            self.tiles[row][col].x = self.tiles[self.cursor.row][self.cursor.col].x
            self.tiles[row][col].y = self.tiles[self.cursor.row][self.cursor.col].y
            self.tiles[row][col] = self.tiles[self.cursor.row][self.cursor.col]

            self.tiles[self.cursor.row][self.cursor.col].x = tx
            self.tiles[self.cursor.row][self.cursor.col].y = ty
            self.tiles[self.cursor.row][self.cursor.col] = temp

        else
            self.cursor:setCoords(self.x+(col-1)*Board.TILESIZE,
                    self.y+(row-1)*Board.TILESIZE)
            self.cursor:setMatrixCoords(row,col)
        end
    
    end -- end if

end

function Board:isAdjacentToCursor(row,col)
    local adjCol = self.cursor.row == row 
       and (self.cursor.col == col+1 or self.cursor.col == col-1)
    local adjRow = self.cursor.col == col 
       and (self.cursor.row == row+1 or self.cursor.row == row-1)
    return adjCol or adjRow
end

function Board:convertPixelToMatrix(x,y)
    local col = 1+math.floor((x-self.x)/Board.TILESIZE)
    local row = 1+math.floor((y-self.y)/Board.TILESIZE)
    return row,col 
end

return Board