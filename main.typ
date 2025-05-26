#import "template.typ": template
#import "@preview/glossarium:0.5.3": make-glossary, print-glossary, gls, glspl 
#import "chapters/0_glossary.typ": glossary

// Your acknowledgments (Ringraziamenti) go here
#let acknowledgments = []

// Your abstract goes here
#let abstract = []

#show: template.with(
  // Your title goes here
  title: "Visual Concept Recognition in an Art Historical Context",

  // Change to the correct academic year, e.g. "2024/2025"
  date: datetime.today(),

  // Change to the correct subtitle, i.e. "Tesi di Laurea Triennale",
  // "Master's Thesis", "PhD Thesis", etc.
  subtitle: "Dissertation",

  // Change to your name and matricola
  candidate: (
    name: "Matthias Springstein",
    matriculation: 10009748
  ),

  // Change to your supervisor's name
  supervisor: (
    "Prof. Ralph Ewerth"
  ),

  // Add as many co-supervisors as you need or remove the entry
  // if none are needed
  co-supervisor: (
    "TODO",
    "TODO"
  ),

  place: "Hannover",

  // Customize with your own school and degree
  affiliation: (
    university: "Leibniz University Hannover",
    school: "Faculty of Electrical Engineering and Computer Science",
    degree: "Disertation",
  ),

  // Change to "it" for the Italian template
  lang: "en",

  // University logo
  logo: image("images/welfen.svg", width: 100%),

  // Hayagriva bibliography is the default one, if you want to use a
  // BibTeX file, pass a .bib file instead (e.g. "works.bib")
  bibliography: bibliography("main.yml", style: "main.csl"),

  // See the `acknowledgments` and `abstract` variables above
  acknowledgments: none,
  abstract: abstract,

  // Add as many keywords as you need, or remove the entry if none
  // are needed
  keywords: none,

  glossary:  glossary
)


// I suggest adding each chapter in a separate typst file under the
// `chapters` directory, and then importing them here.

// #include "chapters/introduction.typ"

#include "chapters/0_glossary.typ"

#include "chapters/1_intro.typ"

#include "chapters/2_foundations.typ"

#include "chapters/3_what.typ"

#include "chapters/4_art_classification.typ"

#include "chapters/5_iart.typ"
#include "chapters/6_conclusions.typ"



