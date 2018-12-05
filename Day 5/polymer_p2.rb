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

def remove_chars(file, letter)
    input = file
    input2 = input
    while true do
        input2 = input
        input = input.gsub(/#{letter}/, "")
        input = input.gsub(/#{letter.downcase()}/, "")
        if input == input2 then
            break
        end
    end
    return input
end

file = File.read('input').strip()
input_lengths = []
for i in 0..25 do
    input = remove_chars(file, $alpha[i])
    input = fully_react_polymer(input)
    input_lengths << input.length()
end

min = 1000000
for i in input_lengths do
    if i < min then
        min = i
    end
end

puts min

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()