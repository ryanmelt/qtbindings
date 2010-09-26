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
	
class SpinBoxDelegate < Qt::ItemDelegate
	
	# A delegate that allows the user to change integer values from the model
	# using a spin box widget.
	
	def initialize(parent = nil)
	    super(parent)
	end
	
	def createEditor(parent, option, index)
	    editor = Qt::SpinBox.new(parent)
	    editor.minimum = 0
	    editor.maximum = 100
	    editor.installEventFilter(self)
	
	    return editor
	end
	
	def setEditorData(editor, index)
	    value = index.model().data(index, Qt::DisplayRole).to_i
	
	    @spinBox = editor
	    @spinBox.value = value
	end
	
	def setModelData(editor, model, index)
	    @spinBox = editor
	    @spinBox.interpretText
	    value = @spinBox.value

	    model.setData(index, Qt::Variant.new(value))
	end
	
	def updateEditorGeometry(editor, option, index)
	    editor.geometry = option.rect
	end
end
