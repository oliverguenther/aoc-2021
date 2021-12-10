require 'pry'

def detect_lows(hm)
  lows = []
  cols = hm[0].count
  rows = hm.count

  hm.each_index do |i|
    hm[i].each_index do |j|
      min = [
        (hm[i - 1][j] if i > 0),
        (hm[i + 1][j] if i < rows - 1),
        (hm[i][j - 1] if j > 0),
        (hm[i][j + 1] if j < cols - 1),
      ].compact.min

      el = hm[i][j]
      lows << el if el < min
    end
  end

  lows
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.split('').map(&:to_i) }
       .then(&method(:detect_lows))
       .flatten
       .reduce(0) { |sum, el| sum + (el + 1)}


