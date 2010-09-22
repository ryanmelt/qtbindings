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
    
require './simplewizard.rb'
    
class ClassWizard < SimpleWizard

    attr_accessor :firstPage, :secondPage, :thirdPage

    def initialize(parent = nil)
        super(parent)
        setNumPages(3)
    end
    
    def createPage(index)
        case index
        when 0:
            @firstPage = FirstPage.new(self)
            return @firstPage
        when 1:
            @secondPage = SecondPage.new(self)
            return @secondPage
        when 2:
            @thirdPage = ThirdPage.new(self)
            return @thirdPage
        end
        return nil
    end
    
    def accept()
        className = @firstPage.classNameLineEdit.text
        baseClass = @firstPage.baseClassLineEdit.text
        qobjectMacro = @firstPage.qobjectMacroCheckBox.checked?
        qobjectCtor = @firstPage.qobjectCtorRadioButton.checked?
        qwidgetCtor = @firstPage.qwidgetCtorRadioButton.checked?
        defaultCtor = @firstPage.defaultCtorRadioButton.checked?
        copyCtor = @firstPage.copyCtorCheckBox.checked?
    
        comment = @secondPage.commentCheckBox.checked?
        protect = @secondPage.protectCheckBox.checked?
        macroName = @secondPage.macroNameLineEdit.text
        includeBase = @secondPage.includeBaseCheckBox.checked?
        baseInclude = @secondPage.baseIncludeLineEdit.text
    
        outputDir = @thirdPage.outputDirLineEdit.text
        header = @thirdPage.headerLineEdit.text
        implementation = @thirdPage.implementationLineEdit.text
    
        block = Qt::ByteArray.new
    
        if comment
            block += "/*\n"
            block += "    " + header + "\n"
            block += "*/\n"
            block += "\n"
        end
        if protect
            block += "#ifndef " + macroName + "\n"
            block += "#define " + macroName + "\n"
            block += "\n"
        end
        if includeBase
            block += "#include " + baseInclude + "\n"
            block += "\n"
        end
    
        block += "class " + className
        if !baseClass.empty?
            block += " : public " + baseClass
        end
        block += "\n"
        block += "{\n"
    
        # qmake ignore Q_OBJECT
    
        if qobjectMacro
            block += "    Q_OBJECT\n"
            block += "\n"
        end
        block += "public:\n"
    
        if qobjectCtor
            block += "    " + className + "(QObject *parent);\n"
        elsif qwidgetCtor
            block += "    " + className + "(QWidget *parent);\n"
        elsif defaultCtor
            block += "    " + className + "();\n"
            if copyCtor
                block += "    " + className + "(const " + className + " &other);\n"
                block += "\n"
                block += "    " + className + " &operator=" + "(const " + className +
                         " &other);\n"
            end
        end
        block += "};\n"
    
        if protect
            block += "\n"
            block += "#endif\n"
        end
    
        headerFile = Qt::File.new(outputDir + "/" + header)
        if !headerFile.open(Qt::File::WriteOnly | Qt::File::Text)
            Qt::MessageBox.warning(self, tr("Simple Wizard"),
                                 tr(    "Cannot write file %s:\n%s" %
                                    [   headerFile.fileName(), headerFile.errorString()] ) )
            return
        end

        headerFile.write(block)
    
        block = Qt::ByteArray.new
    
        if comment
            block += "/*\n"
            block += "    " + implementation + "\n"
            block += "*/\n"
            block += "\n"
        end
        block += "#include \"" + header + "\"\n"
        block += "\n"
    
        if qobjectCtor
            block += className + "::" + className + "(QObject *parent)\n"
            block += "    : " + baseClass + "(parent)\n"
            block += "{\n"
            block += "}\n"
        elsif qwidgetCtor
            block += className + "::" + className + "(QWidget *parent)\n"
            block += "    : " + baseClass + "(parent)\n"
            block += "{\n"
            block += "}\n"
        elsif defaultCtor
            block += className + "::" + className + "()\n"
            block += "{\n"
            block += "    // missing code\n"
            block += "}\n"
    
            if copyCtor
                block += "\n"
                block += className + "::" + className + "(const " + className +
                         " &other)\n"
                block += "{\n"
                block += "    *this = other;\n"
                block += "}\n"
                block += "\n"
                block += className + " &" + className + "::operator=(const " +
                         className + " &other)\n"
                block += "{\n"
                if !baseClass.empty?
                    block += "    " + baseClass + "::operator=(other);\n"
                end
                block += "    // missing code\n"
                block += "    return *this;\n"
                block += "}\n"
            end
        end
    
        implementationFile = Qt::File.new(outputDir + "/" + implementation)

        if !implementationFile.open(Qt::File::WriteOnly | Qt::File::Text)
            Qt::MessageBox.warning(self, tr("Simple Wizard"),
                                 tr("Cannot write file %s:\n%s" %
                                       [    implementationFile.fileName(), 
                                            implementationFile.errorString() ] ) )
            return
        end

        implementationFile.write(block)
        super
    end
