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

class Window < Qt::Widget

    slots    'setIcon(int)',
            'iconActivated(QSystemTrayIcon::ActivationReason)',
            :showMessage,
            :messageClicked

    def initialize(parent = nil)
        super(parent)
        createIconGroupBox()
        createMessageGroupBox()

        @iconLabel.minimumWidth = @durationLabel.sizeHint.width

        createActions()
        createTrayIcon()

        connect(@showMessageButton, SIGNAL(:clicked), self, SLOT(:showMessage))
        connect(@showIconCheckBox, SIGNAL('toggled(bool)'),
                @trayIcon, SLOT('setVisible(bool)'))
        connect(@iconComboBox, SIGNAL('currentIndexChanged(int)'),
                self, SLOT('setIcon(int)'))
        connect(@trayIcon, SIGNAL(:messageClicked), self, SLOT(:messageClicked))
        connect(@trayIcon, SIGNAL('activated(QSystemTrayIcon::ActivationReason)'),
                self, SLOT('iconActivated(QSystemTrayIcon::ActivationReason)'))

        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(@iconGroupBox)
            m.addWidget(@messageGroupBox)
        end

        @iconComboBox.currentIndex = 1
        @trayIcon.show

        setWindowTitle(tr("Systray"))
        resize(400, 300)
    end

    def setVisible(visible)
        @minimizeAction.enabled = visible
        @maximizeAction.enabled = !visible
        @restoreAction.enabled = !visible
        super(visible)
    end

    def closeEvent(event)
        if @trayIcon.visible?
            Qt::MessageBox.information(self, tr("Systray"),
                                     tr("The program will keep running in the " \
                                        "system tray. To terminate the program, " \
                                        "choose <b>Quit</b> in the context menu " \
                                        "that pops up when clicking self program's " \
                                        "entry in the system tray."))
            hide()
            event.ignore()
        end
    end

    def setIcon(index)
        icon = @iconComboBox.itemIcon(index)
        @trayIcon.icon = icon
        setWindowIcon(icon)

        @trayIcon.toolTip = @iconComboBox.itemText(index)
    end

    def iconActivated(reason)
        case reason
        when Qt::SystemTrayIcon::Trigger
        when Qt::SystemTrayIcon::DoubleClick
            @iconComboBox.currentIndex = (iconComboBox.currentIndex + 1) % @iconComboBox.length
        when Qt::SystemTrayIcon::MiddleClick
            showMessage()
        end
    end

    def showMessage()
        icon = @typeComboBox.itemData(@typeComboBox.currentIndex).to_i
        @trayIcon.showMessage(@titleEdit.text, @bodyEdit.toPlainText, icon,
                              @durationSpinBox.value() * 1000)
    end

    def messageClicked()
        Qt::MessageBox.information(nil, tr("Systray"),
                                 tr("Sorry, I already gave what help I could.\n" \
                                    "Maybe you should try asking a human?"))
    end

    def createIconGroupBox()
        @iconGroupBox = Qt::GroupBox.new(tr("Tray Icon"))

        @iconLabel = Qt::Label.new("Icon:")

        @iconComboBox = Qt::ComboBox.new
        @iconComboBox.addItem(Qt::Icon.new(":/images/bad.svg"), tr("Bad"))
        @iconComboBox.addItem(Qt::Icon.new(":/images/heart.svg"), tr("Heart"))
        @iconComboBox.addItem(Qt::Icon.new(":/images/trash.svg"), tr("Trash"))

        @showIconCheckBox = Qt::CheckBox.new(tr("Show icon"))
        @showIconCheckBox.checked = true

        @iconGroupBox.layout = Qt::HBoxLayout.new do |l|
            l.addWidget(@iconLabel)
            l.addWidget(@iconComboBox)
            l.addStretch()
            l.addWidget(@showIconCheckBox)
        end
    end

    def createMessageGroupBox()
        @messageGroupBox = Qt::GroupBox.new(tr("Balloon Message"))

        @typeLabel = Qt::Label.new(tr("Type:"))

        @typeComboBox = Qt::ComboBox.new
        @typeComboBox.addItem(tr("None"), Qt::Variant.new(Qt::SystemTrayIcon::NoIcon.to_i))
        @typeComboBox.addItem(style().standardIcon(Qt::Style::SP_MessageBoxInformation),
                tr("Information"),
                Qt::Variant.new(Qt::SystemTrayIcon::Information.to_i))
        @typeComboBox.addItem(style().standardIcon(Qt::Style::SP_MessageBoxWarning),
                              tr("Warning"),
                              Qt::Variant.new(Qt::SystemTrayIcon::Warning.to_i))
        @typeComboBox.addItem(style().standardIcon(Qt::Style::SP_MessageBoxCritical),
                              tr("Critical"),
                              Qt::Variant.new(Qt::SystemTrayIcon::Critical.to_i))
        @typeComboBox.currentIndex = 1

        @durationLabel = Qt::Label.new(tr("Duration:"))

        @durationSpinBox = Qt::SpinBox.new do |s|
            s.range = 5..60
            s.suffix = " s"
            s.value = 15
        end

        @durationWarningLabel = Qt::Label.new(tr("(some systems might ignore self " \
                                             "hint)"))
        @durationWarningLabel.indent = 10

        @titleLabel = Qt::Label.new(tr("Title:"))

        @titleEdit = Qt::LineEdit.new(tr("Cannot connect to network"))

        @bodyLabel = Qt::Label.new(tr("Body:"))

        @bodyEdit = Qt::TextEdit.new
        @bodyEdit.setPlainText(tr("Don't believe me. Honestly, I don't have a " \
                                  "clue.\nClick self balloon for details."))

        @showMessageButton = Qt::PushButton.new(tr("Show Message"))
        @showMessageButton.default = true

        @messageGroupBox.layout = Qt::GridLayout.new do |m|
            m.addWidget(@typeLabel, 0, 0)
            m.addWidget(@typeComboBox, 0, 1, 1, 2)
            m.addWidget(@durationLabel, 1, 0)
            m.addWidget(@durationSpinBox, 1, 1)
            m.addWidget(@durationWarningLabel, 1, 2, 1, 3)
            m.addWidget(@titleLabel, 2, 0)
            m.addWidget(@titleEdit, 2, 1, 1, 4)
            m.addWidget(@bodyLabel, 3, 0)
            m.addWidget(@bodyEdit, 3, 1, 2, 4)
            m.addWidget(@showMessageButton, 5, 4)
            m.setColumnStretch(3, 1)
            m.setRowStretch(4, 1)
        end
    end

    def createActions()
        @minimizeAction = Qt::Action.new(tr("Mi&nimize"), self)
        connect(@minimizeAction, SIGNAL(:triggered), self, SLOT(:hide))

        @maximizeAction = Qt::Action.new(tr("Ma&ximize"), self)
        connect(@maximizeAction, SIGNAL(:triggered), self, SLOT(:showMaximized))

        @restoreAction = Qt::Action.new(tr("&Restore"), self)
        connect(@restoreAction, SIGNAL(:triggered), self, SLOT(:show))

        @quitAction = Qt::Action.new(tr("&Quit"), self)
        connect(@quitAction, SIGNAL(:triggered), $qApp, SLOT(:quit))
    end

    def createTrayIcon()
        @trayIconMenu = Qt::Menu.new(self) do |t|
            t.addAction(@minimizeAction)
            t.addAction(@maximizeAction)
            t.addAction(@restoreAction)
            t.addSeparator()
            t.addAction(@quitAction)
        end
        @trayIcon = Qt::SystemTrayIcon.new(self)
        @trayIcon.contextMenu = @trayIconMenu
    end
end
