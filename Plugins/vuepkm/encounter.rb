def mark_encountered_pokemon_as_seen
  return if !$player || !$game_map || !$game_map.map_id

  # Récupère l'ID de la carte actuelle
  map_id = $game_map.map_id

  # Vérifie si la carte a des rencontres définies
  enc_data = GameData::Encounter.get(map_id, $PokemonGlobal.encounter_version)
  return if !enc_data

  seen_species = []

  # Parcourt toutes les rencontres de la carte
  enc_data.types.each do |_type, encounters|
    next if encounters.nil?

    encounters.each do |encounter|
      species_symbol = encounter[1]  # Exemple : :BULBASAUR
      next if species_symbol.nil? || seen_species.include?(species_symbol)

      # Vérifie que l'espèce existe
      species_data = GameData::Species.try_get(species_symbol)
      next if species_data.nil?

      # Enregistre le Pokémon comme "vu"
      $player.pokedex.register(species_symbol, 0, 0) 
      seen_species << species_symbol
    end
  end

  pbMessage("Les Pokémon de cette zone ont été enregistrés comme vus dans votre Pokédex !")
end

def mark_all_encountered_pokemon_as_seen_all
  return if !$player

  seen_species = []

  # Parcourt toutes les cartes définies dans les rencontres
  GameData::Encounter::DATA.each do |map_id, encounter_data|
    next if !encounter_data  # Vérifie si la carte a des données de rencontre

    encounter_data.types.each do |_type, encounters|
      next if encounters.nil?

      encounters.each do |encounter|
        species_symbol = encounter[1]  # Exemple : :PIKACHU
        next if species_symbol.nil? || seen_species.include?(species_symbol)

        # Vérifie que l'espèce existe
        species_data = GameData::Species.try_get(species_symbol)
        next if species_data.nil?

        # Enregistre le Pokémon comme "vu"
        $player.pokedex.register(species_symbol, 0, 0)
        seen_species << species_symbol
      end
    end
  end

  pbMessage("Tous les Pokémon sauvages du jeu ont été enregistrés comme vus dans votre Pokédex !")
end
