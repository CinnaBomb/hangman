require './hangman_class.rb'
loop do
	choice = ""
	until choice == "new" || choice == "load" || choice == "quit"
		puts "Would you like to play a new game or load a saved game. Type 'new', 'load' or 'quit'."
		choice = gets.chomp.downcase
	end

	case choice
	when "new"
		game = Game.new.play("new")
	when "load"
		game = Game.new.play("load")
	when "quit"
		exit
	end
end