start_time = Time.new

class Tree
    def initialize(childs, metadatas)
        @num_childs = childs
        @num_metadatas = metadatas
        @metadata = []
        @children = []
    end

    def get_num_childs()
        return @num_childs
    end

    def get_num_metadatas()
        return @num_metadatas
    end

    def get_metadata()
        return @metadata
    end

    def add_child(child)
        @children.append(child)
    end

    def add_metadata(metadata)
        @metadata.append(metadata)
    end

    def get_children()
        return @children
    end
    
    def has_children()
        return @num_childs > 0
    end

    def has_metadata()
        return @num_metadatas > 0
    end
end

$input = File.read('input').split(" ")
$sum_of_metadatas = 0

def recurse()
    childs = $input[0].to_i
    metadatas = $input[1].to_i
    $input = $input.drop(2)
    new_node = Tree.new(childs, metadatas)
    if childs != 0 then
        for i in 0...childs do
            new_node.add_child(recurse())
        end
    end
    if metadatas != 0 then
        for i in 0...metadatas do
            new_node.add_metadata($input[0].to_i)
            $sum_of_metadatas += $input[0].to_i
            $input = $input.drop(1)
        end
    end
    return new_node
end

def recurse2(node)
    sum = 0
    if node.get_num_childs > 0 then
        childs = node.get_children
        node.get_metadata.each do |index|
            if index <= childs.length then
                sum += recurse2(childs[index-1])
            end
        end
    else
        node.get_metadata.each do |x| 
            sum += x
        end
    end
    return sum
end

node = recurse()
sum = recurse2(node)
puts $sum_of_metadatas
puts sum

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()
