# raise IndexError if index.negative? || index >= @buckets.length
require '../linked_lists_TOP/linked_lists'

class HashMap
  attr_accessor :buckets

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key)
    hash_code = 0
    prime = 23

    key.each_char { |char| hash_code = prime * hash_code + char.ord }
    hash_code % @buckets.length
  end

  def set(key, value)
    index = hash(key)
    if @buckets[index].nil?
      @buckets[index] = LinkedList.new
      @buckets[index].append([key, value])
    elsif node = find_key_in_linked_list(key, @buckets[index].head)
      node.value[1] = value
    else
      @buckets[index].append([key, value])
      # p @bucket[index]
    end
  end

  def has?(key)
    @buckets.each do |bucket|
      return true if find_key_in_linked_list(key, bucket.head)
    end
    false
  end

  def find_key_in_linked_list(key, current_node)
    return current_node if current_node.value[0] == key
    return nil if current_node.next_node == nil

    current_node = current_node.next_node
    find_key_in_linked_list(key, current_node)
  end

  def get(key)
    index = hash(key)
    @buckets[index]
  end
end

map = HashMap.new
map.set('john', 'old value')
map.set('mark', 'peak time')
map.set('jim', 'bro')
map.set('john', 'new value')
map.set('nelson', 'amigo')

map.buckets.each_with_index do |bucket, index|
  p "In bucket #{index + 1} we have #{bucket}"
end
keys = ['john', 'jack', 'kevin', 'marco', 'maxim', 'christian', 'johny', 'sara', 'nelson']

