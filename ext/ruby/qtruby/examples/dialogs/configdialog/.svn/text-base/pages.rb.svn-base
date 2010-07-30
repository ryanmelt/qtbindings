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

class ConfigurationPage < Qt::Widget
    
    def initialize(parent = nil)
        super(parent)
        configGroup = Qt::GroupBox.new(tr("Server configuration"))
    
        serverLabel = Qt::Label.new(tr("Server:"))
        serverCombo = Qt::ComboBox.new do |c|
            c.addItem(tr("Trolltech (Australia)"))
            c.addItem(tr("Trolltech (Norway)"))
            c.addItem(tr("Trolltech (People's Republic of China)"))
            c.addItem(tr("Trolltech (USA)"))
        end
    
        serverLayout = Qt::HBoxLayout.new do |s|
            s.addWidget(serverLabel)
            s.addWidget(serverCombo)
        end
    
        configGroup.layout = Qt::VBoxLayout.new do |c|
            c.addLayout(serverLayout)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(configGroup)
            m.addStretch(1)
        end
    end
end

class QueryPage < Qt::Widget
    
    def initialize(parent = nil)
        super(parent)
        updateGroup = Qt::GroupBox.new(tr("Package selection"))
        systemCheckBox = Qt::CheckBox.new(tr("Update system"))
        appsCheckBox = Qt::CheckBox.new(tr("Update applications"))
        docsCheckBox = Qt::CheckBox.new(tr("Update documentation"))
    
        packageGroup = Qt::GroupBox.new(tr("Existing packages"))
    
        packageList = Qt::ListWidget.new
        qtItem = Qt::ListWidgetItem.new(packageList)
        qtItem.text = tr("Qt")
        qsaItem = Qt::ListWidgetItem.new(packageList)
        qsaItem.text = tr("QSA")
        teamBuilderItem = Qt::ListWidgetItem.new(packageList)
        teamBuilderItem.text = tr("Teambuilder")
    
        startUpdateButton = Qt::PushButton.new(tr("Start update"))
    
        updateGroup.layout = Qt::VBoxLayout.new do |u|
            u.addWidget(systemCheckBox)
            u.addWidget(appsCheckBox)
            u.addWidget(docsCheckBox)
        end
    
        packageGroup.layout = Qt::VBoxLayout.new do |p|
            p.addWidget(packageList)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(updateGroup)
            m.addWidget(packageGroup)
            m.addSpacing(12)
            m.addWidget(startUpdateButton)
            m.addStretch(1)
        end
    end
end

class UpdatePage < Qt::Widget
    
    def initialize(parent = nil)
        super(parent)
        packagesGroup = Qt::GroupBox.new(tr("Look for packages"))
    
        nameLabel = Qt::Label.new(tr("Name:"))
        nameEdit = Qt::LineEdit.new
    
        dateLabel = Qt::Label.new(tr("Released after:"))
        dateEdit = Qt::DateTimeEdit.new(Qt::Date.currentDate())
    
        releasesCheckBox = Qt::CheckBox.new(tr("Releases"))
        upgradesCheckBox = Qt::CheckBox.new(tr("Upgrades"))
    
        hitsSpinBox = Qt::SpinBox.new do |h|
            h.prefix = tr("Return up to ")
            h.suffix = tr(" results")
            h.specialValueText = tr("Return only the first result")
            h.minimum = 1
            h.maximum = 100
            h.singleStep = 10
        end

        startQueryButton = Qt::PushButton.new(tr("Start query"))
    
        packagesGroup.layout = Qt::GridLayout.new do |p|
            p.addWidget(nameLabel, 0, 0)
            p.addWidget(nameEdit, 0, 1)
            p.addWidget(dateLabel, 1, 0)
            p.addWidget(dateEdit, 1, 1)
            p.addWidget(releasesCheckBox, 2, 0)
            p.addWidget(upgradesCheckBox, 3, 0)
            p.addWidget(hitsSpinBox, 4, 0, 1, 2)
        end
    
        self.layout = Qt::VBoxLayout.new do |m|
            m.addWidget(packagesGroup)
            m.addSpacing(12)
            m.addWidget(startQueryButton)
            m.addStretch(1)
        end
    end
end
