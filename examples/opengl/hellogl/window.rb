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
    
require './glwidget.rb'

class Window < Qt::Widget
    
    def initialize(parent = nil)
        super
        @glWidget = GLWidget.new(self)
    
        @xSlider = createSlider(SIGNAL('xRotationChanged(int)'),
                               SLOT('setXRotation(int)'))
        @ySlider = createSlider(SIGNAL('yRotationChanged(int)'),
                               SLOT('setYRotation(int)'))
        @zSlider = createSlider(SIGNAL('zRotationChanged(int)'),
                               SLOT('setZRotation(int)'))
    
        self.layout = Qt::HBoxLayout.new do |m|
            m.addWidget(@glWidget)
            m.addWidget(@xSlider)
            m.addWidget(@ySlider)
            m.addWidget(@zSlider)
        end
    
        @xSlider.value = 15 * 16
        @ySlider.value = 345 * 16
        @zSlider.value = 0 * 16
        self.windowTitle = tr("Hello GL")
    end
    
    def createSlider(changedSignal, setterSlot)
        slider = Qt::Slider.new(Qt::Vertical) do |s|
            s.range = 0..(360 * 16)
            s.singleStep = 16
            s.pageStep = 15 * 16
            s.tickInterval = 15 * 16
            s.tickPosition = Qt::Slider::TicksRight
        end
        connect(slider, SIGNAL('valueChanged(int)'), @glWidget, setterSlot)
        connect(@glWidget, changedSignal, slider, SLOT('setValue(int)'))
        return slider
    end
end
