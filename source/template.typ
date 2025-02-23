#import "@preview/cetz:0.2.2"

#let draw = cetz.draw

#let input(name, default) = if name in sys.inputs {
  json.decode(sys.inputs.at(name))
} else {
  default
}
#let bg = luma(100%)
#let fg = luma(0%)
#let gamut = gradient.linear(bg, fg)

#let todo(..what) = {
  let body = what.pos().at(0, default: [TODO])
  text(fill: green, strong(emph(body)))
}

#let template(body) = {
  set page(
    width: auto,
    height: auto,
    fill: bg,
    footer: align(right, text(0.7em)[
      #show link: text.with(blue)

      By MultisampledNight,
      #link(
        "https://creativecommons.org/licenses/by-nc-sa/4.0/",
        [licensed under CC BY-NC-SA 4.0]
      ) \
      #link("https://github.com/MultisampledNight/diagram")[Available on GH],
      please do tell if there's anything wrong!
    ]),
  )
  set text(
    size: 16pt,
    font: "IBM Plex Sans",
    fill: fg,
  )
  show raw: set text(font: "IBM Plex Mono")

  body
}

// Draws a longer line
// starting at `start` following `path`.
// On direction change in `path`,
// the corners are rounded
// according to `radius`.
//
// Format in ABNF:
//
// pathdesc = 1*(dir *WSP len)
// dir = "v" / "^" / "<" / ">"
// len = 1*DIGIT
//
// TODO: implement rounding some day
// TODO: implement save+restore via parenthesis, like IUPAC formulas
#let thread(
  start,
  pathdesc,
  ..args,
) = {
  import draw: *

  let rel = (
    "v": (0, -1),
    "^": (0, 1),
    "<": (-1, 0),
    ">": (1, 0),
  )
  // hacky, should actually use regex matches, but who cares
  let dirs = pathdesc
    .split(regex("\d"))
    .slice(0, -1)
    .map(str.trim)
  let lens = pathdesc
    .split(regex("[v^<>]"))
    .slice(1)
    .map(str.trim)
    .map(float)

  // HACK: using the previous coordinate specifier
  // to keep track of the current position for us
  // so this empty content is just for setting the start pos
  content(start, none)

  for (dir, len) in dirs.zip(lens) {
    let mov = rel.at(dir).map(c => c * len)

    line((), (rel: mov), ..args)
  }
}


#let canvas(body, ..args) = cetz.canvas(..args, {
  import draw: *

  set-style(
    stroke: (
      cap: "round",
      join: "round",
      paint: fg,
    ),
  )

  body
})


#show: template

Use via:

```typst
#import "/template.typ": *
#show: template

#canvas({
  import draw: *
  // your wonderful cetz code comes here
})
```
