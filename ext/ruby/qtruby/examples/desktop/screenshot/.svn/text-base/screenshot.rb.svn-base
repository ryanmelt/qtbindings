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
	
class Screenshot < Qt::Widget
	
	slots	:newScreenshot,
    		:saveScreenshot,
    		:shootScreen,
    		:updateCheckBox
	
	def initialize(parent = nil)
		super(parent)
	    @screenshotLabel = Qt::Label.new
	    @screenshotLabel.setSizePolicy(Qt::SizePolicy::Expanding,
	                                   Qt::SizePolicy::Expanding)
	    @screenshotLabel.alignment = Qt::AlignCenter
	    @screenshotLabel.setMinimumSize(240, 160)
	
	    createOptionsGroupBox()
	    createButtonsLayout()
	
	    self.layout = Qt::VBoxLayout.new do |m|
			m.addWidget(@screenshotLabel)
			m.addWidget(@optionsGroupBox)
			m.addLayout(@buttonsLayout)
		end
	
	    shootScreen()
	    @delaySpinBox.value = 5
	
	    setWindowTitle(tr("Screenshot"))
	    resize(300, 200)
	end
	
	def resizeEvent(event)
	    scaledSize = @originalPixmap.size()
	    scaledSize.scale(@screenshotLabel.size(), Qt::KeepAspectRatio)
	    if @screenshotLabel.pixmap.nil? ||
	            scaledSize != @screenshotLabel.pixmap.size
	        updateScreenshotLabel()
        end
	end
	
	def newScreenshot()
	    if @hideThisWindowCheckBox.checked?
	        hide()
        end
	    @newScreenshotButton.disabled = true
	
	    Qt::Timer.singleShot(@delaySpinBox.value() * 1000, self, SLOT(:shootScreen))
	end
	
	def saveScreenshot()
	    format = "png"
	    initialPath = Qt::Dir.currentPath() + tr("/untitled.") + format
	
	    fileName = Qt::FileDialog.getSaveFileName(self, tr("Save As"),
	                               initialPath,
	                               tr("%s Files (*.%s);;All Files (*)" % [format.upcase, format]))
	    if !fileName.nil?
	        @originalPixmap.save(fileName, format)
        end
	end
	
	def shootScreen()
	    if @delaySpinBox.value() != 0
	        $qApp.beep
        end
	    @originalPixmap = Qt::Pixmap.grabWindow(Qt::Application.desktop.winId)
	    updateScreenshotLabel()
	
	    @newScreenshotButton.disabled = false
	    if @hideThisWindowCheckBox.checked?
	        show()
        end
	end
	
	def updateCheckBox()
	    if @delaySpinBox.value() == 0
	        @hideThisWindowCheckBox.disabled = true
	    else
	        @hideThisWindowCheckBox.disabled = false
        end
	end
	
	def createOptionsGroupBox()
	    @optionsGroupBox = Qt::GroupBox.new(tr("Options"))
	
	    @delaySpinBox = Qt::SpinBox.new do |s|
	    	s.suffix = tr(" s")
	    	s.maximum = 60
		end
	    connect(@delaySpinBox, SIGNAL('valueChanged(int)'), self, SLOT(:updateCheckBox))
	
	    @delaySpinBoxLabel = Qt::Label.new(tr("Screenshot Delay:"))
	
	    @hideThisWindowCheckBox = Qt::CheckBox.new(tr("Hide This Window"))
	
	    @optionsGroupBox.layout = Qt::GridLayout.new do |g|
			g.addWidget(@delaySpinBoxLabel, 0, 0)
			g.addWidget(@delaySpinBox, 0, 1)
			g.addWidget(@hideThisWindowCheckBox, 1, 0, 1, 2)
		end
	end
	
	def createButtonsLayout()
	    @newScreenshotButton = createButton(tr("New Screenshot"),
	                                       self, SLOT(:newScreenshot))
	
	    @saveScreenshotButton = createButton(tr("Save Screenshot"),
	                                        self, SLOT(:saveScreenshot))
	
	    @quitScreenshotButton = createButton(tr("Quit"), self, SLOT(:close))
	
	    @buttonsLayout = Qt::HBoxLayout.new do |b|
			b.addStretch()
			b.addWidget(@newScreenshotButton)
			b.addWidget(@saveScreenshotButton)
			b.addWidget(@quitScreenshotButton)
		end
	end
	
	def createButton(text, receiver, member)
	    button = Qt::PushButton.new(text)
	    button.connect(button, SIGNAL(:clicked), receiver, member)
	    return button
	end
	
	def updateScreenshotLabel()
	    @screenshotLabel.pixmap = @originalPixmap.scaled(@screenshotLabel.size,
	                                                     Qt::KeepAspectRatio,
	                                                     Qt::SmoothTransformation)
	end
end
