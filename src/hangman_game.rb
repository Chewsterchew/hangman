# The game itself
class HangmanGame
  attr_reader :game_word, :game_letters, :game_over, :guessed_letters, :turns, :letter, :counter, :word_list

  def initialize
    @game_over = false
    @guessed_letters = []
    @turns = 7
    words = File.readlines('words.txt') { |line| line.split.map(&:to_s).join }
    words = words[0].delete("\n")
    words = words.split(',')
    @word_list = words
  end

  def play
    @game_word = random_word
    @game_letters = @game_word.chars.to_a
    print_instructions
    play_loop
  end

  def play_loop
    until @game_over
      puts self
      find_letter

      already_guessed?

      @guessed_letters << @letter unless @letter.size != 1

      if lives? && !won?
        make_response

      elsif won?
        puts @game_word.to_s
        puts 'You are victorious human. For now...'
        puts "The word was in fact #{@game_word}"
        game_end
      else
        lost
      end
    end
  end

  def game_end
    @game_over = true
  end

  def lost
    puts self
    puts 'Mwahaha, the superior computer remains superior'
    puts "The word was obviously #{@game_word}"
    game_end
  end

  def won?
    (@game_letters - @guessed_letters).empty?
  end

  def lives?
    @turns > 1
  end

  def already_guessed?
    if @guessed_letters.include? @letter
      puts "You have already guessed the letter #{@letter} silly mortal"
      play_loop
    end
  end

  def make_response
    if @letter.size != 1
      puts 'This is not a valid input foolish human'
    elsif @game_letters.include? @letter
      puts "Yes, this word does include #{@letter}, but you shall not defeat me"
    else
      @turns -= 1
      puts "Fool, this word does not contain your worthless letter #{@letter}. You have #{@turns} guesses left."
    end
    puts "Letters guessed: #{@guessed_letters.join(' ')}"
  end

  def find_letter
    @letter = gets.chomp.downcase
  end

  def random_word
    @word_list.sample
  end

  def print_instructions
    puts 'Welcome to Hangman, where I, the computer, am champion of words'
    puts 'Guess a letter, if you dare'
  end

  def to_s
    output = ''

    t = @turns

    ascii = <<-EOS
    _____
    |    #{t < 7 ? '|' : ' '}
    |    #{t < 6 ? 'O' : ' '}
    |   #{t < 2 ? '/' : ' '}#{t < 5 ? '|' : ' '}#{t < 1 ? '\\' : ' '}
    |   #{t < 4 ? '/' : ' '} #{t < 3 ? '\\' : ' '}
    |
    ===
    EOS

    output << ascii

    @game_letters.each do |l|
      output << (@guessed_letters.include?(l) ? l : '__') + ' '
    end
    output
  end
end
