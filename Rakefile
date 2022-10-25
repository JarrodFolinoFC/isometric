require 'prettyprint'
require_relative 'lib/isometric'

desc 'doco'
task :citations do
  puts '### Implemented'
  count = 0
  ::Citation.encyclopedia.each do |key, value|
    if Citation.encyclopedia[key][:references].size > 0
      count = count + 1
      pp key
      pp Citation.encyclopedia[key][:references]
    end
  end

  puts
  puts "### Todo (#{::Citation.encyclopedia.size - count})"
  ::Citation.encyclopedia.each do |key, value|
    if Citation.encyclopedia[key][:references].size == 0
      pp key
    end
  end
end