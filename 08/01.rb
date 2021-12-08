puts File
  .read('input')
  .each_line(chomp: true)
  .map { |l| l.split(' | ').last.split }
  .flatten
  .each_with_object(Hash.new(0)) { |value, hash| hash[value.length] += 1 }
  .slice(7,4,3,2)
  .values
  .sum


