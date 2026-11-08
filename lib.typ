// xnote: local Typst note components.
// Import with: #import "@local/xnote:0.1.0": *

#let colors = (
  ink: rgb("#24303f"),
  muted: rgb("#667085"),
  line: rgb("#d0d5dd"),
  light-line: rgb("#eaecf0"),
  paper: rgb("#ffffff"),
  soft: rgb("#f8fafc"),
  blue: rgb("#2563eb"),
  blue-soft: rgb("#eff6ff"),
  green: rgb("#16a34a"),
  green-soft: rgb("#f0fdf4"),
  amber: rgb("#d97706"),
  amber-soft: rgb("#fffbeb"),
  red: rgb("#dc2626"),
  red-soft: rgb("#fef2f2"),
  purple: rgb("#7c3aed"),
  purple-soft: rgb("#f5f3ff"),
  cyan: rgb("#0891b2"),
  cyan-soft: rgb("#ecfeff"),
  gray: rgb("#475467"),
  gray-soft: rgb("#f2f4f7"),
)

#let zh-fonts = ("Libertinus Serif", "Songti SC", "STSong", "SimSun")
#let sans-fonts = ("Helvetica Neue", "PingFang SC", "Microsoft YaHei", "Arial")
#let mono-fonts = ("Menlo", "Consolas", "Courier New")

#let xnote(
  title: "",
  author: none,
  date: none,
  abstract: none,
  lang: "zh",
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  font-size: 10.5pt,
  heading-numbering: "1.1",
  outline-title: auto,
  body,
) = {
  set document(title: title, author: if author == none { () } else { author })
  set page(paper: paper, margin: margin)
  set text(lang: lang, font: zh-fonts, size: font-size, fill: colors.ink)
  set par(justify: true, leading: 0.72em, spacing: 0.9em)
  set heading(numbering: heading-numbering)
  set list(marker: ([•], [–], [◦]))
  set enum(numbering: "1.")
  set quote(block: true)
  show raw.where(block: false): it => box(
    fill: colors.gray-soft,
    stroke: 0.4pt + colors.light-line,
    radius: 2pt,
    inset: (x: 2.5pt, y: 1.5pt),
    text(font: mono-fonts, size: 0.88em, it),
  )
  show link: underline.with(stroke: colors.blue, offset: 2pt)
  show heading: it => {
    set par(first-line-indent: 0pt)
    block(above: if it.level == 1 { 1.2em } else { 0.8em }, below: 0.45em)[
      #text(font: sans-fonts, fill: colors.ink, weight: 700, size: if it.level == 1 { 1.35em } else if it.level == 2 { 1.18em } else { 1.04em })[#it]
      #if it.level == 1 { line(length: 100%, stroke: 0.6pt + colors.light-line) }
    ]
  }
  show table: set text(size: 0.94em)

  align(center)[
    #block(width: 100%, inset: (bottom: 0.8em))[
      #text(font: sans-fonts, weight: 700, size: 24pt, title)
      #if author != none or date != none [
        #v(0.6em)
        #text(fill: colors.muted, size: 10pt)[#if author != none { author }#if author != none and date != none { " · " }#if date != none { date }]
      ]
    ]
  ]
  if abstract != none {
    block(width: 100%, fill: colors.blue-soft, stroke: (left: 4pt + colors.blue, rest: 0.4pt + colors.blue.lighten(45%)), radius: 4pt, inset: (x: 0.95em, y: 0.75em), outset: (y: 0.45em))[
      #set par(first-line-indent: 0pt)
      #text(font: sans-fonts, weight: 700, fill: colors.blue)[#if lang == "zh" { "摘要" } else { "Abstract" }]
      #v(0.45em)
      #abstract
    ]
  }
  if outline-title != none {
    outline(title: if outline-title == auto { if lang == "zh" { [目录] } else { [Contents] } } else { outline-title })
    pagebreak()
  }
  body
}

