PluginManager.register({ :name => "TrainCombatDefi", :version => "1.1", :credits => "by Gizmo & ChatGPT" })

module TrainCombatDefi
  POKEMON_LIST = {
    1 => [:PIKACHU, nil, :CALM, :ATTACK, :SPEED, [:THUNDERBOLT, :WATERPULSE, :FACADE, :SHADOWBALL]],
    2 => [:ZUBAT, nil, :JOLLY, :SPATK, :SPEED, [:FEINTATTACK, :SHADOWBALL, :SLUDGEBOMB, :CONFUSERAY]],
    3 => [:GEODUDE, nil, :ADAMANT, :DEFENSE, :ATTACK, [:ROCKTHROW, :MAGNITUDE, :DEFENSECURL, :ROLLOUT]],
    4 => [:CLEFAIRY, :LEFTOVERS, :BOLD, :DEFENSE, :HP, [:MOONBLAST, :CALMMIND, :THUNDERWAVE, :PROTECT]],
    5 => [:GROWLITHE, :CHARCOAL, :NAIVE, :ATTACK, :SPEED, [:FLAMETHROWER, :CRUNCH, :FLAREBLITZ, :WILLOWISP]],
    6 => [:GASTLY, nil, :TIMID, :SPATK, :SPEED, [:SHADOWBALL, :SLUDGEWAVE, :THUNDERBOLT, :SUBSTITUTE]]
  }

  TRAINERS_LIST = [
    {
      id: "ARTISTE",
      trainer_class: :ARTISTE,
      character: "trArtist",
      begin: "LOSING DOESN'T BUG ME",
      win: "A WIN IS JUST AWESOME",
      lose: "DARN ... LOSING DOES BUG ME",
      pool: [1,2,3,4,5,6],
      sex: :male,
    },
    {
      id: "MYSTIC",
      trainer_class: :MYSTIC,
      character: "Trainer_MYSTIC",
      begin: "LOSING DOESN'T BUG ME",
      win: "A WIN IS JUST AWESOME",
      lose: "DARN ... LOSING DOES BUG ME",
      pool: [1,2,3,4,5,6],
      sex: :female,
    },
    {
      id: "OUVRIER",
      trainer_class: :OUVRIER,
      character: "Trainer_OUVRIER",
      begin: "LOSING DOESN'T BUG ME",
      win: "A WIN IS JUST AWESOME",
      lose: "DARN ... LOSING DOES BUG ME",
      pool: [1,2,3,4,5,6],
      sex: :male,
    },
    {
      id: "OUVRIERE",
      trainer_class: :OUVRIERE2,
      character: "Trainer_Ouvriere",
      begin: "LOSING DOESN'T BUG ME",
      win: "A WIN IS JUST AWESOME",
      lose: "DARN ... LOSING DOES BUG ME",
      pool: [1,2,3,4,5,6],
      sex: :female,
    },
    {
      id: "MOTARD02",
      trainer_class: :MOTARD02,
      character: "TRAINER_MOTARD02",
      begin: "I'LL SHOOT YOUR DEFEAT!",
      win: "BEAUTIFUL VICTORY!",
      lose: "Ugh... A blurry loss...",
      pool: [1,3,4,6],
      sex: :male,
    }
  ]

  # 🟢 Fonction à appeler dans un événement pour modifier tous les "DEFI"
  def self.convert_all_defi_events
    available_trainers = TRAINERS_LIST.shuffle.clone
    $game_map.events.each_value do |event|
      next unless event.name.upcase.include?("DEFI")
      next if available_trainers.empty?
      trainer = available_trainers.pop
      event.character_name = trainer[:character]
      event.instance_variable_set(:@_defi_id, trainer[:id])
    end
  end

  def self.pbDefiTrainer(event)
    char = event.character_name
    trainer_def = TrainCombatDefi::TRAINERS_LIST.find { |t| t[:character] == char }

    if trainer_def.nil?
      pbMessage("Erreur : aucun dresseur ne correspond au sprite #{char}.")
      return
    end

    # Prénom aléatoire selon le sexe (par défaut male si rien précisé)
    sex = trainer_def[:sex] || :male
    selected_name = TrainCombatDefi::NAMES[sex].sample

    pbMessage("#{selected_name} : #{trainer_def[:begin]}")

    # Crée le dresseur SANS ÉQUIPE
    trainer = NPCTrainer.new(selected_name, trainer_def[:trainer_class])

    # Génére les Pokémon
    team_ids = trainer_def[:pool].sample(3)
    trainer.party = team_ids.map do |id|
      species, item, nature, ev1, ev2, moves = TrainCombatDefi::POKEMON_LIST[id]
      pkmn = Pokemon.new(species, rand(25..40))
      pkmn.item = item if item
      pkmn.nature = nature
      pkmn.ev[ev1] = 250 if ev1
      pkmn.ev[ev2] = 250 if ev2
      pkmn.moves = []
      moves.each { |m| pkmn.learn_move(m) }
      pkmn
    end

    trainer.lose_text = "#{selected_name} a perdu le combat !"
    TrainerBattle.start(trainer)
  end

  def get_self
    return $game_map.events[$game_player.instance_variable_get(:@interpreter).event_id]
  end

end

