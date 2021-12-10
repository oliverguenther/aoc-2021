require 'set'

BRACES = '()[]{}<>'.split('').reverse.each_slice(2).to_h
OPENERS = BRACES.values.to_set
COST = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }

def parse(line)
  stack = line.each_with_object([]) { |el, stack|
    if OPENERS.include?(el)
      stack << el
    elsif BRACES[el] == stack.last
      stack.pop
    else
      return
    end
  }

  stack
    .reverse
    .reduce(0) { |sum, el| (sum * 5) + COST[el] }
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('') }
       .map(&method(:parse))
       .compact
       .then { |sums| sums.sort[sums.count / 2] }


