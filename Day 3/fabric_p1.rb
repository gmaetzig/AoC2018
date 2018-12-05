start_time = Time.new

fabric = Array.new(1000) { Array.new(1000) }
sum = 0

IO.foreach("input") do |claim|
    values = claim.match(/^#([0-9]*)\s@\s([0-9]*),([0-9]*)\:\s([0-9]*)x([0-9]*)/)
    for i in values[2].to_i()..(values[2].to_i() + values[4].to_i()-1) do
        for j in values[3].to_i()..(values[3].to_i() + values[5].to_i()-1) do
            fabric[i][j] = fabric[i][j] == nil ? fabric[i][j] = 1 : fabric[i][j] += 1
        end
    end
end
for i in 0..fabric.length()-1 do
    for j in 0..fabric.length()-1 do
        unless fabric[i][j].nil? || fabric[i][j] <= 1 then
            sum += 1
        end
    end
end

puts sum

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()
