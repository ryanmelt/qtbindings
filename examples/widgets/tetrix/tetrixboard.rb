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
    
require './tetrixpiece.rb'

class TetrixBoard < Qt::Frame
    
    slots 'start()', 'pause()'
    
    signals 'scoreChanged(int)', 'levelChanged(int)', 'linesRemovedChanged(int)'
    
    BoardWidth = 10
    BoardHeight = 22
    
    def initialize(parent = nil)
        super(parent)
        setFrameStyle(Qt::Frame::Panel | Qt::Frame::Sunken)
        setFocusPolicy(Qt::StrongFocus)
        @isStarting = false
        @isPaused = false
        @board = []
        clearBoard()
    
        @curPiece = TetrixPiece.new
        @nextPiece = TetrixPiece.new
        @nextPiece.setRandomShape()
        @timer = Qt::BasicTimer.new
    end

    def shapeAt(x, y)
        return @board[(y * BoardWidth) + x]
    end

    def setShapeAt(x, y, shape)
        @board[(y * BoardWidth) + x] = shape
    end

    def timeoutTime() return 1000 / (1 + @level) end
    def squareWidth() return contentsRect().width() / BoardWidth end
    def squareHeight() return contentsRect().height() / BoardHeight end

    def nextPieceLabel=(label)
        @nextPieceLabel = label
    end
    
    def sizeHint()
        return Qt::Size.new(BoardWidth * 15 + frameWidth() * 2,
                      15 + frameWidth() * 2)
    end
    
    def minimumSizeHint()
        return Qt::Size.new(BoardWidth * 5 + frameWidth() * 2,
                      5 + frameWidth() * 2)
    end
    
    def start()
        if @isPaused
            return
        end
    
        @isStarting = true
        @isWaitingAfterLine = false
        @numLinesRemoved = 0
        @numPiecesDropped = 0
        @score = 0
        @level = 1
        clearBoard()
    
        emit linesRemovedChanged(@numLinesRemoved)
        emit scoreChanged(@score)
        emit levelChanged(@level)
    
        newPiece()
        @timer.start(timeoutTime(), self)
    end
    
    def pause()
        if !@isStarting
            return
        end
    
        @isPaused = !@isPaused
        if @isPaused
            @timer.stop()
        else
            @timer.start(timeoutTime(), self)
        end
        update()
    end
    
    def paintEvent(e)
        painter = Qt::Painter.new(self)
        rect = contentsRect()
    
        drawFrame(painter)
    
        if @isPaused
            painter.drawText(rect, Qt::AlignCenter, tr("Pause"))
            painter.end
            return
        end
    
        boardTop = rect.bottom() - BoardHeight*squareHeight()
    
        (0...BoardHeight).each do |i|
            (0...BoardWidth).each do |j|
                shape = shapeAt(j, BoardHeight - i - 1)
                if shape != TetrixPiece::NoShape
                    drawSquare(painter, rect.left() + j * squareWidth(),
                               boardTop + i * squareHeight(), shape)
                end
            end
        end
    
        if @curPiece.shape() != TetrixPiece::NoShape
            (0...4).each do |i|
                x = @curX + @curPiece.x(i)
                y = @curY - @curPiece.y(i)
                drawSquare(painter, rect.left() + x * squareWidth(),
                           boardTop + (BoardHeight - y - 1) * squareHeight(),
                           @curPiece.shape())
            end
        end
        painter.end
    end
    
    def keyPressEvent(event)
        if !@isStarting || @isPaused || @curPiece.shape == TetrixPiece::NoShape
            super
            return
        end
    
        case event.key
        when Qt::Key_Left:
            tryMove(@curPiece, @curX - 1, @curY)
        when Qt::Key_Right:
            tryMove(@curPiece, @curX + 1, @curY)
        when Qt::Key_Down:
            tryMove(@curPiece.rotatedRight, @curX, @curY)
        when Qt::Key_Up:
            tryMove(@curPiece.rotatedLeft, @curX, @curY)
        when Qt::Key_Space:
            dropDown()
        when Qt::Key_D:
            oneLineDown()
        else
            super(event)
        end
    end
    
    def timerEvent(event)
        if event.timerId == @timer.timerId
            if @isWaitingAfterLine
                @isWaitingAfterLine = false
                newPiece()
                @timer.start(timeoutTime(), self)
            else
                oneLineDown()
            end
        else
            super(event)
        end
    end
    
    def clearBoard()
        (0...BoardWidth*BoardHeight).each do |i|
            @board[i] = TetrixPiece::NoShape
        end
    end
    
    def dropDown()
        dropHeight = 0
        newY = @curY
        while newY > 0
            if !tryMove(@curPiece, @curX, newY - 1)
                break
            end
            newY -= 1
            dropHeight += 1
        end
        pieceDropped(dropHeight)
    end
    
    def oneLineDown()
        if !tryMove(@curPiece, @curX, @curY - 1)
            pieceDropped(0)
        end
    end
    
    def pieceDropped(dropHeight)
        (0...4).each do |i|
            x = @curX + @curPiece.x(i)
            y = @curY - @curPiece.y(i)
            setShapeAt(x, y, @curPiece.shape())
        end
    
        @numPiecesDropped += 1
        if @numPiecesDropped % 25 == 0
            @level += 1
            @timer.start(timeoutTime(), self)
            emit levelChanged(@level)
        end
    
        @score += dropHeight + 7
        emit scoreChanged(@score)
        removeFullLines()
    
        if !@isWaitingAfterLine
            newPiece()
        end
    end
    
    def removeFullLines()
        numFullLines = 0
        (BoardHeight - 1).downto(0) do |i|
            lineIsFull = true
    
            (0...BoardWidth).each do |j|
                if shapeAt(j, i) == TetrixPiece::NoShape
                    lineIsFull = false
                    break
                end
            end
    
            if lineIsFull
                numFullLines += 1
                (i...BoardHeight).each do |k|
                    (0...BoardWidth).each do |j|
                        setShapeAt(j, k, shapeAt(j, k + 1))
                    end
                end
                (0...BoardWidth).each do |j|
                    setShapeAt(j, BoardHeight - 1, TetrixPiece::NoShape)
                end
            end
        end
    
        if numFullLines > 0
            @numLinesRemoved += numFullLines
            @score += 10 * numFullLines
            emit linesRemovedChanged(@numLinesRemoved)
            emit scoreChanged(@score)
    
            @timer.start(500, self)
            @isWaitingAfterLine = true
            @curPiece.shape = TetrixPiece::NoShape
            update()
        end
    end
    
    def newPiece()
        @curPiece = @nextPiece
        @nextPiece.setRandomShape()
        showNextPiece()
        @curX = BoardWidth / 2 + 1
        @curY = BoardHeight - 1 + @curPiece.minY()
    
        if !tryMove(@curPiece, @curX, @curY)
            @curPiece.shape = TetrixPiece::NoShape
            @timer.stop()
            @isStarting = false
        end
    end
    
    def showNextPiece()
        if @nextPieceLabel.nil?
            return
        end
    
        dx = @nextPiece.maxX() - @nextPiece.minX() + 1
        dy = @nextPiece.maxY() - @nextPiece.minY() + 1
    
        pixmap = Qt::Pixmap.new(dx * squareWidth(), dy * squareHeight())
        painter = Qt::Painter.new(pixmap)
        painter.fillRect(pixmap.rect(), @nextPieceLabel.palette().background())
    
        (0...4).each do |i|
            x = @nextPiece.x(i) - @nextPiece.minX()
            y = @nextPiece.y(i) - @nextPiece.minY()
            drawSquare(painter, x * squareWidth(), y * squareHeight(),
                       @nextPiece.shape())
        end
        @nextPieceLabel.pixmap = pixmap
        painter.end
    end
    
    def tryMove(newPiece, newX, newY)
        (0...4).each do |i|
            x = newX + newPiece.x(i)
            y = newY - newPiece.y(i)
            if x < 0 || x >= BoardWidth || y < 0 || y >= BoardHeight
                return false
            end
            if shapeAt(x, y) != TetrixPiece::NoShape
                return false
            end
        end
    
        @curPiece = newPiece
        @curX = newX
        @curY = newY
        update()
        return true
    end
    
    def drawSquare(painter, x, y, shape)
        colorTable = [  0x000000, 0xCC6666, 0x66CC66, 0x6666CC,
                        0xCCCC66, 0xCC66CC, 0x66CCCC, 0xDAAA00 ]
    
        color = Qt::Color.fromRgb(colorTable[shape])
        painter.fillRect(x + 1, y + 1, squareWidth() - 2, squareHeight() - 2,
                         Qt::Brush.new(color))
    
        painter.pen = color.light
        painter.drawLine(x, y + squareHeight() - 1, x, y)
        painter.drawLine(x, y, x + squareWidth() - 1, y)
    
        painter.pen = color.dark
        painter.drawLine(x + 1, y + squareHeight() - 1,
                         x + squareWidth() - 1, y + squareHeight() - 1)
        painter.drawLine(x + squareWidth() - 1, y + squareHeight() - 1,
                         x + squareWidth() - 1, y + 1)
    end
end
