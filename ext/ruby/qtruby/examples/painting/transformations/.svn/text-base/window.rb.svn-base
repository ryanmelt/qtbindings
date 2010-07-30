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

require 'renderarea.rb'

class Window < Qt::Widget
	
	slots	'operationChanged()',
    		'shapeSelected(int)'

	NumTransformedAreas = 3

	def initialize(parent = nil)
		super
	    @originalRenderArea = RenderArea.new
	
	    @shapeComboBox = Qt::ComboBox.new
	    @shapeComboBox.addItem(tr("Clock"))
	    @shapeComboBox.addItem(tr("House"))
	    @shapeComboBox.addItem(tr("Text"))
	    @shapeComboBox.addItem(tr("Truck"))
	
	    layout = Qt::GridLayout.new
	    layout.addWidget(@originalRenderArea, 0, 0)
	    layout.addWidget(@shapeComboBox, 1, 0)
	
		@transformedRenderAreas = []
		@operationComboBoxes = []
		(0...NumTransformedAreas).each do |i|
	        @transformedRenderAreas[i] = RenderArea.new
	
	        @operationComboBoxes[i] = Qt::ComboBox.new
	        @operationComboBoxes[i].addItem(tr("No transformation"))
	        @operationComboBoxes[i].addItem(tr("Rotate by 60\xB0"))
	        @operationComboBoxes[i].addItem(tr("Scale to 75%"))
	        @operationComboBoxes[i].addItem(tr("Translate by (50, 50)"))
	
	        connect(@operationComboBoxes[i], SIGNAL('activated(int)'),
	                self, SLOT('operationChanged()'))
	
	        layout.addWidget(@transformedRenderAreas[i], 0, i + 1)
	        layout.addWidget(@operationComboBoxes[i], 1, i + 1)
	    end
	
	    setLayout(layout)
	    setupShapes()
	    shapeSelected(0)
	
	    setWindowTitle(tr("Transformations"))
	end
	
	def setupShapes()
	    truck = Qt::PainterPath.new
	    truck.fillRule = Qt::WindingFill
	    truck.moveTo(0.0, 87.0)
	    truck.lineTo(0.0, 60.0)
	    truck.lineTo(10.0, 60.0)
	    truck.lineTo(35.0, 35.0)
	    truck.lineTo(100.0, 35.0)
	    truck.lineTo(100.0, 87.0)
	    truck.lineTo(0.0, 87.0)
	    truck.moveTo(17.0, 60.0)
	    truck.lineTo(55.0, 60.0)
	    truck.lineTo(55.0, 40.0)
	    truck.lineTo(37.0, 40.0)
	    truck.lineTo(17.0, 60.0)
	    truck.addEllipse(17.0, 75.0, 25.0, 25.0)
	    truck.addEllipse(63.0, 75.0, 25.0, 25.0)
	
	    clock = Qt::PainterPath.new
	    clock.addEllipse(-50.0, -50.0, 100.0, 100.0)
	    clock.addEllipse(-48.0, -48.0, 96.0, 96.0)
	    clock.moveTo(0.0, 0.0)
	    clock.lineTo(-2.0, -2.0)
	    clock.lineTo(0.0, -42.0)
	    clock.lineTo(2.0, -2.0)
	    clock.lineTo(0.0, 0.0)
	    clock.moveTo(0.0, 0.0)
	    clock.lineTo(2.732, -0.732)
	    clock.lineTo(24.495, 14.142)
	    clock.lineTo(0.732, 2.732)
	    clock.lineTo(0.0, 0.0)
	
	    house = Qt::PainterPath.new
	    house.moveTo(-45.0, -20.0)
	    house.lineTo(0.0, -45.0)
	    house.lineTo(45.0, -20.0)
	    house.lineTo(45.0, 45.0)
	    house.lineTo(-45.0, 45.0)
	    house.lineTo(-45.0, -20.0)
	    house.addRect(15.0, 5.0, 20.0, 35.0)
	    house.addRect(-35.0, -15.0, 25.0, 25.0)
	
	    text = Qt::PainterPath.new
	    font = Qt::Font.new
	    font.pixelSize = 50
	    fontBoundingRect = Qt::FontMetrics.new(font).boundingRect(tr("Qt"))
	    text.addText(-Qt::PointF.new(fontBoundingRect.center()), font, tr("Qt"))
	
		@shapes = []
	    @shapes.push(clock)
	    @shapes.push(house)
	    @shapes.push(text)
	    @shapes.push(truck)
	
	    connect(@shapeComboBox, SIGNAL('activated(int)'),
	            self, SLOT('shapeSelected(int)'))
	end
	
	def operationChanged()
	    operationTable = [	RenderArea::NoTransformation, 
							RenderArea::Rotate, 
							RenderArea::Scale, 
							RenderArea::Translate ]
	
	    operations = []
		(0...NumTransformedAreas).each do |i|
	        index = @operationComboBoxes[i].currentIndex()
	        operations.push(operationTable[index])
	        @transformedRenderAreas[i].operations = operations
	    end
	end
	
	def shapeSelected(index)
	    shape = @shapes[index]
	    @originalRenderArea.shape = shape
		(0...NumTransformedAreas).each do |i|
	        @transformedRenderAreas[i].shape = shape
		end
	end
end
