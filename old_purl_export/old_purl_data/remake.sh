#!/bin/bash

ls -1 *.csv |grep -v remake.sh | xargs -IXXX sed -i -e '1d' XXX
