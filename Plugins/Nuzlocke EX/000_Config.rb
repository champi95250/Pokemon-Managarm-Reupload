module ChallengeModes
  # Array of species that are to be ignored when checking for "One
  # Capture per Map" rule
  ONE_CAPTURE_WHITELIST = [
    :DIALGA, :PALKIA, :GIRATINA, :ARCEUS
  ]

  # Groups of Map IDs that should be considered as one map in the case
  # where one large map is split up into multiple small maps
  SPLIT_MAPS_FOR_ENCOUNTERS = [
    [44, 45],
    [49, 50, 51]
  ]


  # Name and Description for all the rules that can be toggled in the challenge
  RULES = {
    :PERMAFAINT => {
      :name  => _INTL("Perma KO"),
      :desc  => _INTL("Une fois qu'un Pokémon est K.O., il ne peut pas être réanimé jusqu'à la fin du défi."),
      :order => 1
    },
    :ONE_CAPTURE => {
      :name  => _INTL("Une Capture par Map"),
      :desc  => _INTL("Seul le premier Pokémon rencontré sur une carte peut être capturé et ajouté à votre équipe."),
      :order => 2
    },
    :SHINY_CLAUSE => {
      :name  => _INTL("Clause Shiny"),
      :desc  => _INTL("Les Pokémon Shiny sont exemptés de la règle \"Une Capture par Map\"."),
      :order => 3
    },
    :DUPS_CLAUSE => {
      :name  => _INTL("Clause des Doublons"),
      :desc  => _INTL("Les évolutions possédées ne comptent pas comme une premières rencontres pour la règle \"Une Capture par Carte\"."),
      :order => 4
    },
    :GIFT_CLAUSE => {
      :name  => _INTL("Clause des Cadeaux"),
      :desc  => _INTL("Les Pokémon offerts ou les œufs ne comptent pas"),
      :order => 5
    },
    :FORCE_NICKNAME => {
      :name  => _INTL("Surnoms Forcés"),
      :desc  => _INTL("Tout Pokémon doit être surnommé"),
      :order => 6
    },
    :FORCE_SET_BATTLES => {
      :name  => _INTL("Style de Combat Forcé"),
      :desc  => _INTL("L'option de changer de Pokémon après avoir mis K.O. un Pokémon adverse ne sera pas affichée."),
      :order => 7
    },
    :NO_TRAINER_BATTLE_ITEMS => {
      :name  => _INTL("Pas d'Objets"),
      :desc  => _INTL("L'utilisation d'objets sera désactivée en Combat de Dresseur."),
      :order => 8
    },
    :GAME_OVER_WHITEOUT => {
      :name  => _INTL("Pas de Défaite Totale"),
      :desc  => _INTL("Si tous les Pokémon de votre équipe sont K.O. en combat, vous perdez le défi immédiatement."),
      :order => 9
    }
  }
end
