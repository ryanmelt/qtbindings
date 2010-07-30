class ComTrolltechChatInterface < Qt::DBusAbstractInterface
    signals 'void action(const QString&, const QString&)',
            'void message(const QString&, const QString&)'

    def initialize(service, path, connection, parent)
        super(service, path, ComTrolltechChatInterface.staticInterfaceName(), connection, parent)
    end

    def self.staticInterfaceName()
        return "com.trolltech.chat"
    end
end

