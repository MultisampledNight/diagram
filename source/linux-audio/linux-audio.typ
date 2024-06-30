#import "../template.typ": *
#show: template

#let palette = gradient.linear(..color.map.plasma)
#let indirect = palette.sample(20%)
#let direct = palette.sample(60%)

// Draws a longer internally curved line
// starting at `start` following `path`.
// On direction change in `path`,
// the corners are rounded
// according to `radius`.
//
// Format in ABNF:
//
// path = 1*(dir *WSP len)
// dir = "v" / "^" / "<" / ">"
// len = 1*DIGIT
#let thread(
  start,
  path,
  radius: 1em,
  ..args,
) = {
  let dirs = (
    "v": (0, -1),
    "^": (0, 1),
    "<": (-1, 0),
    ">": (1, 0),
  )
  let dirs = path
    .split(regex("\d"))
    .slice(0, -1)
    .map(str.trim)
  let lengths = path
    .split(regex("[v^<>]"))
    .slice(1)
    .map(str.trim)
    .map(int)

  draw.content((4, 0))[#dirs]
  draw.content((4, 2))[#lengths]
}

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

  thread((0, 0), "> 4 ^ 3")
})
