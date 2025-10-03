// From Saloi to Abdal: Religious Continuity and Holy Foolishness in Anatolian Conversion to Islam
// Academic Paper in Typst

// Document metadata
#set document(
  title: "From Saloi to Abdal: Religious Continuity and Holy Foolishness in Anatolian Conversion to Islam",
  author: "Erdal Günes",
  keywords: ("Abdal", "saloi", "Anatolia", "conversion", "holy foolishness", "Bektashi", "religious syncretism", "menakibname", "vitae")
)

// Page setup
#set page(
  paper: "us-letter",
  margin: (x: 1.5cm, y: 2cm),
  numbering: "1"
)

// Text formatting
#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en"
)

// Paragraph settings
#set par(
  justify: true,
  leading: 0.65em
)

// Heading styles
#show heading.where(level: 1): it => [
  #set text(14pt, weight: "bold")
  #v(12pt)
  #it
  #v(8pt)
]

#show heading.where(level: 2): it => [
  #set text(12pt, weight: "bold")
  #v(10pt)
  #it
  #v(6pt)
]

// Title
#align(center)[
  #text(17pt, weight: "bold")[
    From Saloi to Abdal: Religious Continuity and Holy Foolishness in Anatolian Conversion to Islam
  ]
  #v(8pt)
  #text(11pt)[
    Erdal Günes\
    #link("mailto:erdalgns@gmail.com")
  ]
  #v(12pt)
]

// Abstract
#include "sections/abstract.typ"

// Literature Review
#include "sections/literature.typ"
