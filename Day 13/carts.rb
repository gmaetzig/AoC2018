start_time = Time.new

class Cart 
    attr_accessor :direction, :pos_x, :pos_y, :id

    def initialize(y, x, dir)
        @id = [x, y].join
        @pos_x = x
        @pos_y = y
        @direction = dir
        @last_turn = "RIGHT"
        @inactive = false
    end

    def mark_inactive()
        @inactive = true
    end

    def is_inactive()
        return @inactive
    end

    def change_direction()
        if @last_turn == "RIGHT" then
            turn_left
            @last_turn = "LEFT"
        elsif @last_turn == "LEFT" then
            @last_turn = "STRAIGHT"
        elsif @last_turn == "STRAIGHT" then
            turn_right
            @last_turn = "RIGHT"
        end
    end

    def turn_left()
        if @direction == 'v' then
            @direction = '>'
        elsif @direction == '>' then
            @direction = '^'
        elsif @direction == '^' then
            @direction = '<'
        elsif @direction == '<'
            @direction = 'v'
        else 
            puts "#{@direction} is not valid to turn left"
        end
    end

    def turn_right()
        if @direction == 'v' then
            @direction = '<'
        elsif @direction == '<' then
            @direction = '^'
        elsif @direction == '^' then
            @direction = '>'
        elsif @direction == '>' then
            @direction = 'v'
        else 
            puts "#{@direction} is not valid to turn right"
        end
    end

    def move(track)
        if track == '+' then
            change_direction
        elsif track == '\\' then
            if @direction == '>' || @direction == '<' then
                turn_right
            else
                turn_left
            end
        elsif track == '/' then
            if @direction == '^' || @direction == 'v' then
                turn_right
            else
                turn_left
            end
        else
            if track == '|' && (@direction != '^' && @direction != 'v') then
                puts "Track is #{track}. Shouldn't be going this way... #{@direction}"
            end
            if track == '-' && (@direction != '>' && @direction != '<') then
                puts "Track is #{track}. Shouldn't be going this way... #{@direction}"
            end
        end
        if @direction == '^' then
            @pos_y -= 1
        elsif @direction == '>' then
            @pos_x += 1
        elsif @direction == 'v' then
            @pos_y += 1
        elsif @direction == '<' then
            @pos_x -= 1
        else 
            puts "#{@direction} is not valid direction to move"
        end
    end

    def check_collisions_with(other_cart)
        if @pos_x == other_cart.pos_x && @pos_y == other_cart.pos_y && @id != other_cart.id then
            return true
        else
            return false
        end
    end
end


the_grid = []       # A Digital Frontier...
carts = []

input = File.readlines('input')
active_carts = 
for line in 0...input.length do
    the_grid.append(input[line].split(""))
    for loc in 0...the_grid[line].length do
        if the_grid[line][loc] == 'v' then
            carts.append(Cart.new(line, loc, 'v'))
            the_grid[line][loc] = '|'
        end
        if the_grid[line][loc] == '^' then
            carts.append(Cart.new(line, loc, '^'))
            the_grid[line][loc] = '|'
        end
        if the_grid[line][loc] == '<' then
            carts.append(Cart.new(line, loc, '<'))
            the_grid[line][loc] = '-'
        end
        if the_grid[line][loc] == '>' then
            carts.append(Cart.new(line, loc, '>'))
            the_grid[line][loc] = '-'
        end
    end
end
active_carts = carts.length

while true do
    for i in 0...carts.length do
        if !carts[i].is_inactive
            #puts "cart #{carts[i].id} at #{carts[i].pos_x},#{carts[i].pos_y}, heading #{carts[i].direction}."
            carts[i].move(the_grid[carts[i].pos_y][carts[i].pos_x])
            for j in 0...carts.length do
                if !carts[j].is_inactive
                    if carts[i].check_collisions_with(carts[j]) == true then
                        #puts "other cart at #{cart2.pos_x},#{cart2.pos_y}, heading #{cart2.direction}"
                        puts "Collision with carts #{carts[i].id} and #{carts[j].id} at: #{carts[i].pos_x},#{carts[i].pos_y}"
                        carts[i].mark_inactive
                        carts[j].mark_inactive
                        active_carts -= 2
                        break
                    end
                end
            end
        end
    end
    carts.sort! do |a, b| 
        if a.pos_y > b.pos_y then
            1
        elsif a.pos_y == b.pos_y then
            if a.pos_x > b.pos_x then 
                1
            elsif a.pos_x == b.pos_x then
                0
            else
                -1
            end
        else
            -1
        end
    end
    if active_carts == 1
        for i in 0...carts.length do
            if !carts[i].is_inactive
                puts "Last cart is #{carts[i].id} at #{carts[i].pos_x},#{carts[i].pos_y}, heading #{carts[i].direction}"
            end
        end
        return
    end
end


end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()