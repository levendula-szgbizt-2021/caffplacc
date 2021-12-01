#
# Build with
#
#    docker build -t caffplacc-base .
#

FROM    eclipse-temurin:11-jdk-alpine

ENV     CC=clang
ENV     CFLAGS='-I/usr/include/ImageMagick-6 --rtlib=compiler-rt'
ENV     PREFIX=/usr

# install required tools & libs
RUN     apk update && apk add \
            binutils musl-dev \
            make clang compiler-rt compiler-rt-static \
            libjpeg-turbo-dev imagemagick6-dev

# install libciff
COPY    ciff/ /tmp/ciff/
RUN     cd /tmp/ciff && make clean all && make install-noman

# install libcaff
COPY    caff/ /tmp/caff/
RUN     cd /tmp/caff && make clean all && make install-noman


########################################################################
#
# NOTES
#
# see this for why compiler-rt is required:
# <https://gitlab.alpinelinux.org/alpine/aports/-/issues/10627>
#
# other packages:
#   binutils -> for `ar`
#   musl-dev -> for headers such as `errno.h`
#
