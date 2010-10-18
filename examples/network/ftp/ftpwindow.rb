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
    
    
class FtpWindow < Qt::Dialog
    
    slots :connectOrDisconnect, :downloadFile, :cancelDownload,
        'ftpCommandFinished(int, bool)',
        'addToList(const QUrlInfo &)',
        'processItem(QListWidgetItem *)',
        :cdToParent,
        'updateDataTransferProgress(qint64, qint64)',
        :enableDownloadButton
    
    def initialize(parent = nil)
        super(parent)
        @ftp = nil
        @isDirectory = {}
        @currentPath = ""
        @ftpServerLabel = Qt::Label.new(tr("Ftp &server:"))
        @ftpServerLineEdit = Qt::LineEdit.new("ftp.trolltech.com")
        @ftpServerLabel.buddy = @ftpServerLineEdit
    
        @statusLabel = Qt::Label.new(tr("Please enter the name of an FTP server."))
    
        @fileList = Qt::ListWidget.new
        @fileList.enabled = false
    
        @connectButton = Qt::PushButton.new(tr("Connect"))
        @connectButton.default = true
        
        @downloadButton = Qt::PushButton.new(tr("Download"))
        @downloadButton.enabled = false
    
        @cdToParentButton = Qt::PushButton.new
        @cdToParentButton.icon = Qt::Icon.new("images/cdtoparent.png")
        @cdToParentButton.enabled = false
    
        @quitButton = Qt::PushButton.new(tr("Quit"))
    
        @progressDialog = Qt::ProgressDialog.new(self)
    
        connect(@fileList, SIGNAL('itemDoubleClicked(QListWidgetItem *)'),
                self, SLOT('processItem(QListWidgetItem *)'))
        connect(@fileList, SIGNAL(:itemSelectionChanged),
                self, SLOT(:enableDownloadButton))
        connect(@progressDialog, SIGNAL(:canceled), self, SLOT(:cancelDownload))
        connect(@connectButton, SIGNAL(:clicked), self, SLOT(:connectOrDisconnect))
        connect(@cdToParentButton, SIGNAL(:clicked), self, SLOT(:cdToParent))
        connect(@downloadButton, SIGNAL(:clicked), self, SLOT(:downloadFile))
        connect(@quitButton, SIGNAL(:clicked), self, SLOT(:close))
    
        topLayout = Qt::HBoxLayout.new do |t|
            t.addWidget(@ftpServerLabel)
            t.addWidget(@ftpServerLineEdit)
            t.addWidget(@cdToParentButton)
            t.addWidget(@connectButton)
        end
        
        buttonLayout = Qt::HBoxLayout.new do |b|
            b.addStretch(1)
            b.addWidget(@downloadButton)
            b.addWidget(@quitButton)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addLayout(topLayout)
            m.addWidget(@fileList)
            m.addWidget(@statusLabel)
            m.addLayout(buttonLayout)
        end
    
        setWindowTitle(tr("FTP"))
    end
    
    def connectOrDisconnect()
        @currentPath = ""
        @isDirectory = {}

        if !@ftp.nil?
            @ftp.abort
            @ftp.deleteLater
            @fileList.enabled = false
            @downloadButton.enabled = false
            @connectButton.text = tr("Connect")
            return
        end
        
        Qt::Application.overrideCursor = Qt::Cursor.new(Qt::WaitCursor)
        
        @ftp = Qt::Ftp.new(self)
        connect(@ftp, SIGNAL('commandFinished(int, bool)'),
                self, SLOT('ftpCommandFinished(int, bool)'))
        connect(@ftp, SIGNAL('listInfo(const QUrlInfo &)'),
                self, SLOT('addToList(const QUrlInfo &)'))
        connect(@ftp, SIGNAL('dataTransferProgress(qint64, qint64)'),
                self, SLOT('updateDataTransferProgress(qint64, qint64)'))
    
        @ftp.connectToHost(@ftpServerLineEdit.text())
        @ftp.login()
        @ftp.list()
    
        @fileList.enabled = true
        @connectButton.text = tr("Disconnect")
        @statusLabel.text = tr("Connecting to FTP server %s..." % @ftpServerLineEdit.text)
    end
    
    def downloadFile()
        @fileName = @fileList.currentItem().text()
    
        if Qt::File.exists(@fileName)
            Qt::MessageBox.information(self, tr("FTP"),
                                     tr("There already exists a @file called %s in " \
                                        "the current directory." %
                                     @fileName) )
            return
        end
    
        @file = Qt::File.new(@fileName)
        if !@file.open(Qt::IODevice::WriteOnly)
            Qt::MessageBox.information(self, tr("FTP"),
                                     tr("Unable to save the @file %s: %s." %
                                     [@fileName, file.errorString] ) )
            @file.dispose
            return
        end
    
        @ftp.get(@fileList.currentItem.text, @file)
    
        @progressDialog.labelText = tr("Downloading %s..." % @fileName)
        @progressDialog.show()
        @downloadButton.enabled = false
    end
    
    def cancelDownload()
        @ftp.abort()
    end
    
    def ftpCommandFinished(count, error)
        if @ftp.currentCommand == Qt::Ftp::ConnectToHost
            if error
                Qt::Application.restoreOverrideCursor
                Qt::MessageBox.information(self, tr("FTP"),
                                         tr("Unable to connect to the FTP server " \
                                            "at %s. Please check that the host " \
                                            "name is correct." %
                                         @ftpServerLineEdit.text) )
                return
            end
    
            @statusLabel.text = tr("Logged onto %s." % @ftpServerLineEdit.text)
            @fileList.setFocus()
            @downloadButton.default = true
            return
        end
    
        if @ftp.currentCommand == Qt::Ftp::Get
            Qt::Application.restoreOverrideCursor
            if error
                @statusLabel.text = tr("Canceled download of %s." %
                                     @file.fileName)
                @file.close
                @file.remove
            else
                @statusLabel.text = tr("Downloaded %s to current directory." %
                                     @file.fileName)
                @file.close
            end
            @file.dispose
            enableDownloadButton()
        elsif @ftp.currentCommand == Qt::Ftp::List
            Qt::Application.restoreOverrideCursor
            if @isDirectory.empty?
                @fileList.addItem(tr("<empty>"))
                @fileList.enabled = false
            end
        end
    end
    
    def addToList(urlInfo)
        item = Qt::ListWidgetItem.new
        item.text = urlInfo.name()
        pixmap = Qt::Pixmap.new(urlInfo.dir? ? "images/dir.png" : "images/file.png")

        item.icon = Qt::Icon.new(pixmap)
    
        @isDirectory[urlInfo.name()] = urlInfo.isDir()
        @fileList.addItem(item)
        if @fileList.currentItem.nil?
            @fileList.currentItem = @fileList.item(0)
            @fileList.enabled = true
        end
    end
    
    def processItem(item)
        name = item.text
        if @isDirectory[name]
            @fileList.clear()
            @isDirectory.clear()
            @currentPath += "/" + name
            @ftp.cd(name)
            @ftp.list
            @cdToParentButton.enabled = true
            Qt::Application.overrideCursor = Qt::WaitCursor
            return
        end
    end
    
    def cdToParent()
        Qt::Application.overrideCursor = Qt::WaitCursor
        @fileList.clear()
        @isDirectory.clear()
        @currentPath = @currentPath.slice(@currentPath.rindex('/'), @currentPath.length)
        if @currentPath.empty?
            @cdToParentButton.enabled = false
            @ftp.cd("/")
        else
            @ftp.cd(@currentPath)
        end
        @ftp.list()
    end
    
    def updateDataTransferProgress(readBytes, totalBytes)
        @progressDialog.maximum = totalBytes
        @progressDialog.value = readBytes
    end
    
    def enableDownloadButton()
        current = @fileList.currentItem()
        if !current.nil?
            currentFile = current.text()
            @downloadButton.enabled = !@isDirectory[currentFile]
        else
            @downloadButton.enabled = false
        end
    end
end
