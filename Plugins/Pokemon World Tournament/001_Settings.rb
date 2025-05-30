module PWTSettings
# Information pertining to the start position on the PWT stage
# Format is as following: [map_id, map_x, map_y]
PWT_MAP_DATA = [142,21,14]
# ID for the event used to move the player and opponents on the map
PWT_MOVE_EVENT = 37
# ID of the opponent event
PWT_OPP_EVENT = 35
# ID of the scoreboard event
PWT_SCORE_BOARD_EVENT = 34
# ID of the lobby trainer event
PWT_LOBBY_EVENT = 3
# ID of the event used to display an optional even if the player wins the PWT
PWT_FANFARE_EVENT = 38
# If marked as true, it will apply a multiplier based on the player's current win streak. Defeault to false.
PWT_STREAK_MULT = false
# If marked as true, it will use DeltaTime, otherwise, it will use the old frame system
PWT_USE_DELTA_TIME = false
# Target framerate. By default it's usually 60 fps with MKXP-Z.
PWT_DEFAULT_FRAMERATE = 60
end

module GameData
  class PWTTournament
    attr_reader :id
    attr_reader :real_name
    attr_reader :trainers
    attr_reader :condition_proc
	  attr_reader :points_won

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id             = hash[:id]
      @real_name      = hash[:name]          || "Unnamed"
      @trainers       = hash[:trainers]
      @condition_proc = hash[:condition_proc]
      @rules_proc     = hash[:rules_proc]
      @banned_proc    = hash[:banned_proc]
	  @points_won     = hash[:points_won]    || 3
    end

    # @return [String] the translated name of this nature
    def name
      return _INTL(@real_name)
    end
    
    def call_condition(*args)
      return (@condition_proc) ? @condition_proc.call(*args) : true
    end
    def call_rules(*args)
      return (@rules_proc) ? @rules_proc.call(*args) : PokemonChallengeRules.new
    end
    def call_ban_reason(*args)
      return (@banned_proc) ? @banned_proc.call(*args) : nil
    end
  end
end

##################################################################
# The format for defining individual Tournaments is as follows.
##################################################################
=begin
GameData::PWTTournament.register({
  :id => :Tutorial_Tournament,			# Internal name of the Tournament to be called
  :name => _INTL("Kanto Leaders"),		# Display name of the Tournament in the choice selection box
  :trainers => [						# Array that contains all of the posssible trainers in a Tournament. Must have at least 8.
                [:ID,"Trainer Name","Player Victory Dialogue.","Player Lose Dialogue.",Variant Number,"Lobby Dialogue.","Pre-Battle Dialogue.","Post-Battle Dialogue"], # Trainer 1
				[:ID,"Trainer Name","Player Victory Dialogue.","Player Lose Dialogue.",Variant Number,"Lobby Dialogue.","Pre-Battle Dialogue.","Post-Battle Dialogue"]  # Trainer 2, etc
			   ],
										# Trainers follow this exact format. 
										# ID and Trainer Name are mandatory.
										# Victory dialogue will default to "..." if not filled.
										# Lose dialogue will default to "..." is not filled in either here or trainers.txt. If Lose dialogue is filled here, it overrides the defined line from trainers.txt
										# Variant Number will default to 0 if not filled.
										# If there is no Lobby Dialogue they will not appear in the Lobby map
										# Pre- and Post-battle Dialogue is optional and will display nothing if not filled.
  :condition_proc => proc { 			# The conditions under which this Tournament shows up in the choice selection box. Optional.
	next $PokemonGlobal.hallOfFameLastNumber > 0 
  },					
  :rules_proc => proc {|length|			# This defines the rules for the rules for an individual tournament. More rules can be found in the Challenge Rules script sections
	rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:LANDORUS,:MELOETTA,
                                                      :KELDEO,:GENESECT))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
	next rules
  },
  :banned_proc => proc {				# Displays a message when a team is ineligable to be used in a tournament.
	pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2						# A configurable amount of Battle Points won after a tournament.
})
=end
##################################################################

