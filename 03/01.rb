puts File
  .read('input')
  .each_line(chomp: true)
  .map { |l| l.split('') }
  .transpose
  .map { |col| col.count('0') > col.count('1') ? '1' : '0' }
  .then { |bits| bits.join.to_i(2) }
  .then { |gamma| [gamma, gamma ^ (1 << 12) - 1] }
  .reduce(:*)

