# 相当于java中的hashCode()

def hash_code(str) 
  str.each_char.reduce(0) do |result, char| 
    [((result << 5) - result) + char.ord].pack('L').unpack('l').first 
  end 
end
