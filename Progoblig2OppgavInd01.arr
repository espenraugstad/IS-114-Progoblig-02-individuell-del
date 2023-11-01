use context essentials2021
include color

# See the end of this code and remove comments to draw all flags on run.

# Start by displaying a small menu of available functions the user can use
menu = table: function-name :: String, description :: String
  row: "draw-flag(country-code :: String, width :: Number)", "Draw the flag of a country at a given width in pixels"
  row: "show-country-codes()", "Displays a table of the available country codes"
  row: "show-menu()", "Displays this menu again"
  row: "list-all-flags(width :: Number)", "Displays a table with countries, country codes, and flags at width in pixels"
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
flag-info = table: country  :: String, base :: Color, width :: Number, height :: Number, outer-cross :: FlagCross, inner-cross :: FlagCross 
  row: "dk", color(227, 24, 54, 1), 37, 28, cross(12, 4, 12, 4, color(255, 255, 255, 1)),  cross(0,0,0,0, color(0,0,0,0))
  row: "no", color(186, 12, 47, 1), 22, 16, cross(6, 4, 6, 4, color(255, 255, 255, 1)),  cross(7,2, 7, 2, color(0,32,91,1))
  row: "fi", color(255, 255, 255, 1), 18, 11, cross(5, 3, 4, 3, color(24, 68, 126, 1)), cross(0,0,0,0, color(0,0,0,0))
  row: "se", color(0, 82, 147, 1), 16, 10, cross(5, 2, 4, 2, color(254, 203, 0, 1)), cross(0,0,0,0, color(0,0,0,0))
  row: "is", color(0, 32, 91, 1), 25, 18, cross(7, 4, 7, 4, color(255, 255, 255, 1)), cross(8,2,8,2, color(186,12,47,1))
  row: "fo", color(255, 255, 255, 1), 22, 16, cross(6, 4, 6, 4, color(0, 110, 199, 1)), cross(7,2,7,2, color(237,46,56,1))
  row: "ax", color(0, 100, 174, 1), 26, 17, cross(8, 5, 6, 5, color(255, 211, 0, 1)), cross(9.5, 2, 7.5, 2, color(219, 15, 22, 1))
  row: "ex1", color(255,0,0,1), 26,17, cross(8,2,5,2,color(0,255,0,1)), cross(16,2,10,2,color(0,255,0,1))
  row: "ex2", color(255,0,0,1), 20,20, cross(8,4,8,4,color(209,255,0,1)), cross(0,0,0,0,color(0,0,0,0))
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
  row: "Experimental 1", "ex1"
  row: "Experimental 2", "ex2"
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
    
    ## Scale to convert from dimensions to pixels
    flag-scale = width / dim-width
    height = dim-height * flag-scale
    
    # The outer (big) cross
    outer = this-flag["outer-cross"]
    
    # The inner (smaller) cross
    inner = this-flag["inner-cross"]
    
    # Cross 1 (outer cross)
    ## Outer vertical bar
    outerVertWidth = outer.vw * flag-scale
    outerVertX = (outer.vx * flag-scale) + ((outer.vw * flag-scale) / 2)
    outerVertY = height / 2
    outer-cross-vert = rectangle(outerVertWidth, height, "solid", outer.col)
  
    ## Outer horizontal bar
    outerHorHeight = outer.hh * flag-scale
    outerHorX = width / 2
    outerHorY = (outer.hy * flag-scale) + ((outer.hh * flag-scale) / 2)
    outer-cross-hor = rectangle(width, outerHorHeight, "solid", outer.col)
    
    
    # Cross 2 (inner cross) 
    ## Inner vertical bar
    innerVertWidth = inner.vw * flag-scale
    innerVertX = (inner.vx * flag-scale) + ((inner.vw * flag-scale) / 2) 
    innerVertY = height / 2
    inner-cross-vert = rectangle(innerVertWidth, height, "solid", inner.col)
    
    ## Inner horizontal bar
    innerHorHeight = inner.hh * flag-scale
    innerHorX = width / 2
    innerHorY = (inner.hy * flag-scale) + ((inner.hh * flag-scale) / 2)
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

fun list-all-flags(width :: Number):
  # Extract all country codes from the flag-codes table into a list
  list-of-codes = flag-codes.get-column("code") 

  # Create a new list with all the flags drawn
  list-of-drawn-flags = list-of-codes.map(lam(c): draw-flag(c, width)end)
  
  # Create a new table from from the flag-codes table, and add a column with the drawn flags
  table-of-drawn-flags = flag-codes.add-column("flag", list-of-drawn-flags)
  
  # Display the table with the flags
  table-of-drawn-flags
end



# Remove the comments below to draw all flags on run
#draw-flag("dk", 200)
#draw-flag("no", 200)
#draw-flag("fi", 200)
#draw-flag("se", 200)
#draw-flag("is", 200)
#draw-flag("fo", 200)
#draw-flag("ax", 200)
#draw-flag("ex1", 200)
#draw-flag("ex2", 200)
