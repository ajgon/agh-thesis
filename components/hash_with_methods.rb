class HashWithMethods
  def initialize hash
    @hash = hash
  end
  
  def method_missing key
    return @hash[key] unless @hash[key].nil?
    @hash[key.to_s]
  end
end