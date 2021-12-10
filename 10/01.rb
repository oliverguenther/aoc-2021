require 'set'

BRACES = '()[]{}<>'.split('').reverse.each_slice(2).to_h
OPENERS = BRACES.values.to_set
COST = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }

def parse(line)
  line.each_with_object([]) { |el, stack|
    if OPENERS.include?(el)
      stack << el
    elsif BRACES[el] == stack.last
      stack.pop
    else
      return COST[el]
    end
  }

  0
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('') }
       .map(&method(:parse))
       .sum


