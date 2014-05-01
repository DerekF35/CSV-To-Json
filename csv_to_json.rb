#!/usr/bin/env ruby
require 'csv'
require 'json'

if ARGV.size != 2 && ARGV.size != 3
  puts "Invalid paramaters"
  exit
end
 

#STEP - loads files into array of hashes with first row being header  
CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

if(ARGV.size == 3)
   paramkey = true
  data = {}
else
  paramkey = false
  data = []
end
CSV.foreach(ARGV[0], :row_sep => :auto, :headers => true,  :converters => [:all], :encoding=> "UTF-8") do |row|
  new_hash = {}
  row.to_hash.each_pair do |k,v|
    new_hash.merge!({k.downcase => v.to_s}) 
  end
  if(paramkey)
     data[new_hash[ARGV[2].downcase]] = new_hash
  else
      data << new_hash
  end
end

File.open(ARGV[1], 'w') do |f|
  f.puts JSON.pretty_generate(data )
end
