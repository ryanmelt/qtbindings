#
# Copyright (c) 2001 by Jim Menard <jimm@io.com>
#
# Released under the same license as Ruby. See
# http://www.ruby-lang.org/en/LICENSE.txt.
#

require 'Qt'
require 'World'
require 'Camera'

class Adjustor
    attr_accessor :slider, :num, :origValue
    def initialize(slider, num, origValue = 0)
        @slider = slider
        @num = num
        @origValue = origValue
    end
    def setSlider(val); @slider.setValue(val); end
    def setNum(val); @num.setNum(val); end
    def set(val)
        setSlider(val)
        setNum(val)
    end
    def reset
        set(@origValue)
        return @origValue
    end
end

class CameraDialog < Qt::Dialog
        slots         'slotReset()', 'slotLocXChanged(int)', 
                        'slotLocYChanged(int)', 'slotLocZChanged(int)', 
                        'slotRotationXChanged(int)', 'slotRotationYChanged(int)', 
                        'slotRotationZChanged(int)', 'slotZoomChanged(int)'
        
    def initialize(parent)
        super
        @locAdjustors = []
        @rotationAdjustors = []
        @otherAdjustors = []
        @avoidUpdates = false

        @camera = World.instance.camera

        # Remember values for reset
        @origCamera = @camera.dup()

        # Group and layout widgets
        vLayout = Qt::VBoxLayout.new(self)

        locBox = Qt::GroupBox.new('Location', self)
        rotationBox = Qt::GroupBox.new('Rotation', self)
        otherBox = Qt::GroupBox.new('Other', self)

        locLayout = Qt::GridLayout.new(locBox)
        rotationLayout = Qt::GridLayout.new(rotationBox)
        otherLayout = Qt::GridLayout.new(otherBox)
        buttonLayout = Qt::HBoxLayout.new()

        vLayout.addWidget(locBox)
        vLayout.addWidget(rotationBox)
        vLayout.addWidget(otherBox)
        vLayout.addSpacing(10)
        vLayout.addLayout(buttonLayout)

        # Add extra space at the top of each layout so the group box title
        # doesn't get squished.
#        locLayout.addRowSpacing(0, 15)
#        rotationLayout.addRowSpacing(0, 15)
#        otherLayout.addRowSpacing(0, 15)

        # Contents of camera location box
        @locAdjustors << addSlider(1, locBox, locLayout, 'X', -1000, 1000, 1,
                                   'slotLocXChanged(int)', @camera.position.x)
        @locAdjustors << addSlider(2, locBox, locLayout, 'Y', -1000, 1000, 1,
                                   'slotLocYChanged(int)', @camera.position.y)
        @locAdjustors << addSlider(3, locBox, locLayout, 'Z', -1000, 1000, 1,
                                   'slotLocZChanged(int)', @camera.position.z)

        # Contents of camera rotation box
        @rotationAdjustors << addSlider(1, rotationBox, rotationLayout, 'X',
                                        0, 360, 1, 'slotRotationXChanged(int)',
                                   @camera.rotation.x)
        @rotationAdjustors << addSlider(2, rotationBox, rotationLayout, 'Y',
                                        0, 360, 1, 'slotRotationYChanged(int)',
                                   @camera.rotation.y)
        @rotationAdjustors << addSlider(3, rotationBox, rotationLayout, 'Z',
                                        0, 360, 1, 'slotRotationZChanged(int)',
                                   @camera.rotation.z)

        @otherAdjustors <<  addSlider(1, otherBox, otherLayout, 'Zoom',
                                      1, 100, 1, 'slotZoomChanged(int)',
                                      @camera.zoom * 10.0)
        @otherAdjustors[0].origValue = @camera.zoom

        # The Close button
        button = Qt::PushButton.new('Close', self)
        connect(button, SIGNAL('clicked()'), self, SLOT('close()'))
        button.setDefault(true)
        button.setFixedSize(button.sizeHint())
        buttonLayout.addWidget(button)

        # The Close button
        button = Qt::PushButton.new('Reset', self)
        connect(button, SIGNAL('clicked()'), self, SLOT('slotReset()'))
        button.setFixedSize(button.sizeHint())
        buttonLayout.addWidget(button)

        # 15 layout management
        locLayout.activate()
        rotationLayout.activate()
        otherLayout.activate()
        vLayout.activate()

        resize(0, 0)

        setWindowTitle('Camera Settings')
    end

    def addSlider(row, box, layout, label, min, max, pageStep, slot,
                  initialValue)
        # Label
        text = Qt::Label.new(label, box)
        text.setMinimumSize(text.sizeHint())
        layout.addWidget(text, row, 0)

        # Slider
        slider = Qt::Slider.new(Qt::Horizontal, box) do |s|
            s.range = min..max
            s.sliderPosition = initialValue
            s.pageStep = pageStep
        end

        slider.minimumSize = slider.sizeHint
        slider.minimumWidth = 180

        layout.addWidget(slider, row, 1)

        # Connection from slider signal to our slot
        connect(slider, SIGNAL('valueChanged(int)'), self, SLOT(slot))

        # Number display
        num = Qt::Label.new('XXXXX', box)
        num.setMinimumSize(num.sizeHint())
        num.setFrameStyle(Qt::Frame::Panel | Qt::Frame::Sunken)
        num.setAlignment(Qt::AlignRight | Qt::AlignVCenter)
        num.setNum(initialValue)

        layout.addWidget(num, row, 2)

        return Adjustor.new(slider, num, initialValue)
    end

    def cameraChanged
        World.instance.setupTranslation() unless @avoidUpdates
    end

    def slotLocXChanged(val)
        @locAdjustors[0].setNum(val)
        @camera.position.x = val
        cameraChanged()
    end

    def slotLocYChanged(val)
        @locAdjustors[1].setNum(val)
        @camera.position.y = val
        cameraChanged()
    end

    def slotLocZChanged(val)
        @locAdjustors[2].setNum(val)
        @camera.position.z = val
        cameraChanged()
    end

    def slotRotationXChanged(val)
        @rotationAdjustors[0].setNum(val)
        @camera.rotation.x = val
        cameraChanged()
    end

    def slotRotationYChanged(val)
        @rotationAdjustors[1].setNum(val)
        @camera.rotation.y = val
        cameraChanged()
    end

    def slotRotationZChanged(val)
        @rotationAdjustors[2].setNum(val)
        @camera.rotation.z = val
        cameraChanged()
    end

    def slotZoomChanged(val)
        @otherAdjustors[0].setNum(val)
        @camera.zoom = val / 10.0
        cameraChanged()
    end

    def slotReset
        @avoidUpdates = true

        @camera.position.x = @locAdjustors[0].reset()
        @camera.position.y = @locAdjustors[1].reset()
        @camera.position.z = @locAdjustors[2].reset()

        @camera.rotation.x = @rotationAdjustors[0].reset()
        @camera.rotation.y = @rotationAdjustors[1].reset()
        @camera.rotation.z = @rotationAdjustors[2].reset()

        @camera.zoom = @otherAdjustors[0].reset()
        
        @avoidUpdates = false
        cameraChanged()
    end

end
