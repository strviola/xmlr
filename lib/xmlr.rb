require "xmlr/version"
require 'pry'

module XMLR

  def doctype
    add_content "<!DOCTYPE HTML>\n"
  end

  def reset
    @@content = ""
  end

  def get
    @@content
  end

  private

  def add_content(str)
    str.tap do |text|
      @@content += text
    end
  end

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

  def content_tag_without_args(name, block)
    add_content "<#{name}>\n"
    add_content "  #{block.call}\n"
    add_content "</#{name}>\n"
  end

  def content_tag_with_args(name, args, block)
    add_content "<#{name} #{args_to_param(args[0])}>\n"
    add_content "  #{block.call}\n"
    add_content "</#{name}>\n"
  end

  def empty_tag_without_args(name)
    add_content "<#{name} />\n"
  end

  def empty_tag_with_args(name, args)
    add_content "<#{name} #{args_to_param(args)} />\n"
  end

  def method_missing(method_name, *args, &block)
    if block_given?
      if args.empty?
        content_tag_without_args(method_name, block)
      else
        content_tag_with_args(method_name, args, block)
      end
    else
      if args.empty?
        empty_tag_without_args(method_name)
      else
        empty_tag_with_args(method_name, *args)
      end
    end
  end
end
