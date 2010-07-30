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

require 'slidersgroup.rb'

class Window < Qt::Widget
    
    def initialize()
        super
        @horizontalSliders = SlidersGroup.new(Qt::Horizontal, tr("Horizontal"))
        @verticalSliders = SlidersGroup.new(Qt::Vertical, tr("Vertical"))
    
        @stackedWidget = Qt::StackedWidget.new
        @stackedWidget.addWidget(@horizontalSliders)
        @stackedWidget.addWidget(@verticalSliders)
    
        createControls(tr("Controls"))
    
        connect(@horizontalSliders, SIGNAL('valueChanged(int)'),
                @verticalSliders, SLOT('setValue(int)'))
        connect(@verticalSliders, SIGNAL('valueChanged(int)'),
                @valueSpinBox, SLOT('setValue(int)'))
        connect(@valueSpinBox, SIGNAL('valueChanged(int)'),
                @horizontalSliders, SLOT('setValue(int)'))
    
        layout = Qt::HBoxLayout.new do |l|
            l.addWidget(@controlsGroup)
            l.addWidget(@stackedWidget)
        end

        setLayout(layout)
    
        @minimumSpinBox.value = 0
        @maximumSpinBox.value = 20
        @valueSpinBox.value = 5
    
        setWindowTitle(tr("Sliders"))
    end
    
    def createControls(title)
        @controlsGroup = Qt::GroupBox.new(title)
    
        @minimumLabel = Qt::Label.new(tr("Minimum value:"))
        @maximumLabel = Qt::Label.new(tr("Maximum value:"))
        @valueLabel = Qt::Label.new(tr("Current value:"))
    
        @invertedAppearance = Qt::CheckBox.new(tr("Inverted appearance"))
        @invertedKeyBindings = Qt::CheckBox.new(tr("Inverted key bindings"))
    
        @minimumSpinBox = Qt::SpinBox.new do |s|
            s.range = -100..100
            s.singleStep = 1
        end
    
        @maximumSpinBox = Qt::SpinBox.new do |s|
            s.range = -100..100
            s.singleStep = 1
        end

        @valueSpinBox = Qt::SpinBox.new do |s|
            s.range = -100..100
            s.singleStep = 1
        end
    
        @orientationCombo = Qt::ComboBox.new
        @orientationCombo.addItem(tr("Horizontal slider-like widgets"))
        @orientationCombo.addItem(tr("Vertical slider-like widgets"))
    
        connect(@orientationCombo, SIGNAL('activated(int)'),
                @stackedWidget, SLOT('setCurrentIndex(int)'))
        connect(@minimumSpinBox, SIGNAL('valueChanged(int)'),
                @horizontalSliders, SLOT('setMinimum(int)'))
        connect(@minimumSpinBox, SIGNAL('valueChanged(int)'),
                @verticalSliders, SLOT('setMinimum(int)'))
        connect(@maximumSpinBox, SIGNAL('valueChanged(int)'),
                @horizontalSliders, SLOT('setMaximum(int)'))
        connect(@maximumSpinBox, SIGNAL('valueChanged(int)'),
                @verticalSliders, SLOT('setMaximum(int)'))
        connect(@invertedAppearance, SIGNAL('toggled(bool)'),
                @horizontalSliders, SLOT('invertAppearance(bool)'))
        connect(@invertedAppearance, SIGNAL('toggled(bool)'),
                @verticalSliders, SLOT('invertAppearance(bool)'))
        connect(@invertedKeyBindings, SIGNAL('toggled(bool)'),
                @horizontalSliders, SLOT('invertKeyBindings(bool)'))
        connect(@invertedKeyBindings, SIGNAL('toggled(bool)'),
                @verticalSliders, SLOT('invertKeyBindings(bool)'))
    
        controlsLayout = Qt::GridLayout.new do |c|
            c.addWidget(@minimumLabel, 0, 0)
            c.addWidget(@maximumLabel, 1, 0)
            c.addWidget(@valueLabel, 2, 0)
            c.addWidget(@minimumSpinBox, 0, 1)
            c.addWidget(@maximumSpinBox, 1, 1)
            c.addWidget(@valueSpinBox, 2, 1)
            c.addWidget(@invertedAppearance, 0, 2)
            c.addWidget(@invertedKeyBindings, 1, 2)
            c.addWidget(@orientationCombo, 3, 0, 1, 3)
        end

        @controlsGroup.layout = controlsLayout
    end
end
