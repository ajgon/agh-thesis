class IdEncoder
  
  @hash = 758325984 # must be between 0..4294967295
  @salt = '42378042347853842' # must be numeric and must contain 20 digits
  @precision = 6
  
  def self.encode id
    counted_id = (id ^ @hash).to_s
    salt_position = counted_id[counted_id.length-1].chr.to_i
    counted_id = ((counted_id.to_i * @salt[salt_position..salt_position+9].to_i).to_s + salt_position.to_s).to_i.to_s(28)
    return counted_id
  end
  
  def self.decode hash
    hash = hash.gsub(/[^0-9a-r]/, '')
    hash = hash.to_i(28).to_s
    return false if hash[hash.length-1].nil?
    salt_position = hash[hash.length-1].chr.to_i
    hash[hash.length-1] = ''
    return_id = hash.to_f / @salt[salt_position..salt_position+9].to_f
    if (((return_id - return_id.round) * 10 ** @precision).to_i.zero? && return_id.round ^ @hash < 2147483648)
      return return_id.round ^ @hash
    else
      return false
    end
  end
  
end