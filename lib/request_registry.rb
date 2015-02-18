# http://www.justinweiss.com/blog/2014/12/01/better-globals-with-a-tiny-activesupport-module/
class RequestRegistry
  extend ActiveSupport::PerThreadRegistry

  attr_accessor :current_user, :current_permissions
end
#
# call it with            RequestRegistry.current_user = user
# have the data back with RequestRegistry.current_user # => user