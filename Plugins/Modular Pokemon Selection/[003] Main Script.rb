class ModularSelection_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(pokemonlist, settings = {})
    @pokemonlist = []
    level = 5
    level = settings[:level] if settings[:level]
    is_shadow = settings[:shadow] ? true : false  # Vérifie si le Pokémon doit être Shadow
    pokemonlist.each do |species|
      pkmn = Pokemon.new(species, level)
      min_iv = (settings[:min_iv] ? settings[:min_iv] : 0)
      max_iv = (settings[:max_iv] ? settings[:max_iv] : Pokemon::IV_STAT_LIMIT)
      GameData::Stat.each_main do |s|
        pkmn.iv[s.id] = rand(min_iv, max_iv)
      end
      pkmn.poke_ball = settings[:pokeball] if settings[:pokeball]

      # Ajouter l'état Shadow si l'option est activée
      pkmn.makeShadow if is_shadow

      @pokemonlist.push(pkmn)
    end
    @index = 0
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["background"].setBitmap("Graphics/UI/Modular Pokemon Selection/bg")
    @sprites["pokemon"] = PokemonSprite.new(@viewport)
    @sprites["pokemon"].setOffset(PictureOrigin::CENTER)
    @sprites["pokemon"].x = 104
    @sprites["pokemon"].y = 206
    for i in 0...@pokemonlist.length
      @sprites["pkmnicon#{i}"] = PokemonIconSprite.new(@pokemonlist[i], @viewport)
      @sprites["pkmnicon#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["pkmnicon#{i}"].y = 44
      @sprites["pkmnicon#{i}"].x = 208  # Initial position for icons
    end
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/UI/left_arrow", 8, 40, 28, 2, @viewport)
    @sprites["leftarrow"].x = 188
    @sprites["leftarrow"].y = 30
    @sprites["leftarrow"].play
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/UI/right_arrow", 8, 40, 28, 2, @viewport)
    @sprites["rightarrow"].x = 284
    @sprites["rightarrow"].y = 30
    @sprites["rightarrow"].play
    @pokemon = @pokemonlist[@index]
    updateMenuBar
    drawPage
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

 def updateMenuBar(move = false)
  every_side = (@pokemonlist.length - 1) / 2
  every_side = PokemonSelections::MAX_PER_SIDE if every_side > PokemonSelections::MAX_PER_SIDE
  if move
    duration = (Graphics.frame_rate / 8)
    x_movement = []
    zoom_movement = []
    opacity_movement = []
    @sprites["leftarrow"].visible = false
    @sprites["rightarrow"].visible = false

    # Calcul des mouvements pour chaque Pokémon
    for i in 0...@pokemonlist.length
      location = i - @index
      if location.abs <= (every_side + 1)
      elsif i <= (every_side + 1) && @pokemonlist.length - (every_side + 1) <= @index
        location = i + @pokemonlist.length - @index
      elsif @pokemonlist.length - i <= (every_side + 1) && @index <= (every_side + 1)
        location = i - @pokemonlist.length - @index
      end
      case location.abs
      when 0
        x_movement.push((256 - @sprites["pkmnicon#{i}"].x) / duration)
        zoom_movement.push((1 - @sprites["pkmnicon#{i}"].zoom_x) / duration)
        opacity_movement.push((255 - @sprites["pkmnicon#{i}"].opacity) / duration)
      when 1..every_side
        x_movement.push((((location > 0 ? 304 : 208) + (208 / (every_side + 1)) * location) - @sprites["pkmnicon#{i}"].x) / duration)
        zoom_movement.push((0.5 - @sprites["pkmnicon#{i}"].zoom_x) / duration)
        opacity_movement.push((255 - @sprites["pkmnicon#{i}"].opacity) / duration)
      when (every_side + 1)
        x_movement.push((((location > 0 ? 304 : 208) + (208 / (every_side + 1)) * location) - @sprites["pkmnicon#{i}"].x) / duration)
        zoom_movement.push((0.5 - @sprites["pkmnicon#{i}"].zoom_x) / duration)
        opacity_movement.push((0 - @sprites["pkmnicon#{i}"].opacity) / duration)
      else
        x_movement.push(0)
        zoom_movement.push((0.5 - @sprites["pkmnicon#{i}"].zoom_x) / duration)
        opacity_movement.push((0 - @sprites["pkmnicon#{i}"].opacity) / duration)
      end
    end

    # Exécute les animations des icônes de Pokémon
    duration.times do
      Graphics.update if move
      pbUpdateSpriteHash(@sprites) if move
      for i in 0...@pokemonlist.length
        @sprites["pkmnicon#{i}"].x += x_movement[i]
        @sprites["pkmnicon#{i}"].zoom_x += zoom_movement[i]
        @sprites["pkmnicon#{i}"].zoom_y += zoom_movement[i]
        @sprites["pkmnicon#{i}"].opacity += opacity_movement[i]
      end
    end

    @sprites["leftarrow"].visible = true
    @sprites["rightarrow"].visible = true
    updateMenuBar
  else
    # Ajustement statique des icônes sans mouvement
    for i in 0...@pokemonlist.length
      location = i - @index
      if location.abs <= (every_side + 1)
      elsif i <= (every_side + 1) && @pokemonlist.length - (every_side + 1) <= @index
        location = i + @pokemonlist.length - @index
      elsif @pokemonlist.length - i <= (every_side + 1) && @index <= (every_side + 1)
        location = i - @pokemonlist.length - @index
      end
      case location.abs
      when 0
        @sprites["pkmnicon#{i}"].x = 256
        @sprites["pkmnicon#{i}"].zoom_x = 1
        @sprites["pkmnicon#{i}"].zoom_y = 1
        @sprites["pkmnicon#{i}"].opacity = 255
      when 1..every_side
        @sprites["pkmnicon#{i}"].x = (location > 0 ? 304 : 208) + (208 / (every_side + 1)) * location
        @sprites["pkmnicon#{i}"].zoom_x = 0.5
        @sprites["pkmnicon#{i}"].zoom_y = 0.5
        @sprites["pkmnicon#{i}"].opacity = 255
      when (every_side + 1)
        @sprites["pkmnicon#{i}"].x = (location > 0 ? 304 : 208) + (208 / (every_side + 1)) * location
        @sprites["pkmnicon#{i}"].zoom_x = 0.5
        @sprites["pkmnicon#{i}"].zoom_y = 0.5
        @sprites["pkmnicon#{i}"].opacity = 0
      else
        @sprites["pkmnicon#{i}"].opacity = 0
      end
    end
  end
end

  def drawPage
    @pokemon = @pokemonlist[@index]
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    imagepos = []
    ballimage = sprintf("Graphics/UI/Summary/icon_ball_%s", @pokemon.poke_ball)
    imagepos.push([ballimage, 14, 76])
    imagepos.push(["Graphics/UI/shiny", 2, 150]) if @pokemon.shiny?
    pbDrawImagePositions(overlay, imagepos)
    textpos = [
      [@pokemon.name, 46, 84, :left, base, shadow],
      [@pokemon.level.to_s, 46, 114, :left, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Species"), 238, 158, :left, base, shadow],
      [@pokemon.speciesName, 435, 158, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Nature"), 238, 190, :left, base, shadow],
      [@pokemon.nature.name, 435, 190, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Ability"), 224, 290, :left, base, shadow],
      [_INTL("Category"), 16, 324, :left, base, shadow],
      [GameData::Species.get(@pokemon.species).category, 16, 358, :left, Color.new(64, 64, 64), Color.new(176, 176, 176)]
    ]
    if @pokemon.male?
      textpos.push([_INTL("♂"), 178, 84, :left, Color.new(24, 112, 216), Color.new(136, 168, 208)])
    elsif @pokemon.female?
      textpos.push([_INTL("♀"), 178, 84, :left, Color.new(248, 56, 32), Color.new(224, 152, 144)])
    end

    # Suppression de la section gérant le numéro du Pokédex

    ability = @pokemon.ability
    if ability
      textpos.push([ability.name, 362, 290, :left, Color.new(64, 64, 64), Color.new(176, 176, 176)])
      drawTextEx(overlay, 224, 322, 282, 2, ability.description, Color.new(64, 64, 64), Color.new(176, 176, 176))
    end
    if PluginManager.installed?("Pokemon Personality")
      textpos.push([_INTL("Personality"), 238, 222, :left, base, shadow])
      textpos.push([@pokemon.personality_type, 366, 254, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)])
    end
    pbDrawTextPositions(overlay, textpos)
    # Draw Pokémon type(s)
    @pokemon.types.each_with_index do |type, i|
      type_number = GameData::Type.get(type).icon_position
      type_rect = Rect.new(0, type_number * 28, 64, 28)
      type_x = (@pokemon.types.length == 1) ? 72 : 40 + (66 * i)
      overlay.blt(type_x, 270, @typebitmap.bitmap, type_rect)
    end
  end

  def pbScene(must_choose = true)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::BACK) && !must_choose
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        if pbConfirmMessage(_INTL("Do you choose {1}?", @pokemon.name))
          return @pokemon
        end
      elsif Input.trigger?(Input::RIGHT)
        @index += 1
        @index = 0 if @index >= @pokemonlist.length
        @index = @pokemonlist.length - 1 if @index < 0
        updateMenuBar(true)
        dorefresh = true
      elsif Input.trigger?(Input::LEFT)
        @index -= 1
        @index = 0 if @index >= @pokemonlist.length
        @index = @pokemonlist.length - 1 if @index < 0
        updateMenuBar(true)
        dorefresh = true
      end
      if dorefresh
        drawPage
      end
    end
  end
end

# La classe suivante reste inchangée
class ModularSelectionScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(pokemonlist, must_choose = true, settings = {})
    @scene.pbStartScene(pokemonlist, settings)
    ret = @scene.pbScene(must_choose)
    @scene.pbEndScene
    return ret
  end
end

def pbPokemonSelection(list, must_choose = true, settings = nil)
  if list.kind_of?(Array)
    pokemonlist = list
  else
    pokemonlist = PokemonSelections.const_get(list)
  end
  settings = PokemonSelections.const_get(settings) if settings.is_a?(Symbol)
  settings = PokemonSelections.const_get(:DEFAULT) if settings.nil?
  scene = ModularSelection_Scene.new
  screen = ModularSelectionScreen.new(scene)
  screen.pbStartScreen(pokemonlist, must_choose, settings)
end