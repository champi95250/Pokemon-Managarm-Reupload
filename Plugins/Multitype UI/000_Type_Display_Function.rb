def disp_multiple_types(types,overlay,typebitmap,dx,dy,align = :center)
  types.each_with_index do |type, i|
    type_y = 0
    type_number = GameData::Type.get(type).icon_position
    type_rect = Rect.new(0, type_number * 28, 64, 28)
    if align == :stack_right
      type_rect = Rect.new(64, type_number * 28, 34, 28) if types.length > 6
      type_rect = Rect.new(98, type_number * 28, 32, 14) if types.length > 12
    else
      type_rect = Rect.new(64, type_number * 28, 34, 28) if types.length > 2 && !(align == :left_long && types.length == 3)
      f = 7
      f = 6 if PluginManager.installed?("[DBK] Terastallization")
      type_rect = Rect.new(98, type_number * 28, 32, 14) if types.length > 4 && !(align == :left_long && types.length > 4 && types.length < f)
    end
    if align==:center || align==:center_with_spacing
      if types.length < 3
        type_x = (types.length == 1) ? dx - 32 : dx - 64 + (66 * i)
      elsif types.length < 5
        spacing = [53,36]
        spacing = [68,34] if types.length > 3
        spacing = [71,36] if types.length > 3 && align==:center_with_spacing
        type_x = dx - spacing[0] + (spacing[1] * i)
      elsif align==:center_with_spacing
        type_y = 14*(i/5)
        type_y = 12*(i/5)-2 if types.length > 10
        type_y = 10*(i/5)-4 if types.length > 15
        type_x = dx - 80 + (32 * (i%5))
        type_x += (16 * (5 - (types.length % 5))) if i >= 5*(types.length/5)
      else
        spacing = 34
        spacing = 32 if types.length>8
        type_y = 16*(i/4)
        type_y = 14*(i/4)-4 if types.length > 8
        type_y = 10*(i/4)-6 if types.length > 12
        type_y = 8*(i/4)-10 if types.length > 16
        type_x = dx + (spacing * (i%4 - 2))
        type_x += (17 * (4 - (types.length % 4))) if i >= 4*(types.length/4)
      end
    elsif align.to_s[0,4]=="left"
      spacing = 66
      spacing = 80 if align==:left_long
      spacing = 36 if types.length > 2
      spacing = 78 if align==:left_long && types.length==3
      spacing = 48 if align==:left_long && types.length==4
      spacing = 46 if align==:left_long && types.length>4
      spacing = 36 if align==:left_long && (types.length>10 || types.length==6 || (types.length>=5 && PluginManager.installed?("[DBK] Terastallization")))
      spacing = 32 if align==:left_long && types.length>12
      spacing = 32 if align==:left_wide && types.length>12
      spacing = 32 if align==:left_wide2 && types.length>12
      spacing = 72 if align==:left_halfwide && types.length==2
      spacing = 42 if align==:left_halfwide && types.length==3
      spacing = 32 if align==:left_halfwide && types.length>8
      spacing = 72 if align==:left_diagonal && types.length==2
      spacing = 42 if align==:left_diagonal && types.length==3
      spacing = 32 if align==:left_diagonal && types.length>8
      ii=4
      ii=5 if align==:left_long
      ii=5 if align==:left_wide && types.length>16
      ii=5 if align==:left_wide2 && types.length>16
      ii=5 if align==:left_halfwide && types.length>8
      ii=5 if align==:left_diagonal && types.length>8
      ii=6 if align==:left_long && (types.length>10 || (types.length==6 && !PluginManager.installed?("[DBK] Terastallization")))
      ii=6 if align==:left_diagonal && types.length>18
      ii=6 if align==:left_wide2 && types.length>20
      ii=7 if align==:left_long && types.length>12 && !PluginManager.installed?("[DBK] Terastallization")
      type_y = 16*(i/ii)
      type_y = 14*(i/ii)-4 if types.length > 2*ii && align != :left_wide
      type_y = 14*(i/ii) if align == :left_halfwide && types.length > 8
      type_y = 14*(i/ii) if align == :left_diagonal && types.length > 8
      if align==:left_wide || align==:left_wide2
        type_y -= 12 if types.length > 8
      elsif align==:left_diagonal
      else
        type_y = 10*(i/ii)-6 if types.length > 3*ii
        type_y = 8*(i/ii)-10 if types.length > 4*ii
      end
      type_x = dx + (spacing * (i%ii))
      type_x -= 2 if types.length == 4 && align==:left_wide
      type_x -= 20 if types.length > 16 && align==:left_wide
      type_x -= 2 if types.length == 4 && align==:left_wide2
      type_x -= 20 if types.length > 16 && align==:left_wide2
      type_x -= 10 if types.length > 8 && align==:left_halfwide
      if align==:left_diagonal
        if types.length==11 && i==10
          type_y = 14
          type_x = dx + (spacing * 5)
        elsif types.length>10
          if types.length==16 && i==15
            type_y = 28
            type_x = dx + (spacing * 5)
          elsif types.length==17 || types.length==18
            if i==10
              type_y = 14
              type_x = dx + (spacing * 5)
            elsif i>10
              type_y = 28
              type_x = dx + (spacing * (i - 11))
            end
          elsif types.length==19 && i==18
            type_y = 28
            type_x = dx + (spacing * 6)
          elsif types.length==20
            if i==12
              type_y = 14
              type_x = dx + (spacing * 6)
            elsif i>12
              type_y = 28
              type_x = dx + (spacing * (i - 13))
            end
          end
          type_y -= 8
        end
      end
    elsif align==:stack_right
      type_x = dx + 60
      type_x = 2 + dx + (70 * (i%2)) if types.length > 3
      type_x = 8 + dx + (64 * (i%2)) if types.length > 4
      type_x = 34 + dx + (34 * (i%3)) if types.length > 6
      type_x = dx + (34 * (i%4)) if types.length > 9
      type_y = 28
      type_y = 12 + (32 * i) if types.length > 1
      type_y = (28 * i) if types.length > 2
      type_y = 12 + (32 * (i/2)) if types.length > 3
      type_y = (28 * (i/2)) if types.length > 4
      type_y = (28 * (i/3)) if types.length > 6
      type_y = (28 * (i/4)) if types.length > 9
      if types.length > 12
        z = 3
        j = types.length - 10
        if types.length > 15
          z = 4
          j = types.length - 15
        end
        type_x = 136 - z * 32 + dx + (32 * (i%z))
        type_x = 136 - z * 32 + dx + (32 * ((i - (z * j)) % (z - 1))) if i >= j * z
        type_y = 6 + 14 * (i / z)
        type_y = 6 + 14 * ((i - (z * j)) / (z - 1) + j) if i >= j * z
      end
    end
    overlay.blt(type_x, dy + type_y, typebitmap.bitmap, type_rect)
  end
end