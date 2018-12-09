start_time = Time.new

class Node
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

  end

class MarbleGame
    def initialize()
        @current_marble = Node.new(0)
        @current_marble.next = @current_marble
        @current_marble.prev = @current_marble
    end

    def add_marble(marble_id)
        score = 0
        if marble_id % 23 == 0 then
            score = marble_id
            score += @current_marble.prev.prev.prev.prev.prev.prev.prev.value
            @current_marble.prev.prev.prev.prev.prev.prev.prev.remove
            @current_marble = @current_marble.prev.prev.prev.prev.prev.prev
        else
            node = Node.new(marble_id)
            node.insert_after(@current_marble.next)
            @current_marble = node
        end
        return score
    end

    def print()
        @current_marble.print_node
    end
end

num_players = 470
num_marbles = 72170*100

players = Array.new(num_players, 0)

game = MarbleGame.new

iter = 1
while iter <= num_marbles do
    for i in 0...num_players do
        players[i] += game.add_marble(iter)
        iter += 1
    end
end

puts players.max

end_time = Time.new
puts "Total Execution Time : " + (end_time-start_time).inspect()