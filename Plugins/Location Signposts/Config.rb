class LocationWindow
  # The path to the signpost images
  # Default: "Graphics/Maps/"
  PATH = "Graphics/Maps/"

  # Speed of the signpost animations (in frames)
  SHOW_FRAMES       = 26  # Show signpost
  HIDE_FRAMES       = 26  # Hide signpost
  HIDE_FRAMES_MENU  = 26  # Hide signpost (when a menu is opened)

  # Duration of the signpost (in frames)
  # Default: 140
  DURATION = 280

  # The signpost images to use and the keywords to match
  # "Filename" => ["Map name keyword 1","Map name keyword 2", ...]
  SIGNPOSTS = {
      "Route_1" => ["Route 01", "Route 02","Route 03",],
      "Route_2" => ["Route 10", "Route 09"],
      "Town_1"  => ["Town", "Village"],
      "Lake_1"  => ["Lake"],
      "Cave_1"  => ["Cave","Grotte"],
      "City_1"  => ["City", "Cryodeser"],
      "Platinum_Signpost"  => ["Desert"],
      "HGSS_4"   => ["Blank"]
  }
end