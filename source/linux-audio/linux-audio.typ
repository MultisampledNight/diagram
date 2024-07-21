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
          y: 3,
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

  let connectors = (
    program: (
      indirect: ("jack", "pa", "pw"),
      direct: ("oss", "alsa"),
    ),
    api: (
      oss: ("kernel.oss", "alsa-oss", "padsp"),
      alsa: "kernel.alsa",
      jack: ("server.jack1", "server.jack2", "pa-jack", "pw-jack"),
      pa: ("server.pa", "pw-pa"),
      pw: "server.pw",
    ),
    // TODO: all the rest
  )

  // scale the positions so they're not super tight
  for (name, layer) in nodes {
    layer.x *= 17.5
    for (name, node) in layer.parts {
      node.y *= 1.75
      layer.parts.at(name) = node
    }
    nodes.at(name) = layer
  }

  for (layer-idx, layer) in connectors.pairs().enumerate() {
    let (source-layer, connectors) = layer
    let source-layer = nodes.at(source-layer)

    for (source-node, targets) in connectors {
      if type(targets) != array {
        targets = (targets,)
      }

      for target in targets {
        let (target-layer, target-node) = if "." in target {
          target.split(".")
        } else {
          (nodes.keys().at(layer-idx + 1), target)
        }

        // now that we got all text reprs, let's look them up
        let source = source-layer.parts.at(source-node)
        let target-layer = nodes.at(target-layer)
        let target = target-layer.parts.at(target-node)

        let source-pos = (source-layer.x, source.y)
        let target-pos = (target-layer.x, target.y)

        line(source-pos, target-pos)
      }
    }
  }

  for (i, layer) in nodes.values().enumerate() {
    let side = calc.ceil(i / (nodes.len() - 2))
    let anchor = ("north-east", "north", "north-west").at(side)
    let alignment = (right, center, left).at(side)
    content(
      (layer.x, -4),
      anchor: anchor,
      align(alignment, layer.desc),
    )

    for part in layer.parts.values() {
      let pos = (layer.x, part.y)
      content(
        pos,
        text(
          layer.palette.sample(part.accent),
          part.long,
        ),
      )
    }
  }
})
