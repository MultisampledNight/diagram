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
          long: [Indirectly through wrappers],
          accent: 20%,
        ),
        direct: (
          long: [Directly],
          accent: 60%,
        ),
      ),
    ),
    api: (
      x: 10,
      desc: [
        *API*

        Just the _protocol_ that is spoken. \
        Not necessarily what _processes_ it.
      ],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        pa: (
          long: [PulseAudio],
          accent: 0%,
        ),
        pw: (
          long: [PipeWire],
          accent: 20%,
        ),
        jack: (
          long: [JACK],
          accent: 40%,
        ),
        oss: (
          long: [OSS],
          accent: 60%,
        ),
        alsa: (
          long: [ALSA],
          accent: 80%,
        ),
      ),
    ),
    adapter: (
      x: 20,
      desc: [super creative text],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        pw-pa: (
          long: [pipewire-pulse],
          accent: 10%,
        ),
        pw-jack: (
          long: [pipewire-jack],
          accent: 30%,
        ),
        pa-jack: (
          long: [pulseaudio-jack],
          accent: 0%,
        ),
        padsp: (
          long: [padsp],
          accent: 50%,
        ),
        alsa-oss: (
          long: [alsa-oss],
          accent: 70%,
        ),
      ),
    ),
    server: (
      x: 30,
      desc: [super creative text],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        pw: (
          long: [PipeWire],
          accent: 0%,
        ),
        pa: (
          long: [PulseAudio],
          accent: 20%,
        ),
        jack2: (
          long: [JACK2],
          accent: 50%,
        ),
        jack1: (
          long: [JACK1],
          accent: 40%,
        ),
      ),
    ),
    kernel: (
      x: 40,
      desc: [super creative text],
      palette: gradient.linear(..color.map.viridis),
      parts: (
        oss: (
          long: [OSS],
          accent: 60%,
        ),
        alsa: (
          long: [ALSA],
          accent: 80%,
        ),
      ),
    ),
  )

  for (i, level) in nodes.values().enumerate() {
    let side = calc.ceil(i / (nodes.len() - 2))
    let anchor = ("north-east", "north", "north-west").at(side)
    let alignment = (right, center, left).at(side)
    content(
      (level.x, -4),
      anchor: anchor,
      align(alignment, level.desc),
    )
    circle((level.x, 0))
  }
})
