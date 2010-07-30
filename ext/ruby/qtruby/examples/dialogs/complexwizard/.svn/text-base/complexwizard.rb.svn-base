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
	
	
class ComplexWizard < Qt::Dialog
	
	slots   'backButtonClicked()',
    		'nextButtonClicked()',
    		'completeStateChanged()'
	
	def initialize(parent = nil)
	    super(parent)

		@history = []
	    @cancelButton = Qt::PushButton.new(tr("Cancel"))
	    @backButton = Qt::PushButton.new(tr("< &Back"))
	    @nextButton = Qt::PushButton.new(tr("Next >"))
	    @finishButton = Qt::PushButton.new(tr("&Finish"))
	
	    connect(@cancelButton, SIGNAL('clicked()'), self, SLOT('reject()'))
	    connect(@backButton, SIGNAL('clicked()'), self, SLOT('backButtonClicked()'))
	    connect(@nextButton, SIGNAL('clicked()'), self, SLOT('nextButtonClicked()'))
	    connect(@finishButton, SIGNAL('clicked()'), self, SLOT('accept()'))
	
	    @buttonLayout = Qt::HBoxLayout.new
	    @buttonLayout.addStretch(1)
	    @buttonLayout.addWidget(@cancelButton)
	    @buttonLayout.addWidget(@backButton)
	    @buttonLayout.addWidget(@nextButton)
	    @buttonLayout.addWidget(@finishButton)
	
	    @mainLayout = Qt::VBoxLayout.new
	    @mainLayout.addLayout(@buttonLayout)
	    setLayout(@mainLayout)
	end

	def historyPages() return @history end
	
	def setFirstPage(page)
	    page.resetPage()
	    @history.push(page)
	    switchPage(nil)
	end
	
	def backButtonClicked()
	    oldPage = @history.pop()
	    oldPage.resetPage()
	    switchPage(oldPage)
	end
	
	def nextButtonClicked()
	    oldPage = @history.last()
	    newPage = oldPage.nextPage()
	    newPage.resetPage()
	    @history.push(newPage)
	    switchPage(oldPage)
	end
	
	def completeStateChanged()
	    currentPage = @history.last()
	    if currentPage.isLastPage()
	        @finishButton.enabled = currentPage.isComplete()
	    else
	        @nextButton.enabled = currentPage.isComplete()
		end
	end
	
	def switchPage(oldPage)
	    if !oldPage.nil?
	        oldPage.hide()
	        @mainLayout.removeWidget(oldPage)
	        disconnect(oldPage, SIGNAL('completeStateChanged()'),
	                   self, SLOT('completeStateChanged()'))
	    end
	
	    newPage = @history.last()
	    @mainLayout.insertWidget(0, newPage)
	    newPage.show()
	    newPage.setFocus()
	    connect(newPage, SIGNAL('completeStateChanged()'),
	            self, SLOT('completeStateChanged()'))
	
	    @backButton.enabled = @history.size != 1
	    if newPage.isLastPage()
	        @nextButton.enabled = false
	        @finishButton.default = true
	    else
	        @nextButton.default = true
	        @finishButton.enabled = false
	    end
	    completeStateChanged()
	end
end

class WizardPage < Qt::Widget

	signals 'completeStateChanged()'
	
	def initialize(parent = nil)
	    super(parent)
	    hide()
	end
	
	def resetPage()
	end
	
	def nextPage()
	    return 0
	end
	
	def isLastPage()
	    return false
	end
	
	def isComplete()
	    return true
	end
end
