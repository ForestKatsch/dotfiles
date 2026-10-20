#!/usr/bin/env bash

if pgrep -x hyprlock >/dev/null; then
    # An existing process is only a real lock if logind agrees.
    sid=$(loginctl show-user "$USER" -p Display --value 2>/dev/null)
    if [ "$(loginctl show-session "$sid" -p LockedHint --value 2>/dev/null)" = "yes" ]; then
        exit 0
    fi
    pkill -x hyprlock
    sleep 0.5
fi

exec hyprlock
