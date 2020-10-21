#!/usr/bin/sh
btrfs fi usage / | rg Free | awk '{print $3}'
