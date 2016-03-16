def mac_address
  platform = RUBY_PLATFORM.downcase
  output = `#{(platform =~ /win32/) ? 'ipconfig /all' : 'ifconfig'}`
  case platform
    when /darwin/
      $1 if output =~ /en1.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
    when /win32/
      $1 if output =~ /Physical Address.*?(([A-F0-9]{2}-){5}[A-F0-9]{2})/im
    # Cases for other platforms...
    when /linux/
      $1 if output =~ /HWaddr.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
    else nil
  end
end