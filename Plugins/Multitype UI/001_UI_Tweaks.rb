class PokemonSummary_Scene
  def drawPageOne
    overlay = @sprites["overlay"].bitmap
    if PluginManager.installed?("FRLG Summary Screen")
      base   = Color.new(248, 248, 248)
      shadow = Color.new(120, 128, 144)
      # Write various bits of text
      textpos = [
        [_INTL("Dex No."), 238 + 70, 86 - 40, :center, base, shadow, :outline],
        [_INTL("Species"), 238 + 70, 118 - 40, :center, base, shadow, :outline],
        [@pokemon.speciesName, 435 - 77, 118 - 40, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)],
        [_INTL("Type"), 238 + 70, 150 - 40, :center, base, shadow, :outline],
        [_INTL("OT"), 238 + 70, 182 - 40, :center, base, shadow, :outline],
        [_INTL("ID No."), 238 + 70, 214 - 40, :center, base, shadow, :outline],
        [_INTL("Item"), 308, 206, :center, base, shadow, :outline],
        [_INTL("Trainer Memo"), 86, 270, :center, base, shadow, :outline]
      ]
      # Write the Regional/National Dex number
      dexnum = 0
      dexnumshift = false
      if $player.pokedex.unlocked?(-1)   # National Dex is unlocked
        dexnum = @nationalDexList.index(@pokemon.species_data.species) || 0
        dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(-1)
      else
        ($player.pokedex.dexes_count - 1).times do |i|
          next if !$player.pokedex.unlocked?(i)
          num = pbGetRegionalNumber(i, @pokemon.species)
          next if num <= 0
          dexnum = num
          dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(i)
          break
        end
      end
      if dexnum <= 0
        textpos.push(["???", 435 - 77, 86 - 40, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)])
	  else
        dexnum -= 1 if dexnumshift
        textpos.push([sprintf("%03d", dexnum), 435 - 77, 86 - 40, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)])
      end
      # Write Original Trainer's name and ID number
      if @pokemon.owner.name.empty?
        textpos.push([_INTL("RENTAL"), 435 - 77, 182 - 40, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)])
        textpos.push(["?????", 435 - 77, 214 - 40, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)])
      else
        ownerbase   = Color.new(64, 64, 64)
        ownershadow = Color.new(216, 216, 192)
        case @pokemon.owner.gender
        when 0
          ownerbase = Color.new(160, 192, 240)
          ownershadow = Color.new(48, 80, 200)
        when 1
          ownerbase = Color.new(259, 189, 115)
          ownershadow = Color.new(231, 8, 8)
        end
        textpos.push([@pokemon.owner.name, 435 - 77, 182 - 40, :left, ownerbase, ownershadow])
        textpos.push([sprintf("%05d", @pokemon.owner.public_id), 435 - 77, 214 - 40, :left,
                      Color.new(64, 64, 64), Color.new(216, 216, 192)])
      end
      # Write the held item's name
      if @pokemon.hasItem?
        textpos.push([@pokemon.item.name, 16 + 250, 358 - 130, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)])
      else
        textpos.push([_INTL("None"), 16 + 250, 358 - 130, :left, Color.new(64, 64, 64), Color.new(216, 216, 192)])
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Write Trainer Memo
      memo = ""
      # Write nature and characteristic
      showNature = !@pokemon.shadowPokemon? || @pokemon.heartStage <= 3
      if showNature
        natureName = @pokemon.nature.name
        memo += _INTL("{1} nature. ", natureName)
        best_stat = nil
        best_iv = 0
        stats_order = [:HP, :ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE]
        start_point = @pokemon.personalID % stats_order.length   # Tiebreaker
        stats_order.length.times do |i|
          stat = stats_order[(i + start_point) % stats_order.length]
          if !best_stat || @pokemon.iv[stat] > @pokemon.iv[best_stat]
            best_stat = stat
            best_iv = @pokemon.iv[best_stat]
          end
        end
        characteristics = {
          :HP              => [_INTL("Loves to eat."),
                               _INTL("Takes plenty of siestas."),
                               _INTL("Nods off a lot."),
                               _INTL("Scatters things often."),
                               _INTL("Likes to relax.")],
          :ATTACK          => [_INTL("Proud of its power."),
                               _INTL("Likes to thrash about."),
                               _INTL("A little quick tempered."),
                               _INTL("Likes to fight."),
                               _INTL("Quick tempered.")],
          :DEFENSE         => [_INTL("Sturdy body."),
                               _INTL("Capable of taking hits."),
                               _INTL("Highly persistent."),
                               _INTL("Good endurance."),
                               _INTL("Good perseverance.")],
          :SPECIAL_ATTACK  => [_INTL("Highly curious."),
                               _INTL("Mischievous."),
                               _INTL("Thoroughly cunning."),
                               _INTL("Often lost in thought."),
                               _INTL("Very finicky.")],
          :SPECIAL_DEFENSE => [_INTL("Strong willed."),
                               _INTL("Somewhat vain."),
                               _INTL("Strongly defiant."),
                               _INTL("Hates to lose."),
                               _INTL("Somewhat stubborn.")],
          :SPEED           => [_INTL("Likes to run."),
                               _INTL("Alert to sounds."),
                               _INTL("Impetuous and silly."),
                               _INTL("Somewhat of a clown."),
                               _INTL("Quick to flee.")]
        }
        memo += characteristics[best_stat][best_iv % 5] + "\n"
      end
      # Write how Pokemon was hatched
      if @pokemon.obtain_method == 1
        memo += _INTL("Egg hatched in ")
        mapname = pbGetMapNameFromId(@pokemon.hatched_map)
        mapname = _INTL("Faraway place") if nil_or_empty?(mapname)
        memo += sprintf("%s", mapname)
        if @pokemon.timeEggHatched
          date  = @pokemon.timeEggHatched.day
          month = pbGetMonthName(@pokemon.timeEggHatched.mon)
          year  = @pokemon.timeEggHatched.year
          memo += _INTL(" on {1} {2}, {3}", date, month, year)
        end
        memo += ".\n"
      else
        mettext = [_INTL("Met at Lv. {1}", @pokemon.obtain_level),
                  "",
                  _INTL("Traded at Lv. {1}", @pokemon.obtain_level),
                  "",
                  _INTL("Had a fateful encounter at Lv. {1}", @pokemon.obtain_level)][@pokemon.obtain_method]
        memo += sprintf(mettext) if mettext && mettext != ""
        # Write map name Pokemon was received on
        mapname = pbGetMapNameFromId(@pokemon.obtain_map)
        mapname = @pokemon.obtain_text if @pokemon.obtain_text && !@pokemon.obtain_text.empty?
        mapname = _INTL("Faraway place") if nil_or_empty?(mapname)
        memo += sprintf(" in %s", mapname)
        # Write date received
        if @pokemon.timeReceived
          date  = @pokemon.timeReceived.day
          month = pbGetMonthName(@pokemon.timeReceived.mon)
          year  = @pokemon.timeReceived.year
          memo += _INTL(" on {1} {2}, {3}", date, month, year)
        end
        memo += _INTL(".\n")
      end
      # Write all text
      drawFormattedTextEx(overlay, 232 - 216, 86 + 214, 268 + 220, memo, Color.new(64, 64, 64), Color.new(216, 216, 192), 28)
      # Draw Pokemon type(s)
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,358,106,:left_halfwide)
    elsif PluginManager.installed?("Emerald Summary Screen")
      base   = Color.new(248, 248, 248)
      shadow = Color.new(96, 96, 96)
      # If a Shadow Pokémon, draw the heart gauge area and bar
      if @pokemon.shadowPokemon?
        shadowfract = @pokemon.heart_gauge.to_f / @pokemon.max_gauge_size
        imagepos = [
          ["Graphics/UI/Summary/overlay_shadow", 216, 178],
          ["Graphics/UI/Summary/overlay_shadowbar", 240, 264, 0, 0, (shadowfract * 248).floor, -1]
        ]
        pbDrawImagePositions(overlay, imagepos)
      end
      # Write various bits of text
      textpos = [
        [_INTL("OT/"), 222, 72, :left, base, shadow],
        [_INTL("IDNo"), 390, 72, :left, base, shadow],
        [_INTL("Type/"), 222, 102, :left, Color.new(0, 0, 0), Color.new(208, 208, 200)],
      ]
      # Write Original Trainer's name and ID number
      if @pokemon.owner.name.empty?
        textpos.push([_INTL("RENTAL"), 258, 68, :left, base, shadow])
        textpos.push(["?????", 446, 68, :left, base, shadow])
      else
        ownerbase   = base
        ownershadow = shadow
        case @pokemon.owner.gender
        when 0
          ownerbase = Color.new(60, 206, 255)
          ownershadow = Color.new(0, 140, 149)
        when 1
          ownerbase = Color.new(248, 184, 176)
          ownershadow = Color.new(208, 112, 104)
        end
        textpos.push([@pokemon.owner.name, 258, 72, :left, ownerbase, ownershadow])
        textpos.push([sprintf("%05d", @pokemon.owner.public_id), 504, 72, :right,
                      base, shadow])
      end
      # Write Exp text OR heart gauge message (if a Shadow Pokémon)
      if @pokemon.shadowPokemon?
        black_text_tag = shadowc3tag(BLACK_TEXT_BASE, BLACK_TEXT_SHADOW)
        heartmessage = [_INTL("The door to its heart is open! Undo the final lock!"),
                        _INTL("The door to its heart is almost fully open."),
                        _INTL("The door to its heart is nearly open."),
                        _INTL("The door to its heart is opening wider."),
                        _INTL("The door to its heart is opening up."),
                        _INTL("The door to its heart is tightly shut.")][@pokemon.heartStage]
        memo = black_text_tag + heartmessage
        drawFormattedTextEx(overlay, 222, 202, 282, memo)
      else
        endexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level + 1)
        textpos.push([_INTL("Exp. Points"), 222, 202, :left, base, shadow])
        textpos.push([@pokemon.exp.to_s_formatted, 504, 202, :right, Color.new(0, 0, 0), Color.new(208, 208, 200)])
        textpos.push([_INTL("To Next Lv."), 222, 234, :left, base, shadow])
        textpos.push([(endexp - @pokemon.exp).to_s_formatted, 504, 234, :right, Color.new(0, 0, 0), Color.new(208, 208, 200)])
      end
      # Write the held item's name
      if @pokemon.hasItem?
        textpos.push([@pokemon.item.name, 222, 152, :left, Color.new(0, 0, 0), Color.new(208, 208, 200)])
      else
        textpos.push([_INTL("None"), 222, 152, :left, Color.new(0, 0, 0), Color.new(208, 208, 200)])
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw Pokémon type(s)
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,286,98,:left_long)
      # Draw Exp bar
      if (@pokemon.level < GameData::GrowthRate.max_level) && (!@pokemon.shadowPokemon?)
        w = @pokemon.exp_fraction * 128
        w = ((w / 2).round) * 2
        pbDrawImagePositions(overlay,
                             [["Graphics/UI/Summary/overlay_exp", 368, 264, 0, 0, w, 6]])
      end
    elsif PluginManager.installed?("BW Summary Screen")
      # Changes the color of the text, to the one used in BW
      base   = Color.new(255, 255, 255)
      shadow = Color.new(165, 165, 173)
      dexNumBase   = (@pokemon.shiny?) ? Color.new(198, 0, 0) : Color.new(90, 82, 82)
      dexNumShadow = (@pokemon.shiny?) ? Color.new(255, 155, 155) : Color.new(165, 165, 173)
      # If a Shadow Pokémon, draw the heart gauge area and bar
      if @pokemon.shadowPokemon?
        shadowfract = @pokemon.heart_gauge.to_f / @pokemon.max_gauge_size
        if SUMMARY_B2W2_STYLE
          imagepos = [
            ["Graphics/Pictures/Summary/overlay_shadow_B2W2",0, 228],
            ["Graphics/Pictures/Summary/overlay_shadowbar", 90, 266, 0, 0,(shadowfract * 248).floor, -1]
          ]
        else
          imagepos = [
            ["Graphics/Pictures/Summary/overlay_shadow", 0, 228],
            ["Graphics/Pictures/Summary/overlay_shadowbar", 90, 268, 0, 0,(shadowfract * 248).floor, -1]
          ]
        end
        pbDrawImagePositions(overlay, imagepos)
      end
      # Write various bits of text. Changed various positions of the text
      if SUMMARY_B2W2_STYLE
        textpos = [
          [_INTL("Dex No."), 34, 72, 0, base, shadow],
          [_INTL("Species"), 34, 104, 0, base, shadow],
          [@pokemon.speciesName, 162, 106, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          [_INTL("Type"), 34, 136, 0, base, shadow],
          [_INTL("OT"), 34, 168, 0, base, shadow],
          [_INTL("ID No."), 34, 200, 0, base, shadow],
        ]
      else
        textpos = [
          [_INTL("Dex No."), 34, 74, 0, base, shadow],
          [_INTL("Species"), 34, 106, 0, base, shadow],
          [@pokemon.speciesName, 164, 106, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)],
          [_INTL("Type"), 34, 139, 0, base, shadow],
          [_INTL("OT"), 34, 170, 0, base, shadow],
          [_INTL("ID No."), 34, 202, 0, base, shadow],
        ]
      end
      # Write the Regional/National Dex number
      dexnumshift = false
      if $player.pokedex.unlocked?(-1)   # National Dex is unlocked
        dexnum = @nationalDexList.index(@pokemon.species_data.species) || 0
        dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(-1)
      else
        dexnum = 0
        ($player.pokedex.dexes_count - 1).times do |i|
          next if !$player.pokedex.unlocked?(i)
          num = pbGetRegionalNumber(i, @pokemon.species)
          next if num <= 0
          dexnum = num
          dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(i)
          break
        end
      end
      if dexnum <= 0
        if SUMMARY_B2W2_STYLE
          # Write ??? if Pokémon is not found in the Dex
          textpos.push(["???", 164, 72, 0, dexNumBase, dexNumShadow])
        else
          textpos.push(["???", 164, 74, 0, dexNumBase, dexNumShadow])
        end
      else
        dexnum -= 1 if dexnumshift
        # Write the Dex Number
        if SUMMARY_B2W2_STYLE
          textpos.push([sprintf("%03d", dexnum), 164, 72, 0, dexNumBase, dexNumShadow])
        else
          textpos.push([sprintf("%03d", dexnum), 164, 74, 0, dexNumBase, dexNumShadow])
        end
      end
      # Write Original Trainer's name and ID number
      if @pokemon.owner.name.empty?
        if SUMMARY_B2W2_STYLE
          textpos.push([_INTL("RENTAL"), 164, 156, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push(["?????", 164, 186, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        else
          textpos.push([_INTL("RENTAL"), 164, 158, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push(["?????", 164, 188, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        end
      else
        # Changes the color of the text, to the one used in BW
        ownerbase   = Color.new(90, 82, 82)
        ownershadow = Color.new(165, 165, 173)
        case @pokemon.owner.gender
        when 0
          ownerbase = Color.new(0, 0, 214)
          ownershadow = Color.new(15, 148, 255)
        when 1
          ownerbase = Color.new(198, 0, 0)
          ownershadow = Color.new(255, 155, 155)
        end
        if SUMMARY_B2W2_STYLE
          # Write Trainer's name
          textpos.push([@pokemon.owner.name, 164, 168, 0, ownerbase, ownershadow])
          # Write Pokémon's ID
          textpos.push([sprintf("%05d", @pokemon.owner.public_id), 164, 200, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        else
          # Write Trainer's name
          textpos.push([@pokemon.owner.name, 164, 170, 0, ownerbase, ownershadow])
          # Write Pokémon's ID
          textpos.push([sprintf("%05d", @pokemon.owner.public_id), 164, 202, 0, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        end
      end
      # Write Exp text OR heart gauge message (if a Shadow Pokémon)
      if @pokemon.shadowPokemon?
        textpos.push([_INTL("Heart Gauge"), 33, 234, 0, base, shadow])
        heartmessage = [_INTL("The door to its heart is open! Undo the final lock!"),
                        _INTL("The door to its heart is almost fully open."),
                        _INTL("The door to its heart is nearly open."),
                        _INTL("The door to its heart is opening wider."),
                        _INTL("The door to its heart is opening up."),
                        _INTL("The door to its heart is tightly shut.")][@pokemon.heartStage]
         # Changed the text color, to the one used in BW
         memo = sprintf("<c3=404040,B0B0B0>%s\n", heartmessage)
         y_coord = SUMMARY_B2W2_STYLE ? 294 : 296
         drawFormattedTextEx(overlay, 16, y_coord, 264, memo)
      else
        endexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level + 1)
        if SUMMARY_B2W2_STYLE
          textpos.push([_INTL("Exp. Points"), 34, 232, 0, base, shadow])
          # Changed the Positon of No. of Exp
          textpos.push([@pokemon.exp.to_s_formatted, 215, 264, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push([_INTL("To Next Lv."), 34, 296, 0, base, shadow])
          # Changed the Positon of No. of Exp to Next Level
          textpos.push([(endexp-@pokemon.exp).to_s_formatted, 177, 328, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        else
          textpos.push([_INTL("Exp. Points"), 34, 234, 0, base, shadow])
          # Changed the Positon of No. of Exp
          textpos.push([@pokemon.exp.to_s_formatted, 215, 266, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
          textpos.push([_INTL("To Next Lv."),34,298,0,base,shadow])
          # Changed the Positon of No. of Exp to Next Level
          textpos.push([(endexp-@pokemon.exp).to_s_formatted, 177, 330, 2, Color.new(90, 82, 82), Color.new(165, 165, 173)])
        end
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw Pokémon type(s)
      y = 134
      y = 132 if SUMMARY_B2W2_STYLE
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,162,y,:left_diagonal)
      # Draw Exp bar
      if @pokemon.level < GameData::GrowthRate.max_level
        w = @pokemon.exp_fraction * 128
        w = ((w/2).round) * 2
        if SUMMARY_B2W2_STYLE
          pbDrawImagePositions(overlay, [["Graphics/Pictures/Summary/overlay_exp", 140, 358 ,0, 0, w, 6]])
        else
          pbDrawImagePositions(overlay, [["Graphics/Pictures/Summary/overlay_exp", 140, 360, 0, 0, w, 6]])
        end
      end
    else
      base   = Color.new(248, 248, 248)
      shadow = Color.new(104, 104, 104)
      dexNumBase   = (@pokemon.shiny?) ? Color.new(248, 56, 32) : Color.new(64, 64, 64)
      dexNumShadow = (@pokemon.shiny?) ? Color.new(224, 152, 144) : Color.new(176, 176, 176)
      # If a Shadow Pokemon, draw the heart gauge area and bar
      if @pokemon.shadowPokemon?
        shadowfract = @pokemon.heart_gauge.to_f / @pokemon.max_gauge_size
        imagepos = [
          ["Graphics/UI/Summary/overlay_shadow", 224, 240],
          ["Graphics/UI/Summary/overlay_shadowbar", 242, 280, 0, 0, (shadowfract * 248).floor, -1]
        ]
        pbDrawImagePositions(overlay, imagepos)
      end
      # Write various bits of text
      textpos = [
        [_INTL("Dex No."), 238, 86, :left, base, shadow],
        [_INTL("Species"), 238, 118, :left, base, shadow],
        [@pokemon.speciesName, 435, 118, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
        [_INTL("Type"), 238, 150, :left, base, shadow],
        [_INTL("OT"), 238, 182, :left, base, shadow],
        [_INTL("ID No."), 238, 214, :left, base, shadow]
      ]
      # Write the Regional/National Dex number
      dexnum = 0
      dexnumshift = false
      if $player.pokedex.unlocked?(-1)   # National Dex is unlocked
        dexnum = @nationalDexList.index(@pokemon.species_data.species) || 0
        dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(-1)
      else
        ($player.pokedex.dexes_count - 1).times do |i|
          next if !$player.pokedex.unlocked?(i)
          num = pbGetRegionalNumber(i, @pokemon.species)
          next if num <= 0
          dexnum = num
		  dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(i)
          break
        end
      end
      if dexnum <= 0
        textpos.push(["???", 435, 86, :center, dexNumBase, dexNumShadow])
	  else
        dexnum -= 1 if dexnumshift
        textpos.push([sprintf("%03d", dexnum), 435, 86, :center, dexNumBase, dexNumShadow])
      end
      # Write Original Trainer's name and ID number
      if @pokemon.owner.name.empty?
        textpos.push([_INTL("RENTAL"), 435, 182, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        textpos.push(["?????", 435, 214, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)])
      else
        ownerbase   = Color.new(64, 64, 64)
        ownershadow = Color.new(176, 176, 176)
        case @pokemon.owner.gender
        when 0
          ownerbase = Color.new(24, 112, 216)
          ownershadow = Color.new(136, 168, 208)
        when 1
          ownerbase = Color.new(248, 56, 32)
          ownershadow = Color.new(224, 152, 144)
        end
        textpos.push([@pokemon.owner.name, 435, 182, :center, ownerbase, ownershadow])
        textpos.push([sprintf("%05d", @pokemon.owner.public_id), 435, 214, :center,
                      Color.new(64, 64, 64), Color.new(176, 176, 176)])
      end
      # Write Exp text OR heart gauge message (if a Shadow Pokemon)
      if @pokemon.shadowPokemon?
        textpos.push([_INTL("Heart Gauge"), 238, 246, :left, base, shadow])
        black_text_tag = shadowc3tag(BLACK_TEXT_BASE, BLACK_TEXT_SHADOW)
        heartmessage = [_INTL("The door to its heart is open! Undo the final lock!"),
                        _INTL("The door to its heart is almost fully open."),
                        _INTL("The door to its heart is nearly open."),
                        _INTL("The door to its heart is opening wider."),
                        _INTL("The door to its heart is opening up."),
                        _INTL("The door to its heart is tightly shut.")][@pokemon.heartStage]
        memo = black_text_tag + heartmessage
        drawFormattedTextEx(overlay, 234, 308, 264, memo)
      else
        endexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level + 1)
        textpos.push([_INTL("Exp. Points"), 238, 246, :left, base, shadow])
        textpos.push([@pokemon.exp.to_s_formatted, 488, 278, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        textpos.push([_INTL("To Next Lv."), 238, 310, :left, base, shadow])
        textpos.push([(endexp - @pokemon.exp).to_s_formatted, 488, 342, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)])
      end
      # Draw all text
      pbDrawTextPositions(overlay, textpos)
      # Draw Pokemon type(s)
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,434,146)
      # Draw Exp bar
      if @pokemon.level < GameData::GrowthRate.max_level
        w = @pokemon.exp_fraction * 128
        w = ((w / 2).round) * 2
        pbDrawImagePositions(overlay,
                             [["Graphics/UI/Summary/overlay_exp", 362, 372, 0, 0, w, 6]])
      end
    end
    if PluginManager.installed?("[DBK] Terastallization")
      return if !Settings::SUMMARY_TERA_TYPES
      overlay = @sprites["overlay"].bitmap
      coords = [330, 143]
      coords = [254, 104] if PluginManager.installed?("FRLG Summary Screen")
      coords = [474,  96] if PluginManager.installed?("Emerald Summary Screen")
      coords = [122, 128] if PluginManager.installed?("BW Summary Screen")
      pbDisplayTeraType(@pokemon, overlay, coords[0], coords[1])
    end
  end

  if PluginManager.installed?("FRLG Summary Screen")
    def drawPageThreeSelecting(move_to_learn)
      overlay = @sprites["overlay"].bitmap
      overlay.clear
      # Set different overlay for shiny Pokémon
      drawShinyOverlay(overlay, 2, @pokemon.shiny?)  
      base   = Color.new(248, 248, 248)
      shadow = Color.new(120, 128, 144)
      moveBase   = Color.new(33, 33, 33)
      moveShadow = Color.new(222, 222, 222)
      ppBase   = [moveBase,                # More than 1/2 of total PP
                  Color.new(239, 222, 0),    # 1/2 of total PP or less
                  Color.new(255, 148, 0),   # 1/4 of total PP or less
                  Color.new(239, 0, 0)]    # Zero PP
      ppShadow = [moveShadow,             # More than 1/2 of total PP
                  Color.new(255, 247, 140),   # 1/2 of total PP or less
                  Color.new(255, 239, 115),   # 1/4 of total PP or less
                  Color.new(247, 222, 156)]   # Zero PP
      # Set background image
      if move_to_learn
        @sprites["background"].setBitmap("Graphics/UI/Summary/bg_learnmove")
      else
        @sprites["background"].setBitmap("Graphics/UI/Summary/bg_movedetail")
      end
      # Write various bits of text
      textpos = [
        [_INTL("Known Moves"), 26 - 18, 22 - 16, :left, base, Color.new(96, 96, 96)],
        [_INTL("Switch"), 426, 6, :left, base, Color.new(96, 96, 96)],
        [_INTL("Power"), 20 + 34, 160 - 42, :center, base, shadow, :outline],
        [_INTL("Accuracy"), 20 + 34, 192 - 38, :center, base, shadow, :outline],
        [_INTL("Effect"), 20 + 34, 192 - 4, :center, base, shadow, :outline],
        [@pokemon.name, 92, 42, :left, Color.new(255, 255, 255), Color.new(99, 99, 99)]
      ]
      # Write the gender symbol (Changed to match FRLG)
      if @pokemon.male?
        textpos.push([_INTL("♂"), 244, 42, :right, Color.new(160, 192, 240), Color.new(48, 80, 200)])
      elsif @pokemon.female?
        textpos.push([_INTL("♀"), 244, 42, :right, Color.new(259, 189, 115), Color.new(231, 8, 8)])
      end
      imagepos = []
      # Show shininess star (Changed to match FRLG)
      if @pokemon.shiny?
        imagepos.push([sprintf("Graphics/UI/shiny"), 92, 76])
      end 
      # Write move names, types and PP amounts for each known move
      yPos = 104 - 60
      limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
      limit.times do |i|
        move = @pokemon.moves[i]
        if i == Pokemon::MAX_MOVES
          move = move_to_learn
        end
        if move
          type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
          imagepos.push(["Graphics/UI/types", 248 + 12, yPos - 4, 0, type_number * 28, 64, 28])
          textpos.push([move.name, 316 + 12, yPos + 2, :left, moveBase, moveShadow])
          if move.total_pp > 0
            ppfraction = 0
            if move.pp == 0
              ppfraction = 3
            elsif move.pp * 4 <= move.total_pp
              ppfraction = 2
            elsif move.pp * 2 <= move.total_pp
              ppfraction = 1
            end
            textpos.push([_INTL("PP"), 342 + 76, yPos + 34, :left, ppBase[ppfraction], ppShadow[ppfraction]])
            textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 460 + 44, yPos + 34, :right, ppBase[ppfraction], ppShadow[ppfraction]])
          end
        else
          textpos.push([_INTL("PP"), 342 + 76, yPos + 34, :left, moveBase, moveShadow])
          textpos.push(["-", 316 + 12, yPos + 2, :left, moveBase, moveShadow])
          textpos.push(["--", 442 + 2, yPos + 32, :left, moveBase, moveShadow])
        end
        yPos += 68
      end
      # Draw all text and images
      pbDrawTextPositions(overlay, textpos)
      pbDrawImagePositions(overlay, imagepos)
      # Draw Pokémon's type icon(s)
      v = 108
      v = 100 if @pokemon.types.length > 8
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,v,70,:left_halfwide)
    end
  end

  def drawPageFourSelecting(move_to_learn)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    if PluginManager.installed?("Emerald Summary Screen")
      @sprites["overlay_movedetail"].visible = true
      base   = Color.new(0, 0, 0)
      shadow = Color.new(208, 208, 200)
      moveBase   = Color.new(248, 248, 248)
      moveShadow = Color.new(96, 96, 96)
      ppBase   = [base,                      # More than 1/2 of total PP
                  Color.new(214, 198, 0),    # 1/2 of total PP or less
                  Color.new(248, 136, 32),   # 1/4 of total PP or less
                  Color.new(255, 132, 0)]    # Zero PP
      ppShadow = [shadow,                   # More than 1/2 of total PP
                  Color.new(255, 247, 140), # 1/2 of total PP or less
                  Color.new(247, 222, 156), # 1/4 of total PP or less
                  Color.new(255, 239, 115)] # Zero PP
      # Set background image
      if move_to_learn
        @sprites["background"].setBitmap("Graphics/UI/Summary/bg_learnmove")
      else
        @sprites["background"].setBitmap("Graphics/UI/Summary/bg_4")
      end
      # Write various bits of text
      textpos = [
        [_INTL("Battle Moves"), 4, 6, :left, moveBase, moveShadow],
        [_INTL("Power"), 4, 142, :left, moveBase, moveShadow],
        [_INTL("Accuracy"), 4, 174, :left, moveBase, moveShadow]
      ]
      imagepos = []
      # Write move names, types and PP amounts for each known move
      yPos = 70
      yPos -= 8 if move_to_learn
      limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
      limit.times do |i|
        move = @pokemon.moves[i]
        if i == Pokemon::MAX_MOVES
          move = move_to_learn
          yPos += 20
        end
        if move
          type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
          imagepos.push([_INTL("Graphics/UI/types"), 248, yPos - 4, 0, type_number * 28, 64, 28])
          textpos.push([move.name, 320, yPos, :left, moveBase, moveShadow])
          if move.total_pp > 0
            ppfraction = 0
            if move.pp == 0
              ppfraction = 3
            elsif move.pp * 4 <= move.total_pp
               ppfraction = 2
            elsif move.pp * 2 <= move.total_pp
              ppfraction = 1
            end
            textpos.push([_INTL("PP"), 414, yPos + 30, :left, ppBase[ppfraction], ppShadow[ppfraction]])
            textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 504, yPos + 30, :right, 
                          ppBase[ppfraction], ppShadow[ppfraction]])
          end
        else
          textpos.push(["-", 320, yPos, :left, moveBase, moveShadow])
          textpos.push(["--", 448, yPos + 32, :left, Color.new(0, 0, 0), Color.new(208, 208, 200)])
        end
        yPos += 60
      end
      textpos.push(["Switch", 430, 6, :left, Color.new(0, 0, 0), Color.new(208, 208, 200)])
      # Draw Pokémon's type icon(s)
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,70,32,:stack_right)
    elsif PluginManager.installed?("BW Summary Screen")
      # Changes the color of the text, to the one used in BW
      base   = Color.new(255, 255, 255)
      shadow = Color.new(123, 123, 123)
      moveBase   = Color.new(255, 255, 255)
      moveShadow = Color.new(123, 123, 123)
      ppBase   = [moveBase,                # More than 1/2 of total PP
                  Color.new(255, 214, 0),    # 1/2 of total PP or less
                  Color.new(255, 115, 0),   # 1/4 of total PP or less
                  Color.new(255, 8, 74)]    # Zero PP
      ppShadow = [moveShadow,             # More than 1/2 of total PP
                  Color.new(123, 99, 0),   # 1/2 of total PP or less
                  Color.new(115, 57, 0),   # 1/4 of total PP or less
                  Color.new(123, 8, 49)]   # Zero PP
      # Set background image
      if move_to_learn
        @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_learnmove")
      else
        if SUMMARY_B2W2_STYLE
          @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_movedetail_B2W2")
        else
          @sprites["menuoverlay"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
        end
      end
      # Write various bits of text
      if move_to_learn || SUMMARY_B2W2_STYLE
        textpos = [
          [_INTL("CATEGORY"), 20, 128, 0, base, shadow],
          [_INTL("POWER"), 20, 160, 0, base, shadow],
          [_INTL("ACCURACY"), 20, 192, 0, base, shadow]
        ]
      else
        textpos = [
          [_INTL("MOVES"), 26, 14, 0, base, shadow],
          [_INTL("CATEGORY"), 20, 128, 0, base, shadow],
          [_INTL("POWER"), 20, 160, 0, base, shadow],
          [_INTL("ACCURACY"), 20, 192, 0, base, shadow]
        ]
      end
      imagepos = []
      # Write move names, types and PP amounts for each known move
      yPos = 92
      yPos -= 76 if move_to_learn
      limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
      limit.times do |i|
        move = @pokemon.moves[i]
        if i == Pokemon::MAX_MOVES
          move = move_to_learn
          yPos += 20
        end
        if move
          type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
          imagepos.push(["Graphics/Pictures/types", 260, yPos + 8, 0, type_number * 28, 64, 28])
          textpos.push([move.name, 328, yPos + 12, 0, moveBase, moveShadow])
          if move.total_pp > 0
            textpos.push([_INTL("PP"), 354, yPos + 44, 0, moveBase, moveShadow])
            ppfraction = 0
            if move.pp == 0
              ppfraction = 3
            elsif move.pp * 4 <= move.total_pp
              ppfraction = 2
            elsif move.pp * 2 <= move.total_pp
              ppfraction = 1
            end
            textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 472, yPos + 44, 1, ppBase[ppfraction], ppShadow[ppfraction]])
          end
        else
          textpos.push(["-", 328, yPos + 12, 0, moveBase, moveShadow])
          textpos.push(["--", 454, yPos + 44, 1, moveBase, moveShadow])
        end
        yPos += 64
      end
      # Draw Pokémon's type icon(s)
      v = 96
      v = 130 if @pokemon.types.length==1
      v = 76 if @pokemon.types.length>20
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,v,78,:left_wide2)
    else
      base   = Color.new(248, 248, 248)
      shadow = Color.new(104, 104, 104)
      moveBase   = Color.new(64, 64, 64)
      moveShadow = Color.new(176, 176, 176)
      ppBase   = [moveBase,                # More than 1/2 of total PP
                  Color.new(248, 192, 0),    # 1/2 of total PP or less
                  Color.new(248, 136, 32),   # 1/4 of total PP or less
                  Color.new(248, 72, 72)]    # Zero PP
      ppShadow = [moveShadow,             # More than 1/2 of total PP
                  Color.new(144, 104, 0),   # 1/2 of total PP or less
                  Color.new(144, 72, 24),   # 1/4 of total PP or less
                  Color.new(136, 48, 48)]   # Zero PP
      # Set background image
      if move_to_learn
        @sprites["background"].setBitmap("Graphics/UI/Summary/bg_learnmove")
      else
        @sprites["background"].setBitmap("Graphics/UI/Summary/bg_movedetail")
      end
      # Write various bits of text
      textpos = [
        [_INTL("MOVES"), 26, 22, :left, base, shadow],
        [_INTL("CATEGORY"), 20, 128, :left, base, shadow],
        [_INTL("POWER"), 20, 160, :left, base, shadow],
        [_INTL("ACCURACY"), 20, 192, :left, base, shadow]
      ]
      imagepos = []
      # Write move names, types and PP amounts for each known move
      yPos = 104
      yPos -= 76 if move_to_learn
      limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
      limit.times do |i|
        move = @pokemon.moves[i]
        if i == Pokemon::MAX_MOVES
          move = move_to_learn
          yPos += 20
        end
        if move
          type_number = GameData::Type.get(move.display_type(@pokemon)).icon_position
          imagepos.push([_INTL("Graphics/UI/types"), 248, yPos - 4, 0, type_number * 28, 64, 28])
          textpos.push([move.name, 316, yPos, :left, moveBase, moveShadow])
          if move.total_pp > 0
            textpos.push([_INTL("PP"), 342, yPos + 32, :left, moveBase, moveShadow])
            ppfraction = 0
            if move.pp == 0
              ppfraction = 3
            elsif move.pp * 4 <= move.total_pp
              ppfraction = 2
            elsif move.pp * 2 <= move.total_pp
              ppfraction = 1
            end
            textpos.push([sprintf("%d/%d", move.pp, move.total_pp), 460, yPos + 32, :right,
                          ppBase[ppfraction], ppShadow[ppfraction]])
          end
        else
          textpos.push(["-", 316, yPos, :left, moveBase, moveShadow])
          textpos.push(["--", 442, yPos + 32, :right, moveBase, moveShadow])
        end
        yPos += 64
      end
      # Draw Pokémon's type icon(s)
      disp_multiple_types(@pokemon.types,overlay,@typebitmap,96,78,:left_wide)
    end
    # Draw all text and images
    pbDrawTextPositions(overlay, textpos)
    pbDrawImagePositions(overlay, imagepos)
  end
end

class MoveRelearner_Scene
  def pbDrawMoveList
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    disp_multiple_types(@pokemon.types,overlay,@typebitmap,366,70,:left)
    textpos = [
      [_INTL("Teach which move?"), 16, 14, :left, Color.new(88, 88, 80), Color.new(168, 184, 184)]
    ]
    imagepos = []
    yPos = 88
    VISIBLEMOVES.times do |i|
      moveobject = @moves[@sprites["commands"].top_item + i]
      if moveobject
        moveData = GameData::Move.get(moveobject)
        type_number = GameData::Type.get(moveData.display_type(@pokemon)).icon_position
        imagepos.push([_INTL("Graphics/UI/types"), 12, yPos - 4, 0, type_number * 28, 64, 28])
        textpos.push([moveData.name, 80, yPos, :left, Color.new(248, 248, 248), Color.black])
        textpos.push([_INTL("PP"), 112, yPos + 32, :left, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        if moveData.total_pp > 0
          textpos.push([moveData.total_pp.to_s + "/" + moveData.total_pp.to_s, 230, yPos + 32, :right,
                        Color.new(64, 64, 64), Color.new(176, 176, 176)])
        else
          textpos.push(["--", 230, yPos + 32, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        end
      end
      yPos += 64
    end
    imagepos.push(["Graphics/UI/Move Reminder/cursor",
                   0, 78 + ((@sprites["commands"].index - @sprites["commands"].top_item) * 64),
                   0, 0, 258, 72])
    selMoveData = GameData::Move.get(@moves[@sprites["commands"].index])
    power = selMoveData.display_damage(@pokemon)
    category = selMoveData.display_category(@pokemon)
    accuracy = selMoveData.display_accuracy(@pokemon)
    textpos.push([_INTL("CATEGORY"), 272, 120, :left, Color.new(248, 248, 248), Color.black])
    textpos.push([_INTL("POWER"), 272, 152, :left, Color.new(248, 248, 248), Color.black])
    textpos.push([power <= 1 ? power == 1 ? "???" : "---" : power.to_s, 468, 152, :center,
                  Color.new(64, 64, 64), Color.new(176, 176, 176)])
    textpos.push([_INTL("ACCURACY"), 272, 184, :left, Color.new(248, 248, 248), Color.black])
    textpos.push([accuracy == 0 ? "---" : "#{accuracy}%", 468, 184, :center,
                  Color.new(64, 64, 64), Color.new(176, 176, 176)])
    pbDrawTextPositions(overlay, textpos)
    imagepos.push(["Graphics/UI/category", 436, 116, 0, category * 28, 64, 28])
    if @sprites["commands"].index < @moves.length - 1
      imagepos.push(["Graphics/UI/Move Reminder/buttons", 48, 350, 0, 0, 76, 32])
    end
    if @sprites["commands"].index > 0
      imagepos.push(["Graphics/UI/Move Reminder/buttons", 134, 350, 76, 0, 76, 32])
    end
    pbDrawImagePositions(overlay, imagepos)
    drawTextEx(overlay, 272, 216, 230, 5, selMoveData.description,
               Color.new(64, 64, 64), Color.new(176, 176, 176))
  end
end

class PokemonStorageScene
  def pbUpdateOverlay(selection, party = nil)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    if PluginManager.installed?("BW Storage System")
      # Changed Text Colors
      buttonbase = Color.new(239, 239, 239)
      buttonshadow = Color.new(132, 132, 132)
      pbDrawTextPositions(
        overlay,
        # Changed Text Positions
        [[_INTL("PARTY: {1}", (@storage.party.length rescue 0)), 274, 350, :center, buttonbase, buttonshadow],
         [_INTL("Exit"), 450, 350, :center, buttonbase, buttonshadow]]
      )
      pokemon = nil
      if @screen.pbHeldPokemon
        pokemon = @screen.pbHeldPokemon
      elsif selection >= 0
        pokemon = (party) ? party[selection] : @storage[@storage.currentBox, selection]
      end
      if !pokemon
        @sprites["pokemon"].visible = false
        return
      end
      @sprites["pokemon"].visible = true
      # Changed Text Colors
      base   = Color.new(90, 82, 82)
      shadow = Color.new(165, 165, 173)
      nonbase   = Color.new(90, 82, 82)
      nonshadow = Color.new(165, 165, 173)
      pokename = pokemon.name
      textstrings = [
        # Changed Text Positions
        [pokename, 10, 16, :left, base, shadow]
      ]
      if !pokemon.egg?
        imagepos = []
        # Changed Text Positions
        if pokemon.male?
          textstrings.push([_INTL("♂"), 148, 16, :left, Color.new(0, 0, 214), Color.new(15, 148, 255)])
        elsif pokemon.female?
          textstrings.push([_INTL("♀"), 148, 16, :left, Color.new(198, 0, 0), Color.new(255, 155, 155)])
        end
        imagepos.push(["Graphics/UI/Storage/overlay_lv", 6, 268])
        textstrings.push([pokemon.level.to_s, 28, 262, :left, Color.new(255, 255, 255), Color.new(90, 82, 82)])
        if pokemon.ability
          textstrings.push([pokemon.ability.name, 16, 328, :left, base, shadow])
        else
          textstrings.push([_INTL("No ability"), 16, 328, :left, nonbase, nonshadow])
        end
        if pokemon.item
          textstrings.push([pokemon.item.name, 16, 360, :left, base, shadow])
        else
          textstrings.push([_INTL("No item"), 16, 360, :left, nonbase, nonshadow])
        end
        # Changed Shiny Icon
        imagepos.push(["Graphics/UI/shiny", 68, 262]) if pokemon.shiny?
        typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
        disp_multiple_types(pokemon.types,overlay,typebitmap,94,292,:center_with_spacing)
        # Changed Markins Position
        drawMarkings(overlay, 86, 262, 128, 20, pokemon.markings)
        pbDrawImagePositions(overlay, imagepos)
      end
    else
      buttonbase = Color.new(248, 248, 248)
      buttonshadow = Color.new(80, 80, 80)
      pbDrawTextPositions(
        overlay,
        [[_INTL("Party: {1}", (@storage.party.length rescue 0)), 270, 334, :center, buttonbase, buttonshadow, :outline],
         [_INTL("Exit"), 446, 334, :center, buttonbase, buttonshadow, :outline]]
      )
      pokemon = nil
      if @screen.pbHeldPokemon
        pokemon = @screen.pbHeldPokemon
      elsif selection >= 0
        pokemon = (party) ? party[selection] : @storage[@storage.currentBox, selection]
      end
      if !pokemon
        @sprites["pokemon"].visible = false
        return
      end
      @sprites["pokemon"].visible = true
      base   = Color.new(88, 88, 80)
      shadow = Color.new(168, 184, 184)
      nonbase   = Color.new(208, 208, 208)
      nonshadow = Color.new(224, 224, 224)
      pokename = pokemon.name
      textstrings = [
        [pokename, 10, 14, :left, base, shadow]
      ]
      if !pokemon.egg?
        imagepos = []
        if pokemon.male?
          textstrings.push([_INTL("♂"), 148, 14, :left, Color.new(24, 112, 216), Color.new(136, 168, 208)])
        elsif pokemon.female?
          textstrings.push([_INTL("♀"), 148, 14, :left, Color.new(248, 56, 32), Color.new(224, 152, 144)])
        end
        imagepos.push([_INTL("Graphics/UI/Storage/overlay_lv"), 6, 246])
        textstrings.push([pokemon.level.to_s, 28, 240, :left, base, shadow])
        if pokemon.ability
          textstrings.push([pokemon.ability.name, 86, 312, :center, base, shadow])
        else
          textstrings.push([_INTL("No ability"), 86, 312, :center, nonbase, nonshadow])
        end
        if pokemon.item
          textstrings.push([pokemon.item.name, 86, 348, :center, base, shadow])
        else
          textstrings.push([_INTL("No item"), 86, 348, :center, nonbase, nonshadow])
        end
        imagepos.push(["Graphics/UI/shiny", 156, 198]) if pokemon.shiny?
        typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
        disp_multiple_types(pokemon.types,overlay,typebitmap,84,272,:center_with_spacing)
        drawMarkings(overlay, 70, 240, 128, 20, pokemon.markings)
        pbDrawImagePositions(overlay, imagepos)
      end
    end
    pbDrawTextPositions(overlay, textstrings)
    @sprites["pokemon"].setPokemonBitmap(pokemon)
    if PluginManager.installed?("[DBK] Terastallization")
      return if !Settings::STORAGE_TERA_TYPES
      if @sprites["pokemon"].visible
        if @screen.pbHeldPokemon
          pokemon = @screen.pbHeldPokemon
        elsif selection >= 0
          pokemon = (party) ? party[selection] : @storage[@storage.currentBox, selection]
        end
        pbDisplayTeraType(pokemon, overlay, 8, 164)      
      end
    end
  end
end

class PokemonPokedexInfo_Scene
  def drawMultipleTypes(types,overlay,xPos,yPos)
    types.each_with_index do |type, i|
      type_number = GameData::Type.get(type).icon_position
      type_rect = Rect.new(0, type_number * 32, 96, 32)
      type_x = xPos + (100 * i)
      type_y = yPos
      if types.length > 4
        type_rect = Rect.new(152, type_number * 32, 48, 16)
        type_x = xPos - 14 + (46 * (i%5))
        type_x += (23 * (5 - (types.length % 5))) if i >= 5*(types.length/5)
        type_y = yPos + 15 * (i/5)
        type_y = yPos - 4 + 15 * (i/5) if types.length > 10
        type_y = xPos - 14 + 15 * (i/5) if types.length > 15
      elsif types.length > 2
        type_rect = Rect.new(96, type_number * 32, 56, 32)
        type_x = xPos + (60 * i)
        type_x = xPos - 10 + (58 * i) if types.length > 3
      end
      overlay.blt(type_x, type_y, @typebitmap.bitmap, type_rect)
    end
  end

  def drawPageInfo
    @sprites["background"].setBitmap(_INTL("Graphics/UI/Pokedex/bg_info"))
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(88, 88, 80)
    shadow = Color.new(168, 184, 184)
    imagepos = []
    imagepos.push([_INTL("Graphics/UI/Pokedex/overlay_info"), 0, 0]) if @brief
    species_data = GameData::Species.get_species_form(@species, @form)
    # Write various bits of text
    indexText = "???"
    if @dexlist[@index][:number] > 0
      indexNumber = @dexlist[@index][:number]
      indexNumber -= 1 if @dexlist[@index][:shift]
      indexText = sprintf("%03d", indexNumber)
    end
    textpos = [
      [_INTL("{1}{2} {3}", indexText, " ", species_data.name),
       246, 48, :left, Color.new(248, 248, 248), Color.black]
    ]
    if @show_battled_count
      textpos.push([_INTL("Number Battled"), 314, 164, :left, base, shadow])
      textpos.push([$player.pokedex.battled_count(@species).to_s, 452, 196, :right, base, shadow])
    else
      textpos.push([_INTL("Height"), 314, 164, :left, base, shadow])
      textpos.push([_INTL("Weight"), 314, 196, :left, base, shadow])
    end
    if $player.owned?(@species)
      # Write the category
      textpos.push([_INTL("{1} Pokémon", species_data.category), 246, 80, :left, base, shadow])
      # Write the height and weight
      if !@show_battled_count
        height = species_data.height
        weight = species_data.weight
        if System.user_language[3..4] == "US"   # If the user is in the United States
          inches = (height / 0.254).round
          pounds = (weight / 0.45359).round
          textpos.push([_ISPRINTF("{1:d}'{2:02d}\"", inches / 12, inches % 12), 460, 164, :right, base, shadow])
          textpos.push([_ISPRINTF("{1:4.1f} lbs.", pounds / 10.0), 494, 196, :right, base, shadow])
        else
          textpos.push([_ISPRINTF("{1:.1f} m", height / 10.0), 470, 164, :right, base, shadow])
          textpos.push([_ISPRINTF("{1:.1f} kg", weight / 10.0), 482, 196, :right, base, shadow])
        end
      end
      # Draw the Pokédex entry text
      drawTextEx(overlay, 40, 246, Graphics.width - 80, 4,   # overlay, x, y, width, num lines
                 species_data.pokedex_entry, base, shadow)
      # Draw the footprint
      footprintfile = GameData::Species.footprint_filename(@species, @form)
      if footprintfile
        footprint = RPG::Cache.load_bitmap("", footprintfile)
        overlay.blt(226, 138, footprint, footprint.rect)
        footprint.dispose
      end
      # Show the owned icon
      imagepos.push(["Graphics/UI/Pokedex/icon_own", 212, 44])
      # Draw the type icon(s)
      drawMultipleTypes(species_data.types,overlay,296,120)
    else
      # Write the category
      textpos.push([_INTL("????? Pokémon"), 246, 80, :left, base, shadow])
      # Write the height and weight
      if !@show_battled_count
        if System.user_language[3..4] == "US"   # If the user is in the United States
          textpos.push([_INTL("???'??\""), 460, 164, :right, base, shadow])
          textpos.push([_INTL("????.? lbs."), 494, 196, :right, base, shadow])
        else
          textpos.push([_INTL("????.? m"), 470, 164, :right, base, shadow])
          textpos.push([_INTL("????.? kg"), 482, 196, :right, base, shadow])
        end
      end
    end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw all images
    pbDrawImagePositions(overlay, imagepos)
    @sprites["infosprite"].visible    = true if PluginManager.installed?("Modular UI Scenes")
  end

  if PluginManager.installed?("[MUI] Pokedex Data Page")
    def drawPageData
      base    = Color.new(248, 248, 248)
      shadow  = Color.new(72, 72, 72)
      path = Settings::POKEDEX_DATA_PAGE_GRAPHICS_PATH
      overlay = @sprites["overlay"].bitmap
      imagepos = []
      textpos = []
      owned = $player.owned?(@species)
      species_data = GameData::Species.get_species_form(@species, @form)
      pbGenerateDataLists(species_data)
      @sprites["itemicon"].item = (owned && !@data_hash[:item].empty?) ? @data_hash[:item].values.last.last : nil
      pbDrawDataNotes(:encounter)
      #---------------------------------------------------------------------------
      # Draws species name & typing.
      #---------------------------------------------------------------------------
      textpos.push([species_data.name, 84,  56, :left, base, Color.black, :outline])
      if owned
        drawMultipleTypes(species_data.types,overlay,288,48)
      end
      #---------------------------------------------------------------------------
      # Draws gender icons.
      #---------------------------------------------------------------------------
      case species_data.gender_ratio
      when :AlwaysMale   then gender = [1, 0]
      when :AlwaysFemale then gender = [0, 1]
      when :Genderless   then gender = [0, 0]
      else
        if owned && !gender_difference?(@form)
          gender = [1, 1]
        else
          gender = (@gender == 0) ? [1, 0] : [0, 1]
        end
      end
      imagepos.push([path + "gender", 10, 48, 32 * gender[0],  0, 32, 32],
                    [path + "gender", 44, 48, 32 * gender[1], 32, 32, 32])
      #---------------------------------------------------------------------------
      # Draws habitat icon.
      #---------------------------------------------------------------------------
      habitat = (owned) ? GameData::Habitat.get(species_data.habitat).icon_position : 0
      imagepos.push([path + "habitats", 445, 174, 0, 48 * habitat, 64, 48])
      #---------------------------------------------------------------------------
      # Draws body shape icon.
      #---------------------------------------------------------------------------
      shape = GameData::BodyShape.get(species_data.shape).icon_position
      imagepos.push(["Graphics/UI/Pokedex/icon_shapes", 375, 170, 0, 60 * shape, 60, 60])
      #---------------------------------------------------------------------------
      # Draws egg group icons.
      #---------------------------------------------------------------------------
      if owned
        egg_groups = species_data.egg_groups
        egg_groups = [:None] if species_data.gender_ratio == :Genderless && 
                                !(egg_groups.include?(:Ditto) || egg_groups.include?(:Undiscovered))
      else
        egg_groups = [:None]
      end
      rectX = (Settings::ALT_EGG_GROUP_NAMES) ? 62 : 0
      egg_groups.each_with_index do |group, i|
        rectY = GameData::EggGroup.get(group).icon_position
        group_y = (egg_groups.length == 1) ? 188 : 172 + 30 * i
        imagepos.push([path + "egg_groups", 302, group_y, rectX, 28 * rectY, 62, 28])
      end
      #---------------------------------------------------------------------------
      # Draws the base stats text and bars.
      #---------------------------------------------------------------------------
      textpos.push(
        [_INTL("HP"),        12, 104, :left, base, shadow, :outline],
        [_INTL("Attack"),    12, 132, :left, base, shadow, :outline],
        [_INTL("Defense"),   12, 160, :left, base, shadow, :outline],
        [_INTL("Sp. Atk"),   12, 188, :left, base, shadow, :outline],
        [_INTL("Sp. Def"),   12, 216, :left, base, shadow, :outline],
        [_INTL("Speed"),     12, 244, :left, base, shadow, :outline]
      )
      stats_order = [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED]
      if owned
        stats_order.each_with_index do |s, i|
          stat = species_data.base_stats[s]
          w = stat * 100 / 254.0
          w = 1 if w < 1
          w = ((w / 2).round) * 2
          imagepos.push([path + "overlay_stats", 106, 105 + i * 28, 0, i * 18, w, 18])
        end
      end
      #---------------------------------------------------------------------------
      # Draws Ability/Move button text.
      #---------------------------------------------------------------------------
      textpos.push([_INTL("Abilities"), 306, 253, :center, base, shadow, :outline],
                   [_INTL("Moves"),     434, 253, :center, base, shadow, :outline])			  
      #---------------------------------------------------------------------------
      # Sets up sprites for family data.
      #---------------------------------------------------------------------------
      special_form, check_form, _check_item = pbGetSpecialFormData(species_data)
      if special_form
        imagepos.push([path + "evolutions", 234, ICONS_POS_Y - 34, 0, 64, 272, 64])
        case special_form
        when :mega        then imagepos.push(["Graphics/UI/Battle/icon_mega", 259, 49])
        when :primal      then imagepos.push(["Graphics/UI/Battle/icon_primal_#{species_data.name}", 256, 47])
        when :ultra       then imagepos.push([Settings::ZMOVE_GRAPHICS_PATH + "icon_ultra", 257, 47])
        when :gmax, :emax then imagepos.push([Settings::DYNAMAX_GRAPHICS_PATH + "icon_dynamax", 256, 47])
        when :tera
          species_data.flags.each do |flag|
            next if !flag[/^TeraType_(\w+)/i]
            pos = GameData::Type.get($~[1].to_sym).icon_position
            imagepos.push([Settings::TERASTAL_GRAPHICS_PATH + "tera_types", 257, 47, 0, pos * 32, 32, 32])
            break
          end
        end
        @sprites["familyicon0"].pbSetParams(@species, @gender, @form)
        @sprites["familyicon0"].x = ICONS_RIGHT_DOUBLE
        @sprites["familyicon0"].visible = true
        @sprites["familyicon1"].pbSetParams(@species, @gender, check_form)
        @sprites["familyicon1"].x = ICONS_LEFT_DOUBLE
        @sprites["familyicon1"].visible = true
        @sprites["familyicon2"].visible = false
      else
        prevo = species_data.get_previous_species
        prevo = species_data.species if species_data.id == :FLOETTE_5
        if prevo != species_data.species
          form = (species_data.default_form >= 0) ? species_data.default_form : @form
          prevo_data = GameData::Species.get_species_form(prevo, form)
          stages = (species_data.get_baby_species == prevo) ? 1 : 2
          imagepos.push([path + "evolutions", 234, ICONS_POS_Y - 34, 0, 64 * stages, 272, 64])
          @sprites["familyicon0"].pbSetParams(@species, @gender, @form)
          @sprites["familyicon0"].x = (stages == 1) ? ICONS_RIGHT_DOUBLE : ICONS_RIGHT_TRIPLE
          @sprites["familyicon0"].visible = true
          if $player.seen?(prevo)
            @sprites["familyicon1"].pbSetParams(prevo, @gender, prevo_data.form)
          else
            @sprites["familyicon1"].species = nil
          end
          @sprites["familyicon1"].x = (stages == 1) ? ICONS_LEFT_DOUBLE : ICONS_CENTER
          @sprites["familyicon1"].visible = true
          if stages == 2
            baby = species_data.get_baby_species
            baby_data = GameData::Species.get_species_form(baby, prevo_data.form)
            if $player.seen?(baby)
              @sprites["familyicon2"].pbSetParams(baby, @gender, baby_data.form)
            else
              @sprites["familyicon2"].species = nil
            end
            @sprites["familyicon2"].x = ICONS_LEFT_TRIPLE
            @sprites["familyicon2"].visible = true
          else
            @sprites["familyicon2"].visible = false
          end
        else
          imagepos.push([path + "evolutions", 234, ICONS_POS_Y - 34, 0, 0, 272, 64])
          @sprites["familyicon0"].pbSetParams(@species, @gender, @form)
          @sprites["familyicon0"].x = ICONS_CENTER
          @sprites["familyicon0"].visible = true
          @sprites["familyicon1"].visible = false
          @sprites["familyicon2"].visible = false
        end
      end
      pbDrawImagePositions(overlay, imagepos)
      pbDrawTextPositions(overlay, textpos)
    end
  end
end

class Battle::Scene::FightMenu
  def refreshMoveData(move)
    # Write PP and type of the selected move
    if !USE_GRAPHICS
      return if !move
      moveType = GameData::Type.get(move.display_type(@battler)).name
      if move.total_pp <= 0
        @msgBox.text = _INTL("PP: ---<br>TYPE/{1}", moveType)
      else
        @msgBox.text = _ISPRINTF("PP: {1: 2d}/{2: 2d}<br>TYPE/{3:s}",
                                 move.pp, move.total_pp, moveType)
      end
      return
    end
    @infoOverlay.bitmap.clear
    if !move
      @visibility["typeIcon"] = false
      return
    end
    @visibility["typeIcon"] = true
    # Type icon
    type_number = GameData::Type.get(move.display_type(@battler)).icon_position
    @typeIcon.src_rect.y = type_number * TYPE_ICON_HEIGHT
    @typeIcon.src_rect.width = 64
    # PP text
    if move.total_pp > 0
      ppFraction = [(4.0 * move.pp / move.total_pp).ceil, 3].min
      textPos = []
      textPos.push([_INTL("PP: {1}/{2}", move.pp, move.total_pp),
                    448, 56, :center, PP_COLORS[ppFraction * 2], PP_COLORS[(ppFraction * 2) + 1]])
      pbDrawTextPositions(@infoOverlay.bitmap, textPos)
    end
  end
end

if PluginManager.installed?("[DBK] Enhanced Battle UI")
  class Battle::Scene
    def pbAddTypesDisplay(xpos, ypos, battler, poke)
      #---------------------------------------------------------------------------
      # Gets display types (considers Illusion)
      illusion = battler.effects[PBEffects::Illusion] && !battler.pbOwnedByPlayer?
      if battler.tera?
        displayTypes = (illusion) ? poke.types : battler.types
      elsif illusion
        displayTypes = poke.types.clone
        displayTypes.push(battler.effects[PBEffects::ExtraType]) if battler.effects[PBEffects::ExtraType]
      else
        displayTypes = battler.pbTypes(true)
      end
      #---------------------------------------------------------------------------
      # Displays the "???" type on newly encountered species, or battlers with no typing.
      unknown_species = !(
        battler.pbOwnedByPlayer? ||
        $player.pokedex.owned?(poke.species) ||
        $player.pokedex.battled_count(poke.species) > 0
      )
      unknown_species = false if Settings::SHOW_TYPE_EFFECTIVENESS_FOR_NEW_SPECIES
      unknown_species = true if battler.celestial?
      displayTypes = [:QMARKS] if unknown_species || displayTypes.empty?
      #---------------------------------------------------------------------------
      # Draws each display type. Maximum of 3 types.
      typeY = (displayTypes.length >= 3) ? ypos + 6 : ypos + 34
      typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
      if displayTypes.length > 12
        typeY = ypos + 6
        f = (displayTypes.length/2) + (displayTypes.length%2)
        yGap = 76 / f
        displayTypes.each_with_index do |type, i|
          type_number = GameData::Type.get(type).icon_position
          type_rect = Rect.new(98, type_number * 28, 32, 14)
          @infoUIOverlay.blt(xpos + 170 + ((i%2) * 33), typeY + ((i / 2) * yGap), typebitmap.bitmap, type_rect)
        end
      elsif displayTypes.length > 3
        typeY = (displayTypes.length >= 9) ? ypos + 20 : ypos + 34
        typeY = ypos + 6 if displayTypes.length >= 11
        displayTypes.each_with_index do |type, i|
          type_number = GameData::Type.get(type).icon_position
          type_rect = Rect.new(98, type_number * 28, 32, 14)
          @infoUIOverlay.blt(xpos + 170 + ((i%2) * 33), typeY + ((i / 2) * 15), typebitmap.bitmap, type_rect)
        end
      else
        typeY = (displayTypes.length >= 3) ? ypos + 6 : ypos + 34
        displayTypes.each_with_index do |type, i|
          type_number = GameData::Type.get(type).icon_position
          type_rect = Rect.new(0, type_number * 28, 64, 28)
          @infoUIOverlay.blt(xpos + 170, typeY + (i * 30), typebitmap.bitmap, type_rect)
        end
      end
      #---------------------------------------------------------------------------
      # Draws Tera type.
      if !unknown_species && defined?(poke.tera_type)
        pkmn = (illusion) ? poke : battler
        pbDrawImagePositions(@infoUIOverlay, [[@path + "info_extra", xpos + 182, ypos + 95]])
        pbDisplayTeraType(pkmn, @infoUIOverlay, xpos + 186, ypos + 97, true)
      end
    end
  end
end