require './hangman_class.rb'
loop do
	choice = ""
	until choice == "new" || choice == "saved" || choice == "quit"
		puts "Would you like to play a new game or a saved game. Type 'new', 'saved' or 'quit'."
		choice = gets.chomp.downcase
	end

	case choice
	when "new"
		game = Game.new.play
	when "saved"
		puts "saved"
	when "quit"
		exit
	end
end