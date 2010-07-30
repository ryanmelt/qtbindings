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
	
class FindDialog < Qt::Dialog
	
	def initialize(parent = nil)
	    super(parent)
	    @label = Qt::Label.new(tr("Find &what:"))
	    @lineEdit = Qt::LineEdit.new
	    @label.buddy = @lineEdit
	
	    @caseCheckBox = Qt::CheckBox.new(tr("Match &case"))
	    @fromStartCheckBox = Qt::CheckBox.new(tr("Search from &start"))
	    @fromStartCheckBox.checked = true
	
	    @findButton = Qt::PushButton.new(tr("&Find"))
	    @findButton.default = true
	
	    @closeButton = Qt::PushButton.new(tr("Close"))
	
	    @moreButton = Qt::PushButton.new(tr("&More"))
	    @moreButton.checkable = true
	    @moreButton.autoDefault = false
	
	    @extension = Qt::Widget.new
	
	    @wholeWordsCheckBox = Qt::CheckBox.new(tr("&Whole words"))
	    @backwardCheckBox = Qt::CheckBox.new(tr("Search &backward"))
	    @searchSelectionCheckBox = Qt::CheckBox.new(tr("Search se&lection"))
	
	    connect(@closeButton, SIGNAL('clicked()'), self, SLOT('close()'))
	    connect(@moreButton, SIGNAL('toggled(bool)'), @extension, SLOT('setVisible(bool)'))
	
	    @extensionLayout = Qt::VBoxLayout.new
	    @extensionLayout.margin = 0
	    @extensionLayout.addWidget(@wholeWordsCheckBox)
	    @extensionLayout.addWidget(@backwardCheckBox)
	    @extensionLayout.addWidget(@searchSelectionCheckBox)
	    @extension.layout = @extensionLayout
	
	    topLeftLayout = Qt::HBoxLayout.new
	    topLeftLayout.addWidget(@label)
	    topLeftLayout.addWidget(@lineEdit)
	
	    leftLayout = Qt::VBoxLayout.new
	    leftLayout.addLayout(topLeftLayout)
	    leftLayout.addWidget(@caseCheckBox)
	    leftLayout.addWidget(@fromStartCheckBox)
	    leftLayout.addStretch(1)
	
	    rightLayout = Qt::VBoxLayout.new
	    rightLayout.addWidget(@findButton)
	    rightLayout.addWidget(@closeButton)
	    rightLayout.addWidget(@moreButton)
	    rightLayout.addStretch(1)
	
	    mainLayout = Qt::GridLayout.new
	    mainLayout.sizeConstraint = Qt::Layout::SetFixedSize
	    mainLayout.addLayout(leftLayout, 0, 0)
	    mainLayout.addLayout(rightLayout, 0, 1)
	    mainLayout.addWidget(@extension, 1, 0, 1, 2)
	    setLayout(mainLayout)
	
	    setWindowTitle(tr("Extension"))
	    @extension.hide()
	end
end
