# hangman with save/load feature

# main function to play multiple times
def main
  # initialize loop condition and record
  playing = ""
  record = [0,0]

  # loop game until player saves or quits
  while playing == "" do
    # play round of game, return result (and word if player loses)
    result, word = play

    # save condition
    if result == nil
      puts "Game Saved, goodbye!"
      break

    # win condition
    elsif result == true
      puts "You guessed the word, you win!"
      record[0] += 1

    # loss condition
    elsif result == false
      puts "You ran out of turns, you lose!"
      puts "The word was #{word}!"
      record[1] += 1
    end

    # print record and ask player to play again
    puts "Your record is #{record[0]} win(s), and #{record[1]} loss(es)."
    puts "Press enter to play again. Input anythin else to quit."
    playing = gets.chomp
  end

end

# play function
def play

  # initialize game variables
  turn = 5
  guess = " "
  guessed = []
  saved = false
  correct = nil

  # load game
  puts "Would you like to load a saved game (Y/N)? "
  load_save = gets.chomp
  if load_save.downcase == "y"
      turn, word, found, guessed, loaded = load(turn, word, found, guessed)
  end
  if !loaded
    #sets difficulty
    puts("Enter your difficulty (Easy, Medium, Hard, or Random): ")
    difficulty = gets.chomp
    word = pick_word(difficulty)
    found = Array.new(word.length, "_")
  end



  # display starting information
  puts "Tip: Type 'save game' in place of a guess to save your game."
  display(found, word, guess, guessed, correct)

  # play game
  while game_over(turn, word, found, guess) == 'cont'

    # get guess
    guess, guessed = turn(turn, word, found, guess, guessed)

    # evaluate guess
    found, correct, turn = eval_guess(turn, word, found, guess)

    # display result
    display(found, word, guess, guessed, correct)

  end

  # return result to main (win, loss, save)
  return game_over(turn, word, found, guess), word.join
end

# pick random word based on difficulty
def pick_word(difficulty)
  # set filename based on user input
  case difficulty
  when 'hard'
    filename = 'words/hard.txt'
  when 'medium'
    filename = 'words/medium.txt'
  when 'easy'
    filename = 'words/easy.txt'
  else
    filename = 'words/random.txt'
  end

  #set word using File#sample
  word = File.readlines(filename).sample.split(//)
  word.pop
  word
end

# display current game data
def display(found, word, guess, guessed, correct)
  guess == nil ? return : nil
  # check whether the player has made a guess (if the game has just started or loading from save, correct == nil)
  correct == nil ? nil : puts("Your guess was #{correct}!")

  # display guesses and found letters in word
  puts "Correct guesses: " + (word & guessed).join(", ")
  puts "Incorrect guesses: " + (guessed - word).join(", ")
  puts found.join(" ")
end

# get guess/save input from user
def turn(turn, word, found, guess, guessed)
  # display wrong guesses left
  puts "You have #{turn} wrong guesses left. Enter a letter or save game"

  # get guess
  guess = gets.chomp

  # check if user wants to save
  saved = guess == "save game" ? save(turn, word, found, guessed) : false

  # proceed if not
  if saved == false
    while guess.length != 1 || (guessed.include?(guess))
      puts "Invalid input. Please try again: "
      guess = gets.chomp
    end
    guessed.push(guess)
    return guess, guessed
  end

  # stop eval_guess from running if user chose to save
  [nil, guessed]
end

# evaluate guess
def eval_guess(turn, word, found, guess)
  return [found, false, turn] if guess.nil?

  # default "correct" value
  correct = "wrong"

  # check if guess was correct and modify corresponding value in found
  word.each_with_index do |char, index|
    if char == guess
      found[index] = guess
      correct = "right"
    end
  end

  # reduce turn count if incorrect, return
  correct == "right" ? nil : turn -= 1
  [found, correct, turn]
end

def save(turn, word, found, guessed)
  # returns true
  data =[turn,word.join,found.join,guessed.join]
  puts "Enter name of file to save to (excluding .txt): "
  filename = gets.chomp + '.txt'
  File.open(filename, "w+") do |f|
    f.puts(data)
  end
  true
end

def load(turn, word, found, guessed)
  # returns turn, word, found, and guessed
  puts "Enter name of file to load from (excluding .txt): "
  filename = gets.chomp + '.txt'
  while !(File.exist?(filename))
    puts "File not found. Please try again or type 'quit' to quit"
    filename = gets.chomp + '.txt'
    if filename == 'quit.txt'
      return turn, word, found, guessed, false
    end
  end

  begin
  data = File.readlines(filename).map(&:chomp)
  data = [data[0].to_i, data[1].split(//), data[2].split(//), data[3].split(//), true]
  data
  rescue
    puts "Error: File Invalid."
    return turn, word, found, guessed, false
  end
end

def game_over(turn, word, found, guess)
  if guess == nil
    return nil
  elsif turn <= 0
    return false
  elsif found == word
    return true
  end
  'cont'
end

main
