#!/bin/env ruby

input = File.read('input.txt')
rules = File.readlines('rule.txt')

rules.each do |rule|
  value, key = rule.strip.split

  input.gsub!(value, "${#{key}}")
end

puts input
