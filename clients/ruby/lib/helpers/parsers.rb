def parse_work(work)
  return [] if work.nil?

  return URI.unescape(work).split("\n")
end

# Split data by & and =, returning hash
def parse_data(data)
  # Don't split data if it's xml or json
  
  if data.match(/(\A<\?)|({)/)
    return data
  end

  begin
    URI.decode_www_form(data)
  rescue
    return {}
  end
end

def parse_headers(headers)
  header_hash = {}

  lines = headers.split("\n")

  lines.each do |line|
    split_line = line.split(":", 2)

    # Skip this line if it isn't splittable
    next if split_line.count < 2

    # Remove trailing whitespace
    split_line[1].chomp!
    
    h = Hash[*split_line]
    header_hash.merge!(h)
  end

  return header_hash
end