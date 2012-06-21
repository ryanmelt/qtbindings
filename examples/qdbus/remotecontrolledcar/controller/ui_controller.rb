=begin
** Form generated from reading ui file 'controller.ui'
**
** Created: Thu Jun 21 10:20:37 2012
**      by: Qt User Interface Compiler version 4.8.1
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Controller
    attr_reader :gridLayout
    attr_reader :label
    attr_reader :decelerate
    attr_reader :accelerate
    attr_reader :right
    attr_reader :left

    def setupUi(controller)
    if controller.objectName.nil?
        controller.objectName = "controller"
    end
    controller.resize(255, 111)
    @gridLayout = Qt::GridLayout.new(controller)
    @gridLayout.spacing = 6
    @gridLayout.margin = 9
    @gridLayout.objectName = "gridLayout"
    @label = Qt::Label.new(controller)
    @label.objectName = "label"
    @label.alignment = Qt::AlignCenter

    @gridLayout.addWidget(@label, 1, 1, 1, 1)

    @decelerate = Qt::PushButton.new(controller)
    @decelerate.objectName = "decelerate"

    @gridLayout.addWidget(@decelerate, 2, 1, 1, 1)

    @accelerate = Qt::PushButton.new(controller)
    @accelerate.objectName = "accelerate"

    @gridLayout.addWidget(@accelerate, 0, 1, 1, 1)

    @right = Qt::PushButton.new(controller)
    @right.objectName = "right"

    @gridLayout.addWidget(@right, 1, 2, 1, 1)

    @left = Qt::PushButton.new(controller)
    @left.objectName = "left"

    @gridLayout.addWidget(@left, 1, 0, 1, 1)


    retranslateUi(controller)

    Qt::MetaObject.connectSlotsByName(controller)
    end # setupUi

    def setup_ui(controller)
        setupUi(controller)
    end

    def retranslateUi(controller)
    @label.text = Qt::Application.translate("Controller", "Controller", nil, Qt::Application::UnicodeUTF8)
    @decelerate.text = Qt::Application.translate("Controller", "Decelerate", nil, Qt::Application::UnicodeUTF8)
    @accelerate.text = Qt::Application.translate("Controller", "Accelerate", nil, Qt::Application::UnicodeUTF8)
    @right.text = Qt::Application.translate("Controller", "Right", nil, Qt::Application::UnicodeUTF8)
    @left.text = Qt::Application.translate("Controller", "Left", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(controller)
        retranslateUi(controller)
    end

end

module Ui
    class Controller < Ui_Controller
    end
end  # module Ui

