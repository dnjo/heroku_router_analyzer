module RouterParser
  class << self
    def parse_events(events)
      events.each_with_object([]) do |event, parsed_events|
        parsed_event = parse_single_event event
        parsed_events << parsed_event if parsed_event
      end
    end

    private

    def parse_single_event(event)
      return nil unless valid_event? event
      values = get_event_values event
      ip = get_ip values
      path = values[:path]
      build_parsed_event ip, path
    end

    def get_event_values(event)
      event_parts = event.split ' '
      event_parts.each_with_object({}) do |part, values|
        key, value = part.split '='
        next unless value
        values[key.to_sym] = value.tr '"', ''
      end
    end

    def build_parsed_event(ip, path)
      {
        ip: ip,
        path: path
      }
    end

    def get_ip(event)
      ips = event[:fwd]
      ips.split(',')[0]
    end

    def valid_event?(event)
      /heroku\[router\]:/.match event
    end
  end
end
