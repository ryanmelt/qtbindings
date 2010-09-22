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
	
	
require './circlewidget.rb'	
	
class Window < Qt::Widget
	
	def initialize(parent = nil)
		super
	    @aliasedLabel = createLabel(tr("Aliased"))
	    @antialiasedLabel = createLabel(tr("Antialiased"))
	    @intLabel = createLabel(tr("Int"))
	    @floatLabel = createLabel(tr("Float"))
		@circleWidgets = Array.new(2, Array.new(2))
	
	    layout = Qt::GridLayout.new
	    layout.addWidget(@aliasedLabel, 0, 1)
	    layout.addWidget(@antialiasedLabel, 0, 2)
	    layout.addWidget(@intLabel, 1, 0)
	    layout.addWidget(@floatLabel, 2, 0)
	
	    timer = Qt::Timer.new(self)
	
		(0...2).each do |i|
			(0...2).each do |j|
	            @circleWidgets[i][j] = CircleWidget.new
	            @circleWidgets[i][j].antialiased = j != 0
	            @circleWidgets[i][j].floatBased = i != 0
	
	            connect(timer, SIGNAL('timeout()'),
	                    @circleWidgets[i][j], SLOT('nextAnimationFrame()'))
	
	            layout.addWidget(@circleWidgets[i][j], i + 1, j + 1)
	        end
	    end
	    timer.start(100)
	    setLayout(layout)
	
	    setWindowTitle(tr("Concentric Circles"))
	end
	
	def createLabel(text)
	    label = Qt::Label.new(text)
	    label.alignment = Qt::AlignCenter.to_i
	    label.margin = 2
	    label.frameStyle = Qt::Frame::Box | Qt::Frame::Sunken
	    return label
	end
end
