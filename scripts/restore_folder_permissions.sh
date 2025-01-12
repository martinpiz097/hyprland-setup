#!/bin/bash

chmod -R 755 $1 && find $1 -type f -exec chmod 644 {} \; && find $1 -type f -name '*.sh' -exec chmod 755 {} \;
