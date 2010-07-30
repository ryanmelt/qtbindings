class KIconCollection
   IconInfo = Struct.new(:collection, :id, :filetype)
   def initialize(icon_collections)
      @icon_info = {}
      icon_collections.each_pair {
         |collection_name, collection|
         collection.each_pair {
            |key, value|
            info = IconInfo.new(collection_name, value, "png")
            @icon_info[key] = info
         }
      }
   end
   def dims
      "32x32"
   end
   def kdedir
      ENV["KDEDIR"]
   end
   def get_icon_path(icon_type)
      info = @icon_info[icon_type]
      "#{kdedir}/share/icons/default.kde/#{dims}/#{info.collection}/#{info.id}.#{info.filetype}"
   end
   def get_icon_set(icon_type)
      path = get_icon_path(icon_type)
      pixmap = Qt::Pixmap.new(path)
      icon_set = Qt::IconSet.new
      icon_set.setPixmap(pixmap, Qt::IconSet.Small)
      icon_set
   end
   def make_qt_action(parent, text_with_accel, icon_type)
      act = Qt::Action.new(parent)
      act.setIconSet(get_icon_set(icon_type))
      act.setMenuText(text_with_accel)
      act
   end
end

module Icons
   FILE_NEW, FILE_OPEN, FILE_CLOSE, FILE_SAVE, FILE_SAVE_AS, EXIT = 1,2,3,4,5,6
end

icon_collections = {
   "actions" => {
      Icons::FILE_NEW       => "filenew",
      Icons::FILE_OPEN      => "fileopen",
      Icons::FILE_CLOSE     => "fileclose",
      Icons::FILE_SAVE      => "filesave",
      Icons::FILE_SAVE_AS   => "filesaveas",
      Icons::EXIT           => "exit"
   }
}
$kIcons = KIconCollection.new(icon_collections)
print "Using KDEDIR == ", $kIcons.kdedir, "\n"
