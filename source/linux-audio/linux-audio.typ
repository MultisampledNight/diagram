#import "../template.typ": *
#show: template

#canvas(length: 1em, {
  import draw: *

  let inner-base = oklch(58.31%, 0.175, 299.73deg)
  let outer-base = oklch(48.81%, 0.125, 309.26deg)

  let pw = inner-base
  let pa = inner-base.rotate(120deg).darken(5%)
  let jack = inner-base.rotate(240deg).darken(10%)

  let indirect = outer-base
  let direct = outer-base.rotate(90deg).lighten(5%)
  let alsa = outer-base.rotate(180deg).lighten(10%)
  let oss = outer-base.rotate(270deg).lighten(15%)

  let pw-pa = pa.mix(pw)
  let pw-jack = jack.mix(pw)
  let pa-jack = jack.mix(pa)
  let padsp = oss.mix(pa)
  let alsa-oss = oss.mix(alsa)

  let nodes = (
    program: (
      x: 0.25,
      desc: [
        *Program*

        Would like to play audio. \
        Can't access hardware directly though.
      ],
      parts: (
        indirect: (
          y: 10,
          long: [Indirectly through wrappers],
          accent: indirect,
        ),
        direct: (
          y: 3,
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
          y: 10,
          long: [PipeWire],
          accent: pw,
        ),
        pa: (
          y: 9,
          long: [PulseAudio],
          accent: pa,
        ),
        jack: (
          y: 7,
          long: [JACK],
          accent: jack,
        ),
        oss: (
          y: 3,
          long: [OSS],
          accent: oss,
        ),
        alsa: (
          y: 0,
          long: [ALSA],
          accent: alsa,
        ),
      ),
    ),
    adapter: (
      x: 2,
      desc: [
        *Adapter*

        Speaks one API, actually \
        sends to a _different_ server.
      ],
      parts: (
        pw-pa: (
          y: 8,
          long: [pipewire-pulse],
          accent: pw-pa,
        ),
        pw-jack: (
          y: 5,
          long: [pipewire-jack],
          accent: pw-jack,
        ),
        pa-jack: (
          y: 4,
          long: [pulseaudio-jack],
          accent: pa-jack,
        ),
        padsp: (
          y: 2,
          long: [padsp],
          accent: padsp,
        ),
        alsa-oss: (
          y: 1,
          long: [alsa-oss],
          accent: alsa-oss,
        ),
      ),
    ),
    server: (
      x: 3,
      desc: [
        *Server*

        Juggles codecs, mixes and \
        decides what is the final output.
      ],
      parts: (
        pw: (
          y: 10,
          long: [PipeWire],
          accent: pw,
        ),
        pa: (
          y: 9,
          long: [PulseAudio],
          accent: pa,
        ),
        jack2: (
          y: 7,
          long: [JACK2],
          accent: jack,
        ),
        jack1: (
          y: 6,
          long: [JACK1],
          accent: jack,
        ),
      ),
    ),
    kernel: (
      x: 3.75,
      desc: [
        *Kernel*

        Takes buffer and sends \
        it to the hardware.
      ],
      parts: (
        oss: (
          y: 3,
          long: [OSS],
          accent: oss,
        ),
        alsa: (
          y: 0,
          long: [ALSA],
          accent: alsa,
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
    layer.x *= 15
    for (name, node) in layer.parts {
      node.y *= 2.5
      layer.parts.at(name) = node
    }
    nodes.at(name) = layer
  }

  for (layer-idx, layer) in connectors.pairs().enumerate() {
    let (source-layer, connectors) = layer
    let source-layer = nodes.at(source-layer)

    let node-count = connectors.len()
    for (node-idx, outgoing) in connectors.pairs().enumerate().rev() {
      let (source-node, targets) = outgoing
      if type(targets) != array {
        targets = (targets,)
      }

      for target in targets.rev() {
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
        let node-specific-offset = (-node-idx + node-count / 2 - 0.5) * 1.75

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
          stroke: 2pt + accent,
        )
      }
    }
  }

  for (i, layer) in nodes.values().enumerate() {
    let side = calc.ceil(i / (nodes.len() - 2))
    let anchor = ("east", none, "west").at(side)
    let alignment = (right, center, left).at(side)

    // description
    content(
      (layer.x, -4),
      anchor: if anchor == none { "north" } else { "north-" + anchor },
      align(alignment, layer.desc),
    )

    line(
      (layer.x, -2.5),
      (rel: (0, 30)),
      stroke: (
        paint: gamut.sample(35%),
        dash: "loosely-dotted",
      ),
    )

    for part in layer.parts.values() {
      let pos = (layer.x, part.y)
      // actual node
      content(
        pos,
        anchor: anchor,
        box(
          fill: bg,
          inset: 0.25em,
          radius: 0.5em,
          text(
            part.accent,
            strong(part.long),
          ),
        )
      )
    }
  }
})
