class SnailNumber
  attr_reader :value
  alias :magnitude :value

  def initialize(val)
    @value = val
  end

  def +(other)
    @value += other
  end

  def split?
    return if value < 10

    split_val = value / 2
    Pair.new(split_val, value - split_val)
  end

  def add_left(val)
    @value += val
  end

  alias_method :add_right, :add_left

end

class Pair
  attr_reader :left, :right

  def initialize(left, right)
    @left = instantiate(left)
    @right = instantiate(right)
  end

  def magnitude
    (left.magnitude * 3) + (right.magnitude * 2)
  end

  def +(other)
    Pair.new(self, other).tap(&:reduce)
  end

  def reduce
    while true
      next if explode?
      next if split?
      break
    end

    self
  end

  def split?
    %i[left right]
      .to_h { |side| [side, send(side)] }
      .each do |key, side|
      if (result = side.split?)
        self.send("#{key}=", result)
        return self
      end
    end

    nil
  end

  def explode?(i = 0)
    return self if i == 4

    %i[left right]
      .to_h { |side| [side, send(side)] }
      .select { |_, val| val.is_a?(Pair) }
      .each do |key, side|
      if (exploded = side.explode?(i + 1))
        # Replace the side when parent of exploded
        send("#{key}=", SnailNumber.new(0)) if i == 3
        opposite(key).send("add_#{key}", opposite(key, exploded).value)

        if key == :left
          return Pair.new(exploded.left, SnailNumber.new(0))
        else
          return Pair.new(SnailNumber.new(0), exploded.right)
        end
      end
    end

    nil
  end

  def add_left(val)
    left.add_left(val)
  end

  def add_right(val)
    right.add_right(val)
  end

  protected

  attr_writer :left, :right

  def opposite(side, target = self)
    side == :left ? target.right : target.left
  end

  def instantiate(val)
    if val.is_a?(Integer)
      SnailNumber.new(val)
    else
      val
    end
  end
end

def parse(val)
  if val.is_a?(Integer)
    SnailNumber.new val
  else
    Pair.new parse(val.first), parse(val.last)
  end
end

puts File
       .read('input')
       .each_line
       .map { |l| parse(eval(l)) }
       .reduce(nil) { |pair, val| pair.nil? ? val : pair + val }
       .then { |result| result.magnitude }
