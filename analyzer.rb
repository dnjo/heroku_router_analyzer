#!/usr/bin/env ruby

require 'optparse'
require_relative 'router_parser'
require_relative 'event_analyzer'
require_relative 'output'

options = {
  min_request_count: 10,
  analyzing_mode: :ip
}
OptionParser.new do |opts|
  opts.on '-m', '--min-request-count m', Integer, 'Minimum number of requests to print' do |m|
    options[:min_request_count] = m
  end

  opts.on '-a', '--analyzing-mode a', [:ip, :path, :all], 'Analyzing mode (ip, path, all)' do |a|
    options[:analyzing_mode] = a.to_sym
  end
end.parse!

events = []
begin
  ARGF.each { |line| events << line }
rescue SystemExit, Interrupt
end

parsed_events = RouterParser.parse_events events
analyzed_events = EventAnalyzer.analyze parsed_events
Output.send options[:analyzing_mode], analyzed_events, options[:min_request_count]
