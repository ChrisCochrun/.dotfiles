#!/usr/bin/env bash

transmission-remote -a "$@" && notify-send "Transmission-daemon" "Torrent added"
