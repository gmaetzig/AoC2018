start_time = Time.new

boxes = IO.readlines("input")
num_boxes = boxes.length()

for i in 0..num_boxes-2 do 
    box1 = boxes[i]
    for j in (i+1)..num_boxes-1 do
        box2 = boxes[j]
        char_diff = 0
        for k in 0..(box1.length()) do
            if box1[k] != box2[k] then
                char_diff += 1
            end
            if char_diff > 1 then
                break
            end
        end
        if char_diff == 1 then
            output = ""
            for k in 0..box1.length() do
                if box1[k] == box2[k] then
                    output << box1[k].to_s()
                end
            end
            puts output
        end
    end
end

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()
