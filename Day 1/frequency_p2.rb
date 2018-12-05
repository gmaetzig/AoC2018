start_time = Time.new

freq = 0
freqs = Array[]
freqs << freq
freq_seen = false

until freq_seen do
    IO.foreach("input") do |item|
        op = item[0]
        val = item[1..-1]
        case op
        when '+'
            freq += val.to_i()
        when '-'
            freq -= val.to_i()
        end
        if freqs.include?(freq)
            freq_seen = true
            break
        else
            freqs << freq
        end
    end
end
puts freq

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()