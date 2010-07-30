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
		
	slots	'fillRuleChanged()',
    		'fillGradientChanged()',
    		'penColorChanged()'
	
	NumRenderAreas = 9
	
	def initialize(parent = nil)
		super
		@renderAreas = Array(NumRenderAreas)
	    rectPath = Qt::PainterPath.new do |r|
			r.moveTo(20.0, 30.0)
			r.lineTo(80.0, 30.0)
			r.lineTo(80.0, 70.0)
			r.lineTo(20.0, 70.0)
			r.closeSubpath()
		end
	
	    roundRectPath = Qt::PainterPath.new do |r|
			r.moveTo(80.0, 35.0)
			r.arcTo(70.0, 30.0, 10.0, 10.0, 0.0, 90.0)
			r.lineTo(25.0, 30.0)
			r.arcTo(20.0, 30.0, 10.0, 10.0, 90.0, 90.0)
			r.lineTo(20.0, 65.0)
			r.arcTo(20.0, 60.0, 10.0, 10.0, 180.0, 90.0)
			r.lineTo(75.0, 70.0)
			r.arcTo(70.0, 60.0, 10.0, 10.0, 270.0, 90.0)
			r.closeSubpath()
		end
	
	    ellipsePath = Qt::PainterPath.new do |e|
	    	e.moveTo(80.0, 50.0)
	    	e.arcTo(20.0, 30.0, 60.0, 40.0, 0.0, 360.0)
		end
	
	    piePath = Qt::PainterPath.new do |p|
			p.moveTo(50.0, 50.0)
			p.lineTo(65.0, 32.6795)
			p.arcTo(20.0, 30.0, 60.0, 40.0, 60.0, 240.0)
			p.closeSubpath()
		end
	
	    polygonPath = Qt::PainterPath.new do |p|
			p.moveTo(10.0, 80.0)
			p.lineTo(20.0, 10.0)
			p.lineTo(80.0, 30.0)
			p.lineTo(90.0, 70.0)
			p.closeSubpath()
		end
	
	    groupPath = Qt::PainterPath.new do |g|
			g.moveTo(60.0, 40.0)
			g.arcTo(20.0, 20.0, 40.0, 40.0, 0.0, 360.0)
			g.moveTo(40.0, 40.0)
			g.lineTo(40.0, 80.0)
			g.lineTo(80.0, 80.0)
			g.lineTo(80.0, 40.0)
			g.closeSubpath()
		end
	
	    textPath = Qt::PainterPath.new do |t|
	    	timesFont = Qt::Font.new("Times", 50)
	    	timesFont.styleStrategy = Qt::Font::ForceOutline
	    	t.addText(10, 70, timesFont, tr("Qt"))
		end
	
	    bezierPath = Qt::PainterPath.new do |b|
	    	b.moveTo(20, 30)
	    	b.cubicTo(80, 0, 50, 50, 80, 80)
		end
	
	    starPath = Qt::PainterPath.new do |s|
			s.moveTo(90, 50)
			(1...5).each do |i|
				s.lineTo(50 + 40 * Math.cos(0.8 * i * Math::PI),
						 50 + 40 * Math.sin(0.8 * i * Math::PI))
			end
			s.closeSubpath()
		end
	
	    @renderAreas[0] = RenderArea.new(rectPath)
	    @renderAreas[1] = RenderArea.new(roundRectPath)
	    @renderAreas[2] = RenderArea.new(ellipsePath)
	    @renderAreas[3] = RenderArea.new(piePath)
	    @renderAreas[4] = RenderArea.new(polygonPath)
	    @renderAreas[5] = RenderArea.new(groupPath)
	    @renderAreas[6] = RenderArea.new(textPath)
	    @renderAreas[7] = RenderArea.new(bezierPath)
	    @renderAreas[8] = RenderArea.new(starPath)
	
	    @fillRuleComboBox = Qt::ComboBox.new do |f|
	    	f.addItem(tr("Odd Even"), Qt::Variant.new(Qt::OddEvenFill.to_i))
	    	f.addItem(tr("Winding"), Qt::Variant.new(Qt::WindingFill.to_i))
		end
	
	    @fillRuleLabel = Qt::Label.new(tr("Fill &Rule:"))
	    @fillRuleLabel.buddy = @fillRuleComboBox
	
	    @fillColor1ComboBox = Qt::ComboBox.new
	    populateWithColors(@fillColor1ComboBox)
	    @fillColor1ComboBox.setCurrentIndex(
	            @fillColor1ComboBox.findText("mediumslateblue"))
	
	    @fillColor2ComboBox = Qt::ComboBox.new
	    populateWithColors(@fillColor2ComboBox)
	    @fillColor2ComboBox.setCurrentIndex(
	            @fillColor2ComboBox.findText("cornsilk"))
	
	    @fillGradientLabel = Qt::Label.new(tr("&Fill Gradient:"))
	    @fillGradientLabel.buddy = @fillColor1ComboBox
	
	    @fillToLabel = Qt::Label.new(tr("to"))
	    @fillToLabel.setSizePolicy(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed)
	
	    @penWidthSpinBox = Qt::SpinBox.new
	    @penWidthSpinBox.range = 0..20
	
	    @penWidthLabel = Qt::Label.new(tr("&Pen Width:"))
	    @penWidthLabel.buddy = @penWidthSpinBox
	
	    @penColorComboBox = Qt::ComboBox.new
	    populateWithColors(@penColorComboBox)
	    @penColorComboBox.setCurrentIndex(
	            @penColorComboBox.findText("darkslateblue"))
	
	    @penColorLabel = Qt::Label.new(tr("Pen &Color:"))
	    @penColorLabel.buddy = @penColorComboBox
	
	    @rotationAngleSpinBox = Qt::SpinBox.new do |r|
			r.range = 0..359
			r.wrapping = true
			r.suffix = "\xB0"
		end
	
	    @rotationAngleLabel = Qt::Label.new(tr("&Rotation Angle:"))
	    @rotationAngleLabel.buddy = @rotationAngleSpinBox
	
	    connect(@fillRuleComboBox, SIGNAL('activated(int)'),
	            self, SLOT('fillRuleChanged()'))
	    connect(@fillColor1ComboBox, SIGNAL('activated(int)'),
	            self, SLOT('fillGradientChanged()'))
	    connect(@fillColor2ComboBox, SIGNAL('activated(int)'),
	            self, SLOT('fillGradientChanged()'))
	    connect(@penColorComboBox, SIGNAL('activated(int)'),
	            self, SLOT('penColorChanged()'))
	
		(0...NumRenderAreas).each do |i|
	        connect(@penWidthSpinBox, SIGNAL('valueChanged(int)'),
	                @renderAreas[i], SLOT('penWidth=(int)'))
	        connect(@rotationAngleSpinBox, SIGNAL('valueChanged(int)'),
	                @renderAreas[i], SLOT('rotationAngle=(int)'))
	    end
	
	    topLayout = Qt::GridLayout.new
		(0...NumRenderAreas).each do |i|
	        topLayout.addWidget(@renderAreas[i], i / 3, i % 3)
		end
	
	    self.layout = Qt::GridLayout.new do |m|
			m.addLayout(topLayout, 0, 0, 1, 4)
			m.addWidget(@fillRuleLabel, 1, 0)
			m.addWidget(@fillRuleComboBox, 1, 1, 1, 3)
			m.addWidget(@fillGradientLabel, 2, 0)
			m.addWidget(@fillColor1ComboBox, 2, 1)
			m.addWidget(@fillToLabel, 2, 2)
			m.addWidget(@fillColor2ComboBox, 2, 3)
			m.addWidget(@penWidthLabel, 3, 0)
			m.addWidget(@penWidthSpinBox, 3, 1, 1, 3)
			m.addWidget(@penColorLabel, 4, 0)
			m.addWidget(@penColorComboBox, 4, 1, 1, 3)
			m.addWidget(@rotationAngleLabel, 5, 0)
			m.addWidget(@rotationAngleSpinBox, 5, 1, 1, 3)
		end
	
	    fillRuleChanged()
	    fillGradientChanged()
	    penColorChanged()
	    @penWidthSpinBox.value = 2
	
	    setWindowTitle(tr("Painter Paths"))
	end
	
	def fillRuleChanged()
	    rule = currentItemData(@fillRuleComboBox).toInt
	
		(0...NumRenderAreas).each do |i|
	        @renderAreas[i].fillRule = rule
		end
	end
	
	def fillGradientChanged()
	    color1 = qVariantValue(Qt::Color, currentItemData(@fillColor1ComboBox))
	    color2 = qVariantValue(Qt::Color, currentItemData(@fillColor2ComboBox))
	
		(0...NumRenderAreas).each do |i|
	        @renderAreas[i].setFillGradient(color1, color2)
		end
	end
	
	def penColorChanged()
	    color = qVariantValue(Qt::Color, currentItemData(@penColorComboBox))
	
		(0...NumRenderAreas).each do |i|
	        @renderAreas[i].penColor = color
		end
	end
	
	def populateWithColors(comboBox)
	    colorNames = Qt::Color::colorNames()
		colorNames.each do |name|
	        comboBox.addItem(name, qVariantFromValue(Qt::Color.new(name)))
		end
	end
	
	def currentItemData(comboBox)
	    return comboBox.itemData(comboBox.currentIndex())
	end
end
