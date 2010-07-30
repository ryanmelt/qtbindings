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
	
	slots	:start,
    		:acceptConnection,
    		:startTransfer,
    		:updateServerProgress,
    		'updateClientProgress(qint64)',
    		'displayError(QAbstractSocket::SocketError)'
	
	TotalBytes = 50 * 1024 * 1024
	PayloadSize = 65536
	
	def initialize(parent = nil)
	    super(parent)
		@tcpServer = Qt::TcpServer.new
		@tcpClient = Qt::TcpSocket.new
	    @clientProgressBar = Qt::ProgressBar.new
	    @clientStatusLabel = Qt::Label.new(tr("Client ready"))
	    @serverProgressBar = Qt::ProgressBar.new
	    @serverStatusLabel = Qt::Label.new(tr("Server ready"))
	
	    @startButton = Qt::PushButton.new(tr("&Start"))
	    @quitButton = Qt::PushButton.new(tr("&Quit"))
	
	    connect(@startButton, SIGNAL(:clicked), self, SLOT(:start))
	    connect(@quitButton, SIGNAL(:clicked), self, SLOT(:close))
	    connect(@tcpServer, SIGNAL(:newConnection),
	            self, SLOT(:acceptConnection))
	    connect(@tcpClient, SIGNAL(:connected), self, SLOT(:startTransfer))
	    connect(@tcpClient, SIGNAL('bytesWritten(qint64)'),
	            self, SLOT('updateClientProgress(qint64)'))
	    connect(@tcpClient, SIGNAL('error(QAbstractSocket::SocketError)'),
	            self, SLOT('displayError(QAbstractSocket::SocketError)'))
	
	    buttonLayout = Qt::HBoxLayout.new do |b|
	    	b.addStretch(1)
	    	b.addWidget(@startButton)
	    	b.addWidget(@quitButton)
		end
	
	    self.layout = Qt::VBoxLayout.new do |m|
			m.addWidget(@clientProgressBar)
			m.addWidget(@clientStatusLabel)
			m.addWidget(@serverProgressBar)
			m.addWidget(@serverStatusLabel)
			m.addLayout(buttonLayout)
	    end
	
	    self.windowTitle = tr("Loopback")
	end
	
	def start()
	    @startButton.enabled = false
	
	    Qt::Application.overrideCursor = Qt::Cursor.new(Qt::WaitCursor)
	
	    @bytesWritten = 0
	    @bytesReceived = 0
	
	    while !@tcpServer.isListening && !@tcpServer.listen do
	        ret = Qt::MessageBox.critical(self, tr("Loopback"),
	                                        tr("Unable to start the test: %s." % @tcpServer.errorString),
	                                        Qt::MessageBox::Retry,
						                    Qt::MessageBox::Cancel)
	        if ret == Qt::MessageBox::Cancel
	            return
			end
	    end
	
	    @serverStatusLabel.text = tr("Listening")
	    @clientStatusLabel.text = tr("Connecting")
	    @tcpClient.connectToHost(Qt::HostAddress.new(Qt::HostAddress::LocalHost), 
								@tcpServer.serverPort)
	end
	
	def acceptConnection()
	    @tcpServerConnection = @tcpServer.nextPendingConnection
	    connect(@tcpServerConnection, SIGNAL(:readyRead),
	            self, SLOT(:updateServerProgress))
	    connect(@tcpServerConnection, SIGNAL('error(QAbstractSocket::SocketError)'),
	            self, SLOT('displayError(QAbstractSocket::SocketError)'))
	
	    @serverStatusLabel.text = tr("Accepted connection")
	    @tcpServer.close()
	end
	
	def startTransfer()
	    @bytesToWrite = TotalBytes - @tcpClient.write(Qt::ByteArray.new('@' * PayloadSize))
	    @clientStatusLabel.text = tr("Connected")
	end
	
	def updateServerProgress()
	    @bytesReceived += @tcpServerConnection.bytesAvailable
	    @tcpServerConnection.readAll()
	
	    @serverProgressBar.maximum = TotalBytes
	    @serverProgressBar.value = @bytesReceived
	    @serverStatusLabel.text = tr("Received %dMB" %
	                                  (@bytesReceived / (1024 * 1024)))
	
	    if @bytesReceived == TotalBytes
	        @tcpServerConnection.close
	        @startButton.enabled = true
	        Qt::Application.restoreOverrideCursor
	    end
	end
	
	def updateClientProgress(numBytes)
	    @bytesWritten += numBytes
	    if @bytesToWrite > 0
	        @bytesToWrite -= @tcpClient.write(Qt::ByteArray.new('@' * [@bytesToWrite, PayloadSize].min))
		end

	    @clientProgressBar.maximum = TotalBytes
	    @clientProgressBar.value = @bytesWritten
	    @clientStatusLabel.text = tr("Sent %dMB" % 
	                                 (@bytesWritten / (1024 * 1024)) )
	end
	
	def displayError(socketError)
	    if socketError == Qt::TcpSocket::RemoteHostClosedError
	        return
		end
	
	    Qt::MessageBox.information(self, tr("Network error"),
	                             tr("The following error occurred: %s." %
	                                 tcpClient.errorString))
	
	    @tcpClient.close
	    @tcpServer.close
	    @clientProgressBar.reset
	    @serverProgressBar.reset
	    @clientStatusLabel.text = tr("Client ready")
	    @serverStatusLabel.text = tr("Server ready")
	    @startButton.enabled = true
	    Qt::Application.restoreOverrideCursor
	end
end
