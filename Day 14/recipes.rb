start_time = Time.new

class Recipe
    attr_accessor :value, :prev, :next
  
    def initialize(value)
        @value = value
    end
  
    def remove
        @prev.next = @next if @prev
        @next.prev = @prev if @next
        @next = @prev = nil
    end
  
    def insert_after(node)
        @next = node.next
        @next.prev = self if @next
        @prev = node
        node.next = self
    end

    def move_elf()
        new_recipe = self
        for i in 0..@value do
            new_recipe = new_recipe.next
        end
        return new_recipe
    end

    def get_last_ten()
        recipe = self
        recipe_values = []
        for i in 0...10 do
            recipe_values << recipe.value
            recipe = recipe.prev
        end
        return recipe_values.reverse
    end

    def find_score(score)
        recipe = self
        sequence_intact = true
        for i in 0...score.length do
            if sequence_intact && recipe.value == score[i] then
                recipe = recipe.prev
            else
                sequence_intact = false
                break
            end
        end
        return sequence_intact
    end
end

elf_1_location = Recipe.new(3)
elf_2_location = Recipe.new(7)
elf_2_location.insert_after(elf_1_location)
elf_2_location.next = elf_1_location
elf_1_location.prev = elf_2_location

last_recipe = elf_2_location

number_of_recipes = 864801
score = number_of_recipes.to_s.chars.map(&:to_i).reverse
recipes_made = 2
sequence_found = false

while !sequence_found
    new_recipes = elf_1_location.value + elf_2_location.value
    new_recipes.to_s.chars.map(&:to_i).each do |value|
        Recipe.new(value).insert_after(last_recipe)
        recipes_made += 1
        last_recipe = last_recipe.next
        if recipes_made == number_of_recipes+10 then
            puts "Part 1:    #{last_recipe.get_last_ten.join}"
        end
        if last_recipe.find_score(score) then
            sequence_found = true
            break
        end
    end
    elf_1_location = elf_1_location.move_elf
    elf_2_location = elf_2_location.move_elf
end

puts "Part 2:    #{recipes_made-score.length}"


end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()