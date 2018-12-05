start_time = Time.new

twos = false
threes = false
two_sum = 0
three_sum = 0

IO.foreach("input") do |box_id|
    box_id.split("").each do |chr|
        char_count = box_id.count(chr)
        case char_count
        when 2
            twos = true
            box_id.delete!(chr)
        when 3
            threes = true
            box_id.delete!(chr)
        end
    end

    if twos
        two_sum += 1
        twos = false
    end
    if threes
        three_sum += 1
        threes = false
    end
end
puts two_sum * three_sum

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()