#!/bin/bash
clear
frame_number=1
while true; do
    while true; do
        frame="frame${frame_number}.txt"
        if [ ! -f "$frame" ]; then
            frame_number=1
            break
        fi
        clear
        cat "$frame"
        sleep 0.05
        ((frame_number++))
    done
done
