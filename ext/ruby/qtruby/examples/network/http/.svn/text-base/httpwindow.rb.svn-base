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
	
	
class HttpWindow < Qt::Dialog
		
	slots	:downloadFile,
    		:cancelDownload,
    		'httpRequestFinished(int, bool)',
    		'readResponseHeader(const QHttpResponseHeader &)',
    		'updateDataReadProgress(int, int)',
    		:enableDownloadButton
	
	def initialize(parent = nil)
	    super(parent)
	    @urlLineEdit = Qt::LineEdit.new("http://www.ietf.org/iesg/1rfc_index.txt")
	
	    @urlLabel = Qt::Label.new(tr("&URL:"))
	    @urlLabel.buddy = @urlLineEdit
	    @statusLabel = Qt::Label.new(tr("Please enter the URL of a file you want to " \
	                                "download."))
	
	    @quitButton = Qt::PushButton.new(tr("Quit"))
	    @downloadButton = Qt::PushButton.new(tr("Download"))
	    @downloadButton.default = true
	
	    @progressDialog = Qt::ProgressDialog.new(self)
	
	    @http = Qt::Http.new(self)
	
	    connect(@urlLineEdit, SIGNAL('textChanged(const QString &)'),
	            self, SLOT(:enableDownloadButton))
	    connect(@http, SIGNAL('requestFinished(int, bool)'),
	            self, SLOT('httpRequestFinished(int, bool)'))
	    connect(@http, SIGNAL('dataReadProgress(int, int)'),
	            self, SLOT('updateDataReadProgress(int, int)'))
	    connect(@http, SIGNAL('responseHeaderReceived(const QHttpResponseHeader &)'),
	            self, SLOT('readResponseHeader(const QHttpResponseHeader &)'))
	    connect(@progressDialog, SIGNAL(:canceled), self, SLOT(:cancelDownload))
	    connect(@downloadButton, SIGNAL(:clicked), self, SLOT(:downloadFile))
	    connect(@quitButton, SIGNAL(:clicked), self, SLOT(:close))
	
	    topLayout = Qt::HBoxLayout.new do |t|
	    	t.addWidget(@urlLabel)
	    	t.addWidget(@urlLineEdit)
		end
	
	    buttonLayout = Qt::HBoxLayout.new do |b|
	    	b.addStretch(1)
	    	b.addWidget(@downloadButton)
	    	b.addWidget(@quitButton)
		end
	
	    self.layout = Qt::VBoxLayout.new do |m|
	    	m.addLayout(topLayout)
	    	m.addWidget(@statusLabel)
	    	m.addLayout(buttonLayout)
	    end
	
	    self.windowTitle = tr("HTTP")
	    @urlLineEdit.setFocus()
	end
	
	def downloadFile()
	    url = Qt::Url.new(@urlLineEdit.text)
	    fileInfo = Qt::FileInfo.new(url.path)
	    fileName = fileInfo.fileName
	
	    if Qt::File.exists(fileName)
	        Qt::MessageBox.information(self, tr("HTTP"),
	                                 tr("There already exists a file called %s in " \
	                                    "the current directory." % 
	                                     fileName))
	        return
	    end
	
	    @file = Qt::File.new(fileName)
	    if !@file.open(Qt::IODevice::WriteOnly)
	        Qt::MessageBox.information(self, tr("HTTP"),
	                                 tr("Unable to save the file %s: %s." %
	                                 [fileName, @file.errorString]))
	        @file.dispose
	        return
	    end
	
	    @http.setHost(url.host, url.port != -1 ? url.port : 80)
	    if !url.userName.empty?
	        @http.user = url.userName(url.password)
		end
	
	    @httpRequestAborted = false
	    @httpGetId = @http.get(url.path(), @file)
	
	    @progressDialog.windowTitle = tr("HTTP")
	    @progressDialog.labelText = tr("Downloading %s." % fileName)
	    @downloadButton.enabled = false
	end
	
	def cancelDownload()
	    @statusLabel.text = tr("Download canceled.")
	    @httpRequestAborted = true
	    @http.abort()
	    @downloadButton.enabled = true
	end
	
	def httpRequestFinished(requestId, error)
	    if @httpRequestAborted
	        if !@file.nil?
	            @file.close
	            @file.remove
	            @file.dispose
	            @file = nil
	        end
	
	        @progressDialog.hide
	        return
	    end
	
	    if requestId != @httpGetId
	        return
		end
	
	    @progressDialog.hide
	    @file.close
	
	    if error
	        @file.remove()
	        Qt::MessageBox.information(self, tr("HTTP"),
	                                 tr("Download failed: %s." %
	                                    @http.errorString))
	    else
	        fileName = Qt::FileInfo.new(Qt::Url.new(@urlLineEdit.text).path).fileName
	        @statusLabel.text = tr("Downloaded %s to current directory." % fileName)
	    end
	
	    @downloadButton.enabled = true
	    @file.dispose
	    @file = nil
	end
	
	def readResponseHeader(responseHeader)
	    if responseHeader.statusCode != 200
	        Qt::MessageBox.information(self, tr("HTTP"),
	                                 tr("Download failed: %s." %
	                                    responseHeader.reasonPhrase))
	        @httpRequestAborted = true
	        @progressDialog.hide
	        @http.abort
	        return
	    end
	end
	
	def updateDataReadProgress(bytesRead, totalBytes)
	    if @httpRequestAborted
	        return
		end
	
	    @progressDialog.maximum = totalBytes
	    @progressDialog.value = bytesRead
	end
	
	def enableDownloadButton()
	    @downloadButton.enabled = !@urlLineEdit.text.empty?
	end
end
