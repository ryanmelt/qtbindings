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
	
require './ui_controller.rb'

class Controller < Qt::Widget
	
	slots :on_accelerate_clicked, :on_decelerate_clicked,
    		:on_left_clicked, :on_right_clicked
	
	def initialize(parent = nil)
	    super(parent)
		@ui = Ui_Controller.new
	    @ui.setupUi(self)
	    @car = Qt::DBusInterface.new("com.trolltech.CarExample", "/Car", 
                                     "com.trolltech.Examples.CarInterface",
	                                  Qt::DBusConnection::sessionBus(), self)
	    startTimer(1000)
	end
	
	def timerEvent(event)
	    if @car.valid?
	        @ui.label.text = "connected"
	    else
	        @ui.label.text = "disconnected"
		end
	end
	
	def on_accelerate_clicked
	    @car.accelerate
	end
	
	def on_decelerate_clicked
	    @car.decelerate
	end
	
	def on_left_clicked
	    @car.turnLeft
	end
	
	def on_right_clicked
	    @car.turnRight
	end
end
