
class Word < String
  def palindrome?
    self == self.reverse
  end
end

w = Word.new("Yes")

p w.palindrome?
p w.class
p w.class.superclass

x = "wow"
p x.class

class String
  def palindrome?
    self == self.reverse
  end
end

p x.palindrome?
p "Wow".palindrome?
