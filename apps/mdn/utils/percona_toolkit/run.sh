#!/bin/bash

PT_KILL_OPTIONS="--busy-time=30m --kill --print --victims=all --verbose"
PT_KILL_CREDS="h=${DB_HOST},D=${DB_NAME},u=${DB_USER},p=${DB_PASS}"

pt-kill ${PT_KILL_OPTIONS} ${PT_KILL_CREDS}