#let _kind-style(kind) = {
  let styles = (
    note: (title: "注释", icon: "✎", primary: colors.blue, fill: colors.blue-soft),
    tip: (title: "提示", icon: "★", primary: colors.green, fill: colors.green-soft),
    important: (title: "重要", icon: "!", primary: colors.purple, fill: colors.purple-soft),
    warning: (title: "警告", icon: "⚠", primary: colors.amber, fill: colors.amber-soft),
    danger: (title: "危险", icon: "×", primary: colors.red, fill: colors.red-soft),
    question: (title: "问题", icon: "?", primary: colors.purple, fill: colors.purple-soft),
    definition: (title: "定义", icon: "◇", primary: colors.cyan, fill: colors.cyan-soft),
    theorem: (title: "定理", icon: "∴", primary: colors.purple, fill: colors.purple-soft),
    proof: (title: "证明", icon: "□", primary: colors.gray, fill: colors.gray-soft),
    example: (title: "例子", icon: "#", primary: colors.green, fill: colors.green-soft),
    task: (title: "任务", icon: "✓", primary: colors.blue, fill: colors.blue-soft),
    todo: (title: "待办", icon: "☐", primary: colors.amber, fill: colors.amber-soft),
    experiment: (title: "实验", icon: "λ", primary: colors.cyan, fill: colors.cyan-soft),
    observation: (title: "观察", icon: "◉", primary: colors.blue, fill: colors.blue-soft),
    hypothesis: (title: "假设", icon: "△", primary: colors.amber, fill: colors.amber-soft),
    result: (title: "结果", icon: "→", primary: colors.green, fill: colors.green-soft),
  )
  styles.at(kind, default: (title: str(kind), icon: "", primary: colors.gray, fill: colors.gray-soft))
}

#let callout(
  body,
  title: none,
  kind: "note",
  icon: auto,
  color: auto,
  fill: auto,
  radius: 4pt,
  breakable: true,
  compact: false,
) = {
  let st = _kind-style(kind)
  let primary = if color == auto { st.primary } else { color }
  let bg = if fill == auto { st.fill } else { fill }
  let head = if title == none { st.title } else { title }
  let mark = if icon == auto { st.icon } else { icon }
  block(
    width: 100%,
    breakable: breakable,
    fill: bg,
    stroke: (left: 4pt + primary, rest: 0.4pt + primary.lighten(45%)),
    radius: radius,
    inset: if compact { (x: 0.75em, y: 0.55em) } else { (x: 0.95em, y: 0.75em) },
    outset: (y: 0.45em),
  )[
    #set par(first-line-indent: 0pt)
    #text(font: sans-fonts, weight: 700, fill: primary)[#if mark != "" { mark + " " }#head]
    #v(if compact { 0.25em } else { 0.45em })
    #body
  ]
}

#let note(body, ..args) = callout(body, kind: "note", ..args)
#let tip(body, ..args) = callout(body, kind: "tip", ..args)
#let important(body, ..args) = callout(body, kind: "important", ..args)
#let warning(body, ..args) = callout(body, kind: "warning", ..args)
#let danger(body, ..args) = callout(body, kind: "danger", ..args)
#let question(body, ..args) = callout(body, kind: "question", ..args)
#let definition(body, ..args) = callout(body, kind: "definition", ..args)
#let theorem(body, ..args) = callout(body, kind: "theorem", ..args)
#let proof(body, ..args) = callout(body, kind: "proof", ..args)
#let example(body, ..args) = callout(body, kind: "example", ..args)
#let task(body, ..args) = callout(body, kind: "task", ..args)
#let todo(body, ..args) = callout(body, kind: "todo", ..args)
#let experiment(body, ..args) = callout(body, kind: "experiment", ..args)
#let observation(body, ..args) = callout(body, kind: "observation", ..args)
#let hypothesis(body, ..args) = callout(body, kind: "hypothesis", ..args)
#let result(body, ..args) = callout(body, kind: "result", ..args)

#let highlight(body, fill: rgb("#fef3c7"), stroke: none) = box(
  fill: fill,
  stroke: stroke,
  radius: 2pt,
  inset: (x: 2pt, y: 1pt),
  body,
)

