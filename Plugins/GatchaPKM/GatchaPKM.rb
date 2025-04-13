#===============================================================================
# Plugin Gatcha Pokémon - GatchaPKM v0.1
# Créé par : Champi
# Version : 0.1
# Compatible avec : Pokémon Essentials v21.1
#===============================================================================

module GatchaPKM
  # Configuration des Pokémon et des taux pour chaque ticket
  GATCHA_LIST = {
    :TICKETBASE => {
      :pokemons => [
        # Génération 1 - Pokémon communs
        { name: :CATERPIE, rate: 80 },
        { name: :WEEDLE, rate: 80 },
        { name: :PIDGEY, rate: 80 },
        # Génération 2 - Pokémon communs
        { name: :SENTRET, rate: 80 },
        { name: :HOPPIP, rate: 80 },
        { name: :LEDYBA, rate: 80 },
        # Génération 3 - Pokémon communs
        { name: :ZIGZAGOON, rate: 80 },
        { name: :WURMPLE, rate: 80 },
        { name: :LOTAD, rate: 80 },
        # Génération 4 - Pokémon communs
        { name: :STARLY, rate: 80 },
        { name: :KRICKETOT, rate: 80 },
        { name: :BIDOOF, rate: 80 },
        # Génération 5 - Pokémon communs
        { name: :PATRAT, rate: 80 },
        { name: :SEWADDLE, rate: 80 },
        { name: :PIDOVE, rate: 80 },
        # Génération 6 - Pokémon communs
        { name: :FLETCHLING, rate: 80 },
        { name: :BUNNELBY, rate: 80 },
        { name: :Scatterbug, rate: 80 },
        # Génération 7 - Pokémon communs
        { name: :PIKIPEK, rate: 80 },
        { name: :YUNGOOS, rate: 80 },
        { name: :GRUBBIN, rate: 80 },
        # Génération 8 - Pokémon communs
        { name: :ROOKIDEE, rate: 80 },
        { name: :SKWOVET, rate: 80 },
        { name: :BLIPBUG, rate: 80 },
        # Génération 9 - Pokémon communs
        { name: :LECHONK, rate: 80 },
        { name: :TAROUNTULA, rate: 80 },
        { name: :NACLI, rate: 80 },

        # Génération 1 - Pokémon moins communs
        { name: :RATTATA, rate: 15 },
        { name: :ZUBAT, rate: 15 },
        # Génération 2 - Pokémon moins communs
        { name: :SPINARAK, rate: 15 },
        { name: :MAREEP, rate: 15 },
        # Génération 3 - Pokémon moins communs
        { name: :TAILLOW, rate: 15 },
        { name: :SHROOMISH, rate: 15 },
        # Génération 4 - Pokémon moins communs
        { name: :SHINX, rate: 15 },
        { name: :BUDEW, rate: 15 },
        # Génération 5 - Pokémon moins communs
        { name: :BLITZLE, rate: 15 },
        { name: :SWADLOON, rate: 15 },
        # Génération 6 - Pokémon moins communs
        { name: :LITLEO, rate: 15 },
        { name: :FLABEBE, rate: 15 },
        # Génération 7 - Pokémon moins communs
        { name: :ORICORIO, rate: 15 },
        { name: :CRABRAWLER, rate: 15 },
        # Génération 8 - Pokémon moins communs
        { name: :NICKIT, rate: 15 },
        { name: :ROLYCOLY, rate: 15 },
        # Génération 9 - Pokémon moins communs
        { name: :SHROODLE, rate: 15 },
        { name: :SMOLIV, rate: 15 }
      ],
      :reward_type => :pokemon, # :pokemon, ou :egg
      :level => 5,
      :shiny => 2048
    },
    :TICKETARGENT => {
      :pokemons => [
        # Génération 1 - Pokémon moins communs
        { name: :PARAS, rate: 50 },
        { name: :SANDSHREW, rate: 50 },
        # Génération 2 - Pokémon moins communs
        { name: :SNUBBULL, rate: 50 },
        { name: :SLUGMA, rate: 50 },
        # Génération 3 - Pokémon moins communs
        { name: :ELECTRIKE, rate: 50 },
        { name: :TRAPINCH, rate: 50 },
        # Génération 4 - Pokémon moins communs
        { name: :COMBEE, rate: 50 },
        { name: :GIBLE, rate: 50 },
        # Génération 5 - Pokémon moins communs
        { name: :JOLTIK, rate: 50 },
        { name: :SANDILE, rate: 50 },
        # Génération 6 - Pokémon moins communs
        { name: :ESPURR, rate: 50 },
        { name: :PANCHAM, rate: 50 },
        # Génération 7 - Pokémon moins communs
        { name: :WIMPOD, rate: 50 },
        { name: :MUDSBRAY, rate: 50 },
        # Génération 8 - Pokémon moins communs
        { name: :CHEWTLE, rate: 50 },
        { name: :GOSSIFLEUR, rate: 50 },
        # Génération 9 - Pokémon moins communs
        { name: :TINKATINK, rate: 50 },
        { name: :CHARCADET, rate: 50 }
      ],
      :reward_type => :pokemon,# :pokemon,ou :egg
      :level => 10,
      :shiny => 2048
    },
    :TICKETDORE => {
      :pokemons => [
        # Génération 1 - Starters (œufs)
        { name: :BULBASAUR, rate: 80 },
        { name: :CHARMANDER, rate: 80 },
        { name: :SQUIRTLE, rate: 80 },
        # Génération 2 - Starters (œufs)
        { name: :CHIKORITA, rate: 80 },
        { name: :CYNDAQUIL, rate: 80 },
        { name: :TOTODILE, rate: 80 },
        # Génération 3 - Starters (œufs)
        { name: :TREECKO, rate: 80 },
        { name: :TORCHIC, rate: 80 },
        { name: :MUDKIP, rate: 80 },
        # Génération 4 - Starters (œufs)
        { name: :TURTWIG, rate: 80 },
        { name: :CHIMCHAR, rate: 80 },
        { name: :PIPLUP, rate: 80 },
        # Génération 5 - Starters (œufs)
        { name: :SNIVY, rate: 80 },
        { name: :TEPIG, rate: 80 },
        { name: :OSHAWOTT, rate: 80 },
        # Génération 6 - Starters (œufs)
        { name: :CHESPIN, rate: 80 },
        { name: :FENNEKIN, rate: 80 },
        { name: :FROAKIE, rate: 80 },
        # Génération 7 - Starters (œufs)
        { name: :ROWLET, rate: 80 },
        { name: :LITTEN, rate: 80 },
        { name: :POPPLIO, rate: 80 },
        # Génération 8 - Starters (œufs)
        { name: :GROOKEY, rate: 80 },
        { name: :SCORBUNNY, rate: 80 },
        { name: :SOBBLE, rate: 80 },
        # Génération 9 - Starters (œufs)
        { name: :SPRIGATITO, rate: 80 },
        { name: :FUECOCO, rate: 80 },
        { name: :QUAXLY, rate: 80 },

        # Pokémon moins communs par génération
        # Génération 1
        { name: :PIKACHU, rate: 15 },
        { name: :EVEE, rate: 15 },
        # Génération 2
        { name: :TOGEPI, rate: 15 },
        { name: :IGGLYBUFF, rate: 15 },
        # Génération 3
        { name: :MAKUHITA, rate: 15 },
        { name: :ROSELIA, rate: 15 },
        # Génération 4
        { name: :RIOLU, rate: 15 },
        { name: :MUNCHLAX, rate: 15 },
        # Génération 5
        { name: :EMOLGA, rate: 15 },
        { name: :ZORUA, rate: 15 },
        # Génération 6
        { name: :FLABEBE, rate: 15 },
        { name: :HONEDGE, rate: 15 },
        # Génération 7
        { name: :WIMPOD, rate: 15 },
        { name: :MIMIKYU, rate: 15 },
        # Génération 8
        { name: :MORPEKO, rate: 15 },
        { name: :APPLIN, rate: 15 },
        # Génération 9
        { name: :TINKATINK, rate: 15 },
        { name: :CHARCADET, rate: 15 }
      ],
      :reward_type => :egg # Tous les starters apparaîtront sous forme d'œufs
    },
    :TICKETDIAMANT => {
    :pokemons => [
      # 5% - Pokémon communs (3 Pokémon très courants par génération)
      { name: :PIDGEY, rate: 5 },        # Génération 1
      { name: :WEEDLE, rate: 5 },       # Génération 1
      { name: :RATTATA, rate: 5 },      # Génération 1
      { name: :SENTRET, rate: 5 },      # Génération 2
      { name: :HOPPIP, rate: 5 },       # Génération 2
      { name: :LEDYBA, rate: 5 },       # Génération 2
      { name: :ZIGZAGOON, rate: 5 },    # Génération 3
      { name: :WURMPLE, rate: 5 },      # Génération 3
      { name: :TAILLOW, rate: 5 },      # Génération 3
      { name: :BIDOOF, rate: 5 },       # Génération 4
      { name: :KRICKETOT, rate: 5 },    # Génération 4
      { name: :STARLY, rate: 5 },       # Génération 4
      { name: :PATRAT, rate: 5 },       # Génération 5
      { name: :LILLIPUP, rate: 5 },     # Génération 5
      { name: :PIDOVE, rate: 5 },       # Génération 5
      { name: :FLETCHLING, rate: 5 },   # Génération 6
      { name: :BUNNELBY, rate: 5 },     # Génération 6
      { name: :SCATTERBUG, rate: 5 },   # Génération 6
      { name: :PIKIPEK, rate: 5 },      # Génération 7
      { name: :YUNGOOS, rate: 5 },      # Génération 7
      { name: :GRUBBIN, rate: 5 },      # Génération 7
      { name: :ROOKIDEE, rate: 5 },     # Génération 8
      { name: :SKWOVET, rate: 5 },      # Génération 8
      { name: :BLIPBUG, rate: 5 },      # Génération 8
      { name: :LECHONK, rate: 5 },      # Génération 9
      { name: :TAROUNTULA, rate: 5 },   # Génération 9
      { name: :NACLI, rate: 5 },        # Génération 9

      # 15% - Starters aléatoires (1 par génération)
      { name: :CHARMANDER, rate: 15 },  # Génération 1
      { name: :TOTODILE, rate: 15 },    # Génération 2
      { name: :TREECKO, rate: 15 },     # Génération 3
      { name: :TURTWIG, rate: 15 },     # Génération 4
      { name: :SNIVY, rate: 15 },       # Génération 5
      { name: :FENNEKIN, rate: 15 },    # Génération 6
      { name: :ROWLET, rate: 15 },      # Génération 7
      { name: :SCORBUNNY, rate: 15 },   # Génération 8
      { name: :SPRIGATITO, rate: 15 },  # Génération 9

      # 30% - Pokémon peu communs (3 par génération)
      { name: :VULPIX, rate: 30 },      # Génération 1
      { name: :ABRA, rate: 30 },        # Génération 1
      { name: :GROWLITHE, rate: 30 },   # Génération 1
      { name: :TOGEPI, rate: 30 },      # Génération 2
      { name: :SLUGMA, rate: 30 },      # Génération 2
      { name: :MAREEP, rate: 30 },      # Génération 2
      { name: :ELECTRIKE, rate: 30 },   # Génération 3
      { name: :ROSELIA, rate: 30 },     # Génération 3
      { name: :SWABLU, rate: 30 },      # Génération 3
      { name: :COMBEE, rate: 30 },      # Génération 4
      { name: :SHINX, rate: 30 },       # Génération 4
      { name: :BUDEW, rate: 30 },       # Génération 4
      { name: :JOLTIK, rate: 30 },      # Génération 5
      { name: :SANDILE, rate: 30 },     # Génération 5
      { name: :ZORUA, rate: 30 },       # Génération 5
      { name: :LITLEO, rate: 30 },      # Génération 6
      { name: :FLABEBE, rate: 30 },     # Génération 6
      { name: :SKIDDO, rate: 30 },      # Génération 6
      { name: :WIMPOD, rate: 30 },      # Génération 7
      { name: :MIMIKYU, rate: 30 },     # Génération 7
      { name: :FOMANTIS, rate: 30 },    # Génération 7
      { name: :NICKIT, rate: 30 },      # Génération 8
      { name: :ROLYCOLY, rate: 30 },    # Génération 8
      { name: :APPLIN, rate: 30 },      # Génération 8
      { name: :TINKATINK, rate: 30 },   # Génération 9
      { name: :SHROODLE, rate: 30 },    # Génération 9
      { name: :CHARCADET, rate: 30 },   # Génération 9

      # 45% - Pokémon assez rares (2 par génération)
      { name: :SNORLAX, rate: 45 },     # Génération 1
      { name: :CHANSEY, rate: 45 },     # Génération 1
      { name: :LANTURN, rate: 45 },     # Génération 2
      { name: :PHANPY, rate: 45 },      # Génération 2
      { name: :ALTARIA, rate: 45 },     # Génération 3
      { name: :BRELOOM, rate: 45 },     # Génération 3
      { name: :LUXRAY, rate: 45 },      # Génération 4
      { name: :DRIFBLIM, rate: 45 },    # Génération 4
      { name: :EXCADRILL, rate: 45 },   # Génération 5
      { name: :KROOKODILE, rate: 45 },  # Génération 5
      { name: :PYROAR, rate: 45 },      # Génération 6
      { name: :GOOMY, rate: 45 },       # Génération 6
      { name: :VIKAVOLT, rate: 45 },    # Génération 7
      { name: :TSAREENA, rate: 45 },    # Génération 7
      { name: :HATTERENE, rate: 45 },   # Génération 8
      { name: :GRIMMSNARL, rate: 45 },  # Génération 8
      { name: :CETITAN, rate: 45 },     # Génération 9
      { name: :DACHBUN, rate: 45 },     # Génération 9

      # 5% - Pokémon rares (1 par génération)
      { name: :DRATINI, rate: 5 },      # Génération 1
      { name: :LARVITAR, rate: 5 },     # Génération 2
      { name: :BAGON, rate: 5 },        # Génération 3
      { name: :GIBLE, rate: 5 },        # Génération 4
      { name: :DEINO, rate: 5 },        # Génération 5
      { name: :GOOMY, rate: 5 },        # Génération 6
      { name: :JANGMO_O, rate: 5 },     # Génération 7
      { name: :DREEPY, rate: 5 },       # Génération 8
      { name: :FRIGIBAX, rate: 5 }      # Génération 9
    ],
    :reward_type => :pokemon,
    :level => 20,
    :shiny => 1024
  },
    :TICKETLEGENDAIRE => {
      :pokemons => [
        # Génération 1
        { name: :ARTICUNO, rate: 43 },
        { name: :ZAPDOS, rate: 43 },
        { name: :MOLTRES, rate: 43 },
        { name: :MEWTWO, rate: 5 },
        { name: :MEW, rate: 38 },

        # Génération 2
        { name: :RAIKOU, rate: 43 },
        { name: :ENTEI, rate: 43 },
        { name: :SUICUNE, rate: 43 },
        { name: :LUGIA, rate: 4 },
        { name: :HOOH, rate: 4 },
        { name: :CELEBI, rate: 38 },

        # Génération 3
        { name: :REGIROCK, rate: 43 },
        { name: :REGICE, rate: 43 },
        { name: :REGISTEEL, rate: 43 },
        { name: :LATIAS, rate: 38 },
        { name: :LATIOS, rate: 38 },
        { name: :KYOGRE, rate: 20 },
        { name: :GROUDON, rate: 20 },
        { name: :RAYQUAZA, rate: 4 },
        { name: :JIRACHI, rate: 38 },
        { name: :DEOXYS, rate: 38 },

        # Génération 4
        { name: :UXIE, rate: 43 },
        { name: :MESPRIT, rate: 43 },
        { name: :AZELF, rate: 43 },
        { name: :DIALGA, rate: 4 },
        { name: :PALKIA, rate: 4 },
        { name: :GIRATINA, rate: 4 },
        { name: :HEATRAN, rate: 38 },
        { name: :REGIGIGAS, rate: 20 },
        { name: :CRESSELIA, rate: 38 },
        { name: :MANAPHY, rate: 38 },
        { name: :PHIONE, rate: 66 },
        { name: :DARKRAI, rate: 38 },
        { name: :SHAYMIN, rate: 38 },
        { name: :ARCEUS, rate: 4 },

        # Génération 5
        { name: :VICTINI, rate: 38 },
        { name: :COBALION, rate: 43 },
        { name: :TERRAKION, rate: 43 },
        { name: :VIRIZION, rate: 43 },
        { name: :TORNADUS, rate: 43 },
        { name: :THUNDURUS, rate: 43 },
        { name: :RESHIRAM, rate: 4 },
        { name: :ZEKROM, rate: 4 },
        { name: :LANDORUS, rate: 38 },
        { name: :KYUREM, rate: 20 },
        { name: :KELDEO, rate: 43 },
        { name: :MELOETTA, rate: 38 },
        { name: :GENESECT, rate: 38 },

        # Génération 6
        { name: :XERNEAS, rate: 4 },
        { name: :YVELTAL, rate: 4 },
        { name: :ZYGARDE, rate: 10 },
        { name: :DIANCIE, rate: 38 },
        { name: :HOOPA, rate: 38 },
        { name: :VOLCANION, rate: 38 },

        # Génération 7
        { name: :TAPU_KOKO, rate: 50 },
        { name: :TAPU_LELE, rate: 50 },
        { name: :TAPU_BULU, rate: 50 },
        { name: :TAPU_FINI, rate: 50 },
        { name: :COSMOG, rate: 66 },
        { name: :COSMOEM, rate: 66 },
        { name: :SOLGALEO, rate: 4 },
        { name: :LUNALA, rate: 4 },
        { name: :NECROZMA, rate: 4 },
        { name: :MAGEARNA, rate: 38 },
        { name: :MARSHADOW, rate: 38 },
        { name: :ZERAORA, rate: 38 },

        # Génération 8
        { name: :ZACIAN, rate: 4 },
        { name: :ZAMAZENTA, rate: 4 },
        { name: :ETERNATUS, rate: 10 },
        { name: :KUBFU, rate: 66 },
        { name: :URSHIFU, rate: 43 },
        { name: :ZARUDE, rate: 38 },
        { name: :REGIELEKI, rate: 43 },
        { name: :REGIDRAGO, rate: 43 },
        { name: :GLASTRIER, rate: 43 },
        { name: :SPECTRIER, rate: 43 },
        { name: :CALYREX, rate: 61 },

        # Génération 9
        { name: :KORAIDON, rate: 20 },
        { name: :MIRAIDON, rate: 20 },
        { name: :TINGLU, rate: 50 },
        { name: :CHIENPAO, rate: 50 },
        { name: :WOCHIEN, rate: 50 },
        { name: :CHIYU, rate: 50 }
      ],
      :reward_type => :pokemon,
      :level => 50,
      :shiny => 1024
    },
    :TICKETCHIMERE => {
      :pokemons => [
        # 20% - Ultra-Chimères relativement communes
        { name: :NIHILEGO, rate: 20 },
        { name: :BUZZWOLE, rate: 20 },
        { name: :PHEROMOSA, rate: 20 },
        { name: :XURKITREE, rate: 20 },
        { name: :KARTANA, rate: 20 },

        # 10% - Ultra-Chimères rares
        { name: :CELESTEELA, rate: 10 },
        { name: :GUZZLORD, rate: 10 },
        { name: :POIPOLE, rate: 10 },

        # 5% - Ultra-Chimères très rares
        { name: :NAGANADEL, rate: 5 },
        { name: :BLACEPHALON, rate: 5 },
        { name: :STAKATAKA, rate: 5 }
      ],
      :reward_type => :pokemon,# Les récompenses sont des Pokémon directement (pas en œuf)
      :level => 50,
      :shiny => 1024
    },
    :TICKETFUSION => {
      :pokemons => [
        { name: :FOUICIRE, rate: 100 },
        { name: :GOUSAL, rate: 100 },
        { name: :MAGNERI, rate: 100 },
        { name: :SONGMA, rate: 100 },
        { name: :TENABRI, rate: 100 },
        { name: :MANTARIA, rate: 100 },
        { name: :NOCTUCUS, rate: 100 },
        { name: :REMOSEED, rate: 100 },
        { name: :CAGRIN, rate: 100 },
        { name: :CRAMALIN, rate: 100 },
        { name: :LAGIACRUS, rate: 100 },
        { name: :OMINSINGE, rate: 100 },
        { name: :RATCRAFT, rate: 100 },
        { name: :BRANDATE, rate: 100 },
        { name: :DRACOLORE, rate: 100 },
        { name: :PTICOUP, rate: 100 },
        { name: :LAWATIN, rate: 100 },
        { name: :CHAPI, rate: 100 },
        { name: :PLUMIBRIS, rate: 100 },
        { name: :URINEE, rate: 100 },
        { name: :TRAGIKARP, rate: 100 },
        { name: :DYNAMANT, rate: 100 },
        { name: :ALKAALITE, rate: 100 },
        { name: :BADBUG, rate: 100 },
        { name: :PIX, rate: 100 },
        { name: :HAUNTGLASS, rate: 100 },
        { name: :DROBSON, rate: 100 },
        { name: :MERRI, rate: 100 },
        { name: :CANCOYOTTE, rate: 100 },
        { name: :RISKARD, rate: 100 },
        { name: :RISKARD_1, rate: 100 },
        { name: :RISKARD_2, rate: 100 },
        { name: :RISKARD_3, rate: 100 },
        { name: :BALIGID, rate: 100 },
        { name: :BALOONE, rate: 100 },
        { name: :FANHERBE, rate: 100 },
        { name: :TRIPULZ, rate: 100 },
        { name: :PYROQUET, rate: 100 }

        


      ],
    :reward_type => :pokemon,# Donne directement le Pokémon
    :level => 25,
    :shiny => 256
  },
    :TICKETSURPRISE => {
      :pokemons => nil, # Pas de liste prédéfinie, sera généré dynamiquement
      :reward_type => :pokemon, # La récompense est un Pokémon directement
      :level => 40,
      :shiny => 512
    }
  }

  # Adaptation du système de gatcha pour TICKETSURPRISE
  def self.reward_random_pokemon
    # Récupère tous les IDs valides dans GameData::Species
    valid_ids = GameData::Species.keys
    
    # Tire un Pokémon aléatoire parmi les IDs valides
    random_id = valid_ids.sample
    
    return random_id # Retourne l'ID (symbole) du Pokémon
  end



  # Fonction principale pour lancer le Gatcha
  def self.start
    ticket = select_ticket
    return unless ticket

    selected_pokemon = draw_pokemon(ticket)
    if selected_pokemon
      reward_player(selected_pokemon, ticket)
    else
      pbMessage(_INTL("Aucun Pokémon obtenu. Réessayez !"))
    end
  end

  # Affiche les tickets disponibles dans le sac
  def self.select_ticket
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, $bag)
      # Affiche l'écran du sac et filtre les objets de type ticket (optionnel, peut être ajusté)
      ticket = screen.pbChooseItemScreen(Proc.new { |item| GATCHA_LIST.keys.include?(item) }) 
      if ticket.nil?
        pbMessage(_INTL("Vous n'avez sélectionné aucun objet."))
        return nil
      end
      if !GATCHA_LIST.keys.include?(ticket)
        pbMessage(_INTL("Cet objet ne peut pas être utilisé dans le Gatcha."))
        return nil
      end


      # 4. Retire 1 ticket du sac (ou objet dans ce cas)
      $bag.remove(ticket, 1) 
      return ticket
    }
  end


  # Effectue le tirage au sort parmi les Pokémon possibles pour le ticket
  def self.draw_pokemon(ticket)
    # Vérifie que le ticket existe dans GATCHA_LIST
    unless GATCHA_LIST[ticket]
      pbMessage(_INTL("Erreur : Le ticket sélectionné ne fait pas partie du Gatcha."))
      return nil
    end

    # Gestion spéciale pour TICKETSURPRISE
    if ticket == :TICKETSURPRISE
      return reward_random_pokemon # Génère un Pokémon aléatoire entre 1 et 1000
    end

    # Récupère la liste des Pokémon pour le ticket
    pool = GATCHA_LIST[ticket][:pokemons]

    # Vérifie si la liste est valide
    if pool.nil? || pool.empty?
      pbMessage(_INTL("Erreur : Aucun Pokémon disponible pour ce ticket."))
      return nil
    end

    # Calcule le total des taux de drop
    total_rate = pool.sum { |p| p[:rate] }

    # Effectue un tirage aléatoire basé sur les taux de drop
    roll = rand(total_rate)
    current_rate = 0

    # Parcourt la liste pour déterminer quel Pokémon est tiré
    pool.each do |entry|
      current_rate += entry[:rate]
      return entry[:name] if roll < current_rate
    end

    nil # Si aucun Pokémon n'est obtenu (ne devrait jamais arriver)
  end


  # Donne le Pokémon ou l'œuf au joueur
  def self.reward_player(pokemon, ticket)
    play_gatcha_animation(pokemon, ticket)
    reward_type = GATCHA_LIST[ticket][:reward_type]
    level = GATCHA_LIST[ticket][:level] || 5 # Niveau par défaut : 5
    shiny_chance = GATCHA_LIST[ticket][:shiny]
    is_shiny = shiny_chance && rand(shiny_chance) == 0
    
    if reward_type == :pokemon
      pkmn = Pokemon.new(pokemon, level)
      pkmn.shiny = is_shiny # Définit si le Pokémon est shiny
      pbAddPokemon(pkmn) 
      shiny_message = is_shiny ? _INTL(" shiny") : ""
      pbMessage(_INTL("Félicitations ! Vous avez obtenu un {2} {1} !", shiny_message, GameData::Species.get(pokemon).name, level))
    
    elsif reward_type == :egg
      # 1. Crée l'œuf en utilisant la méthode `create_egg`
      egg = create_egg(pokemon)
      
      # 2. Vérifie si l'équipe du joueur est pleine
      if $player.party_full?
        pbMessage(_INTL("Votre équipe est pleine. L'œuf a été envoyé au PC !", GameData::Species.get(pokemon).name))
        pbStorePokemon(egg) # Envoie l'œuf au PC
      else
        # Équipe non pleine, ajoute l'œuf à l'équipe
        $player.party.push(egg)
        pbMessage(_INTL("Félicitations ! Vous avez obtenu un œuf !", GameData::Species.get(pokemon).name))
      end
    end
  end

