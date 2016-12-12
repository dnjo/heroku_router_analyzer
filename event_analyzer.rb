module EventAnalyzer
  class << self
    def analyze(events)
      analyzed_events = analyze_events events
      sort_events_by_count analyzed_events
    end

    private

    def analyze_events(events)
      events.each_with_object({}) do |event, analyzed_events|
        add_primary_keys event, analyzed_events
      end
    end

    def add_primary_keys(event, analyzed_events)
      event.keys.each do |primary_key|
        analyzed_events[primary_key] ||= {}
        primary_value_name = event[primary_key]
        primary_value = analyzed_events[primary_key][primary_value_name] ||= {}
        add_sub_keys event, primary_key, primary_value
      end
    end

    def add_sub_keys(event, primary_key, primary_value)
      event.keys.each do |sub_key|
        next if sub_key == primary_key
        primary_value[:event_count] ||= 0
        primary_value[:event_count] += 1
        primary_value[sub_key] ||= []
        primary_value[sub_key].push event[sub_key]
      end
    end

    def sort_events_by_count(events)
      events.each do |primary_key, primary_value|
        events[primary_key] = primary_value.sort_by do |_key, value|
          value[:event_count] * -1
        end
      end
      events
    end
  end
end
