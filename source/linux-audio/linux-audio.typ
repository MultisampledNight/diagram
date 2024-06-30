#import "../template.typ": *
#show: template

#let palette = gradient.linear(..color.map.plasma)
#let indirect = palette.sample(20%)
#let direct = palette.sample(60%)

#canvas(length: 1em, {
  import draw: *

  content((0, 0), anchor: "east", padding: 1em)[
    #align(center)[*Program*]

    Would like to play audio. \
    Can't access hardware directly though. \
    Hence it needs to send audio to the kernel,
    either:

    - #text(indirect)[Indirectly through wrappers]
    - #text(direct)[Directly]
  ]

  thread((0, 0), "> 4 ^ 3 > 1 v 0.5")
})
