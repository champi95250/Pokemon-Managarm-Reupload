#===============================================================================
# Modular Pokemon Selection
#===============================================================================
# List Settings page:
# list_name = [
#   setting: value,
#   setting: value,
#   ...
# ]
#===============================================================================
# Optional Settings:
# min_iv: setting the minimum of the iv random number range
# max_iv: setting the maximum of the iv random number range
# pokeball: setting the pokeball
#===============================================================================
module PokemonSelections
  DEFAULT = {}

  STARTER = {
    level: 5,
    min_iv: 20,
    pokeball: :POKEBALL
  }

  SHADOW = {
    level: 5,
    min_iv: 15,
    pokeball: :POKEBALL,
    shadow: true
  }
  SHADOW_2 = {
    level: 17,
    min_iv: 16,
    pokeball: :POKEBALL,
    shadow: true
  }
  SHADOW_3 = {
    level: 29,
    min_iv: 17,
    pokeball: :POKEBALL,
    shadow: true
  }
  SHADOW_HISUI = {
    level: 32,
    min_iv: 18,
    pokeball: :POKEBALL,
    shadow: true
  }
  SHADOW_fusion = {
    level: 50,
    min_iv: 19,
    pokeball: :POKEBALL,
    shadow: true
  }
  SHADOW_final = {
    level: 65,
    min_iv: 26,
    pokeball: :POKEBALL,
    shadow: true
  }
end