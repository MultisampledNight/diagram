# diagram

A few curious diagrams trying to explain things, made in [Typst].

Note: No guarantee for correctness is made.
It is indeed actually very likely that something is wrong.
In that case, I'd appreciate noting this to me in e.g. an issue or opening a pull request.

## how do i get pdf

1. Clone this repository
2. Get the Typst CLI, see https://github.com/typst/typst?tab=readme-ov-file#installation
3. Run the script `compile-all`
4. In the newly created folder `target/docs` are all PDF diagrams now

# Currently in here

## Linux audio system overview

![The diagram, see below for an explanation](https://github.com/user-attachments/assets/61066f23-e482-4a0b-9db8-7fcea67ee4ab)

Shows the journey of audio data from the program
to the kernel.
The layers are:

1. Program
2. API
3. Adapter
4. Server
5. Kernel

The **program** has audio it would like to play
but since it cannot talk directly to the hardware
it needs to resort to an API.
It is possible to talk either
*directly* to the kernel
or *indirectly* through wrappers.

On the **API** layer,
there are
OSS and ALSA
on the direct side and
PipeWire, PulseAudio and JACK
on the indirect side.
They represent a certain interface usable for the program and
have been bound to specific servers in the past.

The **adapter** layer however
relaxes the API-server bijection.
An adapter accepts one API
but actually sends the audio data
to a different server.
It is of course not necessary to use an adapter
if the corresponding server is installed.
Specifically commonly found are:

- Sending to PipeWire
    - pipewire-pulse, adapter to the PulseAudio API
    - pipewire-jack, adapter to the JACK API
- Sending to PulseAudio
    - pulseaudio-jack, adapter to the JACK API
    - padsp, adapter to the OSS API
- Sending to ALSA
    - alsa-oss, adapter to the OSS API

One step before home, the **server** layer
mixes everything together,
enumerates multiple output devices and
sends the final desired results to the kernel.
Although they are called servers,
they usually run on the same machine as the program.
Here to be found are the
PipeWire, PulseAudio, JACK1 and JACK2 servers.
JACK1 and JACK2 both implement the JACK API,
the latter is simply a rewrite of the former,
but both are still in use.

Finally, the **kernel** layer receives the server's result
and takes care of throwing it to the hardware.
Here are the older OSS and the newer ALSA.

## License

CC BY-NC-SA 4.0, see [LICENSE.md](./LICENSE.md)

[Typst]: https://typst.app
