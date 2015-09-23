  KEYSPACEDICT = {
    'l' => ('a'..'z').to_a,
    'u' => ('A'..'Z').to_a,
    'd' => ('0'..'9').to_a
  }

  # Returns position of first charset marker
  def indexOfMarker(charset_str)
    idx = charset_str.index('?')

    idx + 1 if idx
  end

  def rangeForCharset(charset_str)
    idx = indexOfMarker(charset_str)
    charset_sym = charset_str[idx]

    if charset_sym == 'l'
      return CHARSET_LOWER
    elsif charset_sym == 'u'
      return CHARSET_UPPER
    elsif charset_sym == 'd'
      return CHARSET_DECIMAL
    end
  end


  def generateKeys(keyspace,indicies,length)
    keys = []
    length.times do |i|
      key = ""

      indicies.count.times do |i|
        key += KEYSPACEDICT[keyspace[i]][indicies[i]]
      end
      keys.push(key)

      indicies.count.times do |i|
        indicies[i] += 1
        if indicies[i] == KEYSPACEDICT[keyspace[i]].count
          indicies[i] = 0
        else
          break
        end
      end
    end
    return keys
  end

  def indexToIndicies(keyspace,index)
    indicies = Array.new(keyspace.count, 0)
    keyspaceLengths = keyspace.map { |k| KEYSPACEDICT[k].count }

    totalKeyspace  = keyspaceLengths.inject(:*)

    if index > totalKeyspace
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

  def generateSubkeyspace(keyspace,index,length)
    keyspace = keyspace.split(//)
    indicies = indexToIndicies(keyspace, index)

    if indicies.nil?
      return nil
    else
      return generateKeys(keyspace, indicies, length)
    end
  end