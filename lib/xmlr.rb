require "xmlr/version"
require 'pry'

module Doctype
  private

  def value_to_str(value)
    if value.is_a?(Array)
      value.join(' ')
    else
      value.to_s
    end
  end

  def args_to_param(args)
    args.inject("") do |base, kv|
      %(#{base} #{kv[0]}="#{value_to_str(kv[1])}")
    end[1..-1]
  end

  def empty_tag_without_args(name)
    "<#{name} />"
  end

  def empty_tag_with_args(name, args)
    %(<#{name} #{args_to_param(args)} />)
  end

  def method_missing(method_name, *args, &block)
    if block_given?
      "<#{method_name}>(TODO)</#{method_name}>"
    else
      if args.empty?
        empty_tag_without_args(method_name)
      else
        empty_tag_with_args(method_name, *args)
      end
    end
  end
end
