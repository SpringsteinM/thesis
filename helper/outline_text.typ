#import "@preview/subpar:0.2.2"

#let format-caption(it, long) = context {
  let prefix = box(strong({
    it.supplement
    [ ]
    it.counter.display(it.numbering)
    it.separator
  }))
  let indent = measure(prefix).width
  let body = if it.body == [] { it.body } else { long }
  set align(left)

  set par(first-line-indent: 0pt)
  par(hanging-indent: indent)[#prefix#body]
}

#let flex-heading(long, short, label:none, ..args) = {
  show heading: it => long
  [#heading(..args, short)#label]
}

#let flex-figure(body, long, short, label:none, ..args) = {
  show figure.caption: it => format-caption(it, long)
  [#figure(body, ..args, caption: short)#label]
}

#let flex-super(body, long, short, ..args) = {
  show figure.caption: it => format-caption(it, long)
  subpar.super(body, ..args, caption: short)
}

#let flex-grid(long:none, short:none, ..args) = {
  show figure.caption: it => format-caption(it, long)
  subpar.grid( caption: short, ..args)
}