start_time = Time.new

def pad(num)
    for i in 0...num-1 do
        print " "
    end
end

def print_points(points, min_col)
    points = points.sort! do |a,b|
        comp = (a[1] <=> b[1])
        comp.zero? ? (a[0] <=> b[0]) : comp
    end
    curr_row = points[0][1]
    prev_col = min_col
    for i in 0...points.length do
        if points[i][1] != curr_row then
            print "\n"
            curr_row = points[i][1]
            prev_col = min_col
        end
        if points[i][0] != prev_col then
            pad(points[i][0] - prev_col)
            prev_col = points[i][0]
        end
        print "x"
    end
    print "\n\n"
end

points = []
velocities = []

IO.foreach("input") do |line|
    values = line.match(/position=<([0-9 ,-]*)> velocity=<([0-9 ,-]*)>/)
    points.append(values[1].strip.split(",").map(&:to_i))
    velocities.append(values[2].strip.split(",").map(&:to_i))
end

min_rows = 100000000
min_cols = 100000000
number_of_seconds = 0
while true do
    min_col = 10000000
    max_col = -10000000
    min_row = 10000000
    max_row = -10000000
    for j in 0...points.length do
        points[j][0] += velocities[j][0]
        points[j][1] += velocities[j][1]
        min_col = [points[j][0], min_col].min
        max_col = [points[j][0], max_col].max
        min_row = [points[j][1], min_row].min
        max_row = [points[j][1], max_row].max
    end
    number_of_seconds += 1
    loop_min_rows = max_row - min_row
    loop_min_cols = max_col - min_col
    if loop_min_rows >= min_rows && loop_min_cols >= min_cols then
        # rewind one step, we've overshot.
        for j in 0...points.length do
            points[j][0] -= velocities[j][0]
            points[j][1] -= velocities[j][1]
        end
        number_of_seconds -= 1
        # and break.
        break
    else
        min_rows = loop_min_rows
        min_cols = loop_min_cols
    end
end

print_points(points.uniq!, min_col)

puts number_of_seconds

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()
