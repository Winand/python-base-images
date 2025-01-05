FROM python:3.12-alpine AS base
COPY --chmod=500 clean_python_image.sh /
RUN /clean_python_image.sh 3.12

FROM busybox:1.37-musl
# musl dynamic lib
COPY --from=base /lib/ld-musl-x86_64.so.1 /lib/
# python
COPY --from=base /usr/local /usr/local
# certs
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# libraries
ENV LIB=/usr/lib
COPY --from=base \
    # python deps
    $LIB/libz.so.1 \
    $LIB/libreadline.so.8 $LIB/libncursesw.so.6 \
    # ssl
    $LIB/libssl.so.3 \
    $LIB/libcrypto.so.3 \
    # numpy, pandas deps
    $LIB/libffi.so.8 \
    # pyarrow deps
    # (musl has libdl, librt functionality built-in)
    # sqlite
    $LIB/libsqlite3.so.0 \
    # dest
    /usr/lib/

# new user
RUN addgroup --system app && \
    adduser --system app -G app
USER app
