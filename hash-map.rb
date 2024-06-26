# raise IndexError if index.negative? || index >= @buckets.length
require '../linked_lists_TOP/linked_lists'

class HashMap
  attr_accessor :buckets

  def initialize(capacity)
    @capacity = capacity
    @buckets = Array.new(@capacity)
    @load_factor = 0.8
  end

  def buckets_load_perecentage
    count_full_buckets * 100 / @capacity / 100.00
  end

  def count_full_buckets
    count = 0
    @buckets.each do |bucket|
      count += 1 unless bucket.nil?
    end
    count
  end

  def grow_buckets
    @capacity = @capacity * 2
    @new_buckets = Array.new(@capacity)
    entries = self.entries
    @buckets = @new_buckets
    entries.each do |entry|
      set(entry[0], entry[1])
    end
  end

  def hash(key)
    hash_code = 0
    prime = 23

    key.each_char { |char| hash_code = prime * hash_code + char.ord }
    hash_code % @buckets.length
  end

  def set(key, value)
    index = hash(key)
    grow_buckets if buckets_load_perecentage > @load_factor
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
    return if @buckets[index].nil?

    if linked_list_length(@buckets[index]) < 2
      value = @buckets[index].head.value[1]
      @buckets[index] = nil
      return value
    end
    remove_key_in_linked_list(key, @buckets[index])
  end

  def length
    count = 0
    @buckets.each do |bucket|
      next if bucket.nil?
      count += linked_list_length(bucket)
    end
    count
  end

  def clear
    @buckets.each_with_index do |bucket, index|
      @buckets[index] = nil
    end
  end

  def keys
    keys = []
    @buckets.each do |bucket|
      next if bucket.nil?
      keys << linked_list_keys(bucket)
    end
    keys.flatten
  end

  def values
    values = []
    @buckets.each do |bucket|
      next if bucket.nil?
      values << linked_list_values(bucket)
    end
    values.flatten
  end

  def entries
    entries = []
    @buckets.each do |bucket|
      next if bucket.nil?
      entries << linked_list_entries(bucket)
    end
    entries.flatten(1)
  end

  def find_node_in_hash(key)
    index = hash(key)
    return if @buckets[index].nil?

    find_key_in_linked_list(key, @buckets[index].head)
  end

  def linked_list_length(list)
    current_node = list.head
    count = 1
    until current_node.next_node.nil?
      current_node = current_node.next_node
      count += 1
    end
    count
  end

  def linked_list_keys(list)
    keys = [list.head.value[0]]
    current_node = list.head
    until current_node.next_node.nil?
      current_node = current_node.next_node
      keys << current_node.value[0]
    end
    keys
  end

  def linked_list_values(list)
    values = [list.head.value[1]]
    current_node = list.head
    until current_node.next_node.nil?
      current_node = current_node.next_node
      values << current_node.value[1]
    end
    values
  end

  def linked_list_entries(list)
    entries = [[list.head.value[0], list.head.value[1]]]
    current_node = list.head
    until current_node.next_node.nil?
      current_node = current_node.next_node
      entries << [current_node.value[0], current_node.value[1]]
    end
    entries
  end

  # Not sur if this will be useful, maybe better approach than below?
  #
  # def find_with_previous(key, list)
  #   previous_node = list.head
  #   current_node = list.head
  #   until current_node.value[0] == key
  #     previous_node = current_node
  #     current_node = current_node.next_node
  #     return if current_node.nil?
  #   end
  #   return [previous_node, current_node]
  # end

  def remove_key_in_linked_list(key, list)
    current_node = list.head
    if current_node.value[0] == key
      list.head = current_node.next_node
      return current_node.value[1]
    end
    until current_node.next_node.value[0] == key
      current_node = current_node.next_node
      return nil if current_node.next_node.nil?
    end
    value = current_node.next_node.value[1]
    current_node.next_node = current_node.next_node.next_node

    value
  end

  def find_key_in_linked_list(key, current_node)
    return current_node if current_node.value[0] == key
    return nil if current_node.next_node == nil

    current_node = current_node.next_node
    find_key_in_linked_list(key, current_node)
  end
end

map = HashMap.new(6)
map.set('john', 'old value')
map.set('mark', 'peak time')
map.set('jim', 'bro')
map.set('john', 'new value')
map.set('sara', 'old')
map.set('nelson', 'new')

map.buckets.each_with_index do |bucket, index|
  p "In bucket #{index + 1} we have #{bucket}"
end

p map.remove('sara')

p map.keys
p map.values
p map.entries

keys = ['john', 'jack', 'kevin', 'marco', 'maxim', 'christian', 'johny', 'sara', 'nelson']
values = %w[hello what the fuck is this again the same]

values.each_with_index do |v, i|
  map.set(keys[i], values[i])
end

map.buckets.each_with_index do |bucket, index|
  p "In bucket #{index + 1} we have #{bucket}"
end
