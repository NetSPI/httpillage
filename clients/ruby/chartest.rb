KEYSPACEDICT = {
  'l' => ('a'..'z').to_a,
  'u' => ('A'..'Z').to_a,
  'd' => ('0'..'9').to_a
}

def brute(charset_str)
  charset_range = rangeForCharset(charset_str)
  current_index = indexOfMarker(charset_str) - 1

  tmp_charset = charset_str.dup
  tmp_charset[current_index] = ""

  charset_range.each do |c|
    internal_charset = tmp_charset

    internal_charset[current_index] = c

    # Recurse here if we have another index
    if indexOfMarker(internal_charset)
      brute(internal_charset)
    else
      # Process payload..
      puts "\t" + internal_charset
    end
  end
end

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
  # keyspaceLengths = [len(keyspaceDict[k]) for k in keyspace]
  keyspaceLengths = keyspace.map { |k| KEYSPACEDICT[k].count }

  totalKeyspace  = keyspaceLengths.inject(:*)

  if index > totalKeyspace
    return nil
  end

  keyspace.count.times do |i|
    # subkeyspace = functools.reduce(operator.mul, [keyspaceLengths[j] for j in range(i)], 1) #multiply together all previous keyspacelengths e.g. operating on third char of ?d?l?l returns 10*26
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
  indicies = indexToIndicies(keyspace, index)

  if indicies.nil?
    return nil
  else
    return generateKeys(keyspace, indicies, length)
  end
end

keyspace = 'lll'.split(//)
index = 5230
length = 10

puts(generateSubkeyspace(keyspace,index,length))