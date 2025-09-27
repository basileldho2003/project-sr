#!/bin/bash
if [ -f /etc/skel/.Brewfile ] && [ ! -f "$HOME/.Brewfile" ]; then
    cp /etc/skel/.Brewfile "$HOME/.Brewfile"
fi
