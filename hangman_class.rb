require 'json'

class Game

	def initialize
		@max_guesses = 8
		@used_guesses = 0
		@word = ""
		@guess = ""
		@letter_array = []
		@used_letters = []
		@picture = [' ', ' |  ', ' | ', ' |  ']
	end

	def save_game
		save_file = File.open("saved_game.txt", "w")
		save_file.puts JSON.dump({
			:used_guesses => @used_guesses,
			:word => @word,
			:letter_array => @letter_array,
			:used_letters => @used_letters,
			:picture => @picture
			})
		save_file.close
		puts "Game Saved"
		exit
	end

	def load_game
		if File.exists?("saved_game.txt") && !File.zero?("saved_game.txt")
			load_file = File.open("saved_game.txt", "r")
			load_hash = JSON.parse(load_file.read)
			load_file.close
			#load saved values
			@used_guesses = load_hash["used_guesses"]
			@word = load_hash["word"]
			@letter_array = load_hash["letter_array"]
			@used_letters = load_hash["used_letters"]
			@picture = load_hash["picture"]

			puts "Game loaded"
		else
			return false
		end
		true
	end

	def get_word
		if File.exists?("5desk.txt") && !File.zero?("5desk.txt")
			words = File.read("5desk.txt")
			#other environments may not read \r in the dictionary text file.
			words = words.split("\r\n")
			hangman_words = words.select{|word| word.length >= 5 && word.length <= 12}
			hangman_words.collect!{|word| word.downcase}
			@word = hangman_words.sample.split("")
			#FOR TESTING
			#puts @word.inspect
			@letter_array = Array.new(@word.length, "_ ")
		else
			puts "Error: There is no dictionary file!"
			exit
		end
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

	def valid_input?
		return true if @guess == "save" || (!@used_letters.include?(@guess) && (@guess.length == @word.length || @guess.length == 1))
		false
	end

	def good_guess
		@word.each_with_index do |letter, index| 
			if letter == @guess
				@letter_array[index] = letter+" "
			end
		end
		@used_letters << @guess
	end

	def bad_guess
		puts "Your guess was wrong!"
		@used_guesses +=1
		if @guess.length == 1
			@used_letters << @guess
		end
		hangman
	end

	def hangman
		#incrementally add hangman ascii elements to array
		#may need to add escapes on "/" characters in other IDEs
		case @used_guesses
		when 1,2
			@picture[0] << " -"
		when 3
			@picture[1] << "O"
		when 4
			@picture[2] << "/"
		when 5
			@picture[2] << "|"
		when 6
			@picture[2] << "\\"
		when 7
			@picture[3] << "/"
		when 8 
			@picture[3] << "\\"
		end
		puts "______________"
		puts "#{@picture[0]}\n#{@picture[1]}\n#{@picture[2]}\n#{@picture[3]}"
		puts "______________"
	end

	def game_over?
		if @letter_array.include?("_ ")==false || @word.join == @guess
			puts "__________"
			puts "|You WON!|"
			puts "__________"
			puts "The word was '#{@word.join}'"
			return true
		elsif @max_guesses-@used_guesses == 0
			puts "_____________"
			puts "|You LOST...|"
			puts "_____________"
			puts "The word was '#{@word.join}'"
			return true
		else
			return false
		end
	end


	def play (status)
		if status == "load" 
			if load_game == true
				#orient players from the get-go
				puts "Let's continue!"
				hangman
				puts "You've alreaady used the following letters: #{@used_letters.sort.uniq.join.upcase}"
				puts "You have #{@max_guesses-@used_guesses} guesses remaining."
			else
				puts "There are no saved games."
				return
			end
		else
			#start a new game
			get_word
			puts "Let's play hangman! Type 'save' at any time to save your game."
		end

		until game_over? ==true
			guess
		end
	end

end


