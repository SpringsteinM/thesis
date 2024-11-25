#let bottomrule() = {
  table.hline(start: 0, stroke: 1.0pt)
}

#let toprule() = {
  table.hline(start: 0, stroke: 1.0pt)
}

#let midrule() = {
  table.hline(start: 0, stroke: 0.5pt)
}

#let cmidrule(start:0, end:none) = {
  table.hline(start: start, end:end, stroke: 0.25pt)
}