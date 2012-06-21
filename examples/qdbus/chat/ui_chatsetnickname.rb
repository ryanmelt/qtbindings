=begin
** Form generated from reading ui file 'chatsetnickname.ui'
**
** Created: Thu Jun 21 10:20:36 2012
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_NicknameDialog
    attr_reader :vboxLayout
    attr_reader :vboxLayout1
    attr_reader :label
    attr_reader :nickname
    attr_reader :hboxLayout
    attr_reader :spacerItem
    attr_reader :okButton
    attr_reader :cancelButton
    attr_reader :spacerItem1

    def setupUi(nicknameDialog)
    if nicknameDialog.objectName.nil?
        nicknameDialog.objectName = "nicknameDialog"
    end
    nicknameDialog.resize(396, 105)
    @sizePolicy = Qt::SizePolicy.new(1, 1)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = nicknameDialog.sizePolicy.hasHeightForWidth
    nicknameDialog.sizePolicy = @sizePolicy
    @vboxLayout = Qt::VBoxLayout.new(nicknameDialog)
    @vboxLayout.spacing = 6
    @vboxLayout.margin = 9
    @vboxLayout.objectName = "vboxLayout"
    @vboxLayout1 = Qt::VBoxLayout.new()
    @vboxLayout1.spacing = 6
    @vboxLayout1.margin = 0
    @vboxLayout1.objectName = "vboxLayout1"
    @label = Qt::Label.new(nicknameDialog)
    @label.objectName = "label"
    @sizePolicy.heightForWidth = @label.sizePolicy.hasHeightForWidth
    @label.sizePolicy = @sizePolicy

    @vboxLayout1.addWidget(@label)

    @nickname = Qt::LineEdit.new(nicknameDialog)
    @nickname.objectName = "nickname"

    @vboxLayout1.addWidget(@nickname)


    @vboxLayout.addLayout(@vboxLayout1)

    @hboxLayout = Qt::HBoxLayout.new()
    @hboxLayout.spacing = 6
    @hboxLayout.margin = 0
    @hboxLayout.objectName = "hboxLayout"
    @spacerItem = Qt::SpacerItem.new(131, 31, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hboxLayout.addItem(@spacerItem)

    @okButton = Qt::PushButton.new(nicknameDialog)
    @okButton.objectName = "okButton"

    @hboxLayout.addWidget(@okButton)

    @cancelButton = Qt::PushButton.new(nicknameDialog)
    @cancelButton.objectName = "cancelButton"

    @hboxLayout.addWidget(@cancelButton)

    @spacerItem1 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hboxLayout.addItem(@spacerItem1)


    @vboxLayout.addLayout(@hboxLayout)


    retranslateUi(nicknameDialog)
    Qt::Object.connect(@okButton, SIGNAL('clicked()'), nicknameDialog, SLOT('accept()'))
    Qt::Object.connect(@cancelButton, SIGNAL('clicked()'), nicknameDialog, SLOT('reject()'))

    Qt::MetaObject.connectSlotsByName(nicknameDialog)
    end # setupUi

    def setup_ui(nicknameDialog)
        setupUi(nicknameDialog)
    end

    def retranslateUi(nicknameDialog)
    nicknameDialog.windowTitle = Qt::Application.translate("NicknameDialog", "Set nickname", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("NicknameDialog", "New nickname:", nil, Qt::Application::UnicodeUTF8)
    @okButton.text = Qt::Application.translate("NicknameDialog", "OK", nil, Qt::Application::UnicodeUTF8)
    @cancelButton.text = Qt::Application.translate("NicknameDialog", "Cancel", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(nicknameDialog)
        retranslateUi(nicknameDialog)
    end

end

module Ui
    class NicknameDialog < Ui_NicknameDialog
    end
end  # module Ui

