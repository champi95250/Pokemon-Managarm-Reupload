#-------------------------------------------------------------------------
# Définir pbErasePicture si ce n'est pas déjà défini (pour effacer une image)
#-------------------------------------------------------------------------
#--------------------------------------------------------------------------
# Définit pbErasePicture pour masquer une image en la remplaçant par une image vide.
#--------------------------------------------------------------------------
unless defined?(pbErasePicture)
  def pbErasePicture(pictureId)
    # On affiche une image vide (chaine vide) avec opacité 0
    # Les paramètres utilisés sont : 
    #   pictureId, le nom de fichier (ici ""), l'origine (0),
    #   x = 0, y = 0, zoomX = 100, zoomY = 100, opacité = 0, blendType = 0.
    pbShowPicture(pictureId, "", 0, 0, 0, 100, 100, 0, 0)
  end
end


#===========================================================================
# Définition de listes prédéfinies de boss sous forme de tableaux de Hash.
# Vous pouvez ajouter autant de définitions que vous le souhaitez.
# Chaque hash doit contenir au minimum :
#   :species => symbole de l'espèce (ex. :ECTOPLASMA)
#   :tera    => type Tera (ex. :GHOST)
#   :level   => niveau du boss
#   :moves   => tableau des moves à enseigner (optionnel)
#===========================================================================
SPECTRE_BOSS = [
  {
    species: :GENGAR,
    tera:    :GHOST,
    level:   50,
    moves:   [:SHADOWBALL, :HYPNOSIS, :CONFUSERAY, :SUCKERPUNCH]
  },
  {
    species: :MIMIKYU,
    tera:    :GHOST,
    level:   50,
    moves:   [:SHADOWBALL, :HYPNOSIS, :CONFUSERAY, :SUCKERPUNCH]
  },
  {
    species: :PIKACHU,
    tera:    :GHOST,
    level:   50,
    moves:   [:SHADOWBALL, :HYPNOSIS, :CONFUSERAY, :SUCKERPUNCH]
  }
]

ICE_R4 = [
  {
    species: :VULPIX_1, 
    form: 1, 
    tera:    :ICE, 
    level:   15, 
    moves: [] 
  },
  {
    species: :SNEASEL,
    tera:    :ICE,
    level:   15,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :SANDSHREW_1,
    form: 1, 
    tera:    :ICE,
    level:   15,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :POLIWAG,
    tera:    :WATER,
    level:   15,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :SEEL,
    tera:    :WATER,
    level:   15,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :SPHEAL,
    tera:    :WATER,
    level:   15,
    moves:   []  # Ajoutez les moves souhaités
  },
]
# ROUTE 5
ROUTE5 = [
  {
    species: :SNORLAX, 
    tera:    :NORMAL, 
    level:   42, 
    moves: [] 
  },
  {
    species: :SLOWPOKE,
    tera:    :WATER,
    level:   40,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :SLAKING,
    tera:    :NORMAL,
    level:   40,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :JIGGLYPUFF,
    tera:    :NORMAL,
    level:   38,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :HYPNO,
    tera:    :PSYCHIC,
    level:   41,
    moves:   []  # Ajoutez les moves souhaités
  },
]
# ROUTE 4
ROUTE7 = [
  {
    species: :NUZLEAF, 
    tera:    :GRASS, 
    level:   23, 
    moves: [] 
  },
  {
    species: :SUNFLORA,
    tera:    :GRASS,
    level:   23,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :PARASECT,
    tera:    :GRASS,
    level:   24,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :ELECTRODE_1,
    tera:    :GRASS,
    level:   23,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :TOEDSCOOL,
    tera:    :GRASS,
    level:   23,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :SKIPLOOM,
    tera:    :GRASS,
    level:   23,
    moves:   []  # Ajoutez les moves souhaités
  },
]

