#!/usr/bin/env ruby

#libs = %w|exec_application google_crawler|
#libs.each { |lib| require File.join( File.dirname( File.expand_path(__FILE__) ), "/lib/#{lib}" ) }
#

if RUBY_VERSION != '1.8.7'
  puts 'This script includes a class that needs ruby 1.8.7' 
  exit(state=false) 
end

require File.join( File.dirname(File.expand_path(__FILE__)), '/lib/google_crawler' )

crawled_data = []

ARGV.each do |args| 
  crawled_data.push( GoogleCrawler.new(args) )
end

crawled_data.each do |keyword_data|
  puts keyword_data.data
end
