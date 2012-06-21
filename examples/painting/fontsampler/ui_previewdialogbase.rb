=begin
** Form generated from reading ui file 'previewdialogbase.ui'
**
** Created: Thu Jun 21 10:20:34 2012
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_PreviewDialogBase
    attr_reader :vboxLayout
    attr_reader :hboxLayout
    attr_reader :label
    attr_reader :paperSizeCombo
    attr_reader :label_2
    attr_reader :paperOrientationCombo
    attr_reader :spacerItem
    attr_reader :hboxLayout1
    attr_reader :pageList
    attr_reader :previewArea
    attr_reader :hboxLayout2
    attr_reader :progressBar
    attr_reader :buttonBox

    def setupUi(previewDialogBase)
    if previewDialogBase.objectName.nil?
        previewDialogBase.objectName = "previewDialogBase"
    end
    previewDialogBase.resize(733, 479)
    @vboxLayout = Qt::VBoxLayout.new(previewDialogBase)
    @vboxLayout.spacing = 6
    @vboxLayout.margin = 9
    @vboxLayout.objectName = "vboxLayout"
    @hboxLayout = Qt::HBoxLayout.new()
    @hboxLayout.spacing = 6
    @hboxLayout.margin = 0
    @hboxLayout.objectName = "hboxLayout"
    @label = Qt::Label.new(previewDialogBase)
    @label.objectName = "label"

    @hboxLayout.addWidget(@label)

    @paperSizeCombo = Qt::ComboBox.new(previewDialogBase)
    @paperSizeCombo.objectName = "paperSizeCombo"
    @sizePolicy = Qt::SizePolicy.new(1, 0)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = @paperSizeCombo.sizePolicy.hasHeightForWidth
    @paperSizeCombo.sizePolicy = @sizePolicy

    @hboxLayout.addWidget(@paperSizeCombo)

    @label_2 = Qt::Label.new(previewDialogBase)
    @label_2.objectName = "label_2"

    @hboxLayout.addWidget(@label_2)

    @paperOrientationCombo = Qt::ComboBox.new(previewDialogBase)
    @paperOrientationCombo.objectName = "paperOrientationCombo"
    @sizePolicy.heightForWidth = @paperOrientationCombo.sizePolicy.hasHeightForWidth
    @paperOrientationCombo.sizePolicy = @sizePolicy

    @hboxLayout.addWidget(@paperOrientationCombo)

    @spacerItem = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hboxLayout.addItem(@spacerItem)


    @vboxLayout.addLayout(@hboxLayout)

    @hboxLayout1 = Qt::HBoxLayout.new()
    @hboxLayout1.spacing = 6
    @hboxLayout1.margin = 0
    @hboxLayout1.objectName = "hboxLayout1"
    @pageList = Qt::TreeWidget.new(previewDialogBase)
    @pageList.objectName = "pageList"
    @pageList.indentation = 0
    @pageList.rootIsDecorated = false
    @pageList.uniformRowHeights = true
    @pageList.itemsExpandable = false
    @pageList.columnCount = 1

    @hboxLayout1.addWidget(@pageList)

    @previewArea = Qt::ScrollArea.new(previewDialogBase)
    @previewArea.objectName = "previewArea"
    @sizePolicy1 = Qt::SizePolicy.new(5, 5)
    @sizePolicy1.setHorizontalStretch(1)
    @sizePolicy1.setVerticalStretch(0)
    @sizePolicy1.heightForWidth = @previewArea.sizePolicy.hasHeightForWidth
    @previewArea.sizePolicy = @sizePolicy1

    @hboxLayout1.addWidget(@previewArea)


    @vboxLayout.addLayout(@hboxLayout1)

    @hboxLayout2 = Qt::HBoxLayout.new()
    @hboxLayout2.spacing = 6
    @hboxLayout2.margin = 0
    @hboxLayout2.objectName = "hboxLayout2"
    @progressBar = Qt::ProgressBar.new(previewDialogBase)
    @progressBar.objectName = "progressBar"
    @progressBar.enabled = false
    @sizePolicy2 = Qt::SizePolicy.new(7, 0)
    @sizePolicy2.setHorizontalStretch(1)
    @sizePolicy2.setVerticalStretch(0)
    @sizePolicy2.heightForWidth = @progressBar.sizePolicy.hasHeightForWidth
    @progressBar.sizePolicy = @sizePolicy2
    @progressBar.value = 0
    @progressBar.textVisible = false
    @progressBar.orientation = Qt::Horizontal

    @hboxLayout2.addWidget(@progressBar)

    @buttonBox = Qt::DialogButtonBox.new(previewDialogBase)
    @buttonBox.objectName = "buttonBox"
    @buttonBox.orientation = Qt::Horizontal
    @buttonBox.standardButtons = Qt::DialogButtonBox::Cancel|Qt::DialogButtonBox::NoButton|Qt::DialogButtonBox::Ok

    @hboxLayout2.addWidget(@buttonBox)


    @vboxLayout.addLayout(@hboxLayout2)

    @label.buddy = @paperSizeCombo
    @label_2.buddy = @paperOrientationCombo

    retranslateUi(previewDialogBase)
    Qt::Object.connect(@buttonBox, SIGNAL('accepted()'), previewDialogBase, SLOT('accept()'))
    Qt::Object.connect(@buttonBox, SIGNAL('rejected()'), previewDialogBase, SLOT('reject()'))

    Qt::MetaObject.connectSlotsByName(previewDialogBase)
    end # setupUi

    def setup_ui(previewDialogBase)
        setupUi(previewDialogBase)
    end

    def retranslateUi(previewDialogBase)
    previewDialogBase.windowTitle = Qt::Application.translate("PreviewDialogBase", "Print Preview", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("PreviewDialogBase", "&Paper Size:", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("PreviewDialogBase", "&Orientation:", nil, Qt::Application::UnicodeUTF8)
    @pageList.headerItem.setText(0, Qt::Application.translate("PreviewDialogBase", "1", nil, Qt::Application::UnicodeUTF8))
    end # retranslateUi

    def retranslate_ui(previewDialogBase)
        retranslateUi(previewDialogBase)
    end

end

module Ui
    class PreviewDialogBase < Ui_PreviewDialogBase
    end
end  # module Ui

