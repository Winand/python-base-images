#!/bin/sh
PYTHON=/usr/local/lib/python$1
set -e
pip uninstall -y pip || :
rm -rf \
    /usr/local/lib/pkgconfig /usr/local/include \
    $PYTHON/lib-dynload/_codecs_*.so \
    $PYTHON/config-3* \
    $PYTHON/doctest.py \
    $PYTHON/ensurepip \
    /usr/local/bin/idle* $PYTHON/idlelib \
    /usr/local/bin/2to3* $PYTHON/lib2to3 \
    $PYTHON/pdb.py \
    $PYTHON/lib-dynload/_tkinter* $PYTHON/tkinter \
    $PYTHON/lib-dynload/*test*.so \
    $PYTHON/turtle* \
    $PYTHON/unittest \
    $PYTHON/venv
    # pyarrow.compute requires pydoc via numpydoc's docscrape.py
    # $PYTHON/pydoc* /usr/local/bin/pydoc* \
find /usr/local -type d -name "__pycache__" -exec rm -rf {} +
