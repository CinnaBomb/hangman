class Game
	def initialize
		@max_guesses = 12
		@used_guesses = 0
		@word = ""
		@guess = ""
		@letter_array = []
		@used_letters = []
	end

	def get_word
		words = File.read("5desk.txt")
		words = words.split("\r\n")
		hangman_words = words.select{|word| word.length >= 5 && word.length <= 12}
		hangman_words.collect!{|word| word.downcase}
		@word = hangman_words.sample.split("")
		puts "wordarray" + @word.inspect
		@letter_array = Array.new(@word.length, "_ ")
		#puts @letter_array.inspect
	end

	def guess
		@guess = ""
		until @guess.length == @word.length || @guess.length == 1
			puts "You can guess one letter at a time or the entire word."
			@guess = gets.chomp!
		end
		if @word.join == @guess
			return
		elsif @word.include?(@guess)
			good_guess
		else
			bad_guess
		end
	end

	def hangman
		line1 = "|----, "
		line2 = "|    O "
		line3 = "|   /|\\"
		line4 = "|   ./\\"
		puts line1, line2, line3, line4
	end

	def bad_guess
		@used_guesses +=1
		@used_letters << @guess
	end

	def good_guess
		@word.each_with_index do |letter, index| 
			if letter == @guess
				@letter_array[index] = letter+" "
			end
		end
		@used_letters << @guess
		puts @letter_array.join
	end


	def game_over?
		puts @used_guesses
		if @letter_array.include?("_ ")==false || @word.join == @guess
			puts "You WON!"
			return true
		elsif @max_guesses-@used_guesses == 0
			puts "You LOST"
			puts "The word was '#{@word.join}'"
			return true
		else
			return false
		end
	end


	def play
		get_word
		until game_over? ==true
			guess
		end
	end

end

game = Game.new
game.hangman