ROUTE8 = [
  {
    species: :NOSEPASS, 
    tera:    :ROCK, 
    level:   26, 
    moves: [] 
  },
  {
    species: :NACLSTACK,
    tera:    :ROCK,
    level:   25,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :GRAVELER,
    tera:    :ROCK,
    level:   25,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :GRAVELER_1,
    tera:    :ROCK,
    level:   25,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :GROWLITHE_1,
    tera:    :ROCK,
    level:   25,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :LARVITAR,
    tera:    :ROCK,
    level:   26,
    moves:   []  # Ajoutez les moves souhaités
  },
]

DESERT1 = [
  {
    species: :TRAPINCH, 
    tera:    :GROUND, 
    level:   35, 
    moves: [] 
  },
  {
    species: :STEELIX,
    tera:    :GROUND,
    level:   35,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :CAMERUPT,
    tera:    :GROUND,
    level:   35,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :CLAYDOL,
    tera:    :GROUND,
    level:   36,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :GLIGAR,
    tera:    :GROUND,
    level:   35,
    moves:   []  # Ajoutez les moves souhaités
  },
  {
    species: :KROKOROK,
    tera:    :GROUND,
    level:   35,
    moves:   []  # Ajoutez les moves souhaités
  },
]

SALAMECHE_BOSS = [
  {
    species: :GENGAR,
    tera:    :FAIRY,
    level:   40,
    moves:   []  # Ajoutez les moves souhaités
  }
]

