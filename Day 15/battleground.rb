start_time = Time.new


class Elf
    attr_accessor :hp, :ap, :pos_x, :pos_y, :name, :target_loc

    def initialize(x, y)
        @name = 'E'
        @pos_x = x
        @pos_y = y
        @hp = 200
        @ap = 4
        @target_loc = [0, 0]
    end
end

class Goblin
    attr_accessor :hp, :ap, :pos_x, :pos_y, :name, :target_loc

    def initialize(x, y)
        @name = 'G'
        @pos_x = x
        @pos_y = y
        @hp = 200
        @ap = 3
        @target_loc = [0, 0]
    end
end

class Wall
    attr_accessor :name

    def initialize()
        @name = '#'
        @wall = true
    end
end

class Battleground

    def initialize(elf_ap) 
        @battleground = []
        @elfs = []
        @gobs = []
        input = File.readlines('input')

        for i in 0...input.length do 
            @battleground[i] = []
            for j in 0...input[i].split("").length do 
                if input[i][j] == '#' then
                    @battleground[i][j] = Wall.new
                elsif input[i][j] == 'E' then
                    @elfs << Elf.new(j,i)
                    @elfs[-1].ap = elf_ap
                    @battleground[i][j] = @elfs[-1]
                elsif input[i][j] == 'G' then
                    @gobs << Goblin.new(j,i)
                    @battleground[i][j] = @gobs[-1]
                else
                    @battleground[i][j] = nil
                end
            end
        end
    end

    def get_num_elfs()
        return @elfs.length
    end

    def get_num_gobs()
        return @gobs.length
    end

    def goblin_attack(combatant)
        min_hp = 201
        elf = nil
        # Check for surrounding elfs. If so, ATTACK!!!!!!!!!!
        if @battleground[combatant.pos_y-1][combatant.pos_x].is_a? Elf
            in_range = true
            if @battleground[combatant.pos_y-1][combatant.pos_x].hp < min_hp then
                elf = @battleground[combatant.pos_y-1][combatant.pos_x]
                min_hp = elf.hp
            end
        end
        if @battleground[combatant.pos_y][combatant.pos_x-1].is_a? Elf
            in_range = true
            if @battleground[combatant.pos_y][combatant.pos_x-1].hp < min_hp then
                elf = @battleground[combatant.pos_y][combatant.pos_x-1]
                min_hp = elf.hp
            end
        end
        if @battleground[combatant.pos_y][combatant.pos_x+1].is_a? Elf
            in_range = true
            if @battleground[combatant.pos_y][combatant.pos_x+1].hp < min_hp then
                elf = @battleground[combatant.pos_y][combatant.pos_x+1]
                min_hp = elf.hp
            end
        end
        if @battleground[combatant.pos_y+1][combatant.pos_x].is_a? Elf
            in_range = true
            if @battleground[combatant.pos_y+1][combatant.pos_x].hp < min_hp then
                elf = @battleground[combatant.pos_y+1][combatant.pos_x]
                min_hp = elf.hp
            end
        end
        if elf != nil then
            #puts "goblin (#{combatant.pos_x}, #{combatant.pos_y}) is attacking elf at (#{elf.pos_x}, #{elf.pos_y})"
            elf.hp -= combatant.ap
            if elf.hp <= 0 then
                @elfs.delete(elf)
                @battleground[elf.pos_y][elf.pos_x]  = nil
            end
        end
        return in_range
    end

    def elf_attack(combatant)
        in_range = false
        min_hp = 201
        goblin = nil
        # Check for surrounding goblins. If so, ATTACK!!!!!!!!!!
        if @battleground[combatant.pos_y-1][combatant.pos_x].is_a? Goblin
            in_range = true
            if @battleground[combatant.pos_y-1][combatant.pos_x].hp < min_hp then
                goblin = @battleground[combatant.pos_y-1][combatant.pos_x]
                min_hp = goblin.hp
            end
        end
        if @battleground[combatant.pos_y][combatant.pos_x-1].is_a? Goblin
            in_range = true
            if @battleground[combatant.pos_y][combatant.pos_x-1].hp < min_hp then
                goblin = @battleground[combatant.pos_y][combatant.pos_x-1]
                min_hp = goblin.hp
            end
        end
        if @battleground[combatant.pos_y][combatant.pos_x+1].is_a? Goblin
            in_range = true
            if @battleground[combatant.pos_y][combatant.pos_x+1].hp < min_hp then
                goblin = @battleground[combatant.pos_y][combatant.pos_x+1]
                min_hp = goblin.hp
            end
        end
        if @battleground[combatant.pos_y+1][combatant.pos_x].is_a? Goblin
            in_range = true
            if @battleground[combatant.pos_y+1][combatant.pos_x].hp < min_hp then
                goblin = @battleground[combatant.pos_y+1][combatant.pos_x]
                min_hp = goblin.hp
            end
        end
        if goblin != nil then
            #puts "elf (#{combatant.pos_x}, #{combatant.pos_y}) is attacking goblin at (#{goblin.pos_x}, #{goblin.pos_y})"
            goblin.hp -= combatant.ap
            if goblin.hp <= 0 then
                @gobs.delete(goblin)
                @battleground[goblin.pos_y][goblin.pos_x]  = nil
            end
        end

        return in_range
    end

    def move(combatant)
        min_dist = 9999999
        in_range = false
        list_enemies = nil
        if combatant.is_a? Goblin then
            list_enemies = @elfs
            in_range = goblin_attack(combatant)
        elsif combatant.is_a? Elf then
            list_enemies = @gobs
            in_range = elf_attack(combatant)
        end
        if in_range != true then
            potential_spaces = []

            # Finding the closest cell(s) in range
            for i in 0...list_enemies.length do
                x = list_enemies[i].pos_x
                y = list_enemies[i].pos_y
                if @battleground[y-1][x].nil? then
                    dist = find_dist(combatant.pos_x, combatant.pos_y, x, y-1)
                    if dist <= min_dist && dist > 0 then
                        potential_spaces << [dist, x, y-1]
                        min_dist = dist
                    end
                end
                if @battleground[y][x-1].nil? then
                    dist = find_dist(combatant.pos_x, combatant.pos_y, x-1, y)
                    if dist <= min_dist && dist > 0 then
                        potential_spaces << [dist, x-1, y]
                        min_dist = dist
                    end
                end
                if @battleground[y][x+1].nil? then
                    dist = find_dist(combatant.pos_x, combatant.pos_y, x+1, y)
                    if dist <= min_dist && dist > 0 then
                        potential_spaces << [dist, x+1, y]
                        min_dist = dist
                    end
                end
                if @battleground[y+1][x].nil? then
                    dist = find_dist(combatant.pos_x, combatant.pos_y, x, y+1)
                    if dist <= min_dist && dist > 0 then
                        potential_spaces << [dist, x, y+1]
                        min_dist = dist
                    end
                end
                potential_spaces.sort! do |a, b|
                    if a[0] == b[0]
                        if a[2] == b[2]
                            a[1] <=> b[1]
                        else
                            a[2] <=> b[2]
                        end
                    else
                        a[0] <=> b[0]
                    end
                end
                if potential_spaces.length != 0 then
                    combatant.target_loc = [ potential_spaces[0][1], potential_spaces[0][2] ]
                end
            end
            #puts "combatant at (#{combatant.pos_x}, #{combatant.pos_y}) is heading to #{combatant.target_loc}, #{min_dist} places away"

            # Picking the best direction to move
            if min_dist > 0 && min_dist < 999999 then
                step_in_direction = find_dist(combatant.pos_x, combatant.pos_y-1, combatant.target_loc[0], combatant.target_loc[1])
                if step_in_direction < min_dist then
                    if @battleground[combatant.pos_y-1][combatant.pos_x].nil? then
                        #puts "moving #{combatant.name} up"
                        combatant.pos_y -= 1
                        @battleground[combatant.pos_y][combatant.pos_x] = combatant
                        @battleground[combatant.pos_y+1][combatant.pos_x] = nil
                        if step_in_direction == 0 && (combatant.is_a? Goblin) then
                            goblin_attack(combatant)
                        elsif step_in_direction == 0 && (combatant.is_a? Elf) then
                            elf_attack(combatant)
                        end
                        return
                    end
                end
                step_in_direction = find_dist(combatant.pos_x-1, combatant.pos_y, combatant.target_loc[0], combatant.target_loc[1])
                if step_in_direction < min_dist then
                    if @battleground[combatant.pos_y][combatant.pos_x-1].nil? then
                        #puts "moving #{combatant.name} left"
                        combatant.pos_x -= 1
                        @battleground[combatant.pos_y][combatant.pos_x] = combatant
                        @battleground[combatant.pos_y][combatant.pos_x+1] = nil
                        if step_in_direction == 0 && (combatant.is_a? Goblin) then
                            goblin_attack(combatant)
                        elsif step_in_direction == 0 && (combatant.is_a? Elf) then
                            elf_attack(combatant)
                        end
                        return
                    end
                end
                step_in_direction = find_dist(combatant.pos_x+1, combatant.pos_y, combatant.target_loc[0], combatant.target_loc[1])
                if step_in_direction < min_dist then
                    if @battleground[combatant.pos_y][combatant.pos_x+1].nil? then
                        #puts "moving #{combatant.name} right"
                        combatant.pos_x += 1
                        @battleground[combatant.pos_y][combatant.pos_x] = combatant
                        @battleground[combatant.pos_y][combatant.pos_x-1] = nil
                        if step_in_direction == 0 && (combatant.is_a? Goblin) then
                            goblin_attack(combatant)
                        elsif step_in_direction == 0 && (combatant.is_a? Elf) then
                            elf_attack(combatant)
                        end
                        return
                    end
                end
                step_in_direction = find_dist(combatant.pos_x, combatant.pos_y+1, combatant.target_loc[0], combatant.target_loc[1])
                if step_in_direction < min_dist then
                    if @battleground[combatant.pos_y+1][combatant.pos_x].nil? then
                        #puts "moving #{combatant.name} down"
                        combatant.pos_y += 1
                        @battleground[combatant.pos_y][combatant.pos_x] = combatant
                        @battleground[combatant.pos_y-1][combatant.pos_x] = nil
                        if step_in_direction == 0 && (combatant.is_a? Goblin) then
                            goblin_attack(combatant)
                        elsif step_in_direction == 0 && (combatant.is_a? Elf) then
                            elf_attack(combatant)
                        end
                        return
                    end
                end
            end
        end
    end

    def find_dist(curr_x, curr_y, free_space_x, free_space_y)
        min_dist = 999999
        #puts "Finding distance from (#{curr_x}, #{curr_y}) to (#{free_space_x}, #{free_space_y})"
        if @battleground[curr_y][curr_x].is_a? Wall then
            return min_dist
        end
        q = Queue.new
        seen_cells = []
        q << [curr_x, curr_y, 0]
        while !q.empty? do
            coord = q.pop
            if !seen_cells.include?([coord[0], coord[1]]) then
                seen_cells.append([coord[0], coord[1]])
            else
                next
            end
            if coord[0] == free_space_x && coord[1] == free_space_y then
                min_dist = coord[2]
                break
            end
            #puts "#{@battleground[coord[1]-1, coord[0]].name}"
            if @battleground[coord[1]-1][coord[0]] == nil && coord[1] - 1 >= 0
                q << [coord[0], coord[1]-1, coord[2]+1]
            end
            if @battleground[coord[1]][coord[0]-1] == nil && coord[0] - 1 >= 0
                q << [coord[0]-1, coord[1], coord[2]+1]
            end
            if @battleground[coord[1]][coord[0]+1] == nil && coord[0] + 1 < @battleground[coord[1]].length
                q << [coord[0]+1, coord[1], coord[2]+1]
            end
            if @battleground[coord[1]+1][coord[0]] == nil && coord[1] + 1 < @battleground.length
                q << [coord[0], coord[1]+1, coord[2]+1]
            end
        end
        #puts "Distance from (#{curr_x}, #{curr_y}) to (#{free_space_x}, #{free_space_y}) is #{min_dist}"
        return min_dist
    end

    def take_turn()
        q = Queue.new
        for i in 0...@battleground.length do
            for j in 0...@battleground[i].length do
                if @battleground[i][j].is_a? Wall then
                    next
                elsif @battleground[i][j].is_a? Elf then
                    q << @battleground[i][j]
                elsif @battleground[i][j].is_a? Goblin then
                    q << @battleground[i][j]
                else
                    #puts "nothing here"
                end
            end
        end
        while !q.empty? do
            thing = q.pop
            if (@elfs.length == 0 || @gobs.length == 0) then
                return false
            end
            if thing.hp <= 0 then
                next
            else
                move(thing)
            end
        end
        return true
    end

    def print_board()
        for i in 0...@battleground.length do
            soldiers = []
            for j in 0...@battleground[i].length do
                if @battleground[i][j] == nil then
                    print " "
                else
                    print @battleground[i][j].name
                    if @battleground[i][j].is_a? Goblin then
                        soldiers << "G (#{@battleground[i][j].hp})"
                    elsif @battleground[i][j].is_a? Elf then
                        soldiers << "E (#{@battleground[i][j].hp})"
                    end
                end
            end
            print "     "
            print soldiers
            print "\n"
        end
        print "\n"
    end

    def get_elves()
        total_hp = 0
        for i in 0...@elfs.length do
            #puts "Elf #{i} at (#{@elfs[i].pos_x}, #{@elfs[i].pos_y}) with #{@elfs[i].hp} HP remaining."
            total_hp += @elfs[i].hp
        end
        return total_hp
    end

    def get_gobs()
        total_hp = 0
        for i in 0...@gobs.length do
            #puts "Gob #{i} at (#{@gobs[i].pos_x}, #{@gobs[i].pos_y}) with #{@gobs[i].hp} HP remaining."
            total_hp += @gobs[i].hp
        end
        return total_hp
    end

end

game_won = false
elf_ap = 15
while game_won == false do
    BG = Battleground.new(elf_ap)
    #BG.print_board
    game_won = true

    total_elfs = BG.get_num_elfs
    num_rounds = 0
    answer = 0

    while BG.take_turn do
        num_rounds += 1
        puts "after turn #{num_rounds}, there are #{BG.get_num_elfs} elves. Elf AP = #{elf_ap}"
        if BG.get_num_elfs < total_elfs
            puts "Failed: An elf died."
            game_won = false
            elf_ap += 1
            break
        end
        #BG.print_board
    end
    if BG.get_num_elfs < total_elfs && game_won != false
        puts "Failed: the last elf died."
        game_won = false
        elf_ap += 1
    end
end

answer = num_rounds * (BG.get_elves + BG.get_gobs)

#BG.print_board
puts answer


end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()