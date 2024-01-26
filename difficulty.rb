# creates easy dictionary (<7 characters)
dict = File.readlines('words/dictionary.txt').map(&:chomp)
remove = []

dict.each do |word|
  if word.length > 7
    remove.push(word)
  end
end

dict -= remove

File.open("words/easy.txt", "w+") do |f|
  f.puts(dict)
end

# creates medium dictionary (5-12 characters)
dict = File.readlines('words/dictionary.txt').map(&:chomp)
remove = []

dict.each do |word|
  if word.length < 8 || word.length > 12
    remove.push(word)
  end
end

dict -= remove

File.open("words/medium.txt", "w+") do |f|
  f.puts(dict)
end

# creates hard dictionary (>12 characters)
dict = File.readlines('words/dictionary.txt').map(&:chomp)
remove = []

dict.each do |word|
  if word.length < 12
    remove.push(word)
  end
end

dict -= remove

File.open("words/hard.txt", "w+") do |f|
  f.puts(dict)
end
