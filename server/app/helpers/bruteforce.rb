module Bruteforce
  @@keyspacedict = { }

  def self.initiateKeyspaceDict
    charsets = { }
    Charset.all.each do |charset|
      charsets[charset.key] = charset.val
    end

    # Split string to array
    charsets.each do |k,v|
      @@keyspacedict[k] = v.split(//)
    end

    puts "\n\t\t HERE: #{@@keyspacedict}\n\n"
  end

  def self.generateKeys(keyspace,indicies,length)
    keys = []
    length.times do |i|
      key = ""

      indicies.count.times do |i|
        key += @@keyspacedict[keyspace[i]][indicies[i]]
      end
      keys.push(key)

      indicies.count.times do |i|
        indicies[i] += 1
        if indicies[i] == @@keyspacedict[keyspace[i]].count
          indicies[i] = 0
        else
          break
        end
      end
    end
    return keys
  end

  def self.indexToIndicies(keyspace,index)
    indicies = Array.new(keyspace.count, 0)
    keyspaceLengths = keyspace.map { |k| @@keyspacedict[k.upcase].count }

    totalKeyspace  = keyspaceLengths.inject(:*)

    if index.nil? || index > totalKeyspace
      return nil
    end

    keyspace.count.times do |i|
      subkeyspace = keyspaceLengths[0...i].inject(:*)
      if i == 0
        indicies[i] = index % keyspaceLengths[i]
      else
        indicies[i] = (index/subkeyspace).to_i % keyspaceLengths[i]
      end
    end

    return indicies
  end

  def self.generateSubkeyspace(keyspace,index,length)
    keyspace = keyspace.split(//)
    indicies = indexToIndicies(keyspace, index)

    if indicies.nil?
      return nil
    else
      return generateKeys(keyspace, indicies, length)
    end
  end

  # Returns total size of keyspace, used for determinining percentage complete
  def self.totalSize(keyspace)
    keyspace = keyspace.split(//)

    keyspaceLengths = keyspace.map { |k| @@keyspacedict[k.upcase].count }

    totalKeyspace  = keyspaceLengths.inject(:*)

    return totalKeyspace
  end
end