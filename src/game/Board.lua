local Class = require "libs.hump.class"
local Matrix = require "libs.matrix"
local Tween = require "libs.tween"

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
    self:fixInitialMatrix()

    self.tweenGem1 = nil
    self.tweenGem2 = nil
end

function Board:createGem(row,col)
    return Gem(self.x+(col-1)*Board.TILESIZE,
               self.y+(row-1)*Board.TILESIZE,
               math.random(4,8) )
end

function Board:fixInitialMatrix()
    -- First we check horizontally
    for i = 1, Board.MAXROWS do
        local same = 1 
        for j = 2, Board.MAXCOLS do -- pay attention: starts as j=2
            if self.tiles[i][j].type == self.tiles[i][j-1].type then
                same = same+1 -- counting same types
                if same == 3 then -- match 3, fix it
                    self.tiles[i][j]:nextType()
                    same = 1
                end
            else
                same = 1
            end
        end
    end    

    -- Second we check vertically
    for j = 1, Board.MAXCOLS do -- pay attention: first loop is j
        local same = 1 
        for i = 2, Board.MAXROWS do -- second loop is i
            if self.tiles[i][j].type == self.tiles[i-1][j].type then
                same = same+1 -- counting same types
                if same == 3 then -- match 3, fix it
                    self.tiles[i][j]:nextType()
                    same = 1
                end
            else
                same = 1
            end
        end
    end    
end    

function Board:update(dt)
    for i=1, Board.MAXROWS do
        for j=1, Board.MAXCOLS do
            if self.tiles[i][j] then -- tile is not nil
                self.tiles[i][j]:update(dt)
            end -- end if
        end -- end for j
    end -- end for i

    if self.tweenGem1 ~= nil and self.tweenGem2~=nil then
        local completed1 = self.tweenGem1:update(dt)
        local completed2 = self.tweenGem2:update(dt)
        if completed1 and completed2 then
            self.tweenGem1 = nil
            self.tweenGem2 = nil
            local temp = self.tiles[mouseRow][mouseCol]
            self.tiles[mouseRow][mouseCol] = self.tiles[self.cursor.row][self.cursor.col]
            self.tiles[self.cursor.row][self.cursor.col] = temp
            self.cursor:clear()
        end
    end
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

function Board:cheatGem(x,y)
    if x > self.x and y > self.y 
       and x < self.x+Board.MAXCOLS*Board.TILESIZE
       and y < self.y+Board.MAXROWS*Board.TILESIZE then
        -- Click inside the board coords
        local cheatRow,cheatCol = self:convertPixelToMatrix(x,y)
        self.tiles[cheatRow][cheatCol]:nextType()
    end
end

function Board:mousepressed(x,y)
    if x > self.x and y > self.y 
       and x < self.x+Board.MAXCOLS*Board.TILESIZE
       and y < self.y+Board.MAXROWS*Board.TILESIZE then
        -- Click inside the board coords
        mouseRow, mouseCol = self:convertPixelToMatrix(x,y)

        if self.cursor.row == mouseRow and self.cursor.col == mouseCol then
            self.cursor:clear()
        elseif self:isAdjacentToCursor(mouseRow,mouseCol) then
            -- adjacent click, swap gems
            self:tweenStartSwap(mouseRow,mouseCol,self.cursor.row,self.cursor.col)
        else -- sets cursor to clicked place
            self.cursor:setCoords(self.x+(mouseCol-1)*Board.TILESIZE,
                    self.y+(mouseRow-1)*Board.TILESIZE)
            self.cursor:setMatrixCoords(mouseRow,mouseCol)
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

function Board:tweenStartSwap(row1,col1,row2,col2)
    local x1 = self.tiles[row1][col1].x
    local y1 = self.tiles[row1][col1].y

    local x2 = self.tiles[row2][col2].x
    local y2 = self.tiles[row2][col2].y

    self.tweenGem1 = Tween.new(0.3,self.tiles[row1][col1],{x = x2, y = y2})
    self.tweenGem2 = Tween.new(0.3,self.tiles[row2][col2],{x = x1, y = y1})
end

return Board