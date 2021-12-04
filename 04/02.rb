def filled?(board)
  board.any? do |line|
    line.all? { |num| num.is_a?(Integer) }
  end
end

def fill(board, number)
  board.each_index do |i|
    board[i].each_index do |j|
      board[i][j] = board[i][j].to_i if board[i][j] == number
    end
  end
end

def bingo(numbers, boards)
  numbers.each do |number|
    last = nil
    boards.reject! do |board|
      last = board
      fill(board, number)
      [board, board.transpose].any?(&method(:filled?))
    end

    return [last, number] if boards.empty?
  end
end

def separate_boards(lines)
  [
    lines.shift.split(','),
    lines
      .map { |line| line.strip.split(/\s+/) }
      .each_slice(5)
      .to_a
  ]
end

puts File
       .read('input')
       .lines(chomp: true)
       .reject(&:empty?)
       .then(&method(:separate_boards))
       .then { |numbers, boards| bingo(numbers, boards) }
       .then { |winner, number|
         winner
           .flatten
           .reduce(0) { |sum, el| el.is_a?(Integer) ? sum : sum + el.to_i }
           .then { |sum| sum * number.to_i }
       }

