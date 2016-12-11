require 'pry'

module XMLR
  def method_missing(method_name, *args, &block)
    puts "<#{method_name}>(TODO)</#{method_name}>"
  end
end
