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
    
class Window < Qt::Widget

    slots 'browse()', 'find()'
    
    def initialize(parent = nil)
        super(parent)
        @browseButton = createButton(tr("&Browse..."), SLOT('browse()'))
        @findButton = createButton(tr("&Find"), SLOT('find()'))
        @quitButton = createButton(tr("&Quit"), SLOT('close()'))
    
        @fileComboBox = createComboBox(tr("*"))
        @textComboBox = createComboBox()
        @directoryComboBox = createComboBox(Qt::Dir.currentPath())
    
        @fileLabel = Qt::Label.new(tr("Named:"))
        @textLabel = Qt::Label.new(tr("Containing text:"))
        @directoryLabel = Qt::Label.new(tr("In directory:"))
        @filesFoundLabel = Qt::Label.new
    
        createFilesTable()
    
        buttonsLayout = Qt::HBoxLayout.new
        buttonsLayout.addStretch()
        buttonsLayout.addWidget(@findButton)
        buttonsLayout.addWidget(@quitButton)
    
        mainLayout = Qt::GridLayout.new
        mainLayout.addWidget(@fileLabel, 0, 0)
        mainLayout.addWidget(@fileComboBox, 0, 1, 1, 2)
        mainLayout.addWidget(@textLabel, 1, 0)
        mainLayout.addWidget(@textComboBox, 1, 1, 1, 2)
        mainLayout.addWidget(@directoryLabel, 2, 0)
        mainLayout.addWidget(@directoryComboBox, 2, 1)
        mainLayout.addWidget(@browseButton, 2, 2)
        mainLayout.addWidget(@filesTable, 3, 0, 1, 3)
        mainLayout.addWidget(@filesFoundLabel, 4, 0)
        mainLayout.addLayout(buttonsLayout, 5, 0, 1, 3)
        setLayout(mainLayout)
    
        setWindowTitle(tr("Find Files"))
        resize(700, 300)
    end
    
    def browse()
        directory = Qt::FileDialog.getExistingDirectory(self,
                                   tr("Find Files"), Qt::Dir.currentPath())
        @directoryComboBox.addItem(directory)
        @directoryComboBox.currentIndex += 1
    end
    
    def find()
        @filesTable.rowCount = 0
    
        fileName = @fileComboBox.currentText()
        text = @textComboBox.currentText()
        path = @directoryComboBox.currentText()
    
        directory = Qt::Dir.new(path)
        if fileName.empty?
            fileName = "*"
        end
        files = directory.entryList([fileName],
                                    Qt::Dir::Files | Qt::Dir::NoSymLinks)
    
        if !text.empty?
            files = findFiles(directory, files, text)
        end
        showFiles(directory, files)
    end
    
    def findFiles(directory, files, text)
        progressDialog = Qt::ProgressDialog.new(self) do |p|
            p.cancelButtonText = tr("&Cancel")
            p.range = 0..files.length
            p.windowTitle = tr("Find Files")
        end
        foundFiles = []
    
        (0...files.length).each do |i|
            progressDialog.value = i
            progressDialog.labelText = tr("Searching file number %s of %s..." % [i, files.length])
            $qApp.processEvents()
    
            if progressDialog.wasCanceled
                break
            end
    
            file = Qt::File.new(directory.absoluteFilePath(files[i]))
    
            if file.open(Qt::IODevice::ReadOnly.to_i)
                inf = Qt::TextStream.new(file)
                while !inf.atEnd()
                    if progressDialog.wasCanceled()
                        break
                    end
                    line = inf.readLine()
                    if line.include?(text)
                        foundFiles << files[i]
                        break
                    end
                end
            end
        end

        progressDialog.dispose
        return foundFiles
    end
    
    def showFiles(directory, files)
        (0...files.length).each do |i|
            file = Qt::File.new(directory.absoluteFilePath(files[i]))
            size = Qt::FileInfo.new(file).size()
    
            fileNameItem = Qt::TableWidgetItem.new(files[i])
            fileNameItem.flags = Qt::ItemIsEnabled.to_i
            sizeItem = Qt::TableWidgetItem.new("%d KB" % ((size + 1023) / 1024))
            sizeItem.textAlignment = Qt::AlignVCenter | Qt::AlignRight
            sizeItem.flags = Qt::ItemIsEnabled.to_i
    
            row = @filesTable.rowCount()
            @filesTable.insertRow(row)
            @filesTable.setItem(row, 0, fileNameItem)
            @filesTable.setItem(row, 1, sizeItem)
        end
        @filesFoundLabel.text = tr("%d file(s) found" % files.length())
    end
    
    def createButton(text,  member)
        button = Qt::PushButton.new(text)
        connect(button, SIGNAL('clicked()'), self, member)
        return button
    end
    
    def createComboBox(text = "")
        comboBox = Qt::ComboBox.new
        comboBox.editable = true
        comboBox.addItem(text)
        comboBox.setSizePolicy(Qt::SizePolicy::Expanding, Qt::SizePolicy::Preferred)
        return comboBox
    end
    
    def createFilesTable()
        @filesTable = Qt::TableWidget.new(0, 2)
        labels = []
        labels << tr("File Name") << tr("Size")
        @filesTable.horizontalHeaderLabels = labels
        @filesTable.horizontalHeader().setResizeMode(0, Qt::HeaderView::Stretch)
        @filesTable.verticalHeader().hide()
        @filesTable.showGrid = false
    end
    
end
