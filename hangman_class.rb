class Game

	def initialize
		@max_guesses = 12
		@used_guesses = 0
		@word = ""
		@guess = ""
		@letter_array = []
		@used_letters = []
		@picture = [' ', ' ', ' ', ' ']
		#puts @picture.inspect
	end

	def get_word
		words = File.read("5desk.txt")
		words = words.split("\r\n")
		hangman_words = words.select{|word| word.length >= 5 && word.length <= 12}
		hangman_words.collect!{|word| word.downcase}
		@word = hangman_words.sample.split("")
		puts @word.inspect
		@letter_array = Array.new(@word.length, "_ ")
		#puts @letter_array.inspect
	end

	def guess
		puts @letter_array.join
		@guess = ""
		until valid_input? == true
			if @used_letters.include?(@guess)
				puts "You've already guessed that letter!"
			else
				puts "You can guess one letter at a time or the entire word."
			end
			@guess = gets.chomp!
		end
		if @guess == "save"
			save_game
		elsif @word.join == @guess
			return
		elsif @word.include?(@guess)
			good_guess
		else
			bad_guess
		end
		puts "You've alreaady used the following letters: #{@used_letters.sort.uniq.join.upcase}"
		puts "You have #{@max_guesses-@used_guesses} guesses remaining."
	end

	def save_game
		puts "Game Saved"
		exit
	end

	def load_game
		puts "Game loaded"
	end

	def valid_input?
		return true if @guess == "save" || (!@used_letters.include?(@guess) && (@guess.length == @word.length || @guess.length == 1))
		false
	end

	def hangman

		case @used_guesses
		when 1
			@picture[3] << "|  "
		when 2
			@picture[2] << "| "
		when 3
			@picture[1] << "|  "
		when 4,5
			@picture[0] << " -"
		when 6
			@picture[0] << ","
		when 7
			@picture[1] << "O"
		when 8
			@picture[2] << "/"
		when 9
			@picture[2] << "|"
		when 10
			@picture[2] << "\\"
		when 11
			@picture[3] << "/"
		when 12 
			@picture[3] << "\\"
		end
		puts "______________"
		puts "#{@picture[0]}\n#{@picture[1]}\n#{@picture[2]}\n#{@picture[3]}"
		puts "______________"
	end

	def bad_guess
		@used_guesses +=1
		@used_letters << @guess
		hangman
	end

	def good_guess
		#update letter array
		@word.each_with_index do |letter, index| 
			if letter == @guess
				@letter_array[index] = letter+" "
			end
		end
		@used_letters << @guess
		#puts @letter_array.join
	end


	def game_over?
		if @letter_array.include?("_ ")==false || @word.join == @guess
			puts "You WON!"
			return true
		elsif @max_guesses-@used_guesses == 0
			puts "You LOST..."
			puts "The word was '#{@word.join}'"
			return true
		else
			return false
		end
	end


	def play
		puts "Let's play hangman! Type 'save' at any time to save your game."
		get_word
		until game_over? ==true
			guess
			#hangman
		end
	end

end


