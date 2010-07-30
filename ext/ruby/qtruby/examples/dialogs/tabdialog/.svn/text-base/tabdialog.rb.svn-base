=begin
**
** Copyright (C) 2004-2005 Trolltech AS. All rights reserved.
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
    
    
class TabDialog < Qt::Dialog
    
    def initialize(fileName, parent = nil)
        super(parent)
        fileInfo = Qt::FileInfo.new(fileName)
    
        @tabWidget = Qt::TabWidget.new
        @tabWidget.addTab(GeneralTab.new(fileInfo), tr("General"))
        @tabWidget.addTab(PermissionsTab.new(fileInfo), tr("Permissions"))
        @tabWidget.addTab(ApplicationsTab.new(fileInfo), tr("Applications"))
    
        okButton = Qt::PushButton.new(tr("OK"))
        cancelButton = Qt::PushButton.new(tr("Cancel"))
    
        connect(okButton, SIGNAL('clicked()'), self, SLOT('accept()'))
        connect(cancelButton, SIGNAL('clicked()'), self, SLOT('reject()'))
    
        buttonLayout = Qt::HBoxLayout.new do |b|
            b.addStretch(1)
            b.addWidget(okButton)
            b.addWidget(cancelButton)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(@tabWidget)
            m.addLayout(buttonLayout)
        end
    
        self.windowTitle = tr("Tab Dialog")
    end
end

class GeneralTab < Qt::Widget
    
    def initialize(fileInfo, parent = nil)
        super(parent)
        fileNameLabel = Qt::Label.new(tr("File Name:"))
        fileNameEdit = Qt::LineEdit.new(fileInfo.fileName())
    
        pathLabel = Qt::Label.new(tr("Path:"))
        pathValueLabel = Qt::Label.new(fileInfo.absoluteFilePath())
        pathValueLabel.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken
    
        sizeLabel = Qt::Label.new(tr("Size:"))
        size = fileInfo.size()/1024
        sizeValueLabel = Qt::Label.new("%d K" % size)
        sizeValueLabel.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken
    
        lastReadLabel = Qt::Label.new(tr("Last Read:"))
        lastReadValueLabel = Qt::Label.new(fileInfo.lastRead().toString())
        lastReadValueLabel.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken
    
        lastModLabel = Qt::Label.new(tr("Last Modified:"))
        lastModValueLabel = Qt::Label.new(fileInfo.lastModified().toString())
        lastModValueLabel.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(fileNameLabel)
            m.addWidget(fileNameEdit)
            m.addWidget(pathLabel)
            m.addWidget(pathValueLabel)
            m.addWidget(sizeLabel)
            m.addWidget(sizeValueLabel)
            m.addWidget(lastReadLabel)
            m.addWidget(lastReadValueLabel)
            m.addWidget(lastModLabel)
            m.addWidget(lastModValueLabel)
            m.addStretch(1)
        end
    end
end

class PermissionsTab < Qt::Widget

    def initialize(fileInfo, parent = nil)
        super(parent)
        permissionsGroup = Qt::GroupBox.new(tr("Permissions"))
    
        readable = Qt::CheckBox.new(tr("Readable"))
        if fileInfo.readable?
            readable.checked = true
        end
    
        writable = Qt::CheckBox.new(tr("Writable"))
        if fileInfo.writable?
            writable.checked = true
        end
    
        executable = Qt::CheckBox.new(tr("Executable"))
        if fileInfo.executable?
            executable.checked = true
        end
    
        ownerGroup = Qt::GroupBox.new(tr("Ownership"))
    
        ownerLabel = Qt::Label.new(tr("Owner"))
        ownerValueLabel = Qt::Label.new(fileInfo.owner())
        ownerValueLabel.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken
    
        groupLabel = Qt::Label.new(tr("Group"))
        groupValueLabel = Qt::Label.new(fileInfo.group())
        groupValueLabel.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken
    
        permissionsGroup.layout = Qt::VBoxLayout.new do |p|
            p.addWidget(readable)
            p.addWidget(writable)
            p.addWidget(executable)
        end
    
        ownerGroup.layout = Qt::VBoxLayout.new do |o|
            o.addWidget(ownerLabel)
            o.addWidget(ownerValueLabel)
            o.addWidget(groupLabel)
            o.addWidget(groupValueLabel)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(permissionsGroup)
            m.addWidget(ownerGroup)
            m.addStretch(1)
        end
    end
end

class ApplicationsTab < Qt::Widget
    
    def initialize(fileInfo, parent = nil)
        super(parent)
        topLabel = Qt::Label.new(tr("Open with:"))
    
        applicationsListBox = Qt::ListWidget.new
        applications = []
        (1..30).each do |i|
            applications.push tr("Application %d" % i)
        end
        applicationsListBox.insertItems(0, applications)

        if fileInfo.suffix.nil?
            alwaysCheckBox = Qt::CheckBox.new(tr("Always use this application to " +
                "open this type of file"))
        else
            alwaysCheckBox = Qt::CheckBox.new(tr("Always use this application to " +
                "open files with the extension '%s'" % fileInfo.suffix()))
        end
    
        self.layout = Qt::VBoxLayout.new do |l|
            l.addWidget(topLabel)
            l.addWidget(applicationsListBox)
            l.addWidget(alwaysCheckBox)
        end
    end
end
