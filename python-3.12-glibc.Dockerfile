FROM python:3.12-slim AS base
COPY --chmod=500 clean_python_image.sh /
RUN /clean_python_image.sh 3.12

FROM busybox:1.37-glibc
# python
COPY --from=base /usr/local /usr/local
# certs
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# libraries
ENV LIB=/usr/lib/x86_64-linux-gnu
COPY --from=base \
    # python deps
    $LIB/libz.so.1 \
    $LIB/libreadline.so.8 $LIB/libtinfo.so.6 \
    # ssl
    $LIB/libssl.so.3 \
    $LIB/libcrypto.so.3 \
    # numpy, pandas deps
    $LIB/libffi.so.8 \
    $LIB/libgcc_s.so.1 \
    $LIB/libstdc++.so.6 \
    # pyarrow deps
    $LIB/libdl.so.2 \
    $LIB/librt.so.1 \
    # sqlite
    $LIB/libsqlite3.so.0 \
    # dest
    /usr/lib/

# new user
RUN addgroup --system app && \
    adduser --system app -G app
USER app
