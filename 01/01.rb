puts STDIN
       .each_line(chomp: true)
       .each_cons(2)
       .to_a
       .count { |a, b| b.to_i > a.to_i }
