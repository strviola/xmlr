require "xmlr/version"
require 'pry'

module XMLR

  def doctype
    add_content "<!DOCTYPE HTML>\n"
  end

  def get
    @@content.gsub(/^\s*$\n/, "").tap do
      @@content = ""
    end
  end

  private

  def self.included(base)
    @@content = ""
    @@nest_level = 0
  end

  def indent
    '  ' * @@nest_level
  end

  def add_content(str)
    str.tap do |text|
      @@content += indent + text
    end
  end

  def value_to_str(value)
    if value.is_a?(Array)
      value.join(' ')
    else
      value.to_s
    end
  end

  def args_to_param(*args)
    if args.empty?
      ""
    else
      " " + args[0].inject("") do |base, kv|
        %(#{base} #{kv[0]}="#{value_to_str(kv[1])}")
      end[1..-1]
    end
  end

  def content_tag(name, *args, block)
    add_content "<#{name}#{args_to_param(*args)}>\n"
    @@nest_level += 1
    add_content "#{block.call}\n"
    @@nest_level -= 1
    add_content "</#{name}>\n"
    ""
  end

  def empty_tag(name, *args)
    add_content "<#{name}#{args_to_param(*args)} />\n"
  end

  def method_missing(method_name, *args, &block)
    if block_given?
      content_tag(method_name, *args, block)
    else
      empty_tag(method_name, *args)
    end
  end
end
