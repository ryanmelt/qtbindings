=begin
** Form generated from reading ui file 'mainwindowbase.ui'
**
** Created: Thu Jun 21 10:20:34 2012
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_MainWindowBase
    attr_reader :printAction
    attr_reader :quitAction
    attr_reader :markAction
    attr_reader :unmarkAction
    attr_reader :clearAction
    attr_reader :printPreviewAction
    attr_reader :centralwidget
    attr_reader :vboxLayout
    attr_reader :textEdit
    attr_reader :menubar
    attr_reader :menu_Selection
    attr_reader :menu_File
    attr_reader :statusbar
    attr_reader :dockWidget
    attr_reader :dockWidgetContents
    attr_reader :vboxLayout1
    attr_reader :fontTree

    def setupUi(mainWindowBase)
    if mainWindowBase.objectName.nil?
        mainWindowBase.objectName = "mainWindowBase"
    end
    mainWindowBase.resize(800, 345)
    @printAction = Qt::Action.new(mainWindowBase)
    @printAction.objectName = "printAction"
    @printAction.enabled = false
    @quitAction = Qt::Action.new(mainWindowBase)
    @quitAction.objectName = "quitAction"
    @markAction = Qt::Action.new(mainWindowBase)
    @markAction.objectName = "markAction"
    @unmarkAction = Qt::Action.new(mainWindowBase)
    @unmarkAction.objectName = "unmarkAction"
    @clearAction = Qt::Action.new(mainWindowBase)
    @clearAction.objectName = "clearAction"
    @printPreviewAction = Qt::Action.new(mainWindowBase)
    @printPreviewAction.objectName = "printPreviewAction"
    @printPreviewAction.enabled = false
    @centralwidget = Qt::Widget.new(mainWindowBase)
    @centralwidget.objectName = "centralwidget"
    @vboxLayout = Qt::VBoxLayout.new(@centralwidget)
    @vboxLayout.spacing = 6
    @vboxLayout.margin = 9
    @vboxLayout.objectName = "vboxLayout"
    @textEdit = Qt::TextEdit.new(@centralwidget)
    @textEdit.objectName = "textEdit"

    @vboxLayout.addWidget(@textEdit)

    mainWindowBase.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(mainWindowBase)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 800, 24)
    @menu_Selection = Qt::Menu.new(@menubar)
    @menu_Selection.objectName = "menu_Selection"
    @menu_File = Qt::Menu.new(@menubar)
    @menu_File.objectName = "menu_File"
    mainWindowBase.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(mainWindowBase)
    @statusbar.objectName = "statusbar"
    mainWindowBase.statusBar = @statusbar
    @dockWidget = Qt::DockWidget.new(mainWindowBase)
    @dockWidget.objectName = "dockWidget"
    @dockWidget.features = Qt::DockWidget::DockWidgetFloatable|Qt::DockWidget::DockWidgetMovable|Qt::DockWidget::NoDockWidgetFeatures
    @dockWidgetContents = Qt::Widget.new(@dockWidget)
    @dockWidgetContents.objectName = "dockWidgetContents"
    @vboxLayout1 = Qt::VBoxLayout.new(@dockWidgetContents)
    @vboxLayout1.spacing = 6
    @vboxLayout1.margin = 9
    @vboxLayout1.objectName = "vboxLayout1"
    @vboxLayout1.setContentsMargins(0, 0, 0, 0)
    @fontTree = Qt::TreeWidget.new(@dockWidgetContents)
    @fontTree.objectName = "fontTree"
    @fontTree.selectionMode = Qt::AbstractItemView::ExtendedSelection

    @vboxLayout1.addWidget(@fontTree)

    @dockWidget.setWidget(@dockWidgetContents)
    mainWindowBase.addDockWidget((1), @dockWidget)

    @menubar.addAction(@menu_File.menuAction())
    @menubar.addAction(@menu_Selection.menuAction())
    @menu_Selection.addAction(@markAction)
    @menu_Selection.addAction(@unmarkAction)
    @menu_Selection.addAction(@clearAction)
    @menu_File.addAction(@printPreviewAction)
    @menu_File.addAction(@printAction)
    @menu_File.addAction(@quitAction)

    retranslateUi(mainWindowBase)

    Qt::MetaObject.connectSlotsByName(mainWindowBase)
    end # setupUi

    def setup_ui(mainWindowBase)
        setupUi(mainWindowBase)
    end

    def retranslateUi(mainWindowBase)
    mainWindowBase.windowTitle = Qt::Application.translate("MainWindowBase", "Font Sampler", nil, Qt::Application::UnicodeUTF8)
    @printAction.text = Qt::Application.translate("MainWindowBase", "&Print...", nil, Qt::Application::UnicodeUTF8)
    @printAction.shortcut = Qt::Application.translate("MainWindowBase", "Ctrl+P", nil, Qt::Application::UnicodeUTF8)
    @quitAction.text = Qt::Application.translate("MainWindowBase", "E&xit", nil, Qt::Application::UnicodeUTF8)
    @quitAction.shortcut = Qt::Application.translate("MainWindowBase", "Ctrl+Q", nil, Qt::Application::UnicodeUTF8)
    @markAction.text = Qt::Application.translate("MainWindowBase", "&Mark", nil, Qt::Application::UnicodeUTF8)
    @markAction.shortcut = Qt::Application.translate("MainWindowBase", "Ctrl+M", nil, Qt::Application::UnicodeUTF8)
    @unmarkAction.text = Qt::Application.translate("MainWindowBase", "&Unmark", nil, Qt::Application::UnicodeUTF8)
    @unmarkAction.shortcut = Qt::Application.translate("MainWindowBase", "Ctrl+U", nil, Qt::Application::UnicodeUTF8)
    @clearAction.text = Qt::Application.translate("MainWindowBase", "&Clear", nil, Qt::Application::UnicodeUTF8)
    @printPreviewAction.text = Qt::Application.translate("MainWindowBase", "Print Preview...", nil, Qt::Application::UnicodeUTF8)
    @menu_Selection.title = Qt::Application.translate("MainWindowBase", "&Selection", nil, Qt::Application::UnicodeUTF8)
    @menu_File.title = Qt::Application.translate("MainWindowBase", "&File", nil, Qt::Application::UnicodeUTF8)
    @dockWidget.windowTitle = Qt::Application.translate("MainWindowBase", "Available Fonts", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(mainWindowBase)
        retranslateUi(mainWindowBase)
    end

end

module Ui
    class MainWindowBase < Ui_MainWindowBase
    end
end  # module Ui

