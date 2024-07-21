#import "../template.typ": *
#show: template

#canvas(length: 1em, {
  import draw: *

  let indirect = rgb("#777777")
  let direct = rgb("#AAAAAA")
  let pw = rgb("#FF0000")
  let pa = rgb("#00FF00")
  let jack = rgb("#0000FF")
  let alsa = rgb("#770077")
  let oss = rgb("#506070")

  let pw-pa = pa.mix(pw)
  let pw-jack = jack.mix(pw)
  let pa-jack = jack.mix(pa)
  let padsp = oss.mix(pa)
  let alsa-oss = oss.mix(alsa)

  let nodes = (
    program: (
      x: 0,
      desc: [
        *Program*

        Would like to play audio. \
        Can't access hardware directly though. \
        Hence it needs to send audio to the kernel, somehow.
      ],
      parts: (
        indirect: (
          y: 3,
          long: [Indirectly through wrappers],
          accent: indirect,
        ),
        direct: (
          y: 0,
          long: [Directly],
          accent: direct,
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
      parts: (
        pw: (
          y: 8,
          long: [PipeWire],
          accent: pw,
        ),
        pa: (
          y: 5,
          long: [PulseAudio],
          accent: pa,
        ),
        jack: (
          y: 3,
          long: [JACK],
          accent: jack,
        ),
        alsa: (
          y: 1,
          long: [ALSA],
          accent: alsa,
        ),
        oss: (
          y: 0,
          long: [OSS],
          accent: oss,
        ),
      ),
    ),
    adapter: (
      x: 2,
      desc: [super creative text],
      parts: (
        pw-pa: (
          y: 10,
          long: [pipewire-pulse],
          accent: pw-pa,
        ),
        pw-jack: (
          y: 9,
          long: [pipewire-jack],
          accent: pw-jack,
        ),
        pa-jack: (
          y: 7,
          long: [pulseaudio-jack],
          accent: pa-jack,
        ),
        padsp: (
          y: 6,
          long: [padsp],
          accent: padsp,
        ),
        alsa-oss: (
          y: 2,
          long: [alsa-oss],
          accent: alsa-oss,
        ),
      ),
    ),
    server: (
      x: 3,
      desc: [super creative text],
      parts: (
        pw: (
          y: 8,
          long: [PipeWire],
          accent: pw,
        ),
        pa: (
          y: 5,
          long: [PulseAudio],
          accent: pa,
        ),
        jack2: (
          y: 4,
          long: [JACK2],
          accent: jack,
        ),
        jack1: (
          y: 3,
          long: [JACK1],
          accent: jack,
        ),
      ),
    ),
    kernel: (
      x: 4,
      desc: [super creative text],
      parts: (
        alsa: (
          y: 1,
          long: [ALSA],
          accent: alsa,
        ),
        oss: (
          y: 0,
          long: [OSS],
          accent: oss,
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
    adapter: (
      pw-pa: "pw",
      pw-jack: "pw",
      pa-jack: "pa",
      padsp: "pa",
      alsa-oss: "kernel.alsa",
    ),
    server: (
      pw: "alsa",
      pa: "alsa",
      jack2: "alsa",
      jack1: "alsa",
    ),
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

    let node-count = connectors.len()
    for (node-idx, outgoing) in connectors.pairs().enumerate() {
      let (source-node, targets) = outgoing
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

        // and onto rendering them
        // we'd like the y traverser to be on a different x position for every node in a layer
        // so one can still differentiate between them
        // hence this node specific offset
        let node-specific-offset = -node-idx + node-count / 2 - 1

        let mid-bottom = (
          to: (source-pos, 50%, (source-pos, "-|", target-pos)),
          rel: (node-specific-offset, 0),
        )
        let mid-top = (
          to: mid-bottom,
          rel: (0, target.y - source.y),
        )

        let accent = gradient.linear(
          source.accent,
          target.accent,
        )
        line(
          source-pos,
          mid-bottom,
          mid-top,
          target-pos,
          stroke: accent,
        )
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
        box(
          fill: bg,
          inset: 0.25em,
          radius: 0.5em,
          text(
            part.accent,
            part.long,
          ),
        )
      )
    }
  }
})
