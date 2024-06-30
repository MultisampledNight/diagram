#import "@preview/cetz:0.2.2"

#let draw = cetz.draw

#let input(name, default) = if name in sys.inputs {
  json.decode(sys.inputs.at(name))
} else {
  default
}
#let dev = input("dev", false)
#let bg = if dev { oklch(25.2%, 0.0035, 223.44deg) } else { luma(0%) }
#let fg = if dev { oklch(76.9%, 0.0035, 343.44deg) } else { luma(100%) }
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
  )
  set text(
    size: 16pt,
    font: "IBM Plex Sans",
    fill: fg,
  )
  show raw: set text(font: "IBM Plex Mono")

  body
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