#===========================================================================
# Méthode principale d'affrontement boss.
#
# boss_data   : Hash de définition du boss (ex. issu de SPECTRE_BOSS)
# difficulty  : Difficulté (1 à 5) qui servira à sélectionner un loot (optionnel)
#===========================================================================
def pbBossEncounter(boss_data, difficulty)
  # Créer le Pokémon boss à partir des données du hash
  species    = boss_data[:species]
  boss_level = boss_data[:level]
  boss_pokemon = Pokemon.new(species, boss_level)
  $current_boss = boss_pokemon
  
  # Attribuer le Tera type s'il est supporté
  boss_pokemon.tera_type = boss_data[:tera] if boss_pokemon.respond_to?(:tera_type=)

  # Condition pour rendre le boss shiny : 1 chance sur 512
  if rand(512) == 1
      shinytrue = true
  else 
    shinytrue = false
  end

  if boss_data[:form].is_a?(Array)
    boss_form = boss_data[:form]
  end
  
  # Optionnel : assigner les moves définis dans boss_data
  if boss_data[:moves].is_a?(Array)
    boss_data[:moves].each_with_index do |move, i|
      boss_pokemon.moves[i] = move
    end
  end
  
  # -- Modification temporaire des statistiques du boss --
  case difficulty
  when 1
    hp_multiplier   = 2.0
    stat_multiplier = 1.0
    boost_interval  = nil
  when 2
    hp_multiplier   = 3.0
    stat_multiplier = 1.0
    boost_interval  = nil
  when 3
    hp_multiplier   = 3.0
    stat_multiplier = 2
    boost_interval  = 6
  when 4
    hp_multiplier   = 3.0
    stat_multiplier = 2
    boost_interval  = 5  
  when 5
    hp_multiplier   = 4.0
    stat_multiplier = 2.0
    boost_interval  = 4
  else
    hp_multiplier   = 1.0
    stat_multiplier = 1.0
    boost_interval  = nil
  end

  
  # --- Configuration des règles de combat via le plugin ---
  setBattleRule("disablePokeBalls")
  setBattleRule("alwaysCapture")
  setBattleRule("battleIntroText", "Vous entendez un bruit et un pokémon baron s'approche de vous")
  setBattleRule("raidStyleCapture", { :capture_chance => 50 })
  setBattleRule("battleBGM", "039 - Raid")
  setBattleRule("2v1")
  setBattleRule("captureME", "XD 95 Fanfare - Victory")
  setBattleRule("setSlideSprite", "still")
  setBattleRule("backdrop", "elite4")
  setBattleRule("outcome", 42)
  setBattleRule("editWildPokemon", {
    :obtain_text    => "Raid",
    :species        => boss_data[:species],
    :form           => boss_data[:form],
    :shiny          => shinytrue, #DERNIER MODIF ICI
    :level          => boss_level,
    :hp_level       => hp_multiplier,
    :super_shiny    => false,   # ou true si souhaité
    :immunities     => [:OHKO, :ESCAPE, :SLEEP, :BURN, :ATTRACT, :INDIRECT],
    :iv             => 31,
    :terastal_able  => true,
    :tera_type      => boss_data[:tera],
    :terastallized  => true,
  })
  # Construire le hash du midbattleScript
  midbattle_script = {
    "RoundStartCommand_1_foe" => {
      "text_A" => "Une aura de force dégage du pokémon sauvage."
    },
    "TurnStart_2_foe" => {
      "text_A"       => "Le pokémon se mets en colère !",
      "battlerStats" => [:SPEED, stat_multiplier, :SPECIAL_ATTACK, stat_multiplier, :ATTACK, stat_multiplier]
    },
    "BattleEndWin" => {
      "text_A"  => "La tempête nous force à revenir en arrière",
      },
    "BattleEndLoss" => {
      "text_A"  => "Une force nous ramenne ...",
      },
  }
  if difficulty >= 4
    midbattle_script["TurnStart_5_foe"] = {
      "text_A"       => "Le pokémon deviens impatient !",
      "battlerStats" => [:SPEED, stat_multiplier, :SPECIAL_ATTACK, stat_multiplier, :ATTACK, stat_multiplier]
    }
  end

  # Ajouter la règle "RoundEnd_foe_repeat_every_3" seulement si la difficulté est égale ou supérieure à 3
  if boost_interval && boost_interval > 0
    key = "RoundEnd_foe_repeat_every_#{boost_interval}"
    midbattle_script[key] = {
      "text_A"       => "Une douce brise soigne l'ennemi",
      "playCry"      => :Self,
      "battlerMoves" => :Reset,
      "battlerHP"    => [6, "{1} regenerated some HP!"]
    }
  end

  # Appliquer ce script de battle via le plugin
  setBattleRule("midbattleScript", midbattle_script)
  
  # --- Lancement du combat via le plugin WildBattle en 2v1 ---
  # ATTENTION : Le plugin attend que le premier argument soit l'espèce (Symbol, GameData::Species ou String)
  result = WildBattle.start(boss_pokemon.species, boss_pokemon.level)
  #p "Le résultat (outcome) de la bataille est : #{$game_variables[42]}"

  # Vérifier le résultat via la variable globale $bossVictory
  if $game_variables[42] == 1 || $game_variables[42] == 4 || $game_variables[42] == 3
    pbMessage("Vous avez vaincu le boss !")
    drops = pbBossItemDrops(difficulty)
    if drops.any?
      drops.each do |drop|
        item_name = GameData::Item.get(drop[:item]).name rescue drop[:item].to_s
        pbMessage("Vous avez obtenu #{item_name} x#{drop[:quantity]} !")
        pbReceiveItem(drop[:item], drop[:quantity])
      end
    end
  else
    pbMessage("Vous avez perdu le combat contre le boss...")
  end
  $bossVictory = nil
end

  #===========================================================================
  # ITEM DROP
  #===========================================================================

