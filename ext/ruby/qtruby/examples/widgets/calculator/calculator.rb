=begin
**
** Copyright (C) 2005-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** self file.  Please review the following information to ensure GNU
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

require 'button.rb'

class Calculator < Qt::Dialog

    slots    'digitClicked()',
            'unaryOperatorClicked()',
            'additiveOperatorClicked()',
            'multiplicativeOperatorClicked()',
            'equalClicked()',
            'pointClicked()',
            'changeSignClicked()',
            'backspaceClicked()',
            'clear()',
            'clearAll()',
            'clearMemory()',
            'readMemory()',
            'setMemory()',
            'addToMemory()'

    NumDigitButtons = 10

    def initialize(parent = nil)
        super(parent)
        @sumInMemory = 0.0
        @sumSoFar = 0.0
        @factorSoFar = 0.0
        @waitingForOperand = true
    
        @display = Qt::LineEdit.new("0")
        @display.readOnly = true
        @display.alignment = Qt::AlignRight
        @display.maxLength = 15
        @display.installEventFilter(self)
    
        font = @display.font()
        font.pointSize += 8
        @display.font = font
    
        digitColor = Qt::Color.new(150, 205, 205)
        backspaceColor = Qt::Color.new(225, 185, 135)
        memoryColor = Qt::Color.new(100, 155, 155)
        operatorColor = Qt::Color.new(155, 175, 195)
    
        @digitButtons = []
        (0...NumDigitButtons).each do |i|
            @digitButtons[i] = createButton("%d" % i, digitColor,
                                        SLOT('digitClicked()'))
        end
    
        @pointButton = createButton(tr("."), digitColor, SLOT('pointClicked()'))
        @changeSignButton = createButton(tr("\261"), digitColor, SLOT('changeSignClicked()'))
    
        @backspaceButton = createButton(tr("Backspace"), backspaceColor,
                                    SLOT('backspaceClicked()'))
        @clearButton = createButton(tr("Clear"), backspaceColor, SLOT('clear()'))
        @clearAllButton = createButton(tr("Clear All"), backspaceColor.light(120),
                                    SLOT('clearAll()'))
    
        @clearMemoryButton = createButton(tr("MC"), memoryColor,
                                        SLOT('clearMemory()'))
        @readMemoryButton = createButton(tr("MR"), memoryColor, SLOT('readMemory()'))
        @setMemoryButton = createButton(tr("MS"), memoryColor, SLOT('setMemory()'))
        @addToMemoryButton = createButton(tr("M+"), memoryColor,
                                        SLOT('addToMemory()'))
    
        @divisionButton = createButton(tr("\367"), operatorColor,
                                    SLOT('multiplicativeOperatorClicked()'))
        @timesButton = createButton(tr("\327"), operatorColor,
                                SLOT('multiplicativeOperatorClicked()'))
        @minusButton = createButton(tr("-"), operatorColor,
                                SLOT('additiveOperatorClicked()'))
        @plusButton = createButton(tr("+"), operatorColor,
                                SLOT('additiveOperatorClicked()'))
    
        @squareRootButton = createButton(tr("Sqrt"), operatorColor,
                                        SLOT('unaryOperatorClicked()'))
        @powerButton = createButton(tr("x\262"), operatorColor,
                                SLOT('unaryOperatorClicked()'))
        @reciprocalButton = createButton(tr("1/x"), operatorColor,
                                        SLOT('unaryOperatorClicked()'))
        @equalButton = createButton(tr("="), operatorColor.light(120),
                                SLOT('equalClicked()'))
    
        mainLayout = Qt::GridLayout.new
        mainLayout.SizeConstraint = Qt::Layout::SetFixedSize
    
        mainLayout.addWidget(@display, 0, 0, 1, 6)
        mainLayout.addWidget(@backspaceButton, 1, 0, 1, 2)
        mainLayout.addWidget(@clearButton, 1, 2, 1, 2)
        mainLayout.addWidget(@clearAllButton, 1, 4, 1, 2)
    
        mainLayout.addWidget(@clearMemoryButton, 2, 0)
        mainLayout.addWidget(@readMemoryButton, 3, 0)
        mainLayout.addWidget(@setMemoryButton, 4, 0)
        mainLayout.addWidget(@addToMemoryButton, 5, 0)
    
        for i in 1...NumDigitButtons
            row = ((9 - i) / 3) + 2
            column = ((i - 1) % 3) + 1
            mainLayout.addWidget(@digitButtons[i], row, column)
        end
    
        mainLayout.addWidget(@digitButtons[0], 5, 1)
        mainLayout.addWidget(@pointButton, 5, 2)
        mainLayout.addWidget(@changeSignButton, 5, 3)
    
        mainLayout.addWidget(@divisionButton, 2, 4)
        mainLayout.addWidget(@timesButton, 3, 4)
        mainLayout.addWidget(@minusButton, 4, 4)
        mainLayout.addWidget(@plusButton, 5, 4)
    
        mainLayout.addWidget(@squareRootButton, 2, 5)
        mainLayout.addWidget(@powerButton, 3, 5)
        mainLayout.addWidget(@reciprocalButton, 4, 5)
        mainLayout.addWidget(@equalButton, 5, 5)
        setLayout(mainLayout)
    
        setWindowTitle(tr("Calculator"))
    end
    
    def eventFilter(target, event)
        if target == @display
            if event.type() == Qt::Event::MouseButtonPress ||
                    event.type() == Qt::Event::MouseButtonDblClick ||
                    event.type() == Qt::Event::MouseButtonRelease ||
                    event.type() == Qt::Event::ContextMenu 
                mouseEvent = Qt::Internal.cast_object_to(event, Qt::MouseEvent)
                if mouseEvent.buttons() & Qt::LeftButton.to_i != 0
                    newPalette = palette()
                    newPalette.setColor(Qt::Palette::Base,
                                        @display.palette().color(Qt::Palette::Text))
                    newPalette.setColor(Qt::Palette::Text,
                                        @display.palette().color(Qt::Palette::Base))
                    @display.palette = newPalette
                else
                    @display.palette = palette()
                end
                return true
            end
        end
        super(target, event)
    end
    
    def digitClicked()
        clickedButton = sender()
        digitValue = clickedButton.text().to_i
        if @display.text() == "0" && digitValue == 0
            return
        end
    
        if @waitingForOperand
            @display.clear()
            @waitingForOperand = false
        end
        @display.text += digitValue.to_s
    end
    
    def unaryOperatorClicked()
        clickedButton = sender()
        clickedOperator = clickedButton.text()
        operand = @display.text().to_f
        result
    
        if clickedOperator == tr("Sqrt")
            if operand < 0.0
                abortOperation()
                return
            end
            result = Math.sqrt(operand)
        elsif clickedOperator == tr("x\262")
            result = operand ** 2.0
        elsif clickedOperator == tr("1/x")
            if operand == 0.0
                abortOperation()
                return
            end
            result = 1.0 / operand
        end
        @display.text = result.to_s
        @waitingForOperand = true
    end
    
    def additiveOperatorClicked()
        clickedButton = sender()
        clickedOperator = clickedButton.text()
        operand = @display.text().to_f
    
        if !@pendingMultiplicativeOperator.nil?
            if !calculate(operand, @pendingMultiplicativeOperator)
                abortOperation()
                return
            end
            @display.text = @factorSoFar.to_s
            operand = @factorSoFar
            @factorSoFar = 0.0
            @pendingMultiplicativeOperator = nil
        end
    
        if !@pendingAdditiveOperator.nil?
            if !calculate(operand, @pendingAdditiveOperator)
                abortOperation()
                return
            end
            @display.text = @sumSoFar.to_s
        else
            @sumSoFar = operand
        end
    
        @pendingAdditiveOperator = clickedOperator
        @waitingForOperand = true
    end
    
    def multiplicativeOperatorClicked()
        clickedButton = sender()
        clickedOperator = clickedButton.text()
        operand = @display.text().to_f
    
        if !@pendingMultiplicativeOperator.nil?
            if !calculate(operand, @pendingMultiplicativeOperator)
                abortOperation()
                return
            end
            @display.text = @factorSoFar.to_s
        else
            @factorSoFar = operand
        end
    
        @pendingMultiplicativeOperator = clickedOperator
        @waitingForOperand = true
    end
    
    def equalClicked()
        operand = @display.text().to_f
    
        if !@pendingMultiplicativeOperator.nil?
            if !calculate(operand, @pendingMultiplicativeOperator)
                abortOperation()
                return
            end
            operand = @factorSoFar
            @factorSoFar = 0.0
            @pendingMultiplicativeOperator= nil
        end
        if !@pendingAdditiveOperator.nil?
            if !calculate(operand, @pendingAdditiveOperator)
                abortOperation()
                return
            end
            @pendingAdditiveOperator = nil
        else
            @sumSoFar = operand
        end
    
        @display.text = @sumSoFar.to_s
        @sumSoFar = 0.0
        @waitingForOperand = true
    end
    
    def pointClicked()
        if @waitingForOperand
            @display.text = "0"
        end
        if !@display.text().include? "."
            @display.text += tr(".")
        end
        @waitingForOperand = false
    end
    
    def changeSignClicked()
        text = @display.text()
        value = text.to_f
    
        if value > 0.0
            text.insert(0, tr("-"))
        elsif value < 0.0
            text = text[1, text.length - 1]
        end
        @display.text = text
    end
    
    def backspaceClicked()
        if @waitingForOperand
            return
        end
        text = @display.text()
        text.chop!
        if text.empty?
            text = "0"
            @waitingForOperand = true
        end
        @display.text = text
    end
    
    def clear()
        if @waitingForOperand
            return
        end
    
        @display.text = "0"
        @waitingForOperand = true
    end
    
    def clearAll()
        @sumSoFar = 0.0
        @factorSoFar = 0.0
        @pendingAdditiveOperator= nil
        @pendingMultiplicativeOperator= nil
        @display.text = "0"
        @waitingForOperand = true
    end
    
    def clearMemory()
        @sumInMemory = 0.0
    end
    
    def readMemory()
        @display.text = @sumInMemory.to_s
        @waitingForOperand = true
    end
    
    def setMemory()
        equalClicked()
        @sumInMemory = @display.text().to_f
    end
    
    def addToMemory()
        equalClicked()
        @sumInMemory += @display.text().to_f
    end
    
    def createButton(text, color, member)
        button = CalcButton.new(text, color)
        connect(button, SIGNAL('clicked()'), self, member)
        return button
    end
    
    def abortOperation()
        clearAll()
        @display.text = tr("####")
    end
    
    def calculate(rightOperand, pendingOperator)
        if pendingOperator == tr("+")
            @sumSoFar += rightOperand
        elsif pendingOperator == tr("-")
            @sumSoFar -= rightOperand
        elsif pendingOperator == tr("\327")
            @factorSoFar *= rightOperand
        elsif pendingOperator == tr("\367")
            if rightOperand == 0.0
                return false
            end
            @factorSoFar /= rightOperand
        end
        return true
    end
end
