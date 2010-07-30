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
	
	slots   'shapeChanged()',
    		'penChanged()',
    		'brushChanged()'
	
	def initialize(parent = nil)
		super
	 	@idRole = Qt::UserRole
	    @renderArea = RenderArea.new
	
	    @shapeComboBox = Qt::ComboBox.new do |s|
			s.addItem(tr("Rectangle"), Qt::Variant.new(RenderArea::Rect))
			s.addItem(tr("Round Rectangle"), Qt::Variant.new(RenderArea::RoundRect))
			s.addItem(tr("Ellipse"), Qt::Variant.new(RenderArea::Ellipse))
			s.addItem(tr("Pie"), Qt::Variant.new(RenderArea::Pie))
			s.addItem(tr("Chord"), Qt::Variant.new(RenderArea::Chord))
			s.addItem(tr("Polygon"), Qt::Variant.new(RenderArea::Polygon))
			s.addItem(tr("Path"), Qt::Variant.new(RenderArea::Path))
			s.addItem(tr("Line"), Qt::Variant.new(RenderArea::Line))
			s.addItem(tr("Polyline"), Qt::Variant.new(RenderArea::Polyline))
			s.addItem(tr("Arc"), Qt::Variant.new(RenderArea::Arc))
			s.addItem(tr("Points"), Qt::Variant.new(RenderArea::Points))
			s.addItem(tr("Text"), Qt::Variant.new(RenderArea::Text))
			s.addItem(tr("Pixmap"), Qt::Variant.new(RenderArea::Pixmap))
		end
	
	    @shapeLabel = Qt::Label.new(tr("&Shape:"))
	    @shapeLabel.buddy = @shapeComboBox
	
	    @penWidthSpinBox = Qt::SpinBox.new
	    @penWidthSpinBox.range = 0..20
	
	    @penWidthLabel = Qt::Label.new(tr("Pen &Width:"))
	    @penWidthLabel.buddy = @penWidthSpinBox
	
	    @penStyleComboBox = Qt::ComboBox.new do |p|
			p.addItem(tr("Solid"), Qt::Variant.new(Qt::SolidLine.to_i))
			p.addItem(tr("Dash"), Qt::Variant.new(Qt::DashLine.to_i))
			p.addItem(tr("Dot"), Qt::Variant.new(Qt::DotLine.to_i))
			p.addItem(tr("Dash Dot"), Qt::Variant.new(Qt::DashDotLine.to_i))
			p.addItem(tr("Dash Dot Dot"), Qt::Variant.new(Qt::DashDotDotLine.to_i))
			p.addItem(tr("None"), Qt::Variant.new(Qt::NoPen.to_i))
		end
	
	    @penStyleLabel = Qt::Label.new(tr("&Pen Style:"))
	    @penStyleLabel.buddy = @penStyleComboBox
	
	    @penCapComboBox = Qt::ComboBox.new do |p|
	    	p.addItem(tr("Flat"), Qt::Variant.new(Qt::FlatCap.to_i))
	    	p.addItem(tr("Square"), Qt::Variant.new(Qt::SquareCap.to_i))
	    	p.addItem(tr("Round"), Qt::Variant.new(Qt::RoundCap.to_i))
		end
	
	    @penCapLabel = Qt::Label.new(tr("Pen &Cap:"))
	    @penCapLabel.buddy = @penCapComboBox
	
	    @penJoinComboBox = Qt::ComboBox.new do |p|
	    	p.addItem(tr("Miter"), Qt::Variant.new(Qt::MiterJoin.to_i))
	    	p.addItem(tr("Bevel"), Qt::Variant.new(Qt::BevelJoin.to_i))
	    	p.addItem(tr("Round"), Qt::Variant.new(Qt::RoundJoin.to_i))
		end
	
	    @penJoinLabel = Qt::Label.new(tr("Pen &Join:"))
	    @penJoinLabel.buddy = @penJoinComboBox
	
	    @brushStyleComboBox = Qt::ComboBox.new do |b|
			b.addItem(tr("Linear Gradient"),
					Qt::Variant.new(Qt::LinearGradientPattern.to_i))
			b.addItem(tr("Radial Gradient"),
					Qt::Variant.new(Qt::RadialGradientPattern.to_i))
			b.addItem(tr("Conical Gradient"),
					Qt::Variant.new(Qt::ConicalGradientPattern.to_i))
			b.addItem(tr("Texture"), Qt::Variant.new(Qt::TexturePattern.to_i))
			b.addItem(tr("Solid"), Qt::Variant.new(Qt::SolidPattern.to_i))
			b.addItem(tr("Horizontal"), Qt::Variant.new(Qt::HorPattern.to_i))
			b.addItem(tr("Vertical"), Qt::Variant.new(Qt::VerPattern.to_i))
			b.addItem(tr("Cross"), Qt::Variant.new(Qt::CrossPattern.to_i))
			b.addItem(tr("Backward Diagonal"), Qt::Variant.new(Qt::BDiagPattern.to_i))
			b.addItem(tr("Forward Diagonal"), Qt::Variant.new(Qt::FDiagPattern.to_i))
			b.addItem(tr("Diagonal Cross"), Qt::Variant.new(Qt::DiagCrossPattern.to_i))
			b.addItem(tr("Dense 1"), Qt::Variant.new(Qt::Dense1Pattern.to_i))
			b.addItem(tr("Dense 2"), Qt::Variant.new(Qt::Dense2Pattern.to_i))
			b.addItem(tr("Dense 3"), Qt::Variant.new(Qt::Dense3Pattern.to_i))
			b.addItem(tr("Dense 4"), Qt::Variant.new(Qt::Dense4Pattern.to_i))
			b.addItem(tr("Dense 5"), Qt::Variant.new(Qt::Dense5Pattern.to_i))
			b.addItem(tr("Dense 6"), Qt::Variant.new(Qt::Dense6Pattern.to_i))
			b.addItem(tr("Dense 7"), Qt::Variant.new(Qt::Dense7Pattern.to_i))
			b.addItem(tr("None"), Qt::Variant.new(Qt::NoBrush.to_i))
		end
	
	    @brushStyleLabel = Qt::Label.new(tr("&Brush Style:"))
	    @brushStyleLabel.buddy = @brushStyleComboBox
	
	    @antialiasingCheckBox = Qt::CheckBox.new(tr("&Antialiasing"))
	    @transformationsCheckBox = Qt::CheckBox.new(tr("&Transformations"))
	
	    connect(@shapeComboBox, SIGNAL('activated(int)'),
	            self, SLOT('shapeChanged()'))
	    connect(@penWidthSpinBox, SIGNAL('valueChanged(int)'),
	            self, SLOT('penChanged()'))
	    connect(@penStyleComboBox, SIGNAL('activated(int)'),
	            self, SLOT('penChanged()'))
	    connect(@penCapComboBox, SIGNAL('activated(int)'),
	            self, SLOT('penChanged()'))
	    connect(@penJoinComboBox, SIGNAL('activated(int)'),
	            self, SLOT('penChanged()'))
	    connect(@brushStyleComboBox, SIGNAL('activated(int)'),
	            self, SLOT('brushChanged()'))
	    connect(@antialiasingCheckBox, SIGNAL('toggled(bool)'),
	            @renderArea, SLOT('antialiased=(bool)'))
	    connect(@transformationsCheckBox, SIGNAL('toggled(bool)'),
	            @renderArea, SLOT('transformed=(bool)'))
	
	    checkBoxLayout = Qt::HBoxLayout.new do |c|
	    	c.addWidget(@antialiasingCheckBox)
	    	c.addWidget(@transformationsCheckBox)
		end
	
	    self.layout = Qt::GridLayout.new do |l|
			l.addWidget(@renderArea, 0, 0, 1, 2)
			l.addWidget(@shapeLabel, 1, 0)
			l.addWidget(@shapeComboBox, 1, 1)
			l.addWidget(@penWidthLabel, 2, 0)
			l.addWidget(@penWidthSpinBox, 2, 1)
			l.addWidget(@penStyleLabel, 3, 0)
			l.addWidget(@penStyleComboBox, 3, 1)
			l.addWidget(@penCapLabel, 4, 0)
			l.addWidget(@penCapComboBox, 4, 1)
			l.addWidget(@penJoinLabel, 5, 0)
			l.addWidget(@penJoinComboBox, 5, 1)
			l.addWidget(@brushStyleLabel, 6, 0)
			l.addWidget(@brushStyleComboBox, 6, 1)
			l.addLayout(checkBoxLayout, 7, 0, 1, 2)
		end
	
	    shapeChanged()
	    penChanged()
	    brushChanged()
	    @renderArea.antialiased = false
	    @renderArea.transformed = false
	
	    setWindowTitle(tr("Basic Drawing"))
	end
	
	def shapeChanged()
	    shape = @shapeComboBox.itemData(@shapeComboBox.currentIndex(), @idRole).toInt
	    @renderArea.shape = shape
	end
	
	def penChanged()
	    width = @penWidthSpinBox.value()
	    style = @penStyleComboBox.itemData(@penStyleComboBox.currentIndex(), @idRole).toInt
	    cap = @penCapComboBox.itemData(@penCapComboBox.currentIndex(), @idRole).toInt
	    join = @penJoinComboBox.itemData(@penJoinComboBox.currentIndex(), @idRole).toInt
	
	    @renderArea.pen = Qt::Pen.new(Qt::Brush.new(Qt::blue), width, style, cap, join)
	end
	
	def brushChanged()
	    style = @brushStyleComboBox.itemData(@brushStyleComboBox.currentIndex(), @idRole).toInt
	
	    if style == Qt::LinearGradientPattern
	        linearGradient = Qt::LinearGradient.new(0, 0, 100, 100)
	        linearGradient.setColorAt(0.0, Qt::Color.new(Qt::white))
	        linearGradient.setColorAt(0.2, Qt::Color.new(Qt::green))
	        linearGradient.setColorAt(1.0, Qt::Color.new(Qt::black))
	        @renderArea.brush = Qt::Brush.new(linearGradient)
	    elsif style == Qt::RadialGradientPattern
	        radialGradient = Qt::RadialGradient.new(50, 50, 50, 50, 50)
	        radialGradient.setColorAt(0.0, Qt::Color.new(Qt::white))
	        radialGradient.setColorAt(0.2, Qt::Color.new(Qt::green))
	        radialGradient.setColorAt(1.0, Qt::Color.new(Qt::black))
	        @renderArea.brush = Qt::Brush.new(radialGradient)
	    elsif style == Qt::ConicalGradientPattern
	        conicalGradient = Qt::ConicalGradient.new(50, 50, 150)
	        conicalGradient.setColorAt(0.0, Qt::Color.new(Qt::white))
	        conicalGradient.setColorAt(0.2, Qt::Color.new(Qt::green))
	        conicalGradient.setColorAt(1.0, Qt::Color.new(Qt::black))
	        @renderArea.brush = Qt::Brush.new(conicalGradient)
	    elsif style == Qt::TexturePattern
	        @renderArea.brush = Qt::Brush.new(Qt::Pixmap.new("images/brick.png"))
	    else
	        @renderArea.brush = Qt::Brush.new(Qt::green, style)
	    end
	end
end
