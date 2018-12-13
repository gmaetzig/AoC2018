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


grid = Array.new(300) { Array.new(300)}
array_sum = 0
for x in 0...300 do
    for y in 0...300 do
        grid[x][y] = calculate_cell(x, y)
        array_sum += grid[x][y]
        #print grid[x][y], "\t"
    end
    #print "\n"
end
#puts array_sum

max_power = 0
max_coords = [0,0]
max_size = 0
for x in 0...300 do
    for y in 0...300 do
        for d in 0...(300-([x,y].max)) do
            power = 0
            for i in x...x+d do
                for j in y...y+d do
                    power += grid[i][j] 
                end
            end
            #puts d, (300-([x,y].max))
            if power > max_power then
                max_power = power
                max_coords = [x,y]
                max_size = d
            end
        end
    end
    puts "x= #{x}"
end

puts "#{max_power}"
puts "#{max_coords}"
puts "#{max_size}"

# min_col_idx = 0
# max_col_idx = 29
# min_row_idx = 0
# max_row_idx = 29
# min_col_sum = 0
# max_col_sum = 0
# min_row_sum = 0
# max_row_sum = 0
# new_array_sum = array_sum + 1
#puts new_array_sum
# while min_col_idx < max_col_idx do
#     min_col_sum = 0
#     max_col_sum = 0
#     min_row_sum = 0
#     max_row_sum = 0
#     array_sum = new_array_sum
#     for i in min_col_idx..max_col_idx do
#         min_row_sum += grid[min_row_idx][i]
#         #puts max_row_idx
#         max_row_sum += grid[max_row_idx][i]
#     end
#     #puts "rows: #{min_row_sum}, #{max_row_sum}"
#     if min_row_sum > max_row_sum then
#         max_row_idx -= 1
#         new_array_sum -= max_row_sum
#         #puts "max row rm #{new_array_sum}"
#     else
#         min_row_idx += 1
#         new_array_sum -= min_row_sum
#         #puts "min row rm #{new_array_sum}"
#     end

#     for i in min_row_idx..max_row_idx do
#         min_col_sum += grid[i][min_col_idx]
#         max_col_sum += grid[i][max_col_idx]
#     end
#     if min_col_sum > max_col_sum then
#         max_col_idx -= 1
#         new_array_sum -= max_col_sum
#         if min_row_sum > max_row_sum then
#             new_array_sum += grid[max_row_idx][max_col_idx]
#         else
#             new_array_sum += grid[min_row_idx][max_col_idx]
#         end
#         #puts "max col rm #{new_array_sum}"
#     else
#         min_col_idx += 1
#         new_array_sum -= min_col_sum
#         if min_row_sum > max_row_sum then
#             new_array_sum += grid[max_row_idx][min_col_idx]
#         else
#             new_array_sum += grid[min_row_idx][min_col_idx]
#         end
#         #puts "min col rm #{new_array_sum}"
#     end
#     #puts "cols: #{min_col_sum}, #{max_col_sum}"
#     #puts "#{min_col_idx}, #{max_col_idx}, #{min_row_idx}, #{max_row_idx}"
#     #puts new_array_sum
# end

# puts "#{min_col_idx}, #{max_col_idx}, #{min_row_idx}, #{max_row_idx}"

#puts array_sum




end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()