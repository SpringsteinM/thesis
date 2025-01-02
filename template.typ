#import "helper/outline_text.typ": in-outline
#import "@preview/glossarium:0.4.0": make-glossary, print-glossary, gls, glspl 


// Official declaration of originality, both in English and Italian
// taken directly from Paola Gatti's email
#let declaration-of-originality = (
  "de": [
    Hiermit versichere ich, dass ich diese Arbeit selbstständig verfasst habe, keine anderen als die angegebenen Quellen und Hilfsmittel benutzt wurden, alle Stellen der Arbeit, die wörtlich oder sinngemäß aus anderen Quellen übernommen wurden, als solche kenntlich gemacht sind, und die Arbeit in gleicher oder ähnlicher Form noch keiner Prüfungsbehörde vorgelegt habe.
  ],
  "en": [
    I hereby certify that I have written this thesis independently, that no sources and aids other than those specified have been used, that all passages in the thesis that have been taken verbatim or in spirit from other sources have been identified as such, and that the thesis has not yet been submitted in the same or a similar form to any examination authority.
  ],
)

// FIXME: workaround for the lack of `std` scope
#let std-bibliography = bibliography

#let template(
  // Your thesis title
  title: [Thesis Title],

  // The academic year you're graduating in
  date: [2023/2024],

  // Your thesis subtitle, should be something along the lines of
  // "Bachelor's Thesis", "Tesi di Laurea Triennale" etc.
  subtitle: [Bachelor's Thesis],

  // The paper size, refer to https://typst.app/docs/reference/layout/page/#parameters-paper for all the available options
  paper-size: "a4",

  // Candidate's informations. You should specify a `name` key and
  // `matricola` key
  candidate: (),

  // The thesis' supervisor (relatore)
  supervisor: "",

  // place for the signature
  place: none,

  // An array of the thesis' co-supervisors (correlatori).
  // Set to `none` if not needed
  co-supervisor: (),

  // An affiliation dictionary, you should specify a `university`
  // keyword, `school` keyword and a `degree` keyword
  affiliation: (),

  // Set to "it" for the italian template
  lang: "en",

  // The thesis' bibliography, should be passed as a call to the
  // `bibliography` function or `none` if you don't need
  // to include a bibliography
  bibliography: none,

  // The university's logo, should be passed as a call to the `image`
  // function or `none` if you don't need to include a logo
  logo: none,

  // Abstract of the thesis, set to none if not needed
  abstract: none,

  // Acknowledgments, set to none if not needed
  acknowledgments: none,

  // The thesis' keywords, can be left empty if not needed
  keywords: none,
  
  // The thesis' glossary, can be left empty if not needed
  glossary:none,
  // The thesis' content
  body
) = {
  // Set document matadata.
  set document(title: title, author: candidate.name)


  // Set the body font, "New Computer Modern" gives a LaTeX-like look
  set text(font: "New Computer Modern", lang: lang, size: 12pt)

  // Configure the page
  set page(
    paper: paper-size,

    // Margins are taken from the university's guidelines
    margin: (right: 3cm, left: 3.5cm, top: 3.5cm, bottom: 3.5cm)
  )
  set par(justify: true)


  
  set table(
    // fill: (rgb("EAF2F5"), none),
    stroke: 0pt//frame(rgb("21222C")),
  )

  show table.cell: it => [
    #set text(size:9pt)
    #it
  ]

  /////////////////////////////////////////////////////////////////
  // Configure figures
  /////////////////////////////////////////////////////////////////
  
  // Configure figure's internal text
  show figure: set text(size:0.7em)
  set figure(gap: 2em)
  
  // Configure figure's captions
  show figure.caption: set text(size: 1.2em)
  show figure.caption: set align(left)
  
  /////////////////////////////////////////////////////////////////
  // Configure headings
  /////////////////////////////////////////////////////////////////
  set heading(numbering: "1.1.1")
  show heading.where(level: 1): it => {
    pagebreak(weak: true); 
    
    if it.numbering  == none {
      set text(size: 20pt, weight: "bold")
      block(above: 2em, below: 2em)[
        #h(.5em) #it.body
      ]
    } else {
      set text(size: 20pt, weight: "bold")
      block(above: 2em, below: 2em)[
        #counter(heading).display()#h(.5em) #it.body
      ]
    
    }
  }
  
  show heading.where(level: 2): it => block(above: 2em, below: 1em)[
        #counter(heading).display()#h(.5em) #it.body
  ]
  
  show heading.where(level: 3): it => block(above: 2em, below: 1em)[
        #counter(heading).display()#h(.5em) #it.body
  ]

  show heading.where(level: 4): it => block(above: 2em, below: 1em)[
        #counter(heading).display()#h(.5em) #it.body
  ]
  
  /////////////////////////////////////////////////////////////////
  // Configure outline
  /////////////////////////////////////////////////////////////////
  
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }

  
  show outline.where(target:  heading.where(outlined: true)): it => {
    show outline.entry.where(level:1): set text(weight:"bold")  
    it
  }

  

  /////////////////////////////////////////////////////////////////
  // Start document
  /////////////////////////////////////////////////////////////////
  
  // Title page
  set align(center)
  
  block[
    #let jb = linebreak(justify: false)
  
    #text(1.5em, weight: "bold", title) 
    #jb
    #v(2em)
    #text(1.2em, [
      #smallcaps(affiliation.school) #jb
      #smallcaps(affiliation.university) #jb
    ])
  ]

  v(3fr)
  if logo != none {
    logo
  }
  v(3fr)

  text(1.5em, subtitle)
  v(1fr, weak: true)

  v(4fr)

  grid(
    columns: 2,
    align: left,
    grid.cell(
      inset: (right: 40pt)
    )[
      #if lang == "en" {
        smallcaps("supervisor")
      }\
      *#supervisor*

      #if co-supervisor != none {
        if lang == "en" {
          smallcaps("co-supervisor")
        }
        linebreak()
        co-supervisor.map(it => [
          *#it*
        ]).join(linebreak())
      }
    ],
    grid.cell(
      inset: (left: 40pt)
    )[
      #if lang == "en" {
        smallcaps("candidate")
      }\
      *#candidate.name* \
      #candidate.matriculation
    ]
  )

  v(5fr)

  text(1.2em, [
    #date.display("[day]-[month]-[year]")
  ])

  pagebreak(to: "odd")
  
  set page(numbering: "I")
  set par(first-line-indent: 1em)
  set align(top + left)
  
  // Declaration of originality, prints in English or Italian
  // depending on the `lang` parameter
  heading(
    level: 1,
    numbering: none,
    outlined: true,
    if lang == "en" {
      "Declaration of Originality"
    } 
  )
  text(declaration-of-originality.at(lang))
  v(2em)
  grid(
    columns: (50%,50%), 
    align: (left,right),
    [#line(start: (0em,1em),length: 100%)#candidate.name], 
    [#place, #date.display("[month repr:long] [day], [year]")]
  )
  

  pagebreak(weak: true)

  // Acknowledgments
  if acknowledgments != none {
    heading(
      level: 1,
      numbering: none,
      outlined: true,
      if lang == "en" {
        "Acknowledgments"
      }
    )
    acknowledgments

    pagebreak(weak: true)
  }

  // Abstract
  if abstract != none {
    heading(
      level: 1,
      numbering: none,
      outlined: true,
      "Abstract"
    )
    abstract
  }

  // Keywords
  if keywords != none {
    heading(
      level: 1,
      numbering: none,
      outlined: true,
      if lang == "en" {
        "Keywords"
      }
    )
    keywords
  }

  pagebreak(weak: true, to: "odd")

 
  
  outline(title:"Contents",depth: 3, indent: true)

  pagebreak(to: "odd")

  outline(title: "List of Tables", target: figure.where(kind: table))
  outline(title: "List of Figures", target: figure.where(kind: image))

  if glossary != none {
  
    heading(
      level: 1,
      numbering: none,
      outlined: true,
      if lang == "en" {
        "Acronyms"
      }
    )
    print-glossary(
      glossary,
      // show all term even if they are not referenced, default to true
      show-all: true,
      // disable the back ref at the end of the descriptions
      disable-back-references: true,
    )
}

  // Main body

  // show link: underline
  set page(numbering: "1")
  set align(top + left)
  counter(page).update(1)

  body

  pagebreak(to: "odd")

  // Bibliography
  if bibliography != none {
    heading(
      level: 1,
      numbering: none,
      if lang == "en" {
        "References"
      }
    )
    show std-bibliography: set text(size: 0.9em)
    set std-bibliography(title: none)
    bibliography
  }
}

