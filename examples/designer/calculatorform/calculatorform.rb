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
	
require 'ui_calculatorform.rb'	
	
class CalculatorForm < Qt::Widget
	
	slots	'on_inputSpinBox1_valueChanged(int)',
    		'on_inputSpinBox2_valueChanged(int)'
	
	def initialize(parent = nil)
	    super(parent)
		@ui = Ui_CalculatorForm.new
	    @ui.setupUi(self)
	end
	
	def on_inputSpinBox1_valueChanged(value)
	    @ui.outputWidget.text = "%d" % (value + @ui.inputSpinBox2.value)
	end
	
	def on_inputSpinBox2_valueChanged(value)
	    @ui.outputWidget.text = "%d" % (value + @ui.inputSpinBox1.value)
	end
end
