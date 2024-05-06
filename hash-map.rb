# raise IndexError if index.negative? || index >= @buckets.length

class HashMap
  def initialize
    @buckets = Array.new(16, Array.new)
  end

  def hash(key)
    hash_code = 0
    prime = 23

    key.each_char { |char| hash_code = prime * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    index = hash(key) % @buckets.length
    if @buckets[index].nil?
      @buckets[index] = value
    else
      expand
    end
  end
end

map = HashMap.new

puts map.buckets
