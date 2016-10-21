require 'singleton'

class MyLogger
    include Singleton
    
    def initialize
        @log = File.open("log/exceptions.log", "a")
    end
    
    def logException(details)
        @log.puts(details)
        @log.flush
    end
    
end