#import "@preview/subpar:0.2.2"

#let flex-heading(long, short, label:none, ..args) = {
  show heading: it => long
  [#heading(..args, short)#label]
}

#let flex-figure(body, long, short, label:none, ..args) = {
  show figure.caption: it => {
    it.supplement
    [ ]
    context it.counter.display(it.numbering)
    it.separator
    long
  }
  [#figure(body, ..args, caption: short)#label]
}

#let flex-super(body, long, short, ..args) = {
  show figure.caption: it => if it.body == [] { it } else { 
    it.supplement
    [ ]
    context it.counter.display(it.numbering)
    it.separator
    long
  }
  subpar.super(body, ..args, caption: short)
}

#let flex-grid(long:none, short:none, ..args) = {
  show figure.caption: it => if it.body == [] { it } else {
    it.supplement
    [ ]
    context it.counter.display(it.numbering)
    it.separator
    long
  }
  subpar.grid( caption: short, ..args)
}