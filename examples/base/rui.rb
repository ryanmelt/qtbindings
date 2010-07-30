require '../base/kicons.rb'

RAction = Struct.new(:text_with_accel, :icon_type, :rec, :slot, :included_in, :action)
RSeperator = Struct.new(:included_in, :id)

def build_actions(actions)
   actions.each { |a|
      if a.is_a? RSeperator
         a.included_in.each {
            |to| a.id = to.insertSeparator() 
         }
      else
         qt_action = $kIcons.make_qt_action(self, a.text_with_accel, a.icon_type)
         connect(qt_action, SIGNAL('activated()'), a.rec, a.slot)
         a.included_in.each {
            |to| qt_action.addTo(to)
         }
         a.action = qt_action
      end
   }
end
