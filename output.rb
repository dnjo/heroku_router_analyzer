module Output
  class << self
    def ip(events, min_request_count)
      events[:ip].each do |ip, ip_events|
        next if ip_events[:event_count] < min_request_count
        request_string = ip_events[:event_count] == 1 ? 'request' : 'requests'
        puts "#{ip} (#{ip_events[:event_count]} #{request_string}):"
        puts '  Request paths:'
        ip_events[:path].each do |path|
          puts "  #{path}"
        end
        puts
      end
    end

    def path(events, min_request_count)
      events[:path].each do |path, path_events|
        next if path_events[:event_count] < min_request_count
        request_string = path_events[:event_count] == 1 ? 'request' : 'requests'
        puts "#{path} (#{path_events[:event_count]} #{request_string}):"
        puts '  Request IPs:'
        path_events[:ip].each do |ip|
          puts "  #{ip}"
        end
        puts
      end
    end

    def all(events, min_request_count)
      ip events, min_request_count
      path events, min_request_count
    end
  end
end
