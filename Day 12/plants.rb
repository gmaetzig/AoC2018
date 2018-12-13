start_time = Time.new

input = File.readlines('input')
initial_state = input[0].strip.split("")

old_map = Hash.new
new_map = Hash.new

for i in 0...initial_state.length do
    old_map[i] = initial_state[i]
end

old_map[i+1] = "."
old_map[i+2] = "."
old_map[i+3] = "."

instructions = []
for i in 0...input.length-2 do
    instructions[i] = input[i+2].split("")
end

#generations = 20                    # Part 1
generations = 50000000000           # Part 2

new_map = old_map.clone
old_sum = 0

for i in 1..generations do
    sum = 0
    plants = 0
    for key in old_map.keys do
        new_map[key] = "."
        if new_map[key+1] == nil then
            new_map[key+1] = "."
        end
        if new_map[key+2] == nil then
            new_map[key+2] = "."
        end
        if new_map[key-1] == nil then
            new_map[key-1] = "."
        end
        if new_map[key-2] == nil then
            new_map[key-2] = "."
        end
        instructions.each do |instruction|
            if old_map[key] == instruction[2] then
                l2_truth = true if (old_map[key-2] == nil && instruction[0] == ".") || (old_map[key-2] == instruction[0])
                l1_truth = true if (old_map[key-1] == nil && instruction[1] == ".") || (old_map[key-1] == instruction[1])
                r1_truth = true if (old_map[key+1] == nil && instruction[3] == ".") || (old_map[key+1] == instruction[3])
                r2_truth = true if (old_map[key+2] == nil && instruction[4] == ".") || (old_map[key+2] == instruction[4])
                if l2_truth && l1_truth && r1_truth && r2_truth then
                    new_map[key] = instruction[5]
                    break
                end
            end
        end
        if new_map[key] == "#" then
            sum += key
            plants += 1
        end
        #print new_map[key]
    end
    #print "\n"
    
    if sum == old_sum + plants then
        break
    else
        old_sum = sum
    end
    
    old_map = new_map.clone
end
puts "got to loop# #{i}. There are #{plants} plants"
puts sum + (plants * (generations-i))


end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()