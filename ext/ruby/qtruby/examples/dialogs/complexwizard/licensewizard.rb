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

require 'complexwizard.rb'
        
class LicenseWizard < ComplexWizard
    attr_accessor :titlePage
    attr_accessor :evaluatePage
    attr_accessor :registerPage
    attr_accessor :detailsPage
    attr_accessor :finishPage

    def initialize(parent = nil)
        super(parent)
        @titlePage = TitlePage.new(self)
        @evaluatePage = EvaluatePage.new(self)
        @registerPage = RegisterPage.new(self)
        @detailsPage = DetailsPage.new(self)
        @finishPage = FinishPage.new(self)
    
        setFirstPage(@titlePage)
    
        setWindowTitle(tr("Complex Wizard"))
        resize(480, 200)
    end
end

class LicenseWizardPage < WizardPage
    def initialize(wizard)
        super(wizard)
        @wizard = wizard
    end
end

class TitlePage < LicenseWizardPage
    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><font color=\"blue\" size=\"5\"><b><i>" +
                                 "Super Product One</i></b></font></center>"))
    
        @registerRadioButton = Qt::RadioButton.new(tr("&Register your copy"))
        @evaluateRadioButton = Qt::RadioButton.new(tr("&Evaluate our product"))
        setFocusProxy(@registerRadioButton)
    
        layout = Qt::VBoxLayout.new
        layout.addWidget(@topLabel)
        layout.addSpacing(10)
        layout.addWidget(@registerRadioButton)
        layout.addWidget(@evaluateRadioButton)
        layout.addStretch(1)
        setLayout(layout)
    end
    
    def resetPage()
        @registerRadioButton.checked = true
    end
    
    def nextPage()
        if @evaluateRadioButton.checked?
            return @wizard.evaluatePage
        else
            return @wizard.registerPage
        end
    end
end

class EvaluatePage < LicenseWizardPage
    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Evaluate Super Product One" +
                                 "</b></center>"))
    
        @nameLabel = Qt::Label.new(tr("&Name:"))
        @nameLineEdit = Qt::LineEdit.new
        @nameLabel.buddy = @nameLineEdit
        setFocusProxy(@nameLineEdit)
    
        @emailLabel = Qt::Label.new(tr("&Email address:"))
        @emailLineEdit = Qt::LineEdit.new
        @emailLabel.buddy = @emailLineEdit
    
        @bottomLabel = Qt::Label.new(tr("Please fill in both fields.\nThis will " +
                                    "entitle you to a 30-day evaluation."))
    
        connect(@nameLineEdit, SIGNAL('textChanged(QString)'),
                self, SIGNAL('completeStateChanged()'))
        connect(@emailLineEdit, SIGNAL('textChanged(QString)'),
                self, SIGNAL('completeStateChanged()'))
    
        layout = Qt::GridLayout.new
        layout.addWidget(@topLabel, 0, 0, 1, 2)
        layout.setRowMinimumHeight(1, 10)
        layout.addWidget(@nameLabel, 2, 0)
        layout.addWidget(@nameLineEdit, 2, 1)
        layout.addWidget(@emailLabel, 3, 0)
        layout.addWidget(@emailLineEdit, 3, 1)
        layout.setRowMinimumHeight(4, 10)
        layout.addWidget(@bottomLabel, 5, 0, 1, 2)
        layout.setRowStretch(6, 1)
        setLayout(layout)
    end
    
    def resetPage()
        @nameLineEdit.clear()
        @emailLineEdit.clear()
    end
    
    def nextPage()
        return @wizard.finishPage
    end
    
    def isComplete()
        return !@nameLineEdit.text.empty? && !@emailLineEdit.text.empty?
    end
end

