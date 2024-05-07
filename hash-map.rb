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

  def get(key)
    node = find_node_in_hash(key)
    return if node.nil?

    node.value[1]
  end

  def has?(key)
    node = find_node_in_hash(key)
    node.nil? ? false : true
  end

  def remove(key)
    index = hash(key)
    remove_key_in_linked_list(key, @buckets[index])
  end

  def find_node_in_hash(key)
    index = hash(key)
    return if @buckets[index].nil?

    find_key_in_linked_list(key, @buckets[index].head)
  end

  def remove_key_in_linked_list(key, list)
    current_node = list.head
    if current_node.value[0] == key
      list.head = current_node.next_node
      return
    end
    until current_node.next_node.value[0] == key
      current_node = current_node.next_node
      return nil if current_node.next_node == nil
    end
    value = current_node.next_node.value[1]
    current_node.next_node = current_node.next_node.next_node

    return value
  end

  def find_key_in_linked_list(key, current_node)
    return current_node if current_node.value[0] == key
    return nil if current_node.next_node == nil

    current_node = current_node.next_node
    find_key_in_linked_list(key, current_node)
  end
end

map = HashMap.new
map.set('john', 'old value')
map.set('mark', 'peak time')
map.set('jim', 'bro')
map.set('john', 'new value')
map.set('sara', 'old')
map.set('nelson', 'new')

map.remove('mark')

map.buckets.each_with_index do |bucket, index|
  p "In bucket #{index + 1} we have #{bucket}"
end
keys = ['john', 'jack', 'kevin', 'marco', 'maxim', 'christian', 'johny', 'sara', 'nelson']

