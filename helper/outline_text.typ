#let in-outline = state("in-outline", false)


#let outline-text(long, short) = context {
  if in-outline.get() { 
    short 
  } 
  else { 
    long 
}}