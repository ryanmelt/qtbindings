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
        
class Client < Qt::Dialog
    
    slots   'requestNewFortune()',
            'readFortune()',
            'displayError(QAbstractSocket::SocketError)',
            'enableGetFortuneButton()'
    
    def initialize(parent = nil)
        super(parent)
        @hostLabel = Qt::Label.new(tr("&Server name:"))
        @portLabel = Qt::Label.new(tr("S&erver port:"))
    
        @hostLineEdit = Qt::LineEdit.new("Localhost")
        @portLineEdit = Qt::LineEdit.new
        @portLineEdit.validator = Qt::IntValidator.new(1, 65535, self)
    
        @hostLabel.buddy = @hostLineEdit
        @portLabel.buddy = @portLineEdit
    
        @statusLabel = Qt::Label.new(tr("This example requires that you run the " +
                                    "Fortune Server example as well."))
    
        @getFortuneButton = Qt::PushButton.new(tr("Get Fortune")) do |b|
            b.default = true
            b.enabled = false
        end
    
        @quitButton = Qt::PushButton.new(tr("Quit"))
    
        @tcpSocket = Qt::TcpSocket.new(self)
    
        connect(@hostLineEdit, SIGNAL('textChanged(const QString &)'),
                self, SLOT('enableGetFortuneButton()'))
        connect(@portLineEdit, SIGNAL('textChanged(const QString &)'),
                self, SLOT('enableGetFortuneButton()'))
        connect(@getFortuneButton, SIGNAL('clicked()'),
                self, SLOT('requestNewFortune()'))
        connect(@quitButton, SIGNAL('clicked()'), self, SLOT('close()'))
        connect(@tcpSocket, SIGNAL('readyRead()'), self, SLOT('readFortune()'))
        connect(@tcpSocket, SIGNAL('error(QAbstractSocket::SocketError)'), self, SLOT('displayError(QAbstractSocket::SocketError)'))
    
        buttonLayout = Qt::HBoxLayout.new do |b|
            b.addStretch(1)
            b.addWidget(@getFortuneButton)
            b.addWidget(@quitButton)
        end
    
        self.layout = Qt::GridLayout.new do |m|
            m.addWidget(@hostLabel, 0, 0)
            m.addWidget(@hostLineEdit, 0, 1)
            m.addWidget(@portLabel, 1, 0)
            m.addWidget(@portLineEdit, 1, 1)
            m.addWidget(@statusLabel, 2, 0, 1, 2)
            m.addLayout(buttonLayout, 3, 0, 1, 2)
        end
    
        self.windowTitle = tr("Fortune Client")
        @portLineEdit.setFocus()
    end
    
    def requestNewFortune
        @getFortuneButton.enabled = false
        @blockSize = 0
        @tcpSocket.abort
        @tcpSocket.connectToHost(@hostLineEdit.text,
                                 @portLineEdit.text.to_i)
    end
    
    def readFortune
        inf = Qt::DataStream.new(@tcpSocket)
        inf.version = Qt::DataStream::Qt_4_0
    
        if @blockSize == 0
            if @tcpSocket.bytesAvailable < 4
                return
            end
    
            inf >> @blockSize
        end
    
        if @tcpSocket.bytesAvailable < @blockSize
            return
        end
    
        nextFortune = ""
        inf >> nextFortune
    
        if nextFortune == @currentFortune
            Qt::Timer.singleShot(0, self, SLOT('requestNewFortune()'))
            return
        end
    
        @currentFortune = nextFortune
        @statusLabel.text = @currentFortune
        @getFortuneButton.enabled = true
    end
    
    def displayError(socketError)
        case socketError
        when Qt::AbstractSocket::RemoteHostClosedError
        when Qt::AbstractSocket::HostNotFoundError
            Qt::MessageBox.information(self, tr("Fortune Client"),
                                     tr("The host was not found. Please check the " +
                                        "host name and port settings."))
        when Qt::AbstractSocket::ConnectionRefusedError
            Qt::MessageBox.information(self, tr("Fortune Client"),
                                     tr("The connection was refused by the peer. " +
                                        "Make sure the fortune server is running, " +
                                        "and check that the host name and port " +
                                        "settings are correct."))
        else
            Qt::MessageBox.information(self, tr("Fortune Client"),
                                     tr("The following error occurred: %s." %
                                     @tcpSocket.errorString))
        end
    
        @getFortuneButton.enabled = true
    end
    
    def enableGetFortuneButton
        @getFortuneButton.enabled = !@hostLineEdit.text.empty? &&
                                    !@portLineEdit.text.empty?
    end
end
