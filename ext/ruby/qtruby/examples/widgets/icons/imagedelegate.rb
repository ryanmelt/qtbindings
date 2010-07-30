=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
**
** This file is part of the example classes of the Qt Toolkit.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** self file.  Please review the following information to ensure GNU
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

class ImageDelegate < Qt::ItemDelegate

	slots 'emitCommitData()'

	def initialize(parent = nil)
		super(parent)
	end
	
	def createEditor(parent, option, index)
		comboBox = Qt::ComboBox.new(parent)
		if index.column() == 1
			comboBox.addItem(tr("Normal"))
			comboBox.addItem(tr("Active"))
			comboBox.addItem(tr("Disabled"))
		elsif index.column() == 2
			comboBox.addItem(tr("Off"))
			comboBox.addItem(tr("On"))
		end
	
		connect(comboBox, SIGNAL('activated(int)'), self, SLOT('emitCommitData()'))
	
		return comboBox
	end
	
	def setEditorData(editor, index)
		comboBox = editor
		if comboBox.nil?
			return
		end
	
		pos = comboBox.findText(index.model().data(index).toString(),
									Qt::MatchExactly.to_i)
		comboBox.currentIndex = pos
	end
	
	def setModelData(editor, model, index)
		comboBox = editor
		if comboBox.nil?
			return
		end
	
		model.setData(index, Qt::Variant.new(comboBox.currentText()), Qt::EditRole)
	end
	
	def emitCommitData()
		emit commitData(sender())
	end
end