GameData::PWTTournament.register({
  :id => :Kanto_Leaders,
  :name => _INTL("Managarm Team A"),
  :trainers => [
                [:CHAMPION5,"Panda","T'as encore percé ma défense... T'es vraiment pas un gamin ordinaire.",
                  "Pas mal... Mais pas encore assez pour me faire plier.\nOn remet ça quand tu veux.",
                  2,
                  "T'es revenu, hein ? J'attendais ce moment.\nMais ici, c’est pas comme chez moi. J’te laisserai rien passer.",
                  "Voyons si tu peux encaisser un combat pur et dur cette fois ci !",
                  "Panda : Bien joué. Même ici, t’arrives à faire trembler les murs.\nT’oublie pas d’où tu viens, et ça, j’respecte."],
                [:MISTRO,"Mistro","Wesh ?! \nTa progresser de Zinzin.","On dirait que de nous deux, c'est moi qui ai été le meilleur Dresseur.",2,"Je vais m'entraîner encore plus dur pour pouvoir te battre la prochaine fois !"],
                [:WATERHAZE,"WaterHaze","Wesh ?! \nTa progresser de Zinzin.","Tout le monde ne peut pas me battre.",2,"Je suis tellement excité !"],
                [:QUENTIN,"Quentin","Wesh ?! \nTa progresser de Zinzin.","Continue à t'entrainer...",2,"Mes Pokémon se sont épanouis depuis qu'ils t'ont affronté."],
                [:CHAMPION3,"Chrisys","Wesh ?! \nTa progresser de Zinzin.","Continue à t'entrainer...",2,"Le futur me parle de notre revanche"],
                [:CHAMPI,"Champi",
                 "J’avoue, t’as assuré. Même moi, j’aurais rien pu faire…\nT’as gagné le droit de te la péter. Juste un peu.",
                 "Héhé… Garde bien ça en tête. Parce que la prochaine fois, je t’écrase.",
                 4,
                 "Ah, c’est toi ? Parfait. J’aime quand c’est pas trop facile.",
                 "Me revoilà ! Champi ! Mais oublie pas que je suis là pour tout rafler.",
                 "Champi : Bien joué. T’as mérité ta victoire… cette fois.\nMais souviens-toi : je ne perds jamais deux fois."],
                [:TRAINER_TAKA,"Takaku",
                 "WOUH ! Ce combat était digne d’un final de manga !\nT’as mis le feu, p’tit ! Même moi j’me suis fait surprendre.",
                 "Pas mal du tout... Mais c’est pas fini, t’entends ?! J’vais m’entraîner avec Zoro et je reviens te découper en 108 tranches.",
                 3,
                 "Yo ! T’as vu Luffy ? Moi non plus, mais j’suis prêt à tout pour lui péter la gueule si ça peut te faire progresser.",
                 "Takaku King, ancien Maître. Fan de One Piece, mais surtout fan de baston.\nT’es prêt à vivre un arc épique, ou pas ?",
                 "Takaku : Héhé, t’as progressé... Mais t’es encore loin d’être un empereur !\nAllez, continue comme ça, futur Roi des Dresseurs."],

               #### [:GARDE,"Giovanni","What? \nMe, lose?!","I could have never lost to a kid like you!",1],
                [:TRAINER_SHEENA,"Sheena",
                 "Je savais que tu étais fort… mais là, tu m’as carrément dépassée.\nContinue comme ça. Le monde a besoin de dresseurs comme toi.",
                 "T’as gagné cette fois… mais moi, j’abandonne jamais.\nJe reviendrai, plus prête que jamais.",
                 2,
                 "Tu sais que je déteste perdre, hein ? Alors prépare-toi, je compte bien te pousser dans tes retranchements.",
                 "Sheena. Si t’es là, c’est que t’as encore soif de progrès.\nParfait. Moi aussi.",
                 "Sheena : C'était intense. Comme toujours avec toi.\nUn jour, on se battra côte à côte pour de bon… Mais aujourd’hui, c’est chacun pour soi."]

               ],
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:LANDORUS,:MELOETTA,
                                                      :KELDEO,:GENESECT))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(100))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 3
})