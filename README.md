# vxOpenLibM - v1.0.0

This is a wrapper around the `OpenLibm` with the support of the `sh3eb`
architecture (written by [Lephenixnoir](https://silent-tower.net/projects/)),
intended for the Vhex kernel project.

This project will directly patch the current `openlibm` source files and use a
custom build system based on CMake instead of the "Makefile mess" used in the
original project to handle properly the install/uninstall process.

## Installing

You can use the `scripts/install.sh --help` to see manual installation of the
project. But, since the compiler needed to build the `vxOpenLibm` is
`sh-elf-vhex` which automatically installs this project, you theoretically do
not need to do so.

## README and Licensing

See the original
[REAME file](https://github.com/JuliaMath/openlibm/blob/master/README.md) of
the openlibm project for further information.
Note that Openlibm contains code covered by various licenses, see
[LICENSE.md](https://github.com/JuliaMath/openlibm/blob/master/LICENSE.md)

## Special thanks

A big thanks to
[Lephenixnoir](https://silent-tower.net/projects/) who ported the `sh3eb`
support to `openlibm`!
