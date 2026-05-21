#import "../style/heading.typ": main-heading

#let conclusion-page(
  body,
) = {
  show: main-heading
  heading(level: 1)[结论]
  body
  pagebreak(weak: true)
}

