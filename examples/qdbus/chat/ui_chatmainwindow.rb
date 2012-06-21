=begin
** Form generated from reading ui file 'chatmainwindow.ui'
**
** Created: Thu Jun 21 10:22:52 2012
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_ChatMainWindow
    attr_reader :actionQuit
    attr_reader :actionAboutQt
    attr_reader :actionChangeNickname
    attr_reader :centralwidget
    attr_reader :hboxLayout
    attr_reader :vboxLayout
    attr_reader :chatHistory
    attr_reader :hboxLayout1
    attr_reader :label
    attr_reader :messageLineEdit
    attr_reader :sendButton
    attr_reader :menubar
    attr_reader :menuQuit
    attr_reader :menuFile
    attr_reader :statusbar

    def setupUi(chatMainWindow)
    if chatMainWindow.objectName.nil?
        chatMainWindow.objectName = "chatMainWindow"
    end
    chatMainWindow.resize(800, 600)
    @actionQuit = Qt::Action.new(chatMainWindow)
    @actionQuit.objectName = "actionQuit"
    @actionAboutQt = Qt::Action.new(chatMainWindow)
    @actionAboutQt.objectName = "actionAboutQt"
    @actionChangeNickname = Qt::Action.new(chatMainWindow)
    @actionChangeNickname.objectName = "actionChangeNickname"
    @centralwidget = Qt::Widget.new(chatMainWindow)
    @centralwidget.objectName = "centralwidget"
    @hboxLayout = Qt::HBoxLayout.new(@centralwidget)
    @hboxLayout.spacing = 6
    @hboxLayout.margin = 9
    @hboxLayout.objectName = "hboxLayout"
    @vboxLayout = Qt::VBoxLayout.new()
    @vboxLayout.spacing = 6
    @vboxLayout.margin = 0
    @vboxLayout.objectName = "vboxLayout"
    @chatHistory = Qt::TextBrowser.new(@centralwidget)
    @chatHistory.objectName = "chatHistory"
    @chatHistory.acceptDrops = false
    @chatHistory.acceptRichText = true

    @vboxLayout.addWidget(@chatHistory)

    @hboxLayout1 = Qt::HBoxLayout.new()
    @hboxLayout1.spacing = 6
    @hboxLayout1.margin = 0
    @hboxLayout1.objectName = "hboxLayout1"
    @label = Qt::Label.new(@centralwidget)
    @label.objectName = "label"

    @hboxLayout1.addWidget(@label)

    @messageLineEdit = Qt::LineEdit.new(@centralwidget)
    @messageLineEdit.objectName = "messageLineEdit"

    @hboxLayout1.addWidget(@messageLineEdit)

    @sendButton = Qt::PushButton.new(@centralwidget)
    @sendButton.objectName = "sendButton"
    @sizePolicy = Qt::SizePolicy.new(1, 0)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = @sendButton.sizePolicy.hasHeightForWidth
    @sendButton.sizePolicy = @sizePolicy

    @hboxLayout1.addWidget(@sendButton)


    @vboxLayout.addLayout(@hboxLayout1)


    @hboxLayout.addLayout(@vboxLayout)

    chatMainWindow.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(chatMainWindow)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 800, 31)
    @menuQuit = Qt::Menu.new(@menubar)
    @menuQuit.objectName = "menuQuit"
    @menuFile = Qt::Menu.new(@menubar)
    @menuFile.objectName = "menuFile"
    chatMainWindow.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(chatMainWindow)
    @statusbar.objectName = "statusbar"
    chatMainWindow.statusBar = @statusbar
    @label.buddy = @messageLineEdit
    Qt::Widget.setTabOrder(@chatHistory, @messageLineEdit)
    Qt::Widget.setTabOrder(@messageLineEdit, @sendButton)

    @menubar.addAction(@menuFile.menuAction())
    @menubar.addAction(@menuQuit.menuAction())
    @menuQuit.addAction(@actionAboutQt)
    @menuFile.addAction(@actionChangeNickname)
    @menuFile.addSeparator()
    @menuFile.addAction(@actionQuit)

    retranslateUi(chatMainWindow)
    Qt::Object.connect(@messageLineEdit, SIGNAL('returnPressed()'), @sendButton, SLOT('animateClick()'))
    Qt::Object.connect(@actionQuit, SIGNAL('triggered(bool)'), chatMainWindow, SLOT('close()'))

    Qt::MetaObject.connectSlotsByName(chatMainWindow)
    end # setupUi

    def setup_ui(chatMainWindow)
        setupUi(chatMainWindow)
    end

    def retranslateUi(chatMainWindow)
    chatMainWindow.windowTitle = Qt::Application.translate("ChatMainWindow", "QtDBus Chat", nil, Qt::Application::UnicodeUTF8)
    @actionQuit.text = Qt::Application.translate("ChatMainWindow", "Quit", nil, Qt::Application::UnicodeUTF8)
    @actionQuit.shortcut = Qt::Application.translate("ChatMainWindow", "Ctrl+Q", nil, Qt::Application::UnicodeUTF8)
    @actionAboutQt.text = Qt::Application.translate("ChatMainWindow", "About Qt...", nil, Qt::Application::UnicodeUTF8)
    @actionChangeNickname.text = Qt::Application.translate("ChatMainWindow", "Change nickname...", nil, Qt::Application::UnicodeUTF8)
    @actionChangeNickname.shortcut = Qt::Application.translate("ChatMainWindow", "Ctrl+N", nil, Qt::Application::UnicodeUTF8)
    @chatHistory.toolTip = Qt::Application.translate("ChatMainWindow", "Messages sent and received from other users", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("ChatMainWindow", "Message:", nil, Qt::Application::UnicodeUTF8)
    @sendButton.toolTip = Qt::Application.translate("ChatMainWindow", "Sends a message to other people", nil, Qt::Application::UnicodeUTF8)
    @sendButton.whatsThis = ''
    @sendButton.text = Qt::Application.translate("ChatMainWindow", "Send", nil, Qt::Application::UnicodeUTF8)
    @menuQuit.title = Qt::Application.translate("ChatMainWindow", "Help", nil, Qt::Application::UnicodeUTF8)
    @menuFile.title = Qt::Application.translate("ChatMainWindow", "File", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(chatMainWindow)
        retranslateUi(chatMainWindow)
    end

end

module Ui
    class ChatMainWindow < Ui_ChatMainWindow
    end
end  # module Ui

