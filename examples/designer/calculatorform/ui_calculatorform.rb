=begin
** Form generated from reading ui file 'calculatorform.ui'
**
** Created: Thu Jun 21 09:03:09 2012
**      by: Qt User Interface Compiler version 4.6.3
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_CalculatorForm
    attr_reader :gridLayout
    attr_reader :spacerItem
    attr_reader :label_3_2
    attr_reader :vboxLayout
    attr_reader :label_2_2_2
    attr_reader :outputWidget
    attr_reader :spacerItem1
    attr_reader :vboxLayout1
    attr_reader :label_2
    attr_reader :inputSpinBox2
    attr_reader :label_3
    attr_reader :vboxLayout2
    attr_reader :label
    attr_reader :inputSpinBox1

    def setupUi(calculatorForm)
    if calculatorForm.objectName.nil?
        calculatorForm.objectName = "calculatorForm"
    end
    calculatorForm.resize(400, 300)
    @sizePolicy = Qt::SizePolicy.new(5, 5)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = calculatorForm.sizePolicy.hasHeightForWidth
    calculatorForm.sizePolicy = @sizePolicy
    @gridLayout = Qt::GridLayout.new(calculatorForm)
    @gridLayout.spacing = 6
    @gridLayout.margin = 9
    @gridLayout.objectName = "gridLayout"
    @gridLayout.objectName = ""
    @spacerItem = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @gridLayout.addItem(@spacerItem, 0, 6, 1, 1)

    @label_3_2 = Qt::Label.new(calculatorForm)
    @label_3_2.objectName = "label_3_2"
    @label_3_2.geometry = Qt::Rect.new(169, 9, 20, 52)
    @label_3_2.alignment = Qt::AlignCenter

    @gridLayout.addWidget(@label_3_2, 0, 4, 1, 1)

    @vboxLayout = Qt::VBoxLayout.new()
    @vboxLayout.spacing = 6
    @vboxLayout.margin = 1
    @vboxLayout.objectName = "vboxLayout"
    @vboxLayout.objectName = ""
    @label_2_2_2 = Qt::Label.new(calculatorForm)
    @label_2_2_2.objectName = "label_2_2_2"
    @label_2_2_2.geometry = Qt::Rect.new(1, 1, 36, 17)

    @vboxLayout.addWidget(@label_2_2_2)

    @outputWidget = Qt::Label.new(calculatorForm)
    @outputWidget.objectName = "outputWidget"
    @outputWidget.geometry = Qt::Rect.new(1, 24, 36, 27)
    @outputWidget.frameShape = Qt::Frame::Box
    @outputWidget.frameShadow = Qt::Frame::Sunken
    @outputWidget.alignment = Qt::AlignAbsolute|Qt::AlignBottom|Qt::AlignCenter|Qt::AlignHCenter|Qt::AlignHorizontal_Mask|Qt::AlignJustify|Qt::AlignLeading|Qt::AlignLeft|Qt::AlignRight|Qt::AlignTop|Qt::AlignTrailing|Qt::AlignVCenter|Qt::AlignVertical_Mask

    @vboxLayout.addWidget(@outputWidget)


    @gridLayout.addLayout(@vboxLayout, 0, 5, 1, 1)

    @spacerItem1 = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @gridLayout.addItem(@spacerItem1, 1, 2, 1, 1)

    @vboxLayout1 = Qt::VBoxLayout.new()
    @vboxLayout1.spacing = 6
    @vboxLayout1.margin = 1
    @vboxLayout1.objectName = "vboxLayout1"
    @vboxLayout1.objectName = ""
    @label_2 = Qt::Label.new(calculatorForm)
    @label_2.objectName = "label_2"
    @label_2.geometry = Qt::Rect.new(1, 1, 46, 19)

    @vboxLayout1.addWidget(@label_2)

    @inputSpinBox2 = Qt::SpinBox.new(calculatorForm)
    @inputSpinBox2.objectName = "inputSpinBox2"
    @inputSpinBox2.geometry = Qt::Rect.new(1, 26, 46, 25)

    @vboxLayout1.addWidget(@inputSpinBox2)


    @gridLayout.addLayout(@vboxLayout1, 0, 3, 1, 1)

    @label_3 = Qt::Label.new(calculatorForm)
    @label_3.objectName = "label_3"
    @label_3.geometry = Qt::Rect.new(63, 9, 20, 52)
    @label_3.alignment = Qt::AlignCenter

    @gridLayout.addWidget(@label_3, 0, 1, 1, 1)

    @vboxLayout2 = Qt::VBoxLayout.new()
    @vboxLayout2.spacing = 6
    @vboxLayout2.margin = 1
    @vboxLayout2.objectName = "vboxLayout2"
    @vboxLayout2.objectName = ""
    @label = Qt::Label.new(calculatorForm)
    @label.objectName = "label"
    @label.geometry = Qt::Rect.new(1, 1, 46, 19)

    @vboxLayout2.addWidget(@label)

    @inputSpinBox1 = Qt::SpinBox.new(calculatorForm)
    @inputSpinBox1.objectName = "inputSpinBox1"
    @inputSpinBox1.geometry = Qt::Rect.new(1, 26, 46, 25)

    @vboxLayout2.addWidget(@inputSpinBox1)


    @gridLayout.addLayout(@vboxLayout2, 0, 0, 1, 1)


    retranslateUi(calculatorForm)

    Qt::MetaObject.connectSlotsByName(calculatorForm)
    end # setupUi

    def setup_ui(calculatorForm)
        setupUi(calculatorForm)
    end

    def retranslateUi(calculatorForm)
    @label_3_2.text = Qt::Application.translate("CalculatorForm", "=", nil, Qt::Application::UnicodeUTF8)
    @label_2_2_2.text = Qt::Application.translate("CalculatorForm", "Output", nil, Qt::Application::UnicodeUTF8)
    @outputWidget.text = Qt::Application.translate("CalculatorForm", "0", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("CalculatorForm", "Input 2", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("CalculatorForm", "+", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("CalculatorForm", "Input 1", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(calculatorForm)
        retranslateUi(calculatorForm)
    end

end

module Ui
    class CalculatorForm < Ui_CalculatorForm
    end
end  # module Ui