def self.play_gatcha_animation(pokemon, ticket)
  # 1. Crée une nouvelle scène graphique
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999 # Assurez-vous qu'il est au-dessus de tout
  sprites = {}

  # 2. Affiche le fond (hatch_bg.png) depuis Graphics/UI
  sprites["background"] = Sprite.new(viewport)
  sprites["background"].bitmap = RPG::Cache.load_bitmap("Graphics/UI/", "hatch_bg")
  sprites["background"].opacity = 0 # Commence transparent

  # 3. Configure le Pokémon ou l'œuf
  sprites["pokemon"] = PokemonSprite.new(viewport)
  shiny = false # Par défaut, pas shiny

  if GATCHA_LIST[ticket][:reward_type] == :egg
    # Affiche un sprite d'œuf générique
    sprites["pokemon"].bitmap = RPG::Cache.load_bitmap("Graphics/Pokemon/Eggs/", "000")
  else
    # Crée le Pokémon et configure son animation
    full_pokemon = Pokemon.new(pokemon, 5) # Niveau par défaut : 5
    if rand(GATCHA_LIST[ticket][:shiny] || Float::INFINITY) == 0
      full_pokemon.makeShiny # Rend le Pokémon shiny
      shiny = true
    end
    sprites["pokemon"].setPokemonBitmap(full_pokemon) # Utilise Animated Pokémon System si disponible
  end

  # 4. Configure l'apparence du Pokémon/œuf
  sprites["pokemon"].x = Graphics.width / 2
  sprites["pokemon"].y = Graphics.height / 2 + 40
  sprites["pokemon"].ox = sprites["pokemon"].bitmap.width / 2
  sprites["pokemon"].oy = sprites["pokemon"].bitmap.height / 2
  sprites["pokemon"].opacity = 0 # Pokémon invisible au début
  sprites["pokemon"].zoom_x = 0.1 # Échelle initiale (petit)
  sprites["pokemon"].zoom_y = 0.1

  # 6. Joue le son associé au ticket
  ticket_me = "ticket_base" # Son par défaut
  pbMEPlay(ticket_me)

  # 7. Effet de flash rapide
  flash = Sprite.new(viewport)
  flash.bitmap = Bitmap.new(Graphics.width, Graphics.height)
  flash.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(255, 255, 255))
  flash.opacity = 0
  pbSEPlay("Flash") # Joue le son de flash

  # Animation du flash rapide
  40.times do
    flash.opacity += 25 # Rend le flash visible
    Graphics.update
    Input.update
  end

  # 8. Animation d'affichage (fond et Pokémon avec flash)
  150.times do
    flash.opacity -= 10 # Disparition rapide
    sprites["background"].opacity += 50 if sprites["background"].opacity < 255
    sprites["pokemon"].opacity += 10 if sprites["pokemon"].opacity < 255
    sprites["pokemon"].zoom_x += 0.01 if sprites["pokemon"].zoom_x < 1
    sprites["pokemon"].zoom_y += 0.01 if sprites["pokemon"].zoom_y < 1
    if shiny
      sprites["shiny_effect"].opacity += 10 if sprites["shiny_effect"].opacity < 150
    end
    sprites["pokemon"].update # Met à jour l'animation si Animated Pokémon System est utilisé
    Graphics.update
    Input.update
  end

  # 9. Pause pour montrer le Pokémon
  500.times do
    sprites["pokemon"].update # Continue d'animer le Pokémon si applicable
    Graphics.update
    Input.update
  end

  # 10. Animation de disparition
  150.times do
    sprites["pokemon"].update
    sprites["background"].opacity -= 10 if sprites["background"].opacity > 0
    sprites["pokemon"].opacity -= 10 if sprites["pokemon"].opacity > 0
    if shiny
      sprites["shiny_effect"].opacity -= 10 if sprites["shiny_effect"].opacity > 0
    end
    Graphics.update
    Input.update
  end

  # 11. Supprime les sprites
  sprites.each_value(&:dispose)
  viewport.dispose
end


  def self.create_egg(species)
    egg = Pokemon.new(species, Settings::EGG_LEVEL) # Crée le Pokémon au niveau de l'œuf défini
    egg.name = _INTL("Œuf") # Définit le nom de l'œuf (ou "Egg" si tu préfères)
    egg.steps_to_hatch = egg.species_data.hatch_steps # Nombre de pas nécessaires pour éclore
    egg.hatched_map = 0 # La carte où l'œuf a éclos (0 = aucune)
    egg.obtain_method = 1 # Obtention via un œuf
    egg.calc_stats # Recalcule les stats pour être sûr
    return egg # Retourne l'œuf
  end
end


# Commande pour lancer le Gatcha
def pkmgatcha
  GatchaPKM.start
end
