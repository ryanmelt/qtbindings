=begin
This Qt::AbstractItemModel based model allows an ActiveRecord or ActiveResource
data set be used for viewing in a Qt::TreeView. 

Example usage:

app = Qt::Application.new(ARGV)
agencies = TravelAgency.find(:all)
model = ActiveItemModel.new(agencies)
tree = Qt::TreeView.new
tree.model = model
tree.show
app.exec

Written by Richard Dale and Silvio Fonseca

=end

require 'Qt'

#require "active_record"
#require "active_support"
#require "active_resource"

require 'date'

class TreeItem
    attr_reader :childItems, :resource, :itemData

    def initialize(item, keys, parent = nil, prefix="")
        @keys = keys
        @parentItem = parent
        @childItems = []
        @resource = item
        if @resource.respond_to? :attributes
            @resource.attributes.inject(@itemData = {}) do |data, a|
                if a[1].respond_to? :attributes
                    TreeItem.new(a[1], @keys, self, prefix + a[0] + ".")
                else
                    data[prefix + a[0]] = a[1]
                end
                data
            end
        else
            @itemData = item
        end

        if @parentItem
            @parentItem.appendChild(self)
        end
    end
    
    def appendChild(item)
        @childItems.push(item)
    end
    
    def child(row)
        return @childItems[row]
    end
    
    def childCount
        return @childItems.length
    end
    
    def columnCount
        return @itemData.length
    end
    
    def data(column)
        return Qt::Variant.new(@itemData[@keys[column]])
    end
    
    def parent
        return @parentItem
    end
    
    def row
        if !@parentItem.nil?
            return @parentItem.childItems.index(self)
        end
    
        return 0
    end
end

class ActiveItemModel < Qt::AbstractItemModel    
    def initialize(collection, columns=nil)
        super()
        @collection = collection
        @keys = build_keys([], @collection.first.attributes)
        @keys.inject(@labels = {}) do |labels, k| 
            labels[k] = k.humanize.gsub(/\./, ' ')
            labels 
        end

        @rootItem = TreeItem.new(@labels, @keys)
        @collection.each do |row|
            TreeItem.new(row, @keys, @rootItem)
        end
    end

    def build_keys(keys, attrs, prefix="")
        attrs.inject(keys) do |cols, a|
            if a[1].respond_to? :attributes
                build_keys(cols, a[1].attributes, prefix + a[0] + ".")
            else
                cols << prefix + a[0]
            end
        end
    end

    def [](row)
        row = row.row if row.is_a?Qt::ModelIndex
        @collection[row]
    end

    def column(name)
        @keys.index name
    end
    
    def columnCount(parent)
        if parent.valid?
            return parent.internalPointer.columnCount
        else
            return @rootItem.columnCount
        end
    end
    
    def data(index, role)
        if !index.valid?
            return Qt::Variant.new
        end
    
        if role != Qt::DisplayRole
            return Qt::Variant.new
        end
    
        item = index.internalPointer
        return item.data(index.column)
    end

    def setData(index, variant, role=Qt::EditRole)
        if index.valid? and role == Qt::EditRole
            raise "invalid column #{index.column}" if (index.column < 0 ||
                index.column >= @keys.size)

            att = @keys[index.column]
            item = index.internalPointer

            if ! item.itemData.has_key? att
                return false
            end

            value = variant.value

            if value.class.name == "Qt::Date"
                value = Date.new(value.year, value.month, value.day)
            elsif value.class.name == "Qt::Time"
                value = Time.new(value.hour, value.min, value.sec)
            end

            att.gsub!(/.*\.(.*)/, '\1')
            # Don't allow the primary key to be changed
            if att == 'id'
                return false
            end

            eval("item.resource.attributes['%s'] = value" % att)
            item.resource.save
            emit dataChanged(index, index)
            return true
        else
            return false
        end
    end
    
    def flags(index)
        if !index.valid?
            return Qt::ItemIsEnabled
        end
    
        return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable
    end
    
    def headerData(section, orientation, role)
        if orientation == Qt::Horizontal && role == Qt::DisplayRole
            return Qt::Variant.new(@labels[@keys[section]])
        end
    
        return Qt::Variant.new
    end
    
    def index(row, column, parent)
        if !parent.valid?
            parentItem = @rootItem
        else
            parentItem = parent.internalPointer
        end
    
        @childItem = parentItem.child(row)
        if ! @childItem.nil?
            return createIndex(row, column, @childItem)
        else
            return Qt::ModelIndex.new
        end
    end
    
    def parent(index)
        if !index.valid?
            return Qt::ModelIndex.new
        end
    
        childItem = index.internalPointer
        parentItem = childItem.parent
    
        if parentItem == @rootItem
            return Qt::ModelIndex.new
        end
    
        return createIndex(parentItem.row, 0, parentItem)
    end
    
    def rowCount(parent)
        if !parent.valid?
            parentItem = @rootItem
        else
            parentItem = parent.internalPointer
        end
    
        return parentItem.childCount
    end
end

# kate: indent-width 4;
