#import "../template.typ": *
#show: template

#canvas(length: 1em, {
  import draw: *

  let nodes = (
    program: (
      x: 0,
      desc: [
        *Program*

        Would like to play audio. \
        Can't access hardware directly though. \
        Hence it needs to send audio to the kernel, somehow.
      ],
      palette: gradient.linear(..color.map.plasma),
      parts: (
        indirect: (
          y: 4,
          long: [Indirectly through wrappers],
          accent: 20%,
        ),
        direct: (
          y: 0,
          long: [Directly],
          accent: 60%,
        ),
      ),
    ),
    api: (
      x: 1,
      desc: [
        *API*

        Just the _protocol_ that is spoken. \
        Not necessarily what _processes_ it.
      ],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        pw: (
          y: 8,
          long: [PipeWire],
          accent: 20%,
        ),
        pa: (
          y: 5,
          long: [PulseAudio],
          accent: 0%,
        ),
        jack: (
          y: 3,
          long: [JACK],
          accent: 40%,
        ),
        alsa: (
          y: 1,
          long: [ALSA],
          accent: 80%,
        ),
        oss: (
          y: 0,
          long: [OSS],
          accent: 60%,
        ),
      ),
    ),
    adapter: (
      x: 2,
      desc: [super creative text],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        pw-pa: (
          y: 10,
          long: [pipewire-pulse],
          accent: 10%,
        ),
        pw-jack: (
          y: 9,
          long: [pipewire-jack],
          accent: 30%,
        ),
        pa-jack: (
          y: 7,
          long: [pulseaudio-jack],
          accent: 0%,
        ),
        padsp: (
          y: 6,
          long: [padsp],
          accent: 50%,
        ),
        alsa-oss: (
          y: 2,
          long: [alsa-oss],
          accent: 70%,
        ),
      ),
    ),
    server: (
      x: 3,
      desc: [super creative text],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        pw: (
          y: 8,
          long: [PipeWire],
          accent: 0%,
        ),
        pa: (
          y: 5,
          long: [PulseAudio],
          accent: 20%,
        ),
        jack2: (
          y: 4,
          long: [JACK2],
          accent: 50%,
        ),
        jack1: (
          y: 3,
          long: [JACK1],
          accent: 40%,
        ),
      ),
    ),
    kernel: (
      x: 4,
      desc: [super creative text],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        alsa: (
          y: 1,
          long: [ALSA],
          accent: 80%,
        ),
        oss: (
          y: 0,
          long: [OSS],
          accent: 60%,
        ),
      ),
    ),
  )

  for (i, level) in nodes.values().enumerate() {
    level.x *= 17.5
    let side = calc.ceil(i / (nodes.len() - 2))
    let anchor = ("north-east", "north", "north-west").at(side)
    let alignment = (right, center, left).at(side)
    content(
      (level.x, -4),
      anchor: anchor,
      align(alignment, level.desc),
    )

    for part in level.parts.values() {
      part.y *= 1.75
      let pos = (level.x, part.y)
      content(pos, text(level.palette.sample(part.accent), part.long))
    }
  }
})
