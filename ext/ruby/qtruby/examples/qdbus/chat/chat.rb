=begin
**
** Copyright (C) 2004-2006 Trolltech AS. All rights reserved.
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
    
require 'Qt'
require 'chat_interface.rb'
require 'chat_adaptor.rb'

class Ui_ChatMainWindow < Qt::MainWindow
    signals 'message(const QString&, const QString&)',
            'action(const QString&, const QString&)'
    
    slots   'messageSlot(const QString&, const QString&)',
            'actionSlot(const QString&, const QString&)',
            'textChangedSlot(const QString &)',
            'sendClickedSlot()',
            'changeNickname()',
            'aboutQt()',
            'exiting()'
    
    def initialize(parent = nil)
        super
        @m_nickname = "nickname"
        require 'ui_chatmainwindow.rb'
        setupUi(self)
        @sendButton.enabled = false
    
        connect(@messageLineEdit, SIGNAL('textChanged(QString)'),
                self, SLOT('textChangedSlot(QString)'))
        connect(@sendButton, SIGNAL('clicked(bool)'), self, SLOT('sendClickedSlot()'))
        connect(@actionChangeNickname, SIGNAL('triggered(bool)'), self, SLOT('changeNickname()'))
        connect(@actionAboutQt, SIGNAL('triggered(bool)'), self, SLOT('aboutQt()'))
        connect($qApp, SIGNAL('lastWindowClosed()'), self, SLOT('exiting()'))
    
        # add our D-Bus interface and connect to D-Bus
        ChatAdaptor.new(self)
        Qt::DBusConnection.sessionBus.registerObject("/", self)
        iface = ComTrolltechChatInterface.new(nil, nil, Qt::DBusConnection.sessionBus(), self)
#        connect(self, SIGNAL('message(QString,QString)'), self, SLOT('messageSlot(QString,QString)'))
        Qt::DBusConnection.sessionBus.connect(nil, nil, "com.trolltech.chat", "message", self, SLOT('messageSlot(QString,QString)'))
        connect(iface, SIGNAL('action(QString,QString)'), self, SLOT('actionSlot(QString,QString)'))
    
        require 'ui_chatsetnickname.rb'
        dialog = Ui_NicknameDialog.new
        dialog.cancelButton.visible = false
        dialog.exec
        @m_messages = []
        @m_nickname = dialog.nickname.text.strip
        emit action(@m_nickname, "joins the chat")
    end
    
    def rebuildHistory()
        history = @m_messages.join("\n")
        @chatHistory.plainText = history
    end
    
    def messageSlot(nickname, text)
        msg = "<%s> %s" % [nickname, text]
        @m_messages.push(msg)
    
        if @m_messages.length > 100
            @m_messages.shift
        end
        rebuildHistory()
    end
    
    def actionSlot(nickname, text)
        msg = "* %s %s" % [nickname, text]
        @m_messages.push(msg)
    
        if @m_messages.length > 100
            @m_messages.shift
        end
        rebuildHistory()
    end
    
    def textChangedSlot(newText)
        @sendButton.enabled = !newText.empty?
    end
    
    def sendClickedSlot()
        # emit message(@m_nickname, messageLineEdit.text())
        msg = Qt::DBusMessage.createSignal("/", "com.trolltech.chat", "message")
        msg << @m_nickname << @messageLineEdit.text()
        Qt::DBusConnection.sessionBus().send(msg)
        @messageLineEdit.text = ""
    end
    
    def changeNickname()
        dialog = Ui_NicknameDialog.new(self)
        if dialog.exec == Qt::Dialog::Accepted
            old = @m_nickname
            @m_nickname = dialog.nickname.text.strip
            emit action(old, "is now known as %s" % @m_nickname)
        end
    end
    
    def aboutQt()
        Qt::MessageBox.aboutQt(self)
    end
    
    def exiting()
        emit action(@m_nickname, "leaves the chat")
    end
end

class Ui_NicknameDialog < Qt::Dialog
    def initialize(parent = nil)
        super(parent)
        setupUi(self)
    end
end

app = Qt::Application.new(ARGV)
    
if !Qt::DBusConnection.sessionBus().connected?
    qWarning("Cannot connect to the D-BUS session bus.\n" \
    "Please check your system settings and try again.\n")
    return 1
end
    
chat = Ui_ChatMainWindow.new
chat.show
app.exec

