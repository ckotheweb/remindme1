# Class name: MyLogger
# Version: 0.1
# Date 2016/10
# @author Aleksandr Kuriackovskij, x15029476

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