def pbBossItemDrops(difficulty)
  # On applique un multiplicateur sur le taux de drop en fonction de la difficulté.
  # Par exemple, avec une difficulté plus élevée, le taux augmente de 10 % par niveau au-dessus de 1.
  chance_multiplier = 1.0 + 0.1 * (difficulty - 1)

  # Définition de la table de drops en fonction de la difficulté.
  drop_table = case difficulty
  when 1
    [
      {item: :EXPCANDYXS, quantity_range: [2, 3], chance: 100},
      {item: :EXPCANDYS, quantity_range: [1, 1], chance: 100},
      {item: :EXPCANDYXS, quantity_range: [1, 2], chance: 50},
      {item: :EXPCANDYS, quantity_range: [1, 1], chance: 22},
      {item: :TINYMUSHROOM, quantity_range: [1, 1], chance: 6},
      {item: :HEALTHFEATHER, quantity_range: [1, 1], chance: 2},
      {item: :MUSCLEFEATHER, quantity_range: [1, 1], chance: 2},
      {item: :RESISTFEATHER, quantity_range: [1, 1], chance: 2},
      {item: :GENIUSFEATHER, quantity_range: [1, 1], chance: 2},
      {item: :CLEVERFEATHER, quantity_range: [1, 1], chance: 2},
      {item: :SWIFTFEATHER, quantity_range: [1, 1], chance: 2},
    ]
  when 2
    [
      {item: :EXPCANDYXS, quantity_range: [4, 8], chance: 100},
      {item: :EXPCANDYS, quantity_range: [2, 3], chance: 100},
      {item: :EXPCANDYS, quantity_range: [1, 3], chance: 50},
      {item: :EXPCANDYM, quantity_range: [1, 2], chance: 50},
      {item: :HEALTHFEATHER, quantity_range: [1, 2], chance: 6},
      {item: :MUSCLEFEATHER, quantity_range: [1, 2], chance: 6},
      {item: :RESISTFEATHER, quantity_range: [1, 2], chance: 6},
      {item: :GENIUSFEATHER, quantity_range: [1, 2], chance: 6},
      {item: :CLEVERFEATHER, quantity_range: [1, 2], chance: 6},
      {item: :SWIFTFEATHER, quantity_range: [1, 2], chance: 6},
    ]
  when 3
    [
      {item: :EXPCANDYXS, quantity_range: [5, 9], chance: 100},
      {item: :EXPCANDYS, quantity_range: [4, 6], chance: 100},
      {item: :EXPCANDYM, quantity_range: [2, 4], chance: 100},
      {item: :PEARL, quantity_range: [1, 2], chance: 44},
      {item: :HEALTHFEATHER, quantity_range: [1, 2], chance: 16},
      {item: :MUSCLEFEATHER, quantity_range: [1, 2], chance: 16},
      {item: :RESISTFEATHER, quantity_range: [1, 2], chance: 16},
      {item: :GENIUSFEATHER, quantity_range: [1, 2], chance: 16},
      {item: :CLEVERFEATHER, quantity_range: [1, 2], chance: 16},
      {item: :SWIFTFEATHER, quantity_range: [1, 2], chance: 16},
    ]
  when 4
    [
      {item: :EXPCANDYM, quantity_range: [3, 6], chance: 100},
      {item: :EXPCANDYL, quantity_range: [3, 5], chance: 100},
      {item: :EXPCANDYL, quantity_range: [1, 3], chance: 50},
      {item: :HEALTHFEATHER, quantity_range: [1, 2], chance: 36},
      {item: :MUSCLEFEATHER, quantity_range: [1, 2], chance: 36},
      {item: :RESISTFEATHER, quantity_range: [1, 2], chance: 36},
      {item: :GENIUSFEATHER, quantity_range: [1, 2], chance: 36},
      {item: :CLEVERFEATHER, quantity_range: [1, 2], chance: 36},
      {item: :SWIFTFEATHER, quantity_range: [1, 2], chance: 36},
    ]
  when 5
    [
      {item: :EXPCANDYL, quantity_range: [4, 8], chance: 100},
      {item: :EXPCANDYXL, quantity_range: [3, 6], chance: 100},
      {item: :EXPCANDYXL, quantity_range: [1, 4], chance: 50},
      {item: :HEALTHFEATHER, quantity_range: [1, 3], chance: 66},
      {item: :MUSCLEFEATHER, quantity_range: [1, 3], chance: 66},
      {item: :RESISTFEATHER, quantity_range: [1, 3], chance: 66},
      {item: :GENIUSFEATHER, quantity_range: [1, 3], chance: 66},
      {item: :CLEVERFEATHER, quantity_range: [1, 3], chance: 66},
      {item: :SWIFTFEATHER, quantity_range: [1, 3], chance: 66},
    ]
  else
    []
  end

  drops = []
  drop_table.each do |entry|
    # Calcul du taux effectif après application du multiplicateur.
    effective_chance = entry[:chance] * chance_multiplier
    roll = rand * 100.0
    if roll < effective_chance
      # Si une plage de quantité est définie, tirer un nombre aléatoire dans cette plage.
      qty = if entry[:quantity_range]
              rand(entry[:quantity_range][0]..entry[:quantity_range][1])
            else
              entry[:quantity]
            end
      drops.push({item: entry[:item], quantity: qty})
    end
  end
  return drops
