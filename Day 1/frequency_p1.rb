start_time = Time.new

freq = 0

IO.foreach("input") do |val|
    op = val.slice!(0)
    case op
    when '+'
        freq += val.to_i()
    when '-'
        freq -= val.to_i()
    end
end

puts freq

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()