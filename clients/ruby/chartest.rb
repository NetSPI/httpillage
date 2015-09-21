charset = "?u?l?d"

CHARSET_LOWER = ('a'..'z')
CHARSET_UPPER = ('A'..'Z')
CHARSET_DECIMAL = ('0'..'9')

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

brute(charset)