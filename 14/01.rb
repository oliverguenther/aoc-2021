require 'pry'

def step(template, mapping)
  inserted = 0

  template
    .each_cons(2)
    .to_a
    .each_with_index do |(a, b), i|
    insert = mapping[[a, b]]
    next unless insert

    pos = i + 1 + inserted
    inserted += 1

    template.insert(pos, insert)
  end
end

puts File
       .read('input')
       .split("\n\n")
       .then { |template_str, mapping|
         template = template_str.split('')
         lookup = mapping
           .each_line(chomp: true)
           .map { |el| el.split(' -> ') }
           .each_with_object({}) { |(from, to), hash|
             hash[from.chars] = to
           }

         10.times { step(template, lookup) }

         tally = template.tally
         min = tally.min_by { |k, v| v }.last
         max = tally.max_by { |k, v| v }.last

         max - min
       }
