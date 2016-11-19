#########################################################
# Initializer which starts daemons on Rails app's start #
#                Aleksandr Kuriackovskij                #
#########################################################
Dir[File.expand_path(File.dirname(__FILE__) + "../../../scripts/daemons/*.svc")].each do |service| #script considers only .svc files and starts each script individually (separate pid).
    system service, "restart"
end