
#let info_with_bib(body) = block(
  width: 100%,
  inset: 1.2em,
  radius: 0.3em,
  breakable: false,
  fill: rgb("eeeeee"),
  context {
    body
    bibliography(
      "/main.yml",
      title: none,
      target: selector(cite).within(here()),
      // style: "mla",
    )
  }
)

#let info(body) = block(
  width: 100%,
  inset: 1.2em,
  radius: 0.3em,
  breakable: false,
  fill: rgb("eeeeee"),
  context {
    body
  }
)