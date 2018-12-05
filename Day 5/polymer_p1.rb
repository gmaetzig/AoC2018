start_time = Time.new

$alpha = ['A', 'B', 'C', 'D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']

def fully_react_polymer(input)
    input2 = input
    while true do
        input2 = input
        for letter in $alpha do
            regex1 = "[" + letter + "]{1}[" + letter.downcase() + "]{1}"
            regex2 = "[" + letter.downcase() + "]{1}[" + letter + "]{1}"
            input = input.gsub(/#{regex1}/, "")
            input = input.gsub(/#{regex2}/, "")
        end
        if input == input2 then
            break
        end
    end
    return input
end

input = File.read('input').strip()

input = fully_react_polymer(input)

puts input.length()

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()