#import "../template.typ": *
#show: template

#let palette = gradient.linear(..color.map.plasma)
#let indirect = palette.sample(20%)
#let direct = palette.sample(60%)

#let palette = gradient.linear(..color.map.viridis)
#let pulseaudio = palette.sample(0%)
#let pipewire = palette.sample(20%)
#let jack = palette.sample(40%)
#let alsa = palette.sample(60%)

#canvas(length: 1em, {
  import draw: *

  let desc-height = -3

  let api = 10

  // program
  content(
    (0, desc-height),
    anchor: "north-east",
    align(right, [
      *Program*

      Would like to play audio. \
      Can't access hardware directly though. \
      Hence it needs to send audio to the kernel,
      either:
    ])
  )

  content(
    (0, 2),
    anchor: "east", text(indirect)[Indirectly through wrappers],
  )
  content(
    (0, 0),
    anchor: "east",
    text(direct)[Directly to kernel],
  )

  for y in (2, 4, 6) {
    line((3, y), (api, y), stroke: indirect)
  }
  thread((1, 2), ">2^4", stroke: indirect)
  line((1, 0), (api, 0), stroke: direct)


  // API
  content(
    (api, desc-height),
    anchor: "north",
    align(center)[
      *API*

      Just the _protocol_ that is spoken. \
      Not necessarily what _processes_ it.
    ]
  )

  for (i, example) in (
    ([PulseAudio], pulseaudio),
    ([PipeWire], pipewire),
    ([JACK], jack),
    ([ALSA], alsa),
  ).enumerate() {
    let (label, accent) = example
    content(
      (api, (3 - i) * 2),
      box(
        fill: bg,
        inset: 0.25em,
        text(accent, label),
      ),
    )
  }
})
