require 'pry'
OUTCOMES = [1,2,3].repeated_permutation(3).map(&:sum).tally

def play(universes, turn, wins)
  next_universes = Hash.new(0)

  universes.each do |(pos1, score1, pos2, score2), num_universes|
    OUTCOMES.each do |outcome, num_outcomes|
      curpos = turn == 0 ? pos1 : pos2
      curscore = turn == 0 ? score1 : score2
      pos = (curpos + outcome) % 10
      score = curscore + (pos == 0 ? 10 : pos)

      universe_count = num_outcomes * num_universes
      if score >= 21
        wins[turn] += universe_count
      else
        next_universes[[
          turn == 0 ? pos : pos1,
          turn == 0 ? score : score1,
          turn == 1 ? pos : pos2,
          turn == 1 ? score : score2
        ]] += universe_count
      end
    end
  end

  next_universes
end

puts File
       .read('input')
       .each_line(chomp: true)
       .map { |l| l.match(/Player \d+ starting position: (\d+)/) }
       .map { |match| match[1].to_i }
       .flatten
       .then { |(p1_pos, p2_pos)|
         universes = Hash.new(0)
         universes[[p1_pos, 0, p2_pos, 0]] = 1

         wins = [0, 0]

         until universes.empty? do
           universes = play(universes, 0, wins)
           universes = play(universes, 1, wins)
         end

         wins.max
       }
