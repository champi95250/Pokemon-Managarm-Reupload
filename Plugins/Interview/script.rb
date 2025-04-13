  #------------------------------------
  #---Module
  #------------------------------------
module ChoixSelections
  Managarm = [
    "Champi",
    "Many",
    "Boby",
    "Sonaku",
    "Lowell",
    "Néoskyblue",
    "Flamehaze",
    "Takakuna",
    "Ferdi",
    "Zéké",
    "Mistro",
    "XIII",
    "Chris",
    "Mira",
    "Caaling",
    "Vaene",
  ]
  Guez = [
    "Trop Guez",
    "Chiant",
    "Nul au jeux",
    "Relou",
    "Arrogant",
    "Mauvais joueur",
    "Égocentrique",
    "Hautain",
    "Dénué d'intelligence",
    "à côté de la plaque",
    "en mode avion",
    "bruyant pour rien",
    "à la ramasse",
  ]
  Penser = [
    "Guez",
    "Drôle",
    "Forte",
    "Relou",
    "Arrogant",
    "Puante",
    "Hautain",
    "Incroyable",
    "Conne",
  ]
  Fort = [
    "Zeke",
    "Flamehaze",
    "Neoskyblue",
    "Le 1er Sbire",
    "Aucun",
  ]
end

  #------------------------------------
  #---Script
  #------------------------------------

class SimpleInterviewScene
  BASE_COLOR = Color.new(64, 64, 64)
  SHADOW_COLOR = Color.new(168, 184, 192)
  SELECTED_COLOR = Color.new(255, 0, 0)  # Rouge pour l'élément sélectionné

  MAX_VISIBLE_WORDS = 10  # Nombre maximum de mots visibles à l'écran en même temps

  def initialize(question, word_list, variable_to_store)
    @question = question
    @word_list = word_list
    @variable_to_store = variable_to_store
    @index = 0  # Position actuelle dans la liste
    @start_index = 0  # Indice de début pour les mots affichés
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @word_windows = []  # Tableau pour les fenêtres de mots

    create_sprites
  end

  def create_sprites
    # Ajouter le fond
    @sprites["background"] = IconSprite.new(0, 0)
    @sprites["background"].setBitmap("Graphics/Plugins/Interview/bg")

    # Fenêtre de la question pleine largeur, tout en haut
    @sprites["question"] = Window_UnformattedTextPokemon.newWithSize(@question, 0, 0, Graphics.width, 80, @viewport)
    @sprites["question"].baseColor = BASE_COLOR
    @sprites["question"].shadowColor = SHADOW_COLOR

    # Fenêtres pour afficher les mots visibles, MAX_VISIBLE_WORDS définit combien sont visibles à l'écran
    (0...MAX_VISIBLE_WORDS).each do |i|
      col = i % 2  # Calculer la colonne (0 ou 1)
      row = i / 2  # Calculer la ligne (de 0 à MAX_VISIBLE_WORDS)
      x_pos = 10 + col * (Graphics.width / 2)  # Position X basée sur la colonne (50% de largeur)
      y_pos = 80 + row * 60  # Position Y basée sur la ligne
      word_window = Window_UnformattedTextPokemon.newWithSize("", x_pos, y_pos, (Graphics.width / 2) - 20, 60, @viewport)
      word_window.baseColor = BASE_COLOR
      word_window.shadowColor = SHADOW_COLOR
      word_window.contents.font.size = 28  # Ajuste la taille de la police pour rendre les mots lisibles
      @word_windows.push(word_window)  # Ajoute la fenêtre au tableau
    end

    # Mets à jour les mots pour montrer l'élément sélectionné
    update_word_list
  end

  def update_word_list
    # Mets à jour la couleur et le texte des fenêtres pour montrer l'élément sélectionné
    visible_words = @word_list[@start_index, MAX_VISIBLE_WORDS] || []  # Récupère les mots visibles
    @word_windows.each_with_index do |window, i|
      if visible_words[i]
        window.text = visible_words[i]  # Assigne le texte visible
        if @index == @start_index + i
          window.baseColor = SELECTED_COLOR  # Rouge si sélectionné
        else
          window.baseColor = BASE_COLOR  # Autres mots en couleur normale
        end
      else
        window.text = ""  # Vide la fenêtre si elle n'a pas de mot à afficher
      end
      window.refresh  # Actualise l'affichage
    end
  end

  def pbStartScene
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::UP)
        if @index >= 2  # Remonte d'un élément dans la même colonne
          pbPlayCursorSE
          @index -= 2
          if @index < @start_index  # Si on remonte au-delà des éléments visibles, on fait défiler vers le haut
            @start_index -= 2
          end
          update_word_list
        end
      elsif Input.trigger?(Input::DOWN)
        if @index + 2 < @word_list.length  # Descend d'un élément dans la même colonne
          pbPlayCursorSE
          @index += 2
          if @index >= @start_index + MAX_VISIBLE_WORDS  # Si on descend au-delà des éléments visibles, on fait défiler vers le bas
            @start_index += 2
          end
          update_word_list
        end
      elsif Input.trigger?(Input::LEFT) && @index % 2 != 0
        pbPlayCursorSE
        @index -= 1  # Déplacement à gauche dans la colonne
        update_word_list
      elsif Input.trigger?(Input::RIGHT) && @index % 2 == 0 && @index + 1 < @word_list.length
        pbPlayCursorSE
        @index += 1  # Déplacement à droite dans la colonne
        update_word_list
      elsif Input.trigger?(Input::USE)
        pbPlayDecisionSE
        select_word
        break
      elsif Input.trigger?(Input::BACK)
        pbPlayCancelSE
        break
      end
    end
    pbEndScene
  end


  def select_word
    # Récupère le mot sélectionné
    selected_word = @word_list[@index]
    $game_variables[@variable_to_store] = selected_word
    pbMessage("Vous avez sélectionné : #{selected_word}")
  end

  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @word_windows.each(&:dispose)  # Dispose des fenêtres de mots
    @viewport.dispose
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    @word_windows.each(&:update)
  end
end

# Fonction d'appel pour l'interview
def start_interview(question, word_list, variable_to_store)
  scene = SimpleInterviewScene.new(question, word_list, variable_to_store)
  scene.pbStartScene
end
