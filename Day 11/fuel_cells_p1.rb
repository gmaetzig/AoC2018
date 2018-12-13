start_time = Time.new

$grid_serial_no = 7139
$global_grid_max_power = 0
$global_grid_max_coord = [0,0]

def calculate_cell(x, y)
    rack_id = x + 10
    power_level = rack_id * y
    power_level += $grid_serial_no
    power_level *= rack_id
    if power_level > 99 then
        power_level = power_level.digits[2]
    else
        power_level = 0
    end
    power_level -= 5
    return power_level
end

def calculate_3x3(x, y)
    grid_power = 0
    grid_power += calculate_cell(x-1, y-1)
    grid_power += calculate_cell(x,   y-1)
    grid_power += calculate_cell(x+1, y-1)
    grid_power += calculate_cell(x-1, y)
    grid_power += calculate_cell(x,   y)
    grid_power += calculate_cell(x+1, y)
    grid_power += calculate_cell(x-1, y+1)
    grid_power += calculate_cell(x,   y+1)
    grid_power += calculate_cell(x+1, y+1)
    return grid_power
end

max_power = 0
max_power_coord = [0, 0]

for x in 1...299 do
    for y in 1...299 do
        power = calculate_3x3(x, y)
        if power > max_power then
            max_power = power
            max_power_coord = [x-1, y-1]
        end
    end
end

puts "#{max_power_coord}"
puts "#{max_power}"

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()