end


#---------------------------------------------------------------------------
# Crée un bitmap de cadre (frame) de dimensions (width x height)
# en utilisant le windowskin spécifié (par défaut "Choice 1.png").
# Cette fonction suppose que le windowskin se trouve dans Graphics/Windowskins/
# et utilise une bordure d'une largeur de 8 pixels (à adapter si nécessaire).
#---------------------------------------------------------------------------
def createWindowskinFrame(width, height, windowskin_name = "choice 3.png")
  # Charge le windowskin depuis Graphics/Windowskins
  skin = Bitmap.new("Graphics/Windowskins/#{windowskin_name}")
  border = 12  # largeur de la bordure (à ajuster selon votre windowskin)
  frame_bitmap = Bitmap.new(width, height)
  frame_bitmap.clear
  
  # Remplir le centre du cadre en blanc
  frame_bitmap.fill_rect(border, border, width - 2 * border, height - 2 * border, Color.new(255,255,255))
  
  # Copier les coins du windowskin :
  # Haut-gauche
  frame_bitmap.blt(0, 0, skin, Rect.new(0, 0, border, border))
  # Haut-droite
  frame_bitmap.blt(width - border, 0, skin, Rect.new(skin.width - border, 0, border, border))
  # Bas-gauche
  frame_bitmap.blt(0, height - border, skin, Rect.new(0, skin.height - border, border, border))
  # Bas-droite
  frame_bitmap.blt(width - border, height - border, skin, Rect.new(skin.width - border, skin.height - border, border, border))
  
  # Dessiner les bords :
  # Bord supérieur
  frame_bitmap.stretch_blt(Rect.new(border, 0, width - 2 * border, border),
                           skin, Rect.new(border, 0, skin.width - 2 * border, border))
  # Bord inférieur
  frame_bitmap.stretch_blt(Rect.new(border, height - border, width - 2 * border, border),
                           skin, Rect.new(border, skin.height - border, skin.width - 2 * border, border))
  # Bord gauche
  frame_bitmap.stretch_blt(Rect.new(0, border, border, height - 2 * border),
                           skin, Rect.new(0, border, border, skin.height - 2 * border))
  # Bord droit
  frame_bitmap.stretch_blt(Rect.new(width - border, border, border, height - 2 * border),
                           skin, Rect.new(skin.width - border, border, border, skin.height - 2 * border))
  
  skin.dispose
  return frame_bitmap
end