end

class FirstPage < Qt::Widget

    attr_accessor :classNameLineEdit, :baseClassLineEdit, :headerLineEdit,
                  :qobjectMacroCheckBox, :qobjectCtorRadioButton,
                  :qwidgetCtorRadioButton, :defaultCtorRadioButton,
                  :copyCtorCheckBox
    
    slots 'classNameChanged()'
    
    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Class information</b></center>" +
                                 "<p>This wizard will generate a skeleton class " +
                                 "definition and member function definitions."))
        @topLabel.wordWrap = false
    
        @classNameLabel = Qt::Label.new(tr("Class &name:"))
        @classNameLineEdit = Qt::LineEdit.new
        @classNameLabel.buddy = @classNameLineEdit
        setFocusProxy(@classNameLineEdit)
    
        @baseClassLabel = Qt::Label.new(tr("&Base class:"))
        @baseClassLineEdit = Qt::LineEdit.new
        @baseClassLabel.buddy = @baseClassLineEdit
    
        @qobjectMacroCheckBox = Qt::CheckBox.new(tr("&Generate Q_OBJECT macro"))
    
        @groupBox = Qt::GroupBox.new(tr("&Constructor"))
    
        @qobjectCtorRadioButton = Qt::RadioButton.new(tr("&QObject-style constructor"))
        @qwidgetCtorRadioButton = Qt::RadioButton.new(tr("Q&Widget-style constructor"))
        @defaultCtorRadioButton = Qt::RadioButton.new(tr("&Default constructor"))
        @copyCtorCheckBox = Qt::CheckBox.new(tr("&Also generate copy constructor and " +
                                            "assignment operator"))
    
        @defaultCtorRadioButton.checked = true
    
        connect(@classNameLineEdit, SIGNAL('textChanged(const QString &)'),
                self, SLOT('classNameChanged()'))
        connect(@defaultCtorRadioButton, SIGNAL('toggled(bool)'),
                @copyCtorCheckBox, SLOT('setEnabled(bool)'))
    
        wizard.buttonEnabled = false
    
        @groupBox.layout = Qt::VBoxLayout.new do |g|
            g.addWidget(@qobjectCtorRadioButton)
            g.addWidget(@qwidgetCtorRadioButton)
            g.addWidget(@defaultCtorRadioButton)
            g.addWidget(@copyCtorCheckBox)
        end
    
        self.layout = Qt::GridLayout.new do |l|
            l.addWidget(@topLabel, 0, 0, 1, 2)
            l.setRowMinimumHeight(1, 10)
            l.addWidget(@classNameLabel, 2, 0)
            l.addWidget(@classNameLineEdit, 2, 1)
            l.addWidget(@baseClassLabel, 3, 0)
            l.addWidget(@baseClassLineEdit, 3, 1)
            l.addWidget(@qobjectMacroCheckBox, 4, 0, 1, 2)
            l.addWidget(@groupBox, 5, 0, 1, 2)
            l.setRowStretch(6, 1)
        end
    end
    
    def classNameChanged()
        wizard = parent()
        wizard.buttonEnabled = !@classNameLineEdit.text.empty?
    end
end

class SecondPage < Qt::Widget

    attr_accessor :commentCheckBox, :protectCheckBox, :includeBaseCheckBox,
                  :macroNameLineEdit, :baseIncludeLineEdit,
                  :protectCheckBox, :commentCheckBox, :includeBaseCheckBox

    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Code style options</b></center>"))
    
        @commentCheckBox = Qt::CheckBox.new(tr("&Start generated files with a comment"))
        @commentCheckBox.checked = true
        setFocusProxy(@commentCheckBox)
    
        @protectCheckBox = Qt::CheckBox.new(tr("&Protect header file against multiple " +
                                           "inclusions"))
        @protectCheckBox.checked = true
    
        @macroNameLabel = Qt::Label.new(tr("&Macro name:"))
        @macroNameLineEdit = Qt::LineEdit.new
        @macroNameLabel.buddy = @macroNameLineEdit
    
        @includeBaseCheckBox = Qt::CheckBox.new(tr("&Include base class definition"))
        @baseIncludeLabel = Qt::Label.new(tr("Base class include:"))
        @baseIncludeLineEdit = Qt::LineEdit.new
        @baseIncludeLabel.buddy = @baseIncludeLineEdit
    
        className = wizard.firstPage.classNameLineEdit.text()
        @macroNameLineEdit.text = className.upcase + "_H"
    
        baseClass = wizard.firstPage.baseClassLineEdit.text()
        if baseClass.empty?
            @includeBaseCheckBox.enabled = false
            @baseIncludeLabel.enabled = false
            @baseIncludeLineEdit.enabled = false
        else
            @includeBaseCheckBox.checked = true
            if Regexp.new("Q[A-Z].*").match(baseClass)
                @baseIncludeLineEdit.text = "<" + baseClass + ">"
            else
                @baseIncludeLineEdit.text = '"' + baseClass.downcase + '.h"'
            end
        end
    
        connect(@protectCheckBox, SIGNAL('toggled(bool)'),
                @macroNameLabel, SLOT('setEnabled(bool)'))
        connect(@protectCheckBox, SIGNAL('toggled(bool)'),
                @macroNameLineEdit, SLOT('setEnabled(bool)'))
        connect(@includeBaseCheckBox, SIGNAL('toggled(bool)'),
                @baseIncludeLabel, SLOT('setEnabled(bool)'))
        connect(@includeBaseCheckBox, SIGNAL('toggled(bool)'),
                @baseIncludeLineEdit, SLOT('setEnabled(bool)'))
    
        self.layout = Qt::GridLayout.new do |l|
            l.setColumnMinimumWidth(0, 20)
            l.addWidget(@topLabel, 0, 0, 1, 3)
            l.setRowMinimumHeight(1, 10)
            l.addWidget(@commentCheckBox, 2, 0, 1, 3)
            l.addWidget(@protectCheckBox, 3, 0, 1, 3)
            l.addWidget(@macroNameLabel, 4, 1)
            l.addWidget(@macroNameLineEdit, 4, 2)
            l.addWidget(@includeBaseCheckBox, 5, 0, 1, 3)
            l.addWidget(@baseIncludeLabel, 6, 1)
            l.addWidget(@baseIncludeLineEdit, 6, 2)
            l.setRowStretch(7, 1)
        end
    end
end


class ThirdPage < Qt::Widget

    attr_accessor :outputDirLineEdit, :headerLineEdit, :implementationLineEdit

    def initialize(wizard)
        super(wizard)
        @topLabel = Qt::Label.new(tr("<center><b>Output files</b></center>"))
    
        @outputDirLabel = Qt::Label.new(tr("&Output directory:"))
        @outputDirLineEdit = Qt::LineEdit.new
        @outputDirLabel.buddy = @outputDirLineEdit
        self.focusProxy = @outputDirLineEdit
    
        @headerLabel = Qt::Label.new(tr("&Header file name:"))
        @headerLineEdit = Qt::LineEdit.new
        @headerLabel.buddy = @headerLineEdit
    
        @implementationLabel = Qt::Label.new(tr("&Implementation file name:"))
        @implementationLineEdit = Qt::LineEdit.new
        @implementationLabel.buddy = @implementationLineEdit
    
        className = wizard.firstPage.classNameLineEdit.text()
        @headerLineEdit.text = className.downcase + ".h"
        @implementationLineEdit.text = className.downcase + ".cpp"
        @outputDirLineEdit.text = Qt::Dir.convertSeparators(Qt::Dir.homePath())
    
        self.layout = Qt::GridLayout.new do |l|
            l.addWidget(@topLabel, 0, 0, 1, 2)
            l.setRowMinimumHeight(1, 10)
            l.addWidget(@outputDirLabel, 2, 0)
            l.addWidget(@outputDirLineEdit, 2, 1)
            l.addWidget(@headerLabel, 3, 0)
            l.addWidget(@headerLineEdit, 3, 1)
            l.addWidget(@implementationLabel, 4, 0)
            l.addWidget(@implementationLineEdit, 4, 1)
            l.setRowStretch(5, 1)
        end
    end
end