class RegisterPage < LicenseWizardPage
    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Register your copy of Super Product " +
                                 "One</b></center>"))
    
        @nameLabel = Qt::Label.new(tr("&Name:"))
        @nameLineEdit = Qt::LineEdit.new
        @nameLabel.buddy = @nameLineEdit
        setFocusProxy(@nameLineEdit)
    
        @upgradeKeyLabel = Qt::Label.new(tr("&Upgrade key:"))
        @upgradeKeyLineEdit = Qt::LineEdit.new
        @upgradeKeyLabel.buddy = @upgradeKeyLineEdit
    
        @bottomLabel = Qt::Label.new(tr("If you have an upgrade key, please fill in " +
                                    "the appropriate field."))
    
        connect(@nameLineEdit, SIGNAL('textChanged(QString)'),
                self, SIGNAL('completeStateChanged()'))
    
        layout = Qt::GridLayout.new
        layout.addWidget(@topLabel, 0, 0, 1, 2)
        layout.setRowMinimumHeight(1, 10)
        layout.addWidget(@nameLabel, 2, 0)
        layout.addWidget(@nameLineEdit, 2, 1)
        layout.addWidget(@upgradeKeyLabel, 3, 0)
        layout.addWidget(@upgradeKeyLineEdit, 3, 1)
        layout.setRowMinimumHeight(4, 10)
        layout.addWidget(@bottomLabel, 5, 0, 1, 2)
        layout.setRowStretch(6, 1)
        setLayout(layout)
    end
    
    def resetPage()
        @nameLineEdit.clear()
        @upgradeKeyLineEdit.clear()
    end
    
    def nextPage()
        if @upgradeKeyLineEdit.text.empty?
            return @wizard.detailsPage
        else
            return @wizard.finishPage
        end
    end
    
    def isComplete()
        return !@nameLineEdit.text.empty?
    end
end

class DetailsPage < LicenseWizardPage
    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Fill in your details</b></center>"))
    
        @companyLabel = Qt::Label.new(tr("&Company name:"))
        @companyLineEdit = Qt::LineEdit.new
        @companyLabel.buddy = @companyLineEdit
        setFocusProxy(@companyLineEdit)
    
        @emailLabel = Qt::Label.new(tr("&Email address:"))
        @emailLineEdit = Qt::LineEdit.new
        @emailLabel.buddy = @emailLineEdit
    
        @postalLabel = Qt::Label.new(tr("&Postal address:"))
        @postalLineEdit = Qt::LineEdit.new
        @postalLabel.buddy = @postalLineEdit
    
        connect(@companyLineEdit, SIGNAL('textChanged(QString)'),
                self, SIGNAL('completeStateChanged()'))
        connect(@emailLineEdit, SIGNAL('textChanged(QString)'),
                self, SIGNAL('completeStateChanged()'))
        connect(@postalLineEdit, SIGNAL('textChanged(QString)'),
                self, SIGNAL('completeStateChanged()'))
    
        layout = Qt::GridLayout.new
        layout.addWidget(@topLabel, 0, 0, 1, 2)
        layout.setRowMinimumHeight(1, 10)
        layout.addWidget(@companyLabel, 2, 0)
        layout.addWidget(@companyLineEdit, 2, 1)
        layout.addWidget(@emailLabel, 3, 0)
        layout.addWidget(@emailLineEdit, 3, 1)
        layout.addWidget(@postalLabel, 4, 0)
        layout.addWidget(@postalLineEdit, 4, 1)
        layout.setRowStretch(5, 1)
        setLayout(layout)
    end
    
    def resetPage()
        @companyLineEdit.clear
        @emailLineEdit.clear
        @postalLineEdit.clear
    end
    
    def nextPage()
        return @wizard.finishPage
    end
    
    def isComplete()
        return !@companyLineEdit.text.empty? &&
               !@emailLineEdit.text.empty? &&
               !@postalLineEdit.text.empty?
    end
end

class FinishPage < LicenseWizardPage
    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Complete your registration" +
                                 "</b></center>"))
    
        @bottomLabel = Qt::Label.new
        @bottomLabel.wordWrap = true
    
        @agreeCheckBox = Qt::CheckBox.new(tr("I agree to the terms and conditions of " +
                                         "the license"))
        setFocusProxy(@agreeCheckBox)
    
        connect(@agreeCheckBox, SIGNAL('toggled(bool)'),
                self, SIGNAL('completeStateChanged()'))
    
        layout = Qt::VBoxLayout.new
        layout.addWidget(@topLabel)
        layout.addSpacing(10)
        layout.addWidget(@bottomLabel)
        layout.addWidget(@agreeCheckBox)
        layout.addStretch(1)
        setLayout(layout)
    end
    
    def resetPage()
        if @wizard.historyPages.include? @wizard.evaluatePage
            licenseText = tr("Evaluation License Agreement: " +
                             "You can use self software for 30 days and make one " +
                             "back up, but you are not allowed to distribute it.")
        elsif @wizard.historyPages.include? @wizard.detailsPage
            licenseText = tr("First-Time License Agreement: " +
                             "You can use self software subject to the license " +
                             "you will receive by email.")
        else
            licenseText = tr("Upgrade License Agreement: " +
                             "This software is licensed under the terms of your " +
                             "current license.")
        end
        @bottomLabel.text = licenseText
        @agreeCheckBox.checked = false
    end

    def isLastPage() return true end

    def isComplete()
        return @agreeCheckBox.checked?
    end
end
