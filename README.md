# vxOpenLibM

This is a fork of OpenLibm with the support of the sh3eb architecture, intended
for the Vhex kernel project.

This work will directly patch the current openlibm sources code and use a
custom build system based on CMake instead of the Makefile mess used in the
original project.

## Installing

You can use the `scripts/install.sh --help` to see manual installation of the
project. But, since the compiler used for this repository is "sh-elf-vhex"
which automatically install this project as a own dependency you theorically do
not need to install this project.

## README and Licensing

See the original
[REAME file](https://github.com/JuliaMath/openlibm/blob/master/README.md) of
the openlibm project for futher information.
Note that Openlibm contains code covered by various licenses, see
[LICENSE.md](https://github.com/JuliaMath/openlibm/blob/master/LICENSE.md)