#let markbox(body, color: colors.green, fill: colors.green-soft) = block(
  width: 100%,
  breakable: true,
  fill: fill,
  stroke: 0.7pt + color,
  radius: 4pt,
  inset: 0.8em,
  outset: (y: 0.45em),
  body,
)

#let side-note(body, title: "旁注") = callout(title: title, kind: "note", compact: true)[#body]
#let sectionline = align(center)[#v(1.5em)#text(fill: colors.muted)[＊　＊　＊]#v(1.5em)]

// source accepts plain text or native cite(...); location keeps the paper's own numbering.
#let source-ref(source, page: none, location: none, url: none) = {
  let parts = (source,)
  if page != none { parts.push([p. #page]) }
  if location != none { parts.push(location) }
  if url != none { parts.push(link(url)[原文]) }
  text(size: 0.88em, fill: colors.muted)[来源：#parts.join([ · ])]
}

#let annotation(body, title: "批注", ..args) = callout(
  body, title: title, kind: "note", icon: "✎", compact: true, ..args,
)

// Content is native Typst: quoted text, image(...), raw code, or a combination.
#let excerpt(
  body,
  source: none,
  page: none,
  location: none,
  url: none,
  annotation: none,
  title: "原文摘录",
  breakable: true,
) = block(
  width: 100%,
  breakable: breakable,
  stroke: 0.6pt + colors.line,
  radius: 4pt,
  inset: 0.9em,
  above: 0.8em,
  below: 0.8em,
)[
  #assert(source != none, message: "excerpt requires source:")
  #set par(first-line-indent: 0pt)
  #text(font: sans-fonts, weight: 700, title)
  #v(0.5em)
  #body
  #v(0.5em)
  #source-ref(source, page: page, location: location, url: url)
  #if annotation != none [
    #v(0.5em)
    #line(length: 100%, stroke: 0.5pt + colors.light-line)
    #text(font: sans-fonts, weight: 700, fill: colors.blue)[批注]
    #par(annotation)
  ]
]

#let tri-table(
  columns: auto,
  align: auto,
  header: (),
  rows: (),
  caption: none,
  width: 100%,
  top-stroke: 1.1pt + black,
  mid-stroke: 0.65pt + black,
  bottom-stroke: 1.1pt + black,
  row-gutter: 0.55em,
  ..cells,
) = {
  let body = cells.pos()
  let col-spec = if columns != auto { columns } else {
    let n = if header != () { header.len() } else if rows != () and rows.len() > 0 { rows.first().len() } else { body.len() }
    (1fr,) * n
  }
  let content = if rows != () {
    let acc = (table.hline(stroke: top-stroke),)
    if header != () {
      acc += header
      acc.push(table.hline(stroke: mid-stroke))
    }
    for row in rows { acc += row }
    acc.push(table.hline(stroke: bottom-stroke))
    acc
  } else {
    (table.hline(stroke: top-stroke),) + body + (table.hline(stroke: bottom-stroke),)
  }
  let tbl = block(width: width)[#table(
    columns: col-spec,
    align: align,
    stroke: none,
    inset: (x: 0.55em, y: row-gutter),
    ..content,
  )]
  if caption == none { tbl } else { figure(tbl, caption: caption, kind: table) }
}

#let booktabs(
  columns: auto,
  header: (),
  rows: (),
  caption: none,
  ..args,
) = tri-table(columns: columns, header: header, rows: rows, caption: caption, ..args)

#let kv-table(pairs, key-width: 7em, value-width: 1fr) = tri-table(
  columns: (key-width, value-width),
  header: ([字段], [内容]),
  rows: pairs.map(pair => (strong(pair.first()), pair.last())),
)

#let dense-table(
  columns: auto,
  header: (),
  rows: (),
  caption: none,
  ..args,
) = tri-table(columns: columns, header: header, rows: rows, caption: caption, row-gutter: 0.35em, ..args)
