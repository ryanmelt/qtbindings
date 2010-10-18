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

require './ui_previewdialogbase.rb'
require './previewlabel.rb'

class PreviewDialog < Qt::Dialog
    
    SmallPreviewLength = 200
    LargePreviewLength = 400
    
    signals 'pageRequested(int, QPainter*, QPrinter*)'
    
    slots   'accept()',
            'addPage()',
            'on_pageList_currentItemChanged()',
            'on_paperSizeCombo_activated(int)',
            'on_paperOrientationCombo_activated(int)',
            'reject()',
            'setNumberOfPages(int)'
    
    def initialize(printer, parent)
        super(parent) 
        @printer = printer
        @ui = Ui_PreviewDialogBase.new
        @ui.setupUi(self)
    
        @currentPage = 0
        @pageCount = 0
        @ui.pageList.setIconSize(Qt::Size.new(SmallPreviewLength, SmallPreviewLength))
        @ui.pageList.header().hide()
        @previewLabel = PreviewLabel.new
        @printer = Qt::Printer.new
        @ui.previewArea.widget = @previewLabel
        setupComboBoxes()
    
        @ui.buttonBox.button(Qt::DialogButtonBox::Ok).text = tr("&Print")
    end
    
    def setupComboBoxes()
        @ui.paperSizeCombo.addItem(tr("A0 (841 x 1189 mm)"), Qt::Variant.new(Qt::Printer::A0))
        @ui.paperSizeCombo.addItem(tr("A1 (594 x 841 mm)"), Qt::Variant.new(Qt::Printer::A1))
        @ui.paperSizeCombo.addItem(tr("A2 (420 x 594 mm)"), Qt::Variant.new(Qt::Printer::A2))
        @ui.paperSizeCombo.addItem(tr("A3 (297 x 420 mm)"), Qt::Variant.new(Qt::Printer::A3))
        @ui.paperSizeCombo.addItem(tr("A4 (210 x 297 mm, 8.26 x 11.7 inches)"), Qt::Variant.new(Qt::Printer::A4))
        @ui.paperSizeCombo.addItem(tr("A5 (148 x 210 mm)"), Qt::Variant.new(Qt::Printer::A5))
        @ui.paperSizeCombo.addItem(tr("A6 (105 x 148 mm)"), Qt::Variant.new(Qt::Printer::A6))
        @ui.paperSizeCombo.addItem(tr("A7 (74 x 105 mm)"), Qt::Variant.new(Qt::Printer::A7))
        @ui.paperSizeCombo.addItem(tr("A8 (52 x 74 mm)"), Qt::Variant.new(Qt::Printer::A8))
        @ui.paperSizeCombo.addItem(tr("A9 (37 x 52 mm)"), Qt::Variant.new(Qt::Printer::A9))
        @ui.paperSizeCombo.addItem(tr("B0 (1000 x 1414 mm)"), Qt::Variant.new(Qt::Printer::B0))
        @ui.paperSizeCombo.addItem(tr("B1 (707 x 1000 mm)"), Qt::Variant.new(Qt::Printer::B1))
        @ui.paperSizeCombo.addItem(tr("B2 (500 x 707 mm)"), Qt::Variant.new(Qt::Printer::B2))
        @ui.paperSizeCombo.addItem(tr("B3 (353 x 500 mm)"), Qt::Variant.new(Qt::Printer::B3))
        @ui.paperSizeCombo.addItem(tr("B4 (250 x 353 mm)"), Qt::Variant.new(Qt::Printer::B4))
        @ui.paperSizeCombo.addItem(tr("B5 (176 x 250 mm, 6.93 x 9.84 inches)"), Qt::Variant.new(Qt::Printer::B5))
        @ui.paperSizeCombo.addItem(tr("B6 (125 x 176 mm)"), Qt::Variant.new(Qt::Printer::B6))
        @ui.paperSizeCombo.addItem(tr("B7 (88 x 125 mm)"), Qt::Variant.new(Qt::Printer::B7))
        @ui.paperSizeCombo.addItem(tr("B8 (62 x 88 mm)"), Qt::Variant.new(Qt::Printer::B8))
        @ui.paperSizeCombo.addItem(tr("B9 (44 x 62 mm)"), Qt::Variant.new(Qt::Printer::B9))
        @ui.paperSizeCombo.addItem(tr("B10 (31 x 44 mm)"), Qt::Variant.new(Qt::Printer::B10))
        @ui.paperSizeCombo.addItem(tr("C5E (163 x 229 mm)"), Qt::Variant.new(Qt::Printer::C5E))
        @ui.paperSizeCombo.addItem(tr("DLE (110 x 220 mm)"), Qt::Variant.new(Qt::Printer::DLE))
        @ui.paperSizeCombo.addItem(tr("Executive (7.5 x 10 inches, 191 x 254 mm)"), Qt::Variant.new(Qt::Printer::Executive))
        @ui.paperSizeCombo.addItem(tr("Folio (210 x 330 mm)"), Qt::Variant.new(Qt::Printer::Folio))
        @ui.paperSizeCombo.addItem(tr("Ledger (432 x 279 mm)"), Qt::Variant.new(Qt::Printer::Ledger))
        @ui.paperSizeCombo.addItem(tr("Legal (8.5 x 14 inches, 216 x 356 mm)"), Qt::Variant.new(Qt::Printer::Legal))
        @ui.paperSizeCombo.addItem(tr("Letter (8.5 x 11 inches, 216 x 279 mm)"), Qt::Variant.new(Qt::Printer::Letter))
        @ui.paperSizeCombo.addItem(tr("Tabloid (279 x 432 mm)"), Qt::Variant.new(Qt::Printer::Tabloid))
        @ui.paperSizeCombo.addItem(tr("US Common #10 Envelope (105 x 241 mm)"), Qt::Variant.new(Qt::Printer::Comm10E))
        @ui.paperSizeCombo.currentIndex = @ui.paperSizeCombo.findData(Qt::Variant.new(Qt::Printer::A4))
    
        @ui.paperOrientationCombo.addItem(tr("Portrait"), Qt::Variant.new(Qt::Printer::Portrait))
        @ui.paperOrientationCombo.addItem(tr("Landscape"), Qt::Variant.new(Qt::Printer::Landscape))
    end
    
    def addPage()
        if @currentPage >= @pageCount
            return
        end

        item = Qt::TreeWidgetItem.new(@ui.pageList)
        item.setCheckState(0, Qt::Checked)
    
        paintItem(item, @currentPage)
        if @ui.pageList.indexOfTopLevelItem(@ui.pageList.currentItem()) < 0
            @ui.pageList.currentItem = @ui.pageList.topLevelItem(0)
        end
    
        $qApp.processEvents()
        @currentPage += 1
    
        Qt::Timer.singleShot(0, self, SLOT('addPage()'))
    end
    
    def setNumberOfPages(count)
        @pageCount = count
        Qt::Timer.singleShot(0, self, SLOT('addPage()'))
    end
    
    def paintItem(item, index)
        pixmap = Qt::Pixmap.new(SmallPreviewLength, SmallPreviewLength)
        paintPreview(pixmap, index)
        item.setIcon(0, Qt::Icon.new(pixmap))
    end
    
    def paintPreview(pixmap, index)
        longestSide = [@printer.paperRect().width(),
                                  @printer.paperRect().height()].max
        width = pixmap.width() * @printer.paperRect().width() / longestSide
        height = pixmap.height() * @printer.paperRect().height() / longestSide
   
        pixmap.fill(Qt::Color.new(qRgb(224,224,224)))
        painter = Qt::Painter.new
        painter.begin(pixmap)
        painter.renderHint = Qt::Painter::Antialiasing
        painter.translate((pixmap.width() - width)/2,
                          (pixmap.height() - height)/2)
        painter.fillRect(Qt::RectF.new(0, 0, width, height), Qt::Brush.new(Qt::white))
        painter.scale(pixmap.width() / longestSide, pixmap.height() / longestSide)
        painter.translate(@printer.pageRect().topLeft())
        emit pageRequested(index, painter, @printer)
        painter.end()
    end
    
    def accept()
        markedPages = 0
        for pageIndex in 0..@ui.pageList.topLevelItemCount
            if @ui.pageList.topLevelItem(pageIndex).checkState(0) == Qt::Checked
                markedPages += 1
            end
        end
    
        # Print all pages that have yet to be previewed.
        markedPages += @pageCount - pageIndex
    
        @printer.pageSize = @ui.paperSizeCombo.itemData(@ui.paperSizeCombo.currentIndex()).to_i
        @printer.orientation = paperOrientationCombo.itemData(paperOrientationCombo.currentIndex()).to_i
    
        dialog = Qt::PrintDialog.new(@printer, self)
        if dialog.exec() != Qt::Dialog::Accepted
            return
        end

        @ui.progressBar.maximum = markedPages
        @ui.progressBar.enabled = true
        @ui.progressBar.textVisible = true
    
        painter = Qt::Painter.new
        painter.begin(@printer)
    
        @canceled = false
        printed = 0
        firstPage = true
        for pageIndex in 0..@pageCount
            $qApp.processEvents()
    
            if @canceled
                break
            end

            if pageIndex >= @currentPage || isSelected(pageIndex)
                # Print all pages that are either marked or have yet to be
                # previewed.
                if !firstPage
                    @printer.newPage()
                end
    
                emit pageRequested(pageIndex, painter, @printer)
                printed += 1
                @ui.progressBar.value = printed
                firstPage = false
            end
        end
        painter.end()
    
        @ui.progressBar.textVisible = false
        @ui.progressBar.enabled = false
    
        Qt::Dialog.accept()
    end
    
    def isSelected(index)
        if index >= 0 && index < @ui.pageList.topLevelItemCount
            return @ui.pageList.topLevelItem(index).checkState(0) == Qt::Checked
        else
            return false
        end
    end
    
    def reject()
        @canceled = true
        Qt::Dialog.reject()
    end
    
    def resizeEvent(event)
        size = [[@ui.previewArea.width - @ui.previewArea.verticalScrollBar.width,
                             @ui.previewArea.height - @ui.previewArea.horizontalScrollBar.height].min,
                        LargePreviewLength].max
        @previewLabel.resize(size, size)
        on_pageList_currentItemChanged()
    end
    
    def on_pageList_currentItemChanged()
        if @ui.pageList.indexOfTopLevelItem(@ui.pageList.currentItem()) < 0
            return
        end

        pixmap = Qt::Pixmap.new(@previewLabel.size())
        paintPreview(pixmap, @ui.pageList.indexOfTopLevelItem(@ui.pageList.currentItem()))
        @previewLabel.pixmap = pixmap
        @previewLabel.update()
    end
    
    def on_paperSizeCombo_activated(index)
        Qt.debug_level = 100
        @printer.paperSize = @ui.paperSizeCombo.itemData(index.to_i).value
    
        for index in 0..@ui.pageList.topLevelItemCount
            paintItem(@ui.pageList.topLevelItem(index), index)
        end

        on_pageList_currentItemChanged()
    end
    
    def on_paperOrientationCombo_activated(index)
        @printer.orientation = @ui.paperOrientationCombo.itemData(index.to_i)
    
        for index in 0..@ui.pageList.topLevelItemCount
            paintItem(@ui.pageList.topLevelItem(index), index)
        end

        on_pageList_currentItemChanged()
    end
end
