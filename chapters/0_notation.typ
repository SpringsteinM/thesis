#let notation() = {
  text([
    In this section we define the notation used in the mathematical formulas throughout the thesis. The notation follows the conventions general introduced by Goodfellow et al. @Heaton18.  
  ])
  
  table(
    columns: (auto, 1fr),
    inset: 10pt,
    align: horizon,
    table.header(
      table.cell(colspan: 2,align:center)[*Numbers and Arrays*]
    ),
    $a$, [A scalar],
    $bold(a)$, [A 1-dimensional vector],
    $A$, [A 2-dimensional matrix],
    $bold(sans(upright(A)))$, [A n-dimensional tensor]
  )

    
  table(
    columns: (auto, 1fr),
    inset: 10pt,
    align: horizon,
    table.header(
      table.cell(colspan: 2,align:center)[*Indexing*]
    ),
    $a$, [A scalar],
    $bold(a)$, [A 1-dimensional vector],
    $A$, [A 2-dimensional matrix],
    $sans(upright(A))$, [A n-dimensional tensor]
  )
}
