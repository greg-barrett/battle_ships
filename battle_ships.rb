class Player

  def initialize
    create_player
    create_grid
    @guess_array=[]
    @good_guess_array=[]
    @win=0
  end
#makes a blank grid for play
  def create_grid
    @grid = {"1a" => "   ", "1b" => "   ", "1c" => "   ", "1d" => "   ", "1e" => "   ",
              "2a" => "   ", "2b" => "   ", "2c" => "   ", "2d" => "   ", "2e" => "   ",
               "3a" => "   ", "3b" => "   ", "3c" => "   ", "3d" => "   ", "3e" => "   ",
                "4a" => "   ", "4b" => "   ", "4c" => "   ", "4d" => "   ", "4e" => "   ",
                 "5a" => "   ", "5b" => "   ", "5c" => "   ", "5d" => "   ", "5e" => "   "}
    end
#used with gets.chomp to take a coordinate from player and adds it to the guess array
  def guess=(guess)
    @guess=guess
    @guess_array<<@guess
  end
#returns the value of win =true or a number(false)
  def win
    @win
  end
#returns the array of all a player's guesses guess_array
  def guess_array
    @guess_array
  end
#returns the guess the user just gave
  def show_guess
    @guess
  end
#returns the users name
  def show_name
     @name
  end
#prints the grid
  def show_grid
    puts "\n\n#{self.show_name}'s Grid\n\n"
    puts "  A   B   C   D   E  "
    print "1"
    puts @grid.fetch_values("1a", "1b", "1c", "1d", "1e").join("|")#.rjust(20)
    puts " ___________________"#.rjust(20)
    print "2"
    puts @grid.fetch_values("2a", "2b", "2c", "2d", "2e").join("|")#.rjust(20)
    puts " ___________________"#.rjust(20)
    print "3"
    puts @grid.fetch_values("3a", "3b", "3c", "3d", "3e").join("|")#.rjust(20)
    puts " ___________________"#.rjust(20)
    print "4"
    puts @grid.fetch_values("4a", "4b", "4c", "4d", "4e").join("|")#.rjust(20)
    puts " ___________________"#.rjust(20)
    print "5"
    puts @grid.fetch_values("5a", "5b", "5c", "5d", "5e").join("|")#.rjust(20)
  end
#sets up an instance of the player class
  def create_player
    name=gets.chomp
    @name=name
  end
#recieves a string of coordinates from players
#converts them to an guess_array
#uses the coordinate as the key for the grid
#and assigns a + to its value, to mark the place of a ship
  def place_ship
    puts"Your battle ship is 4 squares long.\nPlease place it on your grid.\nIt can not be placed diagonally.\nCo-ordinates could be '2a 3a 4a 5a' "
    @coordinates_string=gets.chomp
    marker=@coordinates_string.split(" ")
    marker.each do |x|
      @grid[x]=" + "
    end
  end
#returns the good guess array with duplicates removed
#duplicates caused by the iteration in the matches method
  def good_guess_array
    @good_guess_array.uniq
  end
#checks if any of the coordinates of one player
#matches the guesses of the other players
#if true win increases by one. If win=4 then there is a win! and win is assigned true
#Also adds the winning guess to the good_guess-array.
#If matches are less than 4 then win in 0ed ready for the next round
  def matches(coordinates, guesses)
    coordinates.each do |c|
      guesses.each do |g|
        if c == g
          @win+=1
          @good_guess_array<<g
        end
      end
    end
      if @win < 4
        @win = 0
      else
        @win=true
      end
  end
#turns the coordinates string into an array so the matches method
#can call .each on it
  def coordinates_array
    @coordinates_array = @coordinates_string.split(" ")
    @coordinates_array
  end
#returns the coordinates as a string
  def coordinates
    @coordinates_string
  end
#checks if the other players coordinates as an array includes
#the current players guess. if true the other players grid is over ridden
  def strike (guess, coordinates)
    if coordinates.include?(guess)
      "******BOOM******".split().each {|x| print "#{x} "; sleep 0.2}
      @grid[guess]=" * "
    else
      "......YOU MISSED......".split().each {|x| print "#{x} "; sleep 0.2}
    end
    sleep 5
    100.times{puts" "}
  end
end

#******BEGIN GAME SETUP*******

20.times {puts" "}
puts"        ^                                       ^"
puts"       /|\\                                     /|\\"
puts"      /_|_\\                                   /_|_\\"
puts"  ______|______                           ______|______"
puts"  \\_o_o_o_o_o_/                           \\_o_o_o_o_o_/"
puts"~~~~~~~~~~~~~~~~~~WELCOME TO BATTLESHIPS~~~~~~~~~~~~~~~~~~~~~"
10.times {puts" "}

#Load player names
puts "Player One, what is your name?"
player_1=Player.new
puts "Player Two, what is your name?"
player_2=Player.new
150.times {puts" "}

#players create the grid and place their battleship
player_1.show_grid
player_1.place_ship
player_1.show_grid
sleep 3
100.times {puts" "}
player_2.show_grid
player_2.place_ship
player_2.show_grid
sleep 3
100.times {puts" "}
#******BEGIN GAME PLAY*******

until player_1.win ==true || player_2.win ==true
  100.times {puts" "}
  puts "\n\n#{player_1.show_name} please give your guess\n\n"
  puts "Previous guesses#{player_1.guess_array}"
  puts "Previous good guesses#{player_1.good_guess_array}"
  player_1.guess=gets.chomp
#check if the guess was a success or failure
  player_2.strike(player_1.show_guess, player_2.coordinates)
  #check if all the guesses have lead to total ship destruction
  player_1.matches(player_2.coordinates_array, player_1.guess_array)
  #game ends if player_1 has won
  break if player_1.win ==true

  puts "\n\n#{player_2.show_name} please give your guess\n\n"
  puts "Previous guesses#{player_2.guess_array}"
  puts "Previous good guesses#{player_2.good_guess_array}"
  player_2.guess=gets.chomp
#check if player_1's guess matches player_2's coordinates
  player_1.strike(player_2.show_guess, player_1.coordinates)
  #player_2.win1(player_2.guess_array, player_1.coordinates)
  player_2.matches(player_1.coordinates_array, player_2.guess_array)
end
# outputs the winner of the game
if player_1.win ==true
  puts "*****#{player_1.show_name} won!*****\n\n"
  puts "****Better luck newxt time#{player_2.show_name}!****"
elsif
  player_2.win ==true
    puts "*****#{player_2.show_name} won!*****\n\n"
      puts "****Better luck newxt time #{player_1.show_name}!****"
  end
