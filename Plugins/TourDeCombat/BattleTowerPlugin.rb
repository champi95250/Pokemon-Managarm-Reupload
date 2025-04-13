module BattleTowerPlugin

  # Set the trainer for the battle
  def self.dresseur(trainer_type)
    @selected_trainer = TRAINERS[trainer_type]
  end

  TRAINERS = {
    noob: {
      CYCLISTE01: { characters: "TRAINER_CYCLISTE01", gender: :male,    pokemon: [:PIKACHU, :EEVEE, :SEEL, :GOOMY], 
        pre_battle_phrases: [
          "Je vais te montrer ma vitesse incroyable !",
          "Prépare-toi à perdre contre un champion cycliste !"
        ]},
      ROLLER:     { characters: "TRAINER_ROLLER",     gender: :male,  pokemon: [:PIKACHU, :EEVEE, :SEEL, :GOOMY],
      pre_battle_phrases: [
          "Je vais te rouler dessus avec style !",
          "Personne ne peut égaler mes mouvements !"
        ] }
    }
  }

  NAMES = {
  male: [
    "Jean", "Pierre", "Lucas", "Thomas", "Alexandre", "Mathieu", "Hugo", "Léo", "Gabriel", "Jules",
    "Nicolas", "Antoine", "Arnaud", "Maxime", "Julien", "Sébastien", "Benjamin", "Arthur", "Théo", "Clément",
    "Romain", "Adrien", "Paul", "Kevin", "Florian", "Benoit", "Jonathan", "Martin", "Quentin", "Édouard", "Victor", "Loïc",
    "Yann", "Simon", "Guillaume", "David", "Cédric", "François", "Geoffrey", "Bastien", "Vincent", "Michaël",
    "Raphaël", "Grégoire", "Olivier", "Damien", "Axel", "Fabien", "Corentin", "Benoît", "Émile", "Louis"
  ],
  female: [
    "Marie", "Claire", "Sophie", "Emma", "Julie", "Lucie", "Camille", "Léa", "Alice", "Chloé",
    "Charlotte", "Sarah", "Manon", "Cécile", "Émilie", "Pauline", "Nina", "Anaïs", "Amandine", "Adeline",
    "Elise", "Marion", "Clara", "Laure", "Justine", "Aurélie", "Mathilde", "Eva", "Lola", "Amélie",
    "Caroline", "Victoria", "Laura", "Sandra", "Margaux", "Louise", "Gabrielle", "Éléonore", "Florence", "Isabelle",
    "Jessica", "Catherine", "Édith", "Martine", "Estelle", "Noémie", "Hélène", "Vanessa", "Sabrina", "Océane"
  ]
}


  POKEMON_DETAILS = {
    PIKACHU:    { ability: :STATIC,           moves: [:ELECTROBALL],                          item: :CHOICESCARF },
    EEVEE:      { ability: :ADAPTABILITY,     moves: [:QUICKATTACK, :SANDATTACK, :COVET],     item: :SILKSCARF },
    SEEL:       { ability: :HYDRATION,        moves: [:WATERGUN],                             item: nil },
    GOOMY:      { ability: :SAPSIPPER,        moves: [:TACKLE],                               item: nil }
  }

  # Set the trainer for the battle
  def self.dresseur(trainer_type)
    @selected_trainer = TRAINERS[trainer_type]
  end

  # Change the NPC sprite based on trainer
  def self.npc(event_id)
    @current_trainer = @selected_trainer.values.sample # Stocker le dresseur choisi
    event = $game_map.events[event_id]
    if event
      event.character_name = @current_trainer[:characters]
    else
      raise "Event with ID #{event_id} not found on the current map."
    end
  end

  # Launch the battle with a set number of Pokémon and level
  def self.battle(pokemon_count, level)

    selected_pokemon = POKEMON_DETAILS.keys.sample(pokemon_count)

    trainer_data = @current_trainer
    trainer_name = @selected_trainer.key(trainer_data)

    # Choix aléatoire du nom selon le genre du dresseur
    name_list = NAMES[trainer_data[:gender]]
    selected_name = name_list.sample # Nom aléatoire à chaque combat

    # Sélection d'une phrase d'avant-match
    pre_battle_phrase = trainer_data[:pre_battle_phrases].sample
    pbMessage("#{selected_name} : #{pre_battle_phrase}")

    trainer = NPCTrainer.new(selected_name, trainer_name.to_s)
    trainer.lose_text = "#{selected_name} a perdu le combat !"

    trainer.party = selected_pokemon.map do |species|
      poke_data = POKEMON_DETAILS[species]
      pokemon = Pokemon.new(species, level)
      pokemon.ability       = poke_data[:ability]
      pokemon.item          = poke_data[:item] if poke_data[:item]
      pokemon.moves         = poke_data[:moves]
      pokemon.nature        = poke_data[:nature] if poke_data[:nature]
      pokemon.shiny         = rand(256) == 0
      pokemon.calc_stats
      pokemon
    end
    TrainerBattle.start(trainer)
  end
end

# Example usage:
# BattleTowerPlugin.dresseur(:noob)
# BattleTowerPlugin.npc(1)
# BattleTowerPlugin.battle(3, 50)