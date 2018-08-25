#!/usr/bin/env ruby

require 'icalendar'
require 'date'

calendar = Icalendar::Calendar.new

File.open('data.txt', 'r') do |file|
  until (line = file.gets).nil?
    next unless line.start_with? 'Video Lecture' or 
                line.start_with? 'Lesson' or 
                line.start_with? 'Quiz'
    title_str = line.chomp
    date_str = file.gets.chomp.sub(/Conditional Assignment Due: /, '').sub(/Due: /, '')
    next if date_str.nil? or date_str.empty?
    begin
      due_date = DateTime.parse(date_str)
    rescue
      puts "Error on: #{title_str} with date '#{date_str}'"
      next
    end
    calendar.event do |event|
      event.summary = title_str
      event.dtstart = due_date
      event.dtend = due_date
    end
  end
end

File.write('calendar.ical', calendar.to_ical)


