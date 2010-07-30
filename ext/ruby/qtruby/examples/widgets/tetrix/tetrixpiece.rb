=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.trolltech.com/products/qt/opensource.html
**
** If you are unsure which license is appropriate for your use, please
** review the following information:
** http://www.trolltech.com/products/qt/licensing.html or contact the
** sales department at sales@trolltech.com.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**

** Translated to QtRuby by Richard Dale
=end
    
class TetrixPiece
    
    NoShape = 0
    ZShape = 1
    SShape = 2
    LineShape = 3
    TShape = 4
    SquareShape = 5
    LShape = 6
    MirroredLShape = 7
    
    def initialize()
        @coordsTable = [
            [ [ 0, 0 ],   [ 0, 0 ],   [ 0, 0 ],   [ 0, 0 ] ],
            [ [ 0, -1 ],  [ 0, 0 ],   [ -1, 0 ],  [ -1, 1 ] ],
            [ [ 0, -1 ],  [ 0, 0 ],   [ 1, 0 ],   [ 1, 1 ] ],
            [ [ 0, -1 ],  [ 0, 0 ],   [ 0, 1 ],   [ 0, 2 ] ],
            [ [ -1, 0 ],  [ 0, 0 ],   [ 1, 0 ],   [ 0, 1 ] ],
            [ [ 0, 0 ],   [ 1, 0 ],   [ 0, 1 ],   [ 1, 1 ] ],
            [ [ -1, -1 ], [ 0, -1 ],  [ 0, 0 ],   [ 0, 1 ] ],
            [ [ 1, -1 ],  [ 0, -1 ],  [ 0, 0 ],   [ 0, 1 ] ] ]
        @coords = [[0, 0], [0, 0], [0, 0], [0, 0]]

        self.shape = NoShape
    end

    def shape() return @pieceShape end
    def x(index) return @coords[index][0] end
    def y(index) return @coords[index][1] end

    def setX(index, x) @coords[index][0] = x end
    def setY(index, y) @coords[index][1] = y end
    
    def setRandomShape()
        self.shape = Kernel.rand(7) + 1
    end
    
    def shape=(shape)
        (0...4).each do |i|
            (0...2).each do |j|
                @coords[i][j] = @coordsTable[shape][i][j]
            end
        end
        @pieceShape = shape
    end
    
    def pieceShape=(shape)
        @pieceShape = shape
    end

    def minX()
        min = @coords[0][0]
        (1...4).each do |i|
            min = [min, @coords[i][0]].min
        end
        return min
    end
    
    def maxX()
        max = @coords[0][0]
        (1...4).each do |i|
            max = [max, @coords[i][0]].max
        end
        return max
    end
    
    def minY()
        min = @coords[0][1]
        (1...4).each do |i|
            min = [min, @coords[i][1]].min
        end
        return min
    end
    
    def maxY()
        max = @coords[0][1]
        (1...4).each do |i|
            max = [max, @coords[i][1]].max
        end
        return max
    end
    
    def rotatedLeft()
        if @pieceShape == SquareShape
            return self
        end
    
        result = TetrixPiece.new
        result.pieceShape = @pieceShape
        (0...4).each do |i|
            result.setX(i, y(i))
            result.setY(i, -x(i))
        end
        return result
    end
    
    def rotatedRight()
        if @pieceShape == SquareShape
            return self
        end
    
        result = TetrixPiece.new
        result.pieceShape = @pieceShape
        (0...4).each do |i|
            result.setX(i, -y(i))
            result.setY(i, x(i))
        end
        return result
    end
end
