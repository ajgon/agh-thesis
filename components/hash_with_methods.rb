class HashWithMethods
  def initialize hash
    @hash = hash
  end
  
  def method_missing key
    @hash[key]
  end
end