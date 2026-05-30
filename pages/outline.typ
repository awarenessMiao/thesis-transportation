#import "../style/font.typ": ziti, zihao

#let outline-page(
  info: (:),
  compact: false,
) = context {
  show outline.entry: it => context {
    if it.level == 1 {
      set text(font: ziti.heiti.get(), size: 14pt)
      let tail-entry = it.element.body in ([结论], [参考文献], [致#h(1em)谢])
      if not compact { v(if tail-entry { 0.05em } else { 0.5em }) }
      if it.element.supplement == [正文] {
        set text(weight: "bold")
        it
      } else {
        it
      }
      if not compact { v(if tail-entry { 0.05em } else { 0.5em }) }
    } else if it.level == 2 {
      if not compact { v(0.3em) }
      set text(font: ziti.songti.get(), size: 12pt)
      it
    } else {
      if not compact { v(0.3em) }
      set text(font: ziti.songti.get(), size: 11pt)
      it
    }
  }
  show outline: it => {
    show heading: set align(center)
    show heading: set text(font: ziti.heiti.get(), size: 18pt, weight: "bold")
    it
  }

  v(15pt)
  context outline(
    title: [目#h(1em)录],
    indent: 1em,
    depth: 3,
  )

  pagebreak(weak: true)
}
