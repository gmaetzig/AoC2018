start_time = Time.new

fabric = Array.new(1000) { Array.new(1000) }
sum = 0
overlap = Array[]
IO.foreach("input") do |claim|
    values = claim.match(/^#([0-9]*)\s@\s([0-9]*),([0-9]*)\:\s([0-9]*)x([0-9]*)/)
    overlap << values[1].to_i()
    for i in values[2].to_i()..(values[2].to_i() + values[4].to_i()-1) do
        for j in values[3].to_i()..(values[3].to_i() + values[5].to_i()-1) do
            if fabric[i][j].nil? then
                fabric[i][j] = values[1].to_i()
            elsif fabric[i][j].is_a? Numeric then
                overlap.delete(fabric[i][j])
                overlap.delete(values[1].to_i())
            else
                fabric[i][j] = "no"
            end
        end
    end
end

puts overlap

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()