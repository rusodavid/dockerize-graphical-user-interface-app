# gui-app

Shared base image for the GUI app images in this workspace. Forked from
[exadra37's dockerize-graphical-user-interface-app](https://gitlab.com/exadra37-docker-images/dockerize-graphical-user-interface-app),
now reduced to a plain base layer.

It contains:

* `ubuntu-base` (always: es_ES locale, Europe/Madrid TZ, CA certificates)
* PulseAudio client (`libpulse0`, `pulseaudio-utils`) configured to use the
  host's server through a socket mounted at `/tmp/pulse/native`
* `NO_AT_BRIDGE=1` so GTK apps don't look for the accessibility bus

It deliberately sets no `USER`, `ENTRYPOINT` or shell and no root password:
each app image creates its user and entrypoint.

## Image chain
```
ubuntu-base:26.04
 └─ gui-app:26.04
     ├─ gnucash
     └─ nvidia-gui-app:26.04
         ├─ chrome-ubuntu
         └─ shotcut
```

## Build args
| Arg | Default | Description |
|---|---|---|
| `UBUNTU_BASE_TAG` | `26.04` | Tag of `ubuntu-base` to build on (the image itself is fixed) |

## Build
```bash
docker build -t gui-app:26.04 build
```

Rebuild the images above it afterwards, in chain order.

## Audio
Mount the host's PulseAudio/PipeWire socket:

```bash
docker run --rm -v "$XDG_RUNTIME_DIR/pulse/native:/tmp/pulse/native:ro" gui-app:26.04 pactl info
```
