# For each Gift Box item you want to use, define a new UseFrom Bag ItemHandler.
# I provide two different ones as examples.

#===============================================================================
# ItemHandlers (This is where you add your own)
#===============================================================================

ItemHandlers::UseFromBag.add(:GIFTBOX,proc{|item|
	#Settings
	pulls = [
		#[itemID, weight, quantity (optional)]
		# - set quantity to an array of 2 numbers for a range of possible quantities => [min quantity, max quantity]
		# make sure to sort your items by weight (so the largest number is at the top), to make sure common items are common/rare items are rare
		[:POTION, 30, [5,12]], 			# 100 - 500/1200
		[:SUPERPOTION, 15, [4,7]],  # 350 - 1050/2450
		[:HYPERPOTION , 5, [3,5]],  # 750 - 1500/3750
		[:POKEBALL, 30, [5,12]],  	# 100 - 500/1200
		[:GREATBALL, 15, [6,9]], 		# 300 - 1800/2700
		[:ULTRABALL, 5, [5,8]], 		# 400 - 2000/3200
		[:RARECANDY, 1] 						# 5000
	]
	pull_count = 3
	allow_repeats = false
	
	ret = pbOpenGiftBox(item, pulls, pull_count, allow_repeats)
	next ret
})

ItemHandlers::UseFromBag.add(:GIFTBOXSAFARIE,proc{|item|
	#Settings
	pulls = [
		#[itemID, weight, quantity (optional)]
		# - set quantity to an array of 2 numbers for a range of possible quantities => [min quantity, max quantity]
		# make sure to sort your items by weight (so the largest number is at the top), to make sure common items are common/rare items are rare
		[:POKEBALL, 30, [8,15]],  	# 100 - 800/1200
		[:GREATBALL, 12, [7,12]], 		# 300 - 2000/2700
		[:ULTRABALL, 8, [5,6]], 		# 400 - 2000/3200
		[:NETBALL, 5, [2,5]],  	# 150 - 300/750
		[:DIVEBALL, 5, [2,5]], 		
		[:NESTBALL, 5, [2,5]], 		
		[:REPEATBALL, 5, [2,5]],  	
		[:TIMERBALL, 5, [2,5]], 		
		[:LUXURYBALL, 5, [2,5]], 		
		[:DUSKBALL, 5, [2,5]], 		
		[:HEALBALL, 5, [2,5]],  	
		[:QUICKBALL, 5, [2,5]], 		
		[:FASTBALL, 5, [2,5]], 		
		[:HEAVYBALL, 5, [2,5]],  	
		[:LOVEBALL, 5, [2,5]], 		
		[:LUREBALL, 5, [2,5]], 		
		[:FRIENDBALL, 5, [2,5]],  	
		[:MOONBALL, 5, [2,5]], 		
		[:DREAMBALL, 5, [2,5]], 		
		[:RARECANDY, 1] 						# 5000
	]
	pull_count = 5
	allow_repeats = false
	
	ret = pbOpenGiftBox(item, pulls, pull_count, allow_repeats)
	next ret
})

ItemHandlers::UseFromBag.add(:GIFTBOXRARE,proc{|item|
	#Settings
	pulls = [
		#[itemID, weight, quantity (optional)]
		# - set quantity to an array of 2 numbers for a range of possible quantities => [min quantity, max quantity]
		# make sure to sort your items by weight (so the largest number is at the top), to make sure common items are common/rare items are rare
		[:MAXPOTION, 25, [3,8]], 
		[:ULTRABALL, 25, [5,10]],
		[:ENIGMABERRY, 15, [2,4]],
		[:BIGNUGGET, 10, [1,3]],
		[:COMETSHARD, 10, [1,3]],
		[:NUGGET, 10, [5,8]],
		[:MASTERBALL, 5]
	]
	pull_count = 4
	allow_repeats = false
	
	ret = pbOpenGiftBox(item, pulls, pull_count, allow_repeats)
	next ret
})

#===============================================================================
# Code (DO NOT EDIT)
#===============================================================================

def pbOpenGiftBox(item, pulls, pull_count, allow_repeats)
  if !allow_repeats && pull_count > pulls.length
    pbMessage("Your pull count setting is larger than the number of available items. Change your settings for this item.")
    return 0
  end
  pbMessage(_INTL("{1} opened the {2}.", $player.name, GameData::Item.get(item).name))
	weight_total = 0
	items = []
	pulls.each { |p| weight_total += p[1] }
	pull_count.times do
		if allow_repeats
			weight = rand(weight_total)
			pulls.each do |p|
				weight -= p[1]
				next if weight >= 0
				qty = 1
				qty = p[2] if p[2] && p[2].is_a?(Integer)
				qty = rand(p[2][1] - p[2][0]) + p[2][0] if p[2] && p[2].is_a?(Array)
				pbReceiveItem(p[0], qty)
				break
			end
		else
			added = false
			while !added
				weight = rand(weight_total)
				pulls.each do |p|
					weight -= p[1]
					next if weight >= 0
					break if items.include?(p[0])
					qty = 1
					qty = p[2] if p[2] && p[2].is_a?(Integer)
					qty = rand(p[2][1] - p[2][0]) + p[2][0] if p[2] && p[2].is_a?(Array)
					items.push(p[0])
          added = true
					pbReceiveItem(p[0], qty)
					break
				end
			end
		end
	end
	return 1
end