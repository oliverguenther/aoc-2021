require 'set'

def derive(signal, output)
  s_1 = signal.detect { |val| val.length == 2 }.chars.to_set
  s_7 = signal.detect { |val| val.length == 3 }.chars.to_set
  s_4 = signal.detect { |val| val.length == 4 }.chars.to_set

  output.map do |val|
    s_val = val.chars.to_set

    case val.length
    when 2
      1
    when 3
      7
    when 4
      4
    when 7
      8
    when 5
      if (s_1 & s_val).length == 2
        3
      elsif (s_4 & s_val).length == 2
        2
      else
        5
      end
    when 6
      if (s_4 & s_val).length == 4
        9
      elsif (s_7 & s_val).length == 3
        0
      else
        6
      end
    end
  end
end

puts File
  .read('input')
  .each_line(chomp: true)
  .map { |l| l.split(' | ').map(&:split) }
  .map { |signal, output| derive(signal, output) }
  .reduce(0) { |sum, val| sum + val.join.to_i }


