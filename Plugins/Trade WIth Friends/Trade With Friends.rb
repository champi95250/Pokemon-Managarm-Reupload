# ================================================================== #
# ======================= Initital Greeting ======================== #
# ================================================================== #
def pbGreeting
  pbMessage(_INTL("Welcome to the Trading Center!"))
  pbMessage(_INTL("Here you can trade with your friends all around the world!"))
  pbMessage(_INTL("How can I assist you today?"))
end 

def twf
  pbTradeWithFriends
end

# ================================================================== #
# =========================== Main Menu ============================ #
# ================================================================== #
def pbTradeWithFriends
    commands = []
    cmd_trade    = -1
    cmd_retrieve = -1
    cmd_explain  = -1
	cmd_clear 	 = -1
    cmd_quit     = -1
	
    # Displays initial greeting
    #pbGreeting
    
    commands[cmd_trade = commands.length]  	  = _INTL("Start a trade")
    commands[cmd_retrieve = commands.length]  = _INTL("Retrieve a traded Pokemon")
    commands[cmd_explain = commands.length]   = _INTL("Explanation of services")
    commands[cmd_quit = commands.length]      = _INTL("Clear stored Pokemon")
    commands[cmd_quit = commands.length]      = _INTL("Exit")
    loop do
      command = pbShowCommands(nil,commands,commands.length)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_trade
        pbSelectPokemonForTrade
      when cmd_retrieve
        pbRetrievePokemon
	  when cmd_clear
		pbClearPokemon
      when cmd_explain
        pbExplainTrade
        next
      when cmd_quit
      end
      break
    end
  end
  
def pbExplainTrade
    commands = []
    cmd_trade    = -1
    cmd_retrieve = -1
	cmd_clear     = -1
    cmd_quit     = -1
    commands[cmd_trade = commands.length]     = _INTL("Trading")
    commands[cmd_retrieve = commands.length]  = _INTL("Retrieving")
	commands[cmd_clear = commands.length]     = _INTL("Clearing")
    commands[cmd_quit = commands.length]      = _INTL("Nevermind")
    pbMessage(_INTL("What would you like to know more about?"))
  loop do
    command = pbShowCommands(nil, commands, commands.length)
    case command
    when cmd_trade
      pbMessage(_INTL("The Trade menu will allow you to choose a Pokemon to trade."))
      pbMessage(_INTL("This Pokemon will be stored in a file which you will give to the friend you are trading."))
      pbMessage(_INTL("They can then use that file to retrieve your Pokemon!"))
    when cmd_retrieve
      pbMessage(_INTL("The Retrieve menu will allow you to receive the Pokemon your friend is trying to trade you."))
      pbMessage(_INTL("Take the file they give you, and put it into the game folder."))
      pbMessage(_INTL("Don't worry about where it is, I'll find it!"))
    when cmd_clear
	  pbMessage(_INTL("Clearing your stored Pokemon will erase data of the pending trade."))
	  pbMessage(_INTL("You will not be able not be able to get back your traded Pokemon."))
	  pbMessage(_INTL("Use this only if your friend didn't trade you back."))	  
	when cmd_quit
      break
    end
  end
end

def pbClearPokemon
  if $player.friendTrade
    pbMessage(_INTL("This will clear your Pokémon data from the trade."))
    pbMessage(_INTL("You will not be able to get your Pokémon back, but this will allow you to start a new trade."))
    ret = pbConfirmMessage(_INTL("Are you sure you wish to proceed and delete your saved Pokémon data?"))

    if ret
      $player.friendTrade = nil
      pbMessage(_INTL("Your Pokémon data has been cleared. You can now start a new trade."))
    else
      pbMessage(_INTL("Please complete the trade to start a new trade."))
    end
  else
    pbMessage(_INTL("There's nothing to clear! Please start a trade to begin the process."))
  end
end

	
# ================================================================== #
# =================== Choose Pokemon For Trade ===================== #
# ================================================================== #
def pbSelectPokemonForTrade
  chosen = -1
  ret = nil
  # Check if the player already has a pending trade
  if $player.friendTrade
    pbMessage(_INTL("You already have a pending trade. Please complete your trade before starting a new one."))
    pbMessage(_INTL("Pending Pokemon is {1}.", $player.friendTrade.name))
  else
    pbFadeOutIn {
      scene = PokemonParty_Scene.new
      screen = PokemonPartyScreen.new(scene, $player.party)
      chosen = screen.pbTWF
    }
    pkmn = $player.party[chosen]

    # Check for a trade file
    tradeWaiting = pbSearchForFile
    if tradeWaiting
      ret = pbConfirmMessage(_INTL("Trade file detected. Are you sure you want to start a new trade? This will start a new trade file."))
	  if !ret
		return
	  end
    end

    # Creates trade file / Deletes Pokemon / Saves game
    if chosen >= 0
      pbCreateTradeFile(pkmn)
      $player.party.delete_at(chosen)
      
    else
      pbMessage(_INTL("Come back if you want to trade."))
    end
  end
end

# ================================================================== #
# ================= Retrieve Pokemon For Trade ===================== #
# ================================================================== #
def pbRetrievePokemon
  pkmn, filePath = pbSearchForFile
  if !pkmn
    pbMessage(_INTL("Could not find any trade data."))
    return
  end
  # ===if pkmn.owner.id == $player.id
  # ===  pbMessage(_INTL("You can't trade your own Pokemon to yourself!"))
  # ===  return
  # ===end
  
  ret = pbCheckForDuplicates(pkmn)
  if ret
    pbMessage(_INTL("Trade has been canceled. Pokemon has already been received."))
    return
  end
  proceed = startFriendTradeScene(pkmn)
  
  if proceed
	  if File.exist?(filePath)
		File.delete(filePath)
		puts "File deleted successfully."
	  else
		puts "File not found."
	  end
   else
	  return
   end
