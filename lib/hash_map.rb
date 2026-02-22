class HashMap
  attr_accessor :capacity, :buckets

  def initialize(load_factor = 0.75, capacity = 16)
    @load_factor = load_factor
    @capacity = capacity
    @buckets = Array.new(@capacity) { [] }
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code + char.ord) }

    hash_code
  end

  def set(key, value)
    index = hash(key) % @capacity
    @buckets[index].each do |pair|
      if pair[0] == key
        pair[1] = value
        return
      end
    end
    @buckets[index] << [key, value]

    return unless length / @capacity.to_f > @load_factor

    entry = entries
    @capacity *= 2
    @buckets = Array.new(@capacity) { [] }
    entry.each do |pair|
      set(pair[0], pair[1])
    end
  end

  def get(key)
    bucket = hash(key) % @capacity
    @buckets[bucket].each do |pair|
      return pair[1] if pair[0] == key
    end
    nil
  end

  def has?(key)
    bucket = hash(key) % @capacity
    @buckets[bucket].each do |pair|
      return true if pair[0] == key
    end
    false
  end

  def remove(key)
    value = get(key)
    bucket = hash(key) % @capacity
    @buckets[bucket].delete_if do |pair|
      pair[0] == key
    end
    return value
    nil
  end

  def length
    count = 0
    @buckets.each do |bucket|
      count += bucket.length
    end
    count
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
  end

  def keys
    entries.map { |pair| pair[0] }
  end

  def values
    entries.map { |pair| pair[1] }
  end

  def entries
    @buckets.flat_map { |bucket| bucket }
  end
end
