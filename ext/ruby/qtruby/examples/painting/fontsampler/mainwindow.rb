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
    
require 'ui_mainwindowbase.rb'
require 'previewdialog.rb'

class MainWindow < Qt::MainWindow
    
    
    slots   'on_clearAction_triggered()',
            'on_markAction_triggered()',
            'on_printAction_triggered()',
            'on_printPreviewAction_triggered()',
            'on_unmarkAction_triggered()',
            'printPage(int, QPainter &, QPrinter &)',
            'showFont(QTreeWidgetItem *)',
            'updateStyles(QTreeWidgetItem *, int)'
    
    def initialize(parent = nil)
        super(parent)
        @ui = Ui_MainWindowBase.new
        @ui.setupUi(self)
        @sampleSizes = []
        @sampleSizes << 32 << 24 << 16 << 14 << 12 << 8 << 4 << 2 << 1
        @markedCount = 0
        @pageMap = {}
        setupFontTree()
    
        connect(@ui.quitAction, SIGNAL('triggered()'), $qApp, SLOT('quit()'))
        connect(@ui.fontTree, SIGNAL('currentItemChanged(QTreeWidgetItem *, QTreeWidgetItem *)'),
                self, SLOT('showFont(QTreeWidgetItem *)'))
        connect(@ui.fontTree, SIGNAL('itemChanged(QTreeWidgetItem *, int)'),
                self, SLOT('updateStyles(QTreeWidgetItem *, int)'))
    
        @ui.fontTree.setItemSelected(@ui.fontTree.topLevelItem(0), true)
        showFont(@ui.fontTree.topLevelItem(0))
    end
    
    def setupFontTree()
        database = Qt::FontDatabase.new
        @ui.fontTree.columnCount = 1
        @ui.fontTree.headerLabels = [tr("Font")]
    
        database.families.each do |family|
            styles = database.styles(family)
            if styles.empty?
                continue
            end
    
            familyItem = Qt::TreeWidgetItem.new(@ui.fontTree)
            familyItem.setText(0, family)
            familyItem.setCheckState(0, Qt::Unchecked)
    
            styles.each do |style|
                styleItem = Qt::TreeWidgetItem.new(familyItem)
                styleItem.setText(0, style)
                styleItem.setCheckState(0, Qt::Unchecked)
                styleItem.setData(0, Qt::UserRole,
                    Qt::Variant.new(database.weight(family, style)))
                styleItem.setData(0, Qt::UserRole + 1,
                    Qt::Variant.new(database.italic(family, style)))
            end
        end
    end
    
    def on_clearAction_triggered()
        currentItem = @ui.fontTree.currentItem()
        @ui.fontTree.selectedItems.each do |item|
            fontTree.setItemSelected(item, false)
        end
        @ui.fontTree.setItemSelected(currentItem, true)
    end
    
    def on_markAction_triggered()
        markUnmarkFonts(Qt::Checked)
    end
    
    def on_unmarkAction_triggered()
        markUnmarkFonts(Qt::Unchecked)
    end
    
    def markUnmarkFonts(state)
        items = @ui.fontTree.selectedItems()
        items.each do |item|
            if item.checkState(0) != state
                item.setCheckState(0, state)
            end
        end
    end
    
    def showFont(item)
        if item.nil?
            return
        end
    
        if !item.parent.nil?
            family = item.parent().text(0)
            style = item.text(0)
            weight = item.data(0, Qt::UserRole).to_i
            italic = item.data(0, Qt::UserRole + 1).toBool()
        else
            family = item.text(0)
            style = item.child(0).text(0)
            weight = item.child(0).data(0, Qt::UserRole).to_i
            italic = item.child(0).data(0, Qt::UserRole + 1).toBool()
        end
    
        oldText = @ui.textEdit.toPlainText.lstrip.rstrip
        modified = @ui.textEdit.document.modified?
        @ui.textEdit.clear
        @ui.textEdit.document.setDefaultFont(Qt::Font.new(family, 32, weight, italic))
    
        cursor = @ui.textEdit.textCursor()
        blockFormat = Qt::TextBlockFormat.new
        blockFormat.alignment = Qt::AlignCenter
        cursor.insertBlock(blockFormat)
    
        if modified
            cursor.insertText(oldText)
        else
            cursor.insertText("%s %s" % [family, style])
        end

        @ui.textEdit.document().modified = modified
    end
    
    def updateStyles(item, column)
        if item.nil? || column != 0
            return
        end
        state = item.checkState(0)
        parent = item.parent
    
        if !parent.nil?
    
            # Only count style items.
            if state == Qt::Checked
                @markedCount += 1
            else
                @markedCount -= 1
            end

            if state == Qt::Checked &&
                parent.checkState(0) == Qt::Unchecked
                # Mark parent items when child items are checked.
                parent.setCheckState(0, Qt::Checked)
            elsif state == Qt::Unchecked &&
                       parent.checkState(0) == Qt::Checked
                marked = false
                for row in 0..parent.childCount
                    if parent.child(row).checkState(0) == Qt::Checked
                        marked = true
                        break
                    end
                end
                # Unmark parent items when all child items are unchecked.
                if !marked
                    parent.setCheckState(0, Qt::Unchecked)
                end
            end
        else
            row
            number = 0
            for row in 0..item.childCount
                if item.child(row).checkState(0) == Qt::Checked
                    number += 1
                end
            end
    
            # Mark/unmark all child items when marking/unmarking top-level
            # items.
            if state == Qt::Checked && number == 0
                for row in 0..item.childCount
                    if item.child(row).checkState(0) == Qt::Unchecked
                        item.child(row).setCheckState(0, Qt::Checked)
                    end
                end
            elsif state == Qt::Unchecked && number > 0
                for row in 0..item.childCount
                    if item.child(row).checkState(0) == Qt::Checked
                        item.child(row).setCheckState(0, Qt::Unchecked)
                    end
                end
            end
        end
    
        @ui.printAction.enabled = @markedCount > 0
        @ui.printPreviewAction.enabled = @markedCount > 0
    end
    
    def on_printAction_triggered()
        @pageMap = currentPageMap()
    
        if @pageMap.length == 0
            return
        end

        printer = Qt::Printer.new(Qt::Printer::HighResolution)
        if !setupPrinter(printer)
            return
        end

        from = printer.fromPage()
        to = printer.toPage()
        if from <= 0 && to <= 0
            from = 1
            to = @pageMap.keys().length
        end
    
        progress = Qt::ProgressDialog.new(tr("Printing font samples..."), tr("&Cancel"),
                                 0, @pageMap.length, self)
        progress.windowModality = Qt::ApplicationModal
        progress.windowTitle = tr("Printing")
        progress.minimum = from - 1
        progress.maximum = to
    
        painter = Qt::Painter.new
        painter.begin(printer)
        firstPage = true
    
        for index in -1..to
            if !firstPage
                printer.newPage()
            end

            $qApp.processEvents()
            if progress.wasCanceled()
                break
            end

            printPage(index, painter, printer)
            progress.value = index + 1
            firstPage = false
        end
    
        painter.end
    end
    
    def on_printPreviewAction_triggered()
        @pageMap = currentPageMap()
    
        if @pageMap.length == 0
            return
        end
        printer = Qt::Printer.new
    
        preview = PreviewDialog.new(printer, self)
        connect(preview,
            SIGNAL('pageRequested(int, QPainter &, QPrinter &)'),
            self, SLOT('printPage(int, QPainter &, QPrinter &)'),
            Qt::DirectConnection)
    
        preview.numberOfPages = @pageMap.length
        preview.exec()
    end
    
    def currentPageMap()
        pageMap = {}
    
        for row in 0..@ui.fontTree.topLevelItemCount
            familyItem = @ui.fontTree.topLevelItem(row)
    
            if familyItem.checkState(0) == Qt::Checked
                family = familyItem.text(0)
                pageMap[family] = []
            end
            
            for childRow in 0..familyItem.childCount
                styleItem = familyItem.child(childRow)
                if styleItem.checkState(0) == Qt::Checked
                    pageMap[family].append(styleItem)
                end
            end
        end
    
        return pageMap
    end
    
    def setupPrinter(printer)
        dialog = Qt::PrintDialog.new(printer, self)
        return dialog.exec() == Qt::Dialog::Accepted
    end
    
    def printPage(index, painter, printer)
        family = pageMap.keys()[index]
        items = pageMap[family]
    
        # Find the dimensions of the text on each page.
        width = 0.0
        height = 0.0
        items.each do |item|
            style = item.text(0)
            weight = item.data(0, Qt::UserRole).to_i
            italic = item.data(0, Qt::UserRole + 1).toBool()
    
            # Calculate the maximum width and total height of the text.
            @sampleSizes.each do |size|
                font = Qt::Font.new(family, size, weight, italic)
                font = Qt::Font.new(font, painter.device())
                fontMetrics = Qt::FontMetricsF.new(font)
                rect = fontMetrics.boundingRect(
                "%s %s" % [family, style])
                width = [rect.width(), width].max
                height += rect.height()
            end
        end
    
        xScale = printer.pageRect().width() / width
        yScale = printer.pageRect().height() / height
        scale = [xScale, yScale].min
    
        remainingHeight = printer.pageRect().height()/scale - height
        spaceHeight = (remainingHeight/4.0) / (items.length + 1)
        interLineHeight = (remainingHeight/4.0) / (@sampleSizes.length * items.count())
    
        painter.save()
        painter.translate(printer.pageRect().width()/2.0, printer.pageRect().height()/2.0)
        painter.scale(scale, scale)
        painter.brush = Qt::Brush.new(Qt::black)
    
        x = -width/2.0
        y = -height/2.0 - remainingHeight/4.0 + spaceHeight
    
        items.each do |item|
            style = item.text(0)
            weight = item.data(0, Qt::UserRole).to_i
            italic = item.data(0, Qt::UserRole + 1).toBool()
    
            # Draw each line of text
            @sampleSizes.each do |size|
                font = Qt::Font.new(family, size, weight, italic)
                font = Qt::Font.new(font, painter.device())
                fontMetrics = Qt::FontMetricsF.new(font)
                rect = fontMetrics.boundingRect("%s %s" % [font.family(), style])
                y += rect.height()
                painter.font = font
                painter.drawText(Qt::PointF.neew(x, y),
                                 "%s %s" % [family, style])
                y += interLineHeight
            end
            y += spaceHeight
        end
    
        painter.restore()
    end
end
