start_time = Time.new

require 'date'

timetable = Array.new(4000) { Array.new(60) }
count = 0

input = File.readlines('input')
input.sort!
guard = 0
guards = []
sleep = 0
awake = 0
for event in input do
    event_data = event.match(/^\[([0-9 \:-]*)\]\s([\w\s#\d]*).*/)
    date_time = DateTime.strptime(event_data.captures[0], '%Y-%m-%d %H:%M')
    date = date_time.month.to_s() + "-" + date_time.day.to_s()
    if event_data.captures[1].include?("#") then
        guard_id = event_data.captures[1].match(/^Guard #([0-9]*).*$/)
        guard = guard_id.captures[0].to_i()
        guards << guard
    elsif event_data.captures[1].include?("sleep") then
        sleep = date_time.min
    elsif event_data.captures[1].include?("wake") then
        awake = date_time.min
        for j in sleep..awake-1 do
            timetable[guard][j].nil? ? timetable[guard][j] = 1 : timetable[guard][j] += 1
        end
    end
end 

# Part 1: Sleepiest Guard

guard_with_max = 0
max = 0
for i in guards.uniq! do
    max_sum = 0
    for j in 0..59 do
        unless timetable[i][j].nil? then
            max_sum += timetable[i][j]
        end
    end
    if max_sum > max then
        guard_with_max = i
        max = max_sum
    end
end

# Part 1: Sleepiest Minute
max_minute = 0
max = 0
for i in 0..59 do
    unless timetable[guard_with_max][i].to_i().nil? then
        if timetable[guard_with_max][i].to_i() > max then
            max = timetable[guard_with_max][i].to_i()
            max_minute = i
        end
    end
end

puts "Strategy 1: " + (guard_with_max * max_minute).to_s()

# Part 2: Overall Sleepiest Minute
max = 0
max_minute = 0
guard = 0
for i in guards do
    for j in 0..59 do
        unless timetable[i][j].to_i().nil? then
            if timetable[i][j].to_i() > max then
                max = timetable[i][j].to_i()
                guard = i
                max_minute = j
            end
        end
    end
end

puts "Strategy 2: " + (guard * max_minute).to_s()

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()