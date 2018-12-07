start_time = Time.new

class Instruction
    def initialize(id)
        @id = id
        @time = id.getbyte(0)-4
        @parents = []
        @children = []
    end

    def get_id()
        return @id
    end

    def get_time()
        return @time
    end

    def add_parent(parent)
        @parents.append(parent)
    end

    def get_parents()
        return @parents
    end

    def add_child(child)
        @children.append(child)
    end

    def get_children()
        return @children
    end
    
    def has_children()
        return @children != []
    end

    def has_parents()
        return @parents != []
    end
end

class Worker
    def initialize()
        @queue = []
        @is_available = true
        @minimum_next = 0

    end

    def is_available(global_max)
        return @queue.length() <= global_max
    end

    def add_to_queue(item, start_time, end_time)
        for i in start_time...(start_time + end_time) do
            @queue[i] = item
        end
    end

    def output()
        return @queue.length()
    end

    def includes(parent)
        return @queue.include?(parent)
    end

    def lookup_index(p)
        return @queue.rindex(p)
    end
end

class Workers
    def initialize()
        @worker_threads = Array.new(5) { Worker.new }
        @current_min = 0
        @leftovers = []
    end

    def find_available_worker(child, parents)
        last_index = 0
        if parents == [] then
            last_index = 0
        else
            for p in parents do
                for i in 0...@worker_threads.length() do 
                    if @worker_threads[i].includes(p) then
                        if @worker_threads[i].lookup_index(p)+1 > last_index then
                            last_index = @worker_threads[i].lookup_index(p)+1
                        end
                    end
                end
            end
        end
        for i in 0...@worker_threads.length() do
            if @worker_threads[i].is_available(last_index)
                return i, last_index
            end
        end
        return -1, last_index
    end
    
    def add_items(available_children, ordered_instructions)
        if @leftovers != [] then
            available_children += @leftovers
        end
        available_children.each() do |child|
            parents = ordered_instructions[child].get_parents()
            i = find_available_worker(child, parents)
            unless i[0] == -1 then
                if @leftovers.include?(child)
                    @leftovers.delete(child)
                end
                @worker_threads[i[0]].add_to_queue(ordered_instructions[child].get_id(), i[1], ordered_instructions[child].get_time())
            else 
                @leftovers << child
            end
        end
    end

    def print_output()
        output = []
        @worker_threads.each() do |worker|
            output << worker.output()
        end
        puts output.max
    end

    def get_leftovers()
        return @leftovers
    end
end

# Initialize
instructions = File.readlines('input')
ordered_instructions = Hash.new
instructions.each() do |instruction|
    nodes = instruction.match(/Step ([A-Z]{1}) must.*step ([A-Z]{1}) can.*/)
    unless ordered_instructions.key?(nodes[1]) then
        ordered_instructions[nodes[1]] = Instruction.new(nodes[1])
    end
    unless ordered_instructions.key?(nodes[2]) then
        ordered_instructions[nodes[2]] = Instruction.new(nodes[2])
    end
    ordered_instructions[nodes[1]].add_child(ordered_instructions[nodes[2]].get_id())
    ordered_instructions[nodes[2]].add_parent(ordered_instructions[nodes[1]].get_id())
end

heads = []
ordered_instructions.each() do |key, value|
    unless value.has_parents() then
        heads << key
    end
end

out_string = ""
available_children = heads
available_children.sort!
success = true
workers = Workers.new

# Part 1 loop
while available_children != [] do
    x = available_children[0]
    if ordered_instructions[x].has_parents() then
        #puts "parents of #{x} are: #{ordered_instructions[x].get_parents()}"
        for j in 0...ordered_instructions[x].get_parents().length() do
            z = ordered_instructions[x].get_parents()[j]
            if !out_string.include?(z) then
                available_children.delete(x)
                success = false
            end
        end
        if !success then
            success = true
            redo
        end
    end
    #workers.add_item(ordered_instructions[x])
    out_string << x
    #puts "children of #{x} are: #{ordered_instructions[x].get_children()}"
    available_children += ordered_instructions[x].get_children()
    available_children.delete(x)
    available_children.sort!.uniq!
    #puts "#{available_children}"
end

# Part 2

available_children = heads
string2 = ""
while available_children != [] do
    #puts "available children: #{available_children}"
    success = true
    a = 0
    while a < available_children.length() do
        x = available_children[a]
        #puts "#{x}, #{a}, #{available_children}"
        if ordered_instructions[x].has_parents() then
            #puts "parents of #{x} are: #{ordered_instructions[x].get_parents()}"
            for j in 0...ordered_instructions[x].get_parents().length() do
                z = ordered_instructions[x].get_parents()[j]
                if !string2.include?(z) then
                    available_children.delete(x)
                    success = false
                end
            end
            if !success then
                success = true
                a -= 1
            end
        end
        a += 1
    end
    available_children.each() { |c| string2 << c }
    #puts "adding: #{available_children}"
    workers.add_items(available_children, ordered_instructions)

    new_children = []
    available_children.each() do |child|
        new_children += ordered_instructions[child].get_children()
        #puts "children of #{child} are: #{ordered_instructions[child].get_children()}"
    end
    available_children = new_children
    available_children.sort!.uniq!
end

puts out_string

workers.print_output()

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()