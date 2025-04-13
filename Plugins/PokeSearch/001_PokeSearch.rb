#-------------------------------------------------------------------------------
# PokéSearch v1.1
# Find your perfect encounter with style 😎
#-------------------------------------------------------------------------------
#
# Based on UI-Encounters by ThatWelshOne
# 
#-------------------------------------------------------------------------------
#
# Call the UI with: vPokeSearch
#
#-------------------------------------------------------------------------------
#
# If you want to add the PokeSearch to an item
# un-comment the following lines
#
ItemHandlers::UseInField.add(:POKESEARCH, proc { |item|
vPokeSearch
next true
})
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------

def vPokeSearch
  if !$PokemonEncounters.encounter_possible_here?
    pbMessage("Cet objet ne peut être utilisé que dans une zone avec des rencontres Pokémon.")
    return
  end
  scene = PokeSearch_Scene.new
  screen = PokeSearch_Screen.new(scene)
  screen.pbStartScreen
end

class PokeSearch_Scene
  BASE_COLOR    = Color.new(64,64,64)
  SHADOW_COLOR  = Color.new(168,184,192)

  ONLY_ON_ENCOUNTER_TILE = true # Whether you can only search while on an encounter tile (grass, surfing, in a cave)

  # Initializes Scene
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    mapid = $game_map.map_id
    @encounter_data = GameData::Encounter.get(mapid, $PokemonGlobal.encounter_version)
    if @encounter_data
        @encounter_tables = Marshal.load(Marshal.dump(@encounter_data.types))
        @max_enc, @eLength = getMaxEncounters(@encounter_tables)
    else
        @max_enc, @eLength = [1, 1]
    end
    @index_hor = 1
    @index_ver = 0
    @current_key = 0
    @current_mon = nil
    @current_berry = nil
    @current_repel = nil
    @average_level = 1
    @disposed = false
  end

  # draw scene elements
  def pbStartScene
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap(sprintf("Graphics/Pictures/PokeSearch/bg"))
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["sel_berry"] = IconSprite.new(0,0,@viewport)
    @sprites["sel_berry"].setBitmap(sprintf("Graphics/Pictures/PokeSearch/sel_small"))
    @sprites["sel_berry"].x = 96
    @sprites["sel_berry"].y = 96
    @sprites["sel_berry"].visible = false
    @sprites["sel_repel"] = IconSprite.new(0,0,@viewport)
    @sprites["sel_repel"].setBitmap(sprintf("Graphics/Pictures/PokeSearch/sel_small"))
    @sprites["sel_repel"].x = 360
    @sprites["sel_repel"].y = 96
    @sprites["sel_repel"].visible = false
    @sprites["sel_pokemon"] = IconSprite.new(0,0,@viewport)
    @sprites["sel_pokemon"].setBitmap(sprintf("Graphics/Pictures/PokeSearch/sel_medium"))
    @sprites["sel_pokemon"].x = 166
    @sprites["sel_pokemon"].y = 102
    @sprites["sel_pokemon"].visible = true
    @sprites["sel_search"] = IconSprite.new(0,0,@viewport)
    @sprites["sel_search"].setBitmap(sprintf("Graphics/Pictures/PokeSearch/sel_large_search"))
    @sprites["sel_search"].x = 96
    @sprites["sel_search"].y = 318
    @sprites["sel_search"].visible = false
    @sprites["sel_cancel"] = IconSprite.new(0,0,@viewport)
    @sprites["sel_cancel"].setBitmap(sprintf("Graphics/Pictures/PokeSearch/sel_large_cancel"))
    @sprites["sel_cancel"].x = 288
    @sprites["sel_cancel"].y = 318
    @sprites["sel_cancel"].visible = false
    @sprites["berry_icon"] = ItemIconSprite.new(124,124,nil,@viewport)
    @sprites["berry_text"] = Window_UnformattedTextPokemon.newWithSize("",21, 155, 236, 174, @viewport)
    @sprites["berry_text"].baseColor   = BASE_COLOR
    @sprites["berry_text"].shadowColor = SHADOW_COLOR
    @sprites["berry_text"].visible     = true
    @sprites["berry_text"].windowskin  = nil
    @sprites["berry_text"].text = "Ajoutez une baie dans cet emplacement pour obtenir un effet secondaire."
    @sprites["repel_icon"] = ItemIconSprite.new(388,124,nil,@viewport)
    @sprites["repel_text"] = Window_UnformattedTextPokemon.newWithSize("",257, 155, 236, 174, @viewport)
    @sprites["repel_text"].baseColor   = BASE_COLOR
    @sprites["repel_text"].shadowColor = SHADOW_COLOR
    @sprites["repel_text"].visible     = true
    @sprites["repel_text"].windowskin  = nil
    @sprites["repel_text"].text = "Ajoutez un repousse dans cet emplacement pour augmenter les chances de rencontre."
    @sprites["berry_icon"].visible = false
    @sprites["repel_icon"].visible = false
    if $PokemonSystem.last_pokesearch_settings != []
      # Only set last pokemon if it's available in this map
      if getEncData[0].include?($PokemonSystem.last_pokesearch_settings[0])
        @current_mon = $PokemonSystem.last_pokesearch_settings[0]
        current_mon_name = GameData::Species.get(@current_mon).name
        overlay = @sprites["overlay"].bitmap
        overlay.clear
        pbDrawTextPositions(overlay,[[current_mon_name,Graphics.width/2,112,2,BASE_COLOR,SHADOW_COLOR]])
      end
      # Only set last berry if it's available in the bag
      if $bag.has?($PokemonSystem.last_pokesearch_settings[1])
        @current_berry = $PokemonSystem.last_pokesearch_settings[1]
        @sprites["berry_icon"].item = @current_berry
        @sprites["berry_text"].text = description(@current_berry)
      end
      # Only set last repel if it's available in the bag
      if $bag.has?($PokemonSystem.last_pokesearch_settings[2])
        @current_repel = $PokemonSystem.last_pokesearch_settings[2]
        @sprites["repel_icon"].item = @current_repel
        @sprites["repel_text"].text = description(@current_repel)
      end
      drawPresent
    end
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  # input controls
  def pbPokeSearch
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if @disposed
        break
      else
        if Input.trigger?(Input::RIGHT) && @index_hor < 2
          pbPlayCursorSE
          @index_hor += 1
          drawPresent
        elsif Input.trigger?(Input::LEFT) && @index_hor !=0
          pbPlayCursorSE
          @index_hor -= 1
          drawPresent
        elsif Input.trigger?(Input::DOWN) && @index_ver < 1
          pbPlayCursorSE
          @index_ver += 1
          drawPresent
        elsif Input.trigger?(Input::UP) && @index_ver !=0
          pbPlayCursorSE
          @index_ver -= 1
          drawPresent
        elsif Input.trigger?(Input::USE)
          pbPlayCursorSE
          case @index_ver # please ignore this awful code
          when 0
            case @index_hor
            when 0
              selectBerry
            when 1
              selectMon
            when 2
              selectRepel
            end
          when 1
            case @index_hor
            when 0
              startSearch
            when 1
              pbPlayCloseMenuSE
              break
            when 2
              pbPlayCloseMenuSE
              break
            end
          end
        elsif Input.trigger?(Input::BACK)
          pbPlayCloseMenuSE
          break
        end
      end
    end
  end

  # selecting the correct berry
  def selectBerry
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      berry = screen.pbChooseItemScreen(Proc.new { |item| GameData::Item.get(item).is_berry? })
      @sprites["berry_icon"].item = berry
      if berry
        @sprites["berry_text"].text = description(berry)
        @sprites["berry_icon"].visible = true
      else
        @sprites["berry_text"].text = "Ajoutez une baie dans cet emplacement pour obtenir un effet secondaire."
        @sprites["berry_icon"].visible = false
      end
      @current_berry = berry
    }
    drawPresent
  end

  # returns the correct description
  def description(item)
    case item
    when :REPEL
      return _INTL("Grâce au Repousse, il y a une chance raisonnable de rencontre.")
    when :SUPERREPEL
      return _INTL("Grâce au Super Repousse, il y a une bonne chance de rencontre.")
    when :MAXREPEL
      return _INTL("Grâce au Max Repousse, les rencontres sont garanties.")
    when :LUMBERRY
      return _INTL("Les Baies Prine augmentent les chances de rencontrer des Pokémon avec un talent caché.")
    when :CHESTOBERRY, :CHERIBERRY, :PECHABERRY, :RAWSTBERRY, :PERSIMBERRY, :ASPEARBERRY
      return _INTL("Les {1} augmentent les chances de rencontrer des Pokémon atteints du Pokérus.", GameData::Item.get(item).name_plural)
    when :ORANBERRY
      return _INTL("Les Baies Oran augmentent légèrement les IV des Pokémon rencontrés.")
    when :SITRUSBERRY
      return _INTL("Les Baies Sitrus augmentent significativement les IV des Pokémon rencontrés.")
    when :LEPPABERRY
      return _INTL("Les Baies Mepo réduisent le niveau des Pokémon rencontrés.")
    when :FIGYBERRY
      return _INTL("Les Baies Figy augmentent fortement le niveau des Pokémon rencontrés.")
    when :LANSATBERRY
      return _INTL("Les Baies Lansat augmentent fortement les chances de Pokémon chromatiques.")
    when :ENIGMABERRY
      return _INTL("Les Baies Enigma augmentent les chances de rencontrer des Pokémon chromatiques.")
    else
      return _INTL("Les {1} augmentent le niveau des Pokémon rencontrés.", GameData::Item.get(item).name_plural)
    end
  end


  # selecting mons based on the encounter table
  def selectMon
    commands = []
    mons = []
    if !getEncData.nil?
      command_list = getEncData[0]
      @average_level = getEncData[1]
    end
    if !command_list.nil?
      command_list.each { |mon| mons.push(mon)}
      mons.each { |thismon| commands.push(GameData::Species.get(thismon).name)}
    end
    commands.push("Cancel")
    command = pbShowCommands(nil,commands,commands.length)
    @current_mon = nil
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    if commands[command] != "Cancel"
      pbDrawTextPositions(overlay,[[commands[command],Graphics.width/2,112,2,BASE_COLOR,SHADOW_COLOR]])
      @current_mon = mons[command]
    end
  end

  # selecting repels
  def selectRepel
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene,$bag)
      repel = screen.pbChooseItemScreen(Proc.new { |item| GameData::Item.get(item) == :REPEL || GameData::Item.get(item) == :SUPERREPEL || GameData::Item.get(item) == :MAXREPEL })
      @sprites["repel_icon"].item = repel
      if repel
        @sprites["repel_text"].text = description(repel)
        @sprites["repel_icon"].visible = true
      else
        @sprites["repel_text"].text = "Ajoutez un repousse dans cet emplacement pour augmenter les chances de rencontre."
        @sprites["repel_icon"].visible = false
      end
      @current_repel = repel
    }
    drawPresent
  end

  # checks all of the current parameters and initiates a battle if successful
  def startSearch
    if @current_mon.nil?
      pbPlayBuzzerSE()
      pbMessage("Sélectionnez un Pokémon pour lancer le scan.")
      return
    end
    if !$PokemonEncounters.encounter_possible_here? && ONLY_ON_ENCOUNTER_TILE
      pbPlayBuzzerSE()
      pbMessage("Vous ne pouvez scanner que dans une zone où des rencontres sont possibles.")
      return
    end

    base_level = @average_level
    level = base_level + rand(-2..2)
    if @current_berry == :LEPPABERRY
      level = [[level - 4, 1].max, 120].min
    elsif !@current_berry.nil? && ![:CHESTOBERRY, :CHERIBERRY, :PECHABERRY, :RAWSTBERRY, :PERSIMBERRY, :ASPEARBERRY, :LUMBERRY, :ORANBERRY, :SITRUSBERRY,:ENIGMABERRY].include?(@current_berry)
      level = [[level + 4, 1].max, 120].min
    elsif @current_berry.nil? == :FIGYBERRY
      level = [[level + 8, 1].max, 120].min
    end
    level = [[level, 120].min, 1].max
    $PokemonSystem.pokesearch_encounter = true
    odds = rand(0..100) < getRepelOdds
    if !@current_repel.nil?
      $bag.remove(@current_repel)
      @current_repel = nil
    end
    if !@current_berry.nil?
      $bag.remove(@current_berry)
      @current_berry = nil
    end
    pbEndScene
    waitingMessage = "\\se[Battle ball shake]...\\. \\se[Battle ball shake]...\\. \\se[Battle ball shake]...\\| "
    finalMessage = ""
    for i in 0..rand(1,2); finalMessage += waitingMessage; end
    pbMessage(_INTL("{1}\\wtnp[2]", finalMessage))
    if odds
      $scene.spriteset.addUserAnimation(Settings::EXCLAMATION_ANIMATION_ID, $game_player.x, $game_player.y, true, 3)
      #pbWait(20)
      # Vérifie si on est dans la zone Safari
      if $game_map.metadata&.has_flag?("Safari")
        # Système de rencontre spécifique Safari
        pbMessage("Un Pokémon apparaît!")
        pbSafariBattle(@current_mon, level)
        return
      end
      WildBattle.start(@current_mon, level)
    else
      pbMessage("No Pokémon appeared.")
    end
    $PokemonSystem.pokesearch_encounter = false
  end

  # in percentages
  def getRepelOdds
    case @current_repel
    when :REPEL
      return 50
    when :SUPERREPEL
      return 80
    when :MAXREPEL
      return 100
    end
    return 10
  end

  # update UI based on current status
  # thanks to ThatWelshOne
  def drawPresent
    $PokemonSystem.last_pokesearch_settings = [ @current_mon, @current_berry, @current_repel ]
    @sprites["repel_icon"].visible = !@current_repel.nil?
    @sprites["berry_icon"].visible = !@current_berry.nil?
    @sprites["sel_berry"].visible = false
    @sprites["sel_pokemon"].visible = false
    @sprites["sel_repel"].visible = false
    @sprites["sel_search"].visible = false
    @sprites["sel_cancel"].visible = false
    case @index_ver
    when 0
      case @index_hor
      when 0
        @sprites["sel_berry"].visible = true
      when 1
        @sprites["sel_pokemon"].visible = true
      when 2
        @sprites["sel_repel"].visible = true
      end
    when 1
      case @index_hor
      when 0
        @sprites["sel_search"].visible = true
      when 1
        @sprites["sel_cancel"].visible = true
      when 2
        @sprites["sel_cancel"].visible = true
        @index_hor = 1
      end
    end
  end

  def pbGetTimeOfDayEssentials
    timeNow = pbGetTimeNow
    return :Morning if PBDayNight.isMorning?(timeNow)
    return :Afternoon if PBDayNight.isAfternoon?(timeNow)
    return :Evening if PBDayNight.isEvening?(timeNow)
    return :Night if PBDayNight.isNight?(timeNow)
  end

  def pbGetEncounterType
    encounter_type = $PokemonEncounters.encounter_type
    case encounter_type
    when :Land, :LandMorning, :LandAfternoon, :LandEvening, :LandNight
      return :Land
    when :Water
      return :Water
    when :Cave, :CaveMorning, :CaveAfternoon, :CaveEvening, :CaveNight
      return :Cave
    when :Sand, :SandMorning, :SandAfternoon, :SandEvening, :SandNight
      return :Sand
    else
      return nil
    end
  end





  # get encounter data
  # again thanks to ThatWelshOne
  def getEncData
    return nil if @encounter_tables.nil?

    # Récupère l'heure actuelle de la journée (matin, après-midi, soir, nuit)
    time_of_day = pbGetTimeOfDayEssentials

    # Détermine la clé à utiliser en fonction de la zone et du moment de la journée
    currKey = nil
    encounter_type = pbGetEncounterType  # Vérifie le type de rencontre (herbe, eau, cave, sable, etc.)

    if encounter_type == :Land  # Si le joueur est dans l'herbe
      if @encounter_tables.has_key?(:Land)  # Vérifie si "Land" général existe
        currKey = :Land
      else
        case time_of_day  # Sélectionne en fonction du moment de la journée
        when :Morning
          currKey = :LandMorning if @encounter_tables.has_key?(:LandMorning)
        when :Afternoon
          currKey = :LandAfternoon if @encounter_tables.has_key?(:LandAfternoon)
        when :Evening
          currKey = :LandEvening if @encounter_tables.has_key?(:LandEvening)
        when :Night
          currKey = :LandNight if @encounter_tables.has_key?(:LandNight)
        end
      end
    elsif encounter_type == :Water  # Si le joueur est sur l'eau
      currKey = :Water if @encounter_tables.has_key?(:Water)
    elsif encounter_type == :Cave  # Si le joueur est dans une cave
      if @encounter_tables.has_key?(:Cave)
        currKey = :Cave
      else
        case time_of_day
        when :Morning
          currKey = :CaveMorning if @encounter_tables.has_key?(:CaveMorning)
        when :Afternoon
          currKey = :CaveAfternoon if @encounter_tables.has_key?(:CaveAfternoon)
        when :Evening
          currKey = :CaveEvening if @encounter_tables.has_key?(:CaveEvening)
        when :Night
          currKey = :CaveNight if @encounter_tables.has_key?(:CaveNight)
        end
      end
    elsif encounter_type == :Sand  # Si le joueur est dans une zone de sable
      if @encounter_tables.has_key?(:Sand)
        currKey = :Sand
      else
        case time_of_day
        when :Morning
          currKey = :SandMorning if @encounter_tables.has_key?(:SandMorning)
        when :Afternoon
          currKey = :SandAfternoon if @encounter_tables.has_key?(:SandAfternoon)
        when :Evening
          currKey = :SandEvening if @encounter_tables.has_key?(:SandEvening)
        when :Night
          currKey = :SandNight if @encounter_tables.has_key?(:SandNight)
        end
      end
    end

    if currKey.nil?
      pbMessage("L'utilisation de cet objet n'est pas possible ici.")
      return nil
    end

    # Maintenant on récupère les données associées à la clé trouvée
    arr = []
    min_levels = 0
    max_levels = 0
    enc_array = []

    # Remplit le tableau avec les espèces de Pokémon et leurs niveaux
    @encounter_tables[currKey].each { |s| arr.push(s[1]); min_levels += s[2]; max_levels += s[3] }

    # Récupère les espèces rencontrables
    GameData::Species.each { |s| enc_array.push(s.id) if arr.include?(s.id) }
    enc_array.uniq!

    # Calcule le niveau moyen des Pokémon
    # Calcule le niveau moyen des Pokémon
    average_level = arr.length > 0 ? ((min_levels + max_levels) / 2) / arr.length : 25  # Si arr.length = 0, on utilise 60 par défaut


    return enc_array, average_level
  end



  # get max encounters
  # again again thanks to ThatWelshOne
  def getMaxEncounters(data)
    keys = data.keys
    a = []
    for key in keys
      b = []
      arr = data[key]
      for i in 0...arr.length
        b.push( arr[i][1] )
      end
      a.push(b.uniq.length)
    end
    return a.max, keys.length
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @disposed = true
    @viewport.dispose
  end
end

class PokeSearch_Screen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbPokeSearch
    @scene.pbEndScene
  end
end

class PokemonSystem
  attr_accessor :last_pokesearch_settings # Array[current_mon, current_berry, current_repel]
  attr_accessor :pokesearch_encounter
  
	def last_pokesearch_settings
    @last_pokesearch_settings = [] if !@last_pokesearch_settings
		return @last_pokesearch_settings
  end

  def pokesearch_encounter
		return @pokesearch_encounter
  end
end