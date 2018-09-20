=begin
  By replacing the question marks in Listing 4.10 with the appropriate methods, 
  combine split, shuffle, and join to write a function that shuffles the letters 
  in a given string.
=end

class String 
  def string_shuffle(s)
    s.split('').shuffle.join
  end
end
#=> nil



a = String.new

p a.string_shuffle("foobar")
p a.string_shuffle('hey')
p a.string_shuffle('Angie')

=begin
  Create three hashes called person1, person2, and person3, with first and l
  ast names under the keys :first and :last. Then create a params hash so that 
  params[:father] is person1, params[:mother] is person2, and params[:child] 
  is person3. Verify that, for exam- ple, params[:father][:first] has the right value.
=end

person1 = {first: 'Kris', last: "O'Meara"}
person2 = {first: 'Angie', last: 'Barcelle'}
person3 = {first: 'Joel', last: "O'Meara"}
params = {father: person1, mother: person2, child: person3}

puts person1
puts person2
puts person3
puts params