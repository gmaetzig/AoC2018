
class Register
    attr_accessor :registers

    def initialize(registers)
        @registers = registers
        @ops = Hash.new
    end

    def populate_ops(op, val)
        @ops.store(op, val)
    end

    def get_op(op_code)
        return @ops[op_code]
    end

    def addr(a, b, c)
        @registers[c] = @registers[a] + @registers[b]
    end

    def addi(a, b, c)
        @registers[c] = @registers[a] + b
    end

    def mulr(a, b, c)
        @registers[c] = @registers[a] * @registers[b]
    end

    def muli(a, b, c)
        @registers[c] = @registers[a] * b
    end

    def banr(a, b, c)
        @registers[c] = @registers[a] & @registers[b]
    end

    def bani(a, b, c)
        @registers[c] = @registers[a] & b
    end

    def borr(a, b, c)
        @registers[c] = @registers[a] | @registers[b]
    end

    def bori(a, b, c)
        @registers[c] = @registers[a] | b
    end

    def setr(a, b, c)
        @registers[c] = @registers[a]
    end

    def seti(a, b, c)
        @registers[c] = a
    end

    def gtir(a, b, c)
        @registers[c] = a > @registers[b] ? 1 : 0
    end

    def gtri(a, b, c)
        @registers[c] = @registers[a] > b ? 1 : 0
    end

    def gtrr(a, b, c)
        @registers[c] = @registers[a] > @registers[b] ? 1 : 0
    end

    def eqir(a, b, c)
        @registers[c] = a == @registers[b] ? 1 : 0
    end

    def eqri(a, b, c)
        @registers[c] = @registers[a] == b ? 1 : 0
    end

    def eqrr(a, b, c)
        @registers[c] = @registers[a] == @registers[b] ? 1 : 0
    end
end

input = File.readlines("input1")
possible_ops = ["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"]
potentials = []
num_ops = 0
i = 0
while i < input.length do
    if input[i].length > 2 then
        before = input[i].slice(9,10).split(", ").map(&:to_i)
        i += 1
        change = input[i].split(" ").map(&:to_i)
        i += 1
        after = input[i].slice(9, 10).split(", ").map(&:to_i)
        potentials[i] = []
        potentials[i][0] = change[0]
        possible_ops.each do |op|
            r1 = Register.new(before.map(&:clone))
            r1.send(op, change[1], change[2], change[3])
            if r1.registers == after then
                potentials[i] << op
            end
        end

        if potentials[i].length >= 4 then
            num_ops += 1
        end
    end
    i += 1
end

puts "Part 1: #{num_ops}"


sorted_ops = []
final_reg = Register.new(Array.new(10, 0))

while sorted_ops.length < 16 do
    potentials.each do |list|
        if list != nil then
            if list.length == 2 then
                final_reg.populate_ops(list[0], list[1])
                sorted_ops << list[1]
                potentials.delete(list)
            else
                list.each do |op|
                    if sorted_ops.include?(op) then
                        list.delete(op)
                    end
                end
            end
        end
    end
end

program_input = File.readlines("input2")
program_input.each do |op|
    operation = op.split(" ").map(&:to_i)
    final_reg.send(final_reg.get_op(operation[0]), operation[1], operation[2], operation[3])
end

puts "Part 2: #{final_reg.registers[0]}"

