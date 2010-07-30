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
        
class SimpleWizard < Qt::Dialog
    
    slots 'backButtonClicked()', 'nextButtonClicked()'
        
    def initialize(parent = nil)
        super(parent)
        @history = []
        @numPages = 0
        @cancelButton = Qt::PushButton.new(tr("Cancel"))
        @backButton = Qt::PushButton.new(tr("< &Back"))
        @nextButton = Qt::PushButton.new(tr("Next >"))
        @finishButton = Qt::PushButton.new(tr("&Finish"))
    
        connect(@cancelButton, SIGNAL('clicked()'), self, SLOT('reject()'))
        connect(@backButton, SIGNAL('clicked()'), self, SLOT('backButtonClicked()'))
        connect(@nextButton, SIGNAL('clicked()'), self, SLOT('nextButtonClicked()'))
        connect(@finishButton, SIGNAL('clicked()'), self, SLOT('accept()'))
    
        @buttonLayout = Qt::HBoxLayout.new do |b|
			b.addStretch(1)
			b.addWidget(@cancelButton)
			b.addWidget(@backButton)
			b.addWidget(@nextButton)
			b.addWidget(@finishButton)
    	end

        @mainLayout = Qt::VBoxLayout.new {|l| l.addLayout(@buttonLayout)}
        self.layout = @mainLayout
    end
    
    def buttonEnabled=(enable)
        if @history.length == @numPages
            @finishButton.enabled = enable
        else
            @nextButton.enabled = enable
        end
    end
    
    def setNumPages(n)
        @numPages = n
        @history.push createPage(0)
        switchPage(nil)
    end
    
    def backButtonClicked()
        @nextButton.enabled = true
        @finishButton.enabled = true
    
        oldPage = @history.last
        switchPage(oldPage)
    end
    
    def nextButtonClicked()
        @nextButton.enabled = true
        @finishButton.enabled = (@history.length == @numPages - 1)
    
        oldPage = @history.last
        @history.push createPage(@history.length)
        switchPage(oldPage)
    end
    
    def switchPage(oldPage)
        if !oldPage.nil?
            oldPage.hide
            @mainLayout.removeWidget(oldPage)
        end
    
        newPage = @history.last
        @mainLayout.insertWidget(0, newPage)
        newPage.show
        newPage.setFocus
    
        @backButton.enabled = (@history.length != 1)
        if @history.length == @numPages
            @nextButton.enabled = false
            @finishButton.default = true
        else
            @nextButton.default = true
            @finishButton.enabled = false
        end
    
        setWindowTitle(tr("Simple Wizard - Step %d of %d" % 
                          [@history.length, @numPages] ) )
    end
end
