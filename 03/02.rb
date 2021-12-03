def reduce(candidates, select:, column:)
  return candidates.first.join if candidates.count == 1

  candidates
    .map { |line| line[column] }
    .then { |col| col.count('0') <= col.count('1') ? select.to_s : (select ^ 1).to_s }
    .then { |marker| candidates.select { |l| l[column] == marker } }
    .then { |selected| reduce(selected, select: select, column: column + 1) }
end

puts File
  .read('input')
  .lines(chomp: true)
  .map { |l| l.split('') }
  .then { |candidates| [candidates] * 2 }
  .map.with_index { |candidates, index| reduce(candidates, select: index, column: 0).to_i(2) }
  .reduce(:*)