end

# Picking a Pokmemon for trade
def pbTWF
  ret = -1
  @scene.pbStartScene(
    @party,
    (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
  )
  loop do
    @scene.pbSetHelpText(
      (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
    )
    pkmnid = @scene.pbChoosePokemon
    break if pkmnid < 0  # Player chose to cancel
    pbMessage(_INTL("Once you trade your Pokemon, you cannot get it back."))
    confirm = pbConfirmMessage(_INTL("Are you sure you wish to trade the Pokémon, {1}?", $player.party[pkmnid].name))
    if confirm
      ret = pkmnid
      break
    end
  end
  @scene.pbEndScene
  return ret
end

# ================================================================== #
# ========================== Trade Scene =========================== #
# ================================================================== #
def startFriendTradeScene(pkmn)
  # Validates species exists in the game
  valid = validateSpecies(pkmn.species, pkmn.gender, pkmn.shiny?)
  if valid
    if $player.friendTrade.nil?
      pbMessage(_INTL("Please choose a Pokémon to trade for {1}'s {2}.", pkmn.owner.name, pkmn.name))
      ret = pbSelectPokemonForTrade
      if ret
        pbMessage(_INTL("Starting trade."))
      else
        pbMessage(_INTL("Two Pokémon are required for trading."))
        return false
      end
    end

    $stats.trade_count += 1
    myPokemon = $player.friendTrade
    yourPokemon = pkmn
    yourPokemon.obtain_method = 2   # traded
    yourPokemon.record_first_moves
    trainerName = yourPokemon.owner.name
    pbFadeOutInWithMusic do
      evo = PokemonTrade_Scene.new
      evo.pbStartScreen(myPokemon, yourPokemon, $player.name, trainerName)
      evo.pbTrade
      evo.pbEndScreen
    end
    $player.friendTrade = nil
    pbAddPokemonSilent(yourPokemon)
  end
end

# Method to validate the species of the incoming Pokémon
def validateSpecies(species, gender, shiny)
  GameData::Species.each do |tradedSpecies|
    return true if tradedSpecies.id == species
  end
  return false
end

# ================================================================== #
# ======================= Duplication Check ======================== #
# ================================================================== #
# Checks the boxes and party for Pokemon your trying to receive
# All Pokemon should have unique IDs, so a duplicate means trade has 
#   already been used.


def pbCheckForDuplicates(tradePkmn)
  # Check the player's party
  for i in 0...$player.party.length
    pkmn = $player.party[i]
    next if pkmn.nil?

    if tradePkmn.owner.id == pkmn.owner.id && tradePkmn.obtain_level == pkmn.obtain_level && tradePkmn.species == pkmn.species && tradePkmn.obtain_map == pkmn.obtain_map
      pbMessage(_INTL("The Pokémon {1} was found in the party at position {2}.", pkmn.species, i))
      return true
    end
  end

  # Check Pokémon storage boxes
  for box in 0...$PokemonStorage.maxBoxes
    for slot in 0...$PokemonStorage.maxPokemon(box)
      pkmn = $PokemonStorage[box, slot]
      next if pkmn.nil?

      if tradePkmn.owner.id == pkmn.owner.id && tradePkmn.obtain_level == pkmn.obtain_level && tradePkmn.species == pkmn.species && tradePkmn.obtain_map == pkmn.obtain_map
        pbMessage(_INTL("The Pokémon {1} was found in Box: {2}, Slot: {3}.", pkmn.species, box, slot))
        return true
      end
    end
  end
  return false
end


# Variable to store "myPokemon" value for trade scene
class Player
  attr_accessor :friendTrade
end

# ================================================================== #
# ================== Method to Read / Write file =================== #
# ================================================================== #
# Makes and writes a trade file containing Pokémon information
def pbCreateTradeFile(decryptedPkmn)
  $player.friendTrade = decryptedPkmn
  # Makes a directory "Trade" and stores the file in it (for easy locating)
  Dir.mkdir("Trade\\") unless File.exists?("Trade\\")
  filePath = "Trade\\PokemonForTrade.txt"
    
  begin
    File.open(filePath, "w") do |file|
      # Encrypts data to prevent modification and writes to the file
      pkmn = [Zlib::Deflate.deflate(Marshal.dump(decryptedPkmn))].pack("m")
      formattedData = "(\"#{pkmn}\")"
      file.puts(formattedData)
      
      pbMessage(_INTL("File successfully created in the Trade directory of the Game Folder."))
      pbMessage(_INTL("Please give this file to your friend to complete the trade."))
    end
  rescue StandardError => e
    pbMessage(_INTL("Error creating the trade file: {1}", e.message))
  end
end

# Searches game folder and subfolders for PokemonForTrade text
def pbSearchForFile
  rootFolder = File.dirname(__FILE__)
  filePath = Dir.glob(File.join(rootFolder, "**", "PokemonForTrade.txt")).first

  if filePath.nil?
    puts "Trade file not found"
    return false
  end

  begin
    encryptedPkmn = File.read(filePath)
    pkmnData = Marshal.restore(Zlib::Inflate.inflate(encryptedPkmn.unpack("m")[0]))
    return [pkmnData, filePath]
  rescue StandardError => e
    pbMessage(_INTL("Error reading or decrypting the trade file: {1}", e.message))
    return nil
  end
end
