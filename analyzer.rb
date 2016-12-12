#!/usr/bin/env ruby

require 'optparse'
require_relative 'router_parser'
require_relative 'event_analyzer'

options = {
  min_request_count: 10
}
OptionParser.new do |opts|
  opts.on '-m', '--min-request-count m', Integer, 'Minimum number of requests to print' do |m|
    options[:min_request_count] = m
  end
end.parse!

events = []
begin
  ARGF.each { |line| events << line }
rescue SystemExit, Interrupt
end

parsed_events = RouterParser.parse_events events
analyzed_events = EventAnalyzer.analyze parsed_events

analyzed_events[:ip].each do |ip, ip_events|
  next if ip_events[:event_count] < options[:min_request_count]
  request_string = ip_events[:event_count] == 1 ? 'request' : 'requests'
  puts "#{ip} (#{ip_events[:event_count]} #{request_string}):"
  puts "  Request paths:"
  ip_events[:path].each do |path|
    puts "  #{path}"
  end
  puts
end
