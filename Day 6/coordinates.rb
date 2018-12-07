data = File.readlines("input")
$coordinates = []
for i in 0...data.length() do
    $coordinates[i] = data[i].strip().split(",")
end
$space = Array.new(1000) {Array.new(1000,0)}

def check_closest_coord(a, b, curr_x, curr_y)
    print "coord_vals = " , a, " ",b, "::", curr_x, " ", curr_y,"\n"
    if a == '.' || a.nil? then
        return b
    end
    if b == '.' || b.nil? then
        return a
    end
    coord_a = $coordinates[a]#.strip().split(",")
    coord_b = $coordinates[b]#.strip().split(",")
    dist_to_a = (coord_a[1].to_i()-curr_x).abs + (coord_a[0].to_i()-curr_y).abs
    dist_to_b = (coord_b[1].to_i()-curr_x).abs + (coord_b[0].to_i()-curr_y).abs
    if dist_to_a < dist_to_b then
        print "dist to a: ", dist_to_a, ":", a, "\n"
        return a
    elsif dist_to_a > dist_to_b then
        print "dist to a: ", dist_to_a, ":", a, "\n"
        print "dist to b: ", dist_to_b, ":", b, "\n"
        return b
    else
        print "even dist\n"
        return '.'
    end
end

# Measure distance between (curr_x, curr_y) and coordinates at a and b to get closest.
def check_closest_coord(a, curr_x, curr_y)
    coord_a = $coordinates[a]
    dist_to_a = (coord_a[1].to_i()-curr_x).abs + (coord_a[0].to_i()-curr_y).abs
    
    return dist_to_a
end

# Recurse over next cell at (x, y), comparing it to previous closest coordinate i
def recurse(i, x, y)
    if i.nil? then
        return
    end
    if (x<$min_x || x>$max_x) then
        return
    end
    if (y<$min_y || y>$max_y) then
        return
    end
    if $space[x].nil? then
        $space[x] = []
    end
    if $space[x][y].nil? then
        #print "setting: ", i, "&", x, y, "\n"
        $space[x][y] = i
    elsif $space[x][y] != i then
        min = 100000
        for k in 0...$coordinates.length() do
            print "checking: ", k, $space[x][y], "\n"
            closest = check_closest_coord(k, $space[x][y], x, y).to_i()
            if closest < min then
                min = closest
            elsif closest == min then
                min = '.'
                break
            end
        end
        $space[x][y] = min
        if $space[x][y] != i then
            recurse($space[x][y], x-1, y)
            recurse($space[x][y], x, y-1)
        end
    elsif $space[x][y] == i then
        return
    end
    print "current value=",$space[x][y],"\n"
    recurse($space[x][y], x+1, y)
    recurse($space[x][y], x, y+1)
end

def print_space()
    for i in 0...$space.length() do;
        if $space[i].nil? then
            $space[i] = []
        end
        for j in 0..$space[i].length() do
            unless $space[i][j].nil? then
                print $space[i][j].to_s(), " "
            else
                print "- "
            end
        end
        print "\n"
    end
end

sums = Array.new($coordinates.length, 0)
region = 0

# Calculate closest coordinate for each cell in the space
for i in 0...$space.length() do
    if $space[i].nil? then
        $space[i] = []
    end
    for j in 0...$space[i].length() do
        min_dist = 10000
        min = 0
        sum = 0
        for k in 0...$coordinates.length() do
            closest = check_closest_coord(k, i, j).to_i()
            sum += closest
            if closest < min_dist then
                min_dist = closest
                min = k
            elsif closest == min_dist then
                min = '.'
            end
        end
        if sum < 10000 then
            region += 1
        end
        $space[i][j] = min
        if min != '.' && !$space[i][j].nil? then
            sums[$space[i][j]] += 1
        end
    end
end

# remove any 'infinity' areas
for i in 0...$space.length() do
    if $space[i][0] != '.' then
        sums[$space[i][0]] = -1
    end
    if $space[0][i] != '.' then
        sums[$space[0][i]] = -1
    end
    if $space[i][$space.length()-1] != '.' then
        sums[$space[i][$space.length()-1]] = -1
    end
    if $space[$space.length()-1][i] != '.' then
        sums[$space[$space.length()-1][i]] = -1
    end
end

puts "Part 1: ", sums.sort().last()
puts "Part 2: ", region