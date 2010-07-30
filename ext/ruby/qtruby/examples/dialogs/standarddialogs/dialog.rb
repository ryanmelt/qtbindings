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
    
    
class Dialog < Qt::Dialog
        
    slots   'setInteger()',
            'setDouble()',
            'setItem()',
            'setText()',
            'setColor()',
            'setFont()',
            'setExistingDirectory()',
            'setOpenFileName()',
            'setOpenFileNames()',
            'setSaveFileName()',
            'criticalMessage()',
            'informationMessage()',
            'questionMessage()',
            'warningMessage()',
            'errorMessage()'
    
    def initialize(parent = nil)
        super(parent)

        @message = tr("<p>Message boxes have a caption, a text, " +
                   "and up to three buttons, each with standard or custom texts." +
                   "<p>Click a button or press Esc.")

        @errorMessageDialog = Qt::ErrorMessage.new(self)
    
        frameStyle = Qt::Frame::Sunken | Qt::Frame::Panel
    
        @integerLabel = Qt::Label.new
        @integerLabel.frameStyle = frameStyle
        integerButton = Qt::PushButton.new(tr("Qt::InputDialog.get&Integer()"))
    
        @doubleLabel = Qt::Label.new
        @doubleLabel.frameStyle = frameStyle
        doubleButton =
                Qt::PushButton.new(tr("Qt::InputDialog.get&Double()"))
    
        @itemLabel = Qt::Label.new
        @itemLabel.frameStyle = frameStyle
        itemButton = Qt::PushButton.new(tr("Qt::InputDialog.getIte&m()"))
    
        @textLabel = Qt::Label.new
        @textLabel.frameStyle = frameStyle
        textButton = Qt::PushButton.new(tr("Qt::InputDialog.get&Text()"))
    
        @colorLabel = Qt::Label.new
        @colorLabel.frameStyle = frameStyle
        colorButton = Qt::PushButton.new(tr("Qt::ColorDialog.get&Color()"))
    
        @fontLabel = Qt::Label.new
        @fontLabel.frameStyle = frameStyle
        fontButton = Qt::PushButton.new(tr("Qt::tFontDialog.get&Font()"))
    
        @directoryLabel = Qt::Label.new
        @directoryLabel.frameStyle = frameStyle
        directoryButton =
                Qt::PushButton.new(tr("Qt::FileDialog.getE&xistingDirectory()"))
    
        @openFileNameLabel = Qt::Label.new
        @openFileNameLabel.frameStyle = frameStyle
        openFileNameButton =
                Qt::PushButton.new(tr("Qt::FileDialog.get&OpenFileName()"))
    
        @openFileNamesLabel = Qt::Label.new
        @openFileNamesLabel.frameStyle = frameStyle
        openFileNamesButton =
                Qt::PushButton.new(tr("Qt::File&Dialog.getOpenFileNames()"))
    
        @saveFileNameLabel = Qt::Label.new
        @saveFileNameLabel.frameStyle = frameStyle
        saveFileNameButton =
                Qt::PushButton.new(tr("Qt::FileDialog.get&SaveFileName()"))
    
        @criticalLabel = Qt::Label.new
        @criticalLabel.frameStyle = frameStyle
        criticalButton =
                Qt::PushButton.new(tr("Qt::MessageBox.critica&l()"))
    
        @informationLabel = Qt::Label.new
        @informationLabel.frameStyle = frameStyle
        informationButton =
                Qt::PushButton.new(tr("Qt::MessageBox.i&nformation()"))
    
        @questionLabel = Qt::Label.new
        @questionLabel.frameStyle = frameStyle
        questionButton =
                Qt::PushButton.new(tr("Qt::MessageBox.&question()"))
    
        @warningLabel = Qt::Label.new
        @warningLabel.frameStyle = frameStyle
        warningButton = Qt::PushButton.new(tr("Qt::MessageBox.&warning()"))
    
        @errorLabel = Qt::Label.new
        @errorLabel.frameStyle = frameStyle
        errorButton =
                Qt::PushButton.new(tr("Qt::ErrorMessage.show&M&essage()"))
    
        connect(integerButton, SIGNAL('clicked()'), self, SLOT('setInteger()'))
        connect(doubleButton, SIGNAL('clicked()'), self, SLOT('setDouble()'))
        connect(itemButton, SIGNAL('clicked()'), self, SLOT('setItem()'))
        connect(textButton, SIGNAL('clicked()'), self, SLOT('setText()'))
        connect(colorButton, SIGNAL('clicked()'), self, SLOT('setColor()'))
        connect(fontButton, SIGNAL('clicked()'), self, SLOT('setFont()'))
        connect(directoryButton, SIGNAL('clicked()'),
                self, SLOT('setExistingDirectory()'))
        connect(openFileNameButton, SIGNAL('clicked()'),
                self, SLOT('setOpenFileName()'))
        connect(openFileNamesButton, SIGNAL('clicked()'),
                self, SLOT('setOpenFileNames()'))
        connect(saveFileNameButton, SIGNAL('clicked()'),
                self, SLOT('setSaveFileName()'))
        connect(criticalButton, SIGNAL('clicked()'), self, SLOT('criticalMessage()'))
        connect(informationButton, SIGNAL('clicked()'),
                self, SLOT('informationMessage()'))
        connect(questionButton, SIGNAL('clicked()'), self, SLOT('questionMessage()'))
        connect(warningButton, SIGNAL('clicked()'), self, SLOT('warningMessage()'))
        connect(errorButton, SIGNAL('clicked()'), self, SLOT('errorMessage()'))
    
        self.layout = Qt::GridLayout.new do |l|
            l.setColumnStretch(1, 1)
            l.setColumnMinimumWidth(1, 250)
            l.addWidget(integerButton, 0, 0)
            l.addWidget(@integerLabel, 0, 1)
            l.addWidget(doubleButton, 1, 0)
            l.addWidget(@doubleLabel, 1, 1)
            l.addWidget(itemButton, 2, 0)
            l.addWidget(@itemLabel, 2, 1)
            l.addWidget(textButton, 3, 0)
            l.addWidget(@textLabel, 3, 1)
            l.addWidget(colorButton, 4, 0)
            l.addWidget(@colorLabel, 4, 1)
            l.addWidget(fontButton, 5, 0)
            l.addWidget(@fontLabel, 5, 1)
            l.addWidget(directoryButton, 6, 0)
            l.addWidget(@directoryLabel, 6, 1)
            l.addWidget(openFileNameButton, 7, 0)
            l.addWidget(@openFileNameLabel, 7, 1)
            l.addWidget(openFileNamesButton, 8, 0)
            l.addWidget(@openFileNamesLabel, 8, 1)
            l.addWidget(saveFileNameButton, 9, 0)
            l.addWidget(@saveFileNameLabel, 9, 1)
            l.addWidget(criticalButton, 10, 0)
            l.addWidget(@criticalLabel, 10, 1)
            l.addWidget(informationButton, 11, 0)
            l.addWidget(@informationLabel, 11, 1)
            l.addWidget(questionButton, 12, 0)
            l.addWidget(@questionLabel, 12, 1)
            l.addWidget(warningButton, 13, 0)
            l.addWidget(@warningLabel, 13, 1)
            l.addWidget(errorButton, 14, 0)
            l.addWidget(@errorLabel, 14, 1)
        end
    
        self.windowTitle = tr("Standard Dialogs")
    end
    
    def setInteger()
        ok = Qt::Boolean.new
        i = Qt::InputDialog.getInteger(self, tr("Qt::InputDialog.getInteger()"),
                                         tr("Percentage:"), 25, 0, 100, 1, ok)
        if ok
            @integerLabel.text = tr("%d%" % i)
        end
    end
    
    def setDouble()
        ok = Qt::Boolean.new
        d = Qt::InputDialog.getDouble(self, tr("Qt::InputDialog.getDouble()"),
                                           tr("Amount:"), 37.56, -10000, 10000, 2, ok)
        if ok
            @doubleLabel.text = "$%f" % d
        end
    end
    
    def setItem()
        items = []
        items << tr("Spring") << tr("Summer") << tr("Fall") << tr("Winter")
    
        ok = Qt::Boolean.new
        item = Qt::InputDialog.getItem(self, tr("Qt::InputDialog.getItem()"),
                                             tr("Season:"), items, 0, false, ok)
        if ok && !item.nil?
            @itemLabel.text = item
        end
    end
    
    def setText()
        ok = Qt::Boolean.new
        text = Qt::InputDialog.getText(self, tr("Qt::InputDialog.getText()"),
                                             tr("User name:"), Qt::LineEdit::Normal,
                                             Qt::Dir::home().dirName(), ok)
        if ok && !text.nil?
            @textLabel.text = text
        end
    end
    
    def setColor()
        color = Qt::ColorDialog.getColor(Qt::Color.new(Qt::green), self)
        if color.isValid()
            @colorLabel.text = color.name
            @colorLabel.palette = Qt::Palette.new(color)
        end
    end
    
    def setFont()
        ok = Qt::Boolean.new
        font = Qt::FontDialog.getFont(ok, Qt::Font.new(@fontLabel.text), self)
        if ok
            @fontLabel.text = font.key()
        end
    end
    
    def setExistingDirectory()
        directory = Qt::FileDialog.getExistingDirectory(self,
                                    tr("Qt::FileDialog.getExistingDirectory()"),
                                    @directoryLabel.text,
                                    Qt::FileDialog::DontResolveSymlinks |
                                    Qt::FileDialog::ShowDirsOnly)
        if !directory.nil?
            @directoryLabel.text = directory
        end
    end
    
    def setOpenFileName()
        fileName = Qt::FileDialog.getOpenFileName(self,
                                    tr("Qt::FileDialog.getOpenFileName()"),
                                    @openFileNameLabel.text,
                                    tr("All Files (*);;Text Files (*.txt)"))
        if !fileName.nil?
            @openFileNameLabel.text = fileName
        end
    end
    
    def setOpenFileNames()
        files = Qt::FileDialog.getOpenFileNames(
                                    self, tr("Qt::FileDialog.getOpenFileNames()"),
                                    @openFilesPath,
                                    tr("All Files (*);;Text Files (*.txt)"))
        if files.length != 0
            @openFilesPath = files[0]
            @openFileNamesLabel.text = "[%s]" % files.join(", ")
        end
    end
    
    def setSaveFileName()
        fileName = Qt::FileDialog.getSaveFileName(self,
                                    tr("Qt::FileDialog.getSaveFileName()"),
                                    @saveFileNameLabel.text,
                                    tr("All Files (*);;Text Files (*.txt)"))
        if !fileName.nil?
            @saveFileNameLabel.text = fileName
        end
    end
    
    def criticalMessage()
        reply = Qt::MessageBox::critical(self, tr("Qt::MessageBox.showCritical()"),
                                          @message,
                                          Qt::MessageBox::Abort,
                                          Qt::MessageBox::Retry,
                                          Qt::MessageBox::Ignore)
        if reply == Qt::MessageBox::Abort
            @criticalLabel.text = tr("Abort")
        elsif reply == Qt::MessageBox::Retry
            @criticalLabel.text = tr("Retry")
        else
            @criticalLabel.text = tr("Ignore")
        end
    end
    
    def informationMessage()
        Qt::MessageBox::information(self, tr("Qt::MessageBox.showInformation()"), @message)
        @informationLabel.text = tr("Closed with OK or Esc")
    end
    
    def questionMessage()
        reply = Qt::MessageBox.question(self, tr("Qt::MessageBox.showQuestion()"),
                                          @message,
                                          Qt::MessageBox::Yes,
                                          Qt::MessageBox::No,
                                          Qt::MessageBox::Cancel)
        if reply == Qt::MessageBox::Yes
            @questionLabel.text = tr("Yes")
        elsif reply == Qt::MessageBox::No
            @questionLabel.text = tr("No")
        else
            @questionLabel.text = tr("Cancel")
        end
    end
    
    def warningMessage()
        reply = Qt::MessageBox.warning(self, tr("Qt::MessageBox.showWarning()"),
                                         @message,
                                         tr("Save &Again"),
                                         tr("&Continue"))
        if reply == 0
            @warningLabel.text = tr("Save Again")
        else
            @warningLabel.text = tr("Continue")
        end
    end
    
    def errorMessage()
        @errorMessageDialog.showMessage(
                tr("This dialog shows and remembers error messages. " +
                   "If the checkbox is checked (as it is by default), " +
                   "the shown message will be shown again, " +
                   "but if the user unchecks the box the message " +
                   "will not appear again if Qt::ErrorMessage.showMessage() " +
                   "is called with the same message."))
        @errorLabel.text = tr("If the box is unchecked, the message " +
                               "won't appear again.")
    end
end
