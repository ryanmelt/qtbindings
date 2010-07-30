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
    
class PieView < Qt::AbstractItemView
    
    slots 'dataChanged(const QModelIndex &, const QModelIndex &)',
            'rowsInserted(const QModelIndex &, int, int)',
            'rowsAboutToBeRemoved(const QModelIndex &, int, int)'
    
    def initialize(parent = nil)
        super(parent)
        horizontalScrollBar.range = 0..0
        verticalScrollBar.range = 0..0
    
        @margin = 8
        @totalSize = 300
        @pieSize = @totalSize - 2*@margin
        @validItems = 0
        @totalValue = 0.0
    end
    
    def dataChanged(topLeft, bottomRight)
        super(topLeft, bottomRight)
    
        @validItems = 0
        @totalValue = 0.0
    
        (0...model().rowCount(rootIndex())).each do |row|
    
            index = model().index(row, 1, rootIndex())
            value = model().data(index).toDouble
    
            if value > 0.0
                @totalValue += value
                @validItems += 1
            end
        end
        viewport().update()
    end
    
    def edit(index, trigger, event)
        if index.column() == 0
            return super(index, trigger, event)
        else
            return false
        end
    end
    
    # Returns the item that covers the coordinate given in the view.
    
    def indexAt(point)
        if @validItems == 0
            return Qt::ModelIndex.new
        end
    
        # Transform the view coordinates into contents widget coordinates.
        wx = point.x() + horizontalScrollBar().value()
        wy = point.y() + verticalScrollBar().value()
    
        if wx < @totalSize
            cx = wx - @totalSize/2
            cy = @totalSize/2 - wy # positive cy for items above the center
    
            # Determine the distance from the center point of the pie chart.
            d = ((cx ** 2) + (cy ** 2)) ** 0.5
    
            if d == 0 || d > @pieSize/2
                return Qt::ModelIndex.new
            end
    
            # Determine the angle of the point.
            angle = (180 / Math::PI) * Math.acos(cx/d)
            if cy < 0
                angle = 360 - angle
            end
    
            # Find the relevant slice of the pie.
            startAngle = 0.0
    
            for row in 0...model.rowCount(rootIndex)
    
                index = model.index(row, 1, rootIndex())
                value = model.data(index).to_f
    
                if value > 0.0
                    sliceAngle = 360*value/@totalValue
    
                    if angle >= startAngle && angle < (startAngle + sliceAngle)
                        return model().index(row, 1, rootIndex())
                    end
    
                    startAngle += sliceAngle
                end
            end
        else
            itemHeight = Qt::FontMetrics.new(viewOptions().font).height()
            listItem = ((wy - @margin) / itemHeight).to_i
            validRow = 0
    
            for row in 0...model.rowCount(rootIndex) do
    
                index = model().index(row, 1, rootIndex())
                if model().data(index).to_f > 0.0
    
                    if listItem == validRow
                        return model().index(row, 0, rootIndex())
                    end
    
                    # Update the list index that corresponds to the next valid row.
                    validRow += 1
                end
            end
        end
    
        return Qt::ModelIndex.new
    end
    
    def isIndexHidden(index)
        return false
    end
    
    # Returns the rectangle of the item at position \a index in the
    # model. The rectangle is in contents coordinates.
    
    def itemRect(index)
        if !index.isValid()
            return Qt::Rect.new
        end
    
        # Check whether the index's row is in the list of rows represented
        # by slices.
        valueIndex = Qt::ModelIndex.new
    
        if index.column() != 1
            valueIndex = model().index(index.row(), 1, rootIndex())
        else
            valueIndex = index
        end
    
        if model().data(valueIndex).toDouble > 0.0
    
            listItem = 0
            (index.row()-1).downto(0) do |row|
                if model().data(model().index(row, 1, rootIndex())).toDouble > 0.0
                    listItem += 1
                end
            end
    
            case index.column
            when 0:
                itemHeight = Qt::FontMetrics.new(viewOptions().font).height()
    
                return Qt::Rect.new(@totalSize,
                             (@margin + listItem*itemHeight).to_i,
                             @totalSize - @margin, itemHeight.to_i)
            when 1:
                return viewport().rect()
            end
    
        end
        return Qt::Rect.new
    end
    
    def itemRegion(index)
        if !index.isValid()
            return Qt::Region.new
        end
    
        if index.column() != 1
            return Qt::Region.new(itemRect(index))
        end
    
        if model().data(index).to_f <= 0.0
            return Qt::Region.new
        end
    
        startAngle = 0.0
        (0...model.rowCount(rootIndex())).each do |row|
    
            sliceIndex = model.index(row, 1, rootIndex)
            value = model.data(sliceIndex).to_f
    
            if value > 0.0
                angle = 360*value/@totalValue
    
                if sliceIndex == index
                    slicePath = Qt::PainterPath.new
                    slicePath.moveTo(@totalSize/2, @totalSize/2)
                    slicePath.arcTo(@margin, @margin, @margin+@pieSize, @margin+@pieSize,
                                    startAngle, angle)
                    slicePath.closeSubpath()
    
                    return Qt::Region.new(slicePath.toFillPolygon().toPolygon())
                end
    
                startAngle += angle
            end
        end
    
        return Qt::Region.new
    end
    
    def horizontalOffset()
        return horizontalScrollBar().value()
    end
    
    def mouseReleaseEvent(event)
        super(event)
        @selectionRect = Qt::Rect.new
        viewport().update()
    end
    
    def moveCursor(cursorAction, modifiers)
        current = currentIndex()
    
        case cursorAction
        when MoveLeft, MoveUp
            if current.row > 0
                current = model().index(current.row() - 1, current.column,
                                            rootIndex())
            else
                current = model().index(0, current.column, rootIndex())
            end
        when MoveRight, MoveDown
            if current.row < rows(current) - 1
                current = model().index(current.row + 1, current.column,
                                            rootIndex())
            else
                current = model().index(rows(current) - 1, current.column,
                                            rootIndex())
            end
        end
    
        viewport().update()
        return current
    end
    
    def paintEvent(event)
        selections = selectionModel()
        option = viewOptions()
        state = option.state
    
        background = option.palette.base()
        foreground = Qt::Pen.new(option.palette.color(Qt::Palette::Foreground))
        textPen = Qt::Pen.new(option.palette.color(Qt::Palette::Text))
        highlightedPen = Qt::Pen.new(option.palette.color(Qt::Palette::HighlightedText))
    
        painter = Qt::Painter.new(viewport())
        painter.renderHint = Qt::Painter::Antialiasing
    
        painter.fillRect(event.rect(), background)
        painter.pen = foreground
    
        # Viewport rectangles
        pieRect = Qt::Rect.new(@margin, @margin, @pieSize, @pieSize)
        keyPoint = Qt::Point.new(@totalSize - horizontalScrollBar().value(),
                                 @margin - verticalScrollBar().value())
    
        if @validItems > 0
            painter.save()
            painter.translate(pieRect.x() - horizontalScrollBar().value(),
                              pieRect.y() - verticalScrollBar().value())
            painter.drawEllipse(0, 0, @pieSize, @pieSize)
            startAngle = 0.0
    
            for row in 0...model.rowCount(rootIndex) do
                index = model.index(row, 1, rootIndex())
                value = model.data(index).toDouble
    
                if value > 0.0
                    angle = 360*value/@totalValue
    
                    colorIndex = model().index(row, 0, rootIndex())
                    color = Qt::Color.new(model().data(colorIndex,
                                    Qt::DecorationRole).toString)
    
                    if currentIndex() == index
                        painter.brush = Qt::Brush.new(color, Qt::Dense4Pattern)
                    elsif selections.isSelected(index)
                        painter.brush = Qt::Brush.new(color, Qt::Dense3Pattern)
                    else
                        painter.brush = Qt::Brush.new(color)
                    end
    
                    painter.drawPie(0, 0, @pieSize, @pieSize, (startAngle*16).to_i,
                                    (angle*16).to_i)
    
                    startAngle += angle
                end
            end
            painter.restore()
    
            keyNumber = 0
    
            for row in 0...model.rowCount(rootIndex()) do
    
                index = model.index(row, 1, rootIndex())
                value = model.data(index).toDouble
    
                if value > 0.0
                    labelIndex = model.index(row, 0, rootIndex())
    
                    option = viewOptions()
                    option.rect = visualRect(labelIndex)
                    if selections.isSelected(labelIndex)
                        option.state |= Qt::Style::State_Selected.to_i
                    end
                    if currentIndex() == labelIndex
                        option.state |= Qt::Style::State_HasFocus.to_i
                    end
                    itemDelegate().paint(painter, option, labelIndex)
    
                    keyNumber += 1
                end
            end
        end
    
        if !@selectionRect.nil?
            band = Qt::StyleOptionRubberBand.new
            band.shape = Qt::RubberBand::Rectangle
            band.rect = @selectionRect
            painter.save()
            style().drawControl(Qt::Style::CE_RubberBand, band, painter)
            painter.restore()
        end

        painter.end
    end
    
    def resizeEvent(event)
        updateGeometries()
    end
    
    def rows(index)
        return model().rowCount(model().parent(index))
    end
    
    def rowsInserted(parent, start_row, end_row)
        for row in start_row..end_row do
    
            index = model.index(row, 1, rootIndex)
            value = model.data(index).toDouble
    
            if value > 0.0
                @totalValue += value
                @validItems += 1
            end
        end
    
        super(parent, start_row, end_row)
    end
    
    def rowsAboutToBeRemoved(parent, start_row, end_row)
        for row in start_row..end_row do
    
            index = model.index(row, 1, rootIndex())
            value = model.data(index).toDouble
            if value > 0.0
                @totalValue -= value
                @validItems -= 1
            end
        end
    
        super(parent, start_row, end_row)
    end
    
    def scrollContentsBy(dx, dy)
        viewport().scroll(dx, dy)
    end
    
    def scrollTo(index, hint)
        area = viewport.rect
        rect = visualRect(index)
    
        if rect.left < area.left
            horizontalScrollBar.setValue(
                horizontalScrollBar.value + rect.left - area.left)
        elsif rect.right > area.right
            horizontalScrollBar.setValue(
                horizontalScrollBar.value +
                    [rect.right - area.right, rect.left - area.left].min)
        end
    
        if rect.top < area.top()
            verticalScrollBar.setValue(
                verticalScrollBar.value + rect.top - area.top)
        elsif rect.bottom > area.bottom()
            verticalScrollBar.setValue(
                verticalScrollBar.value +
                    [rect.bottom - area.bottom, rect.top - area.top].min)
        end
    end
    
    # Find the indices corresponding to the extent of the selection.
    def setSelection(rect, command)
        # Use content widget coordinates because we will use the itemRegion()
        # function to check for intersections.
    
        contentsRect = rect.translated(horizontalScrollBar.value,
                                             verticalScrollBar.value)
    
        rows = model.rowCount(rootIndex)
        columns = model.columnCount(rootIndex)
        indexes = []
    
        for row in 0...rows do
            for column in 0...columns do
                index = model.index(row, column, rootIndex)
                region = itemRegion(index)
                if !region.intersect(Qt::Region.new(contentsRect)).empty?
                    indexes.push(index)
                end
            end
        end
    
        if indexes.size > 0
            firstRow = indexes[0].row
            lastRow = indexes[0].row
            firstColumn = indexes[0].column
            lastColumn = indexes[0].column
    
            for i in 1...indexes.size do
                firstRow = [firstRow, indexes[i].row].min
                lastRow = [lastRow, indexes[i].row].max
                firstColumn = [firstColumn, indexes[i].column].min
                lastColumn = [lastColumn, indexes[i].column].max
            end
    
             selection = Qt::ItemSelection.new(
                model.index(firstRow, firstColumn, rootIndex()),
                model.index(lastRow, lastColumn, rootIndex()))
            selectionModel.select(selection, command)
        else
            noIndex = Qt::ModelIndex.new
            selection = Qt::ItemSelection.new(noIndex, noIndex)
            selectionModel.select(selection, command)
        end
    
        @selectionRect = rect
    end
    
    def updateGeometries
        horizontalScrollBar.pageStep = viewport.width
        horizontalScrollBar.range = 0..[0, 2*@totalSize - viewport.width].max
        verticalScrollBar.pageStep = viewport.height
        verticalScrollBar.range = 0..[0, @totalSize - viewport.height].max
    end
    
    def verticalOffset
        return verticalScrollBar.value
    end
    
    # Returns the position of the item in viewport coordinates.
    
    def visualRect(index)
        rect = itemRect(index)
        if rect.valid?
            return Qt::Rect.new(rect.left - horizontalScrollBar.value,
                         rect.top - verticalScrollBar.value,
                         rect.width, rect.height)
        else
            return rect
        end
    end
    
    # Returns a region corresponding to the selection in viewport coordinates.
    
    def visualRegionForSelection(selection)
        ranges = selection.length

        if ranges == 0
            return Qt::Region.new(Qt::Rect.new)
        end
    
        # Note that we use the top and bottom functions of the selection range
        # since the data is stored in rows.
    
        firstRow = selection.at(0).top
        lastRow = selection.at(0).top
    
        for i in 0...ranges do
            firstRow = [firstRow, selection.at(i).top].min
            lastRow = [lastRow, selection.at(i).bottom].max
        end
    
        firstItem = model().index([firstRow, lastRow].min, 0, rootIndex())
        lastItem = model().index([firstRow, lastRow].max, 0, rootIndex())
    
        firstRect = visualRect(firstItem)
        lastRect = visualRect(lastItem)
    
        return Qt::Region.new(firstRect.unite(lastRect))
    end
end