#===========================================================================
# Méthode d'appel de l'événement boss.
#
# boss_list_data : Tableau de Hash définissant une liste de boss (ex. SPECTRE_BOSS)
# difficulty (facultatif) : Difficulté (1 à 5) à utiliser (sinon aléatoire)
#===========================================================================
def pbBossEvent(boss_list_data, difficulty = nil)
  # Détermine l'ID de l'événement courant (si disponible)
  current_event_id = ($game_map.events[@event_id] ? $game_map.events[@event_id].id : nil)
  $current_boss_data_by_event ||= {}

  # Si un boss est déjà verrouillé pour cet événement, on l'utilise
  if current_event_id && $current_boss_data_by_event[current_event_id]
    chosen_boss_data = $current_boss_data_by_event[current_event_id]
  else
    # Sinon, on choisit aléatoirement un boss dans la liste et on le stocke
    chosen_boss_data = boss_list_data[rand(boss_list_data.length)]
    $current_boss_data_by_event[current_event_id] = chosen_boss_data if current_event_id
  end

  # Créer une instance temporaire du Pokémon boss pour l'aperçu
  preview_level = chosen_boss_data[:level]
  boss_preview = Pokemon.new(chosen_boss_data[:species], preview_level)
  
  # Création d'un viewport pour afficher l'aperçu par-dessus la carte
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  
  # Création du sprite animé du Pokémon (depuis Graphics/Pokemon/Front)
  boss_sprite = PokemonSprite.new(viewport)
  boss_sprite.setPokemonBitmap(boss_preview)
  boss_sprite.x = Graphics.width / 2
  boss_sprite.y = Graphics.height / 2
  boss_sprite.tone.set(-255, -255, -255, 0)  # Forcer l'apparence "noire"
  
  # Création du cadre à partir du windowskin
  margin = 10  # Marge autour du sprite
  frame = Sprite.new(viewport)
  if boss_sprite.bitmap
    f_width  = boss_sprite.bitmap.width + margin
    f_height = boss_sprite.bitmap.height + margin
    # Si la difficulté est donnée, on l'utilise pour choisir le windowskin, sinon on utilise "choice 1.png" par défaut.
    diff_choice = difficulty ? difficulty : 1
    diff_choice = diff_choice+2 # Ajuste les cadres
    skin_name = "choice #{diff_choice}.png"
    frame.bitmap = createWindowskinFrame(f_width, f_height, skin_name)
    # Positionner le cadre pour qu'il encadre le sprite (le cadre est derrière le Pokémon)
    frame.x = boss_sprite.x - (f_width / 2)
    frame.y = boss_sprite.y - (f_height / 2)
    frame.z = boss_sprite.z - 1  # Place le cadre derrière le sprite du Pokémon
  end
  
  # Affichage d'un message de confirmation
  # Si la difficulté n'est pas donnée, on la fixe aléatoirement ici (mais si elle est passée, on l'utilise)
  difficulty = difficulty ? difficulty : (rand(5) + 1)
  pbMessage(_INTL("Niveau de difficulté : {1} étoile(s)", difficulty))
  choices = ["Oui", "Non"]
  command = pbMessage("Allez à la rencontre de ce pokémon ?", choices)
  
  # Dispose des sprites et du viewport
  boss_sprite.dispose
  frame.dispose if frame
  viewport.dispose
  
  if command == 0   # Le joueur choisit "Oui"
    pbBossEncounter(chosen_boss_data, difficulty)
    # Une fois le combat lancé, on exécute le script pbSetEventTime
    pbSetEventTime
    # Et on active l'interrupteur local A pour cet événement
    if current_event_id
      $game_self_switches[[$game_map.map_id, current_event_id, "A"]] = true
    end
    # Déverrouiller le boss pour cet événement
    $current_boss_data_by_event.delete(current_event_id) if current_event_id
  else
    pbMessage("Peut-être une autre fois...")
    # On ne déverrouille pas pour conserver le même boss dans cet event
  end
end



#===========================================================================
# Pour appeler l'événement depuis un script d'événement, utilisez par exemple :
#
#   pbBossEvent(SPECTRE_BOSS)
#
# Vous pouvez aussi appeler pbBossEvent(FEU_BOSS) ou pbBossEvent(SALAMECHE_BOSS)
#===========================================================================