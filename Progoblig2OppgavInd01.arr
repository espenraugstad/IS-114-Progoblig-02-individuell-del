use context essentials2021
include color

# See the end of this code and remove comments to draw all flags on run.

# Start by displaying a small menu of available functions the user can use
menu = table: function-name :: String, description :: String
  row: "draw-flag(country-code :: String, width :: Number)", "Draw the flag of a country at a given width in pixels"
  row: "show-country-codes()", "Displays a table of the available country codes"
  row: "show-menu()", "Displays this menu again"
end

fun show-menu():
  menu
end

show-menu()

# A datatype for crosses
data FlagCross:
    # vx = x position of the vertical bar 
    #vw = width of the vertical bar 
    #hy = y position of horizontal bar 
    #hh = height of horizontal bar
    cross(vx :: Number, vw :: Number, hy :: Number, hh :: Number, col :: Color)
end

# The table containing all relevant information about the elements of the different nordic flags.
flag-info = table: country  :: String, base :: Color, width :: Number, height :: Number, cross1 :: FlagCross, cross2 :: FlagCross
  row: "dk", color(227, 24, 54, 1), 37, 28, cross(12, 4, 12, 4, color(255, 255, 255, 1)),  cross(0,0,0,0, color(0,0,0,0))
  row: "no", color(186, 12, 47, 1), 22, 16, cross(6, 4, 6, 4, color(255, 255, 255, 1)),  cross(7,2, 7, 2, color(0,32,91,1))
  row: "fi", color(255, 255, 255, 1), 18, 11, cross(5, 3, 4, 3, color(24, 68, 126, 1)), cross(0,0,0,0, color(0,0,0,0))
  row: "se", color(0, 82, 147, 1), 16, 10, cross(5, 2, 4, 2, color(254, 203, 0, 1)), cross(0,0,0,0, color(0,0,0,0))
  row: "is", color(0, 32, 91, 1), 25, 18, cross(7, 4, 7, 4, color(255, 255, 255, 1)), cross(8,2,8,2, color(186,12,47,1))
  row: "fo", color(255, 255, 255, 1), 22, 16, cross(6, 4, 6, 4, color(0, 110, 199, 1)), cross(7,2,7,2, color(237,46,56,1))
  row: "ax", color(0, 100, 174, 1), 26, 17, cross(8, 5, 6, 5, color(255, 211, 0, 1)), cross(9.5, 2, 7.5, 2, color(219, 15, 22, 1))
end

# List of available flag code, and a function to display them.
flag-codes = table: name :: String, code :: String
  row: "Denmark", "dk"
  row: "Norway", "no"
  row: "Finland", "fi"
  row: "Sweden", "se"
  row: "Iceland", "is"
  row: "Faroe Islands", "fo"
  row: "Åland", "ax"
end

fun show-country-codes() -> Table:
  flag-codes
end

fun draw-flag(flag :: String, width :: Number):
  # Find the row in the flag-info containing information about the selected country
  selected-country = sieve flag-info using country:
    country == flag
  end
  
  # If a country is found, proceed to draw the flag.
  if selected-country.length() == 1:
    # Get information about the flag from the row in the selected-country-table
    this-flag = selected-country.row-n(0)
    
    # Base color of the flag corresponding to the rectangles
    base = this-flag["base"]
    
    # The dimensional width of the flag
    dim-width = this-flag["width"]
    
    # The dimensional height of the flag
    dim-height = this-flag["height"]
    
    ## Ratios
    ratioWH = dim-width / dim-height
    ratioW = width / dim-width
    
    # Actual pixel height of the flag corresponding to the width given as an argument to this function
    height = width / ratioWH
    
    # The outer (big) cross
    outer = this-flag["cross1"]
    
    # The inner (smaller) cross
    inner = this-flag["cross2"]
    
    # Cross 1 (outer cross)
    ## Outer vertical bar
    outerVertWidth = outer.vw * ratioW
    outerVertX = (outer.vx * ratioW) + ((outer.vw * ratioW) / 2)
    outerVertY = height / 2
    outer-cross-vert = rectangle(outerVertWidth, height, "solid", outer.col)
  
    ## Outer horizontal bar
    outerHorHeight = outer.hh * ratioW
    outerHorX = width / 2
    outerHorY = height / 2    
    outer-cross-hor = rectangle(width, outerHorHeight, "solid", outer.col)
    
    
    # Cross 2 (inner cross) 
    ## Inner vertical bar
    innerVertWidth = inner.vw * ratioW
    innerVertX = (inner.vx * ratioW) + ((inner.vw * ratioW) / 2)
    innerVertY = (width  / ratioWH) / 2    
    inner-cross-vert = rectangle(innerVertWidth, height, "solid", inner.col)
    
    ## Inner horizontal bar
    innerHorHeight = inner.hh * ratioW
    innerHorX = width / 2
    innerHorY = height / 2    
    inner-cross-hor = rectangle(width, innerHorHeight, "solid", inner.col)
    
    # Place the elements of the flag
    place-image(inner-cross-hor, innerHorX, innerHorY,
      place-image(inner-cross-vert, innerVertX, innerVertY,
         place-image(outer-cross-vert, outerVertX, outerVertY,
           place-image(outer-cross-hor, outerHorX, outerHorY,
             rectangle(width, height, "solid", base)))))
  else:
    # No row is found corresponding to the selected country
    "Incorrect country code. Try the function show-country-codes() to get a list of available countries"
  end
end

# Remove the comments below to draw all flags on run
#draw-flag("dk", 200)
#draw-flag("no", 200)
#draw-flag("fi", 200)
#draw-flag("se", 200)
#draw-flag("is", 200)
#draw-flag("fo", 200)
#draw-flag("ax", 200)