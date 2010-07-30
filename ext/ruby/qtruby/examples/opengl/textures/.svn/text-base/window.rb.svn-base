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

require 'glwidget.rb'

class Window < Qt::Widget
	
	slots   'currentGlWidget=()',
    		'rotateOneStep()'
	
	NumRows = 2 
    NumColumns = 3
	
	def initialize(parent = nil)
		super
	    mainLayout = Qt::GridLayout.new
	
	    @glWidgets = [[], []]

		(0...NumRows).each do |i|
			(0...NumColumns).each do |j|
	            clearColor = Qt::Color.new
	            clearColor.setHsv((i * NumColumns + j) * 255 / (NumRows * NumColumns - 1),
	                              255, 63)
	
	            @glWidgets[i][j] = GLWidget.new(self, @glWidgets[0][0])
	            @glWidgets[i][j].clearColor = clearColor
	            @glWidgets[i][j].rotateBy(+42 * 16, +42 * 16, -21 * 16)
	            mainLayout.addWidget(@glWidgets[i][j], i, j)

	            connect(@glWidgets[i][j], SIGNAL('clicked()'),
	                    self, SLOT('currentGlWidget=()'))
	        end
	    end
	    setLayout(mainLayout)

	    @currentGlWidget = @glWidgets[0][0]
	
	    timer = Qt::Timer.new(self)
	    connect(timer, SIGNAL('timeout()'), self, SLOT('rotateOneStep()'))
	    timer.start(20)
	
	    self.windowTitle = tr("Textures")
	end
	
	def currentGlWidget=()
	    @currentGlWidget = sender()
	end
	
	def rotateOneStep()
	    if !@currentGlWidget.nil?
	        @currentGlWidget.rotateBy(+2 * 16, +2 * 16, -1 * 16)
		end
	end
end
