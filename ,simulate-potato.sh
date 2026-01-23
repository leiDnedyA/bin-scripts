#!/usr/bin/env bash

# Usage: ./simulate-potato.sh <process_name> [cpu_limit_percent] [prlimit_args]
# Example: ./simulate-potato.sh chrome
# (defaults to 50% CPU limit and 2GB memory limit)

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <process_name> [cpu_limit_percent] [prlimit_args]"
    echo "Example: $0 chrome"
    exit 1
fi

PROCESS_NAME=$1
CPU_LIMIT=${2:-20}                   # Default: 50% CPU
PRLIMIT_ARGS=${3:-"--as=1000000"}    # Default: 2GB memory limit (address space)

# Find matching PIDs (exact process name match)
PIDS=$(ps -C "$PROCESS_NAME" -o pid=)

if [[ -z "$PIDS" ]]; then
    echo "No processes found with name \"$PROCESS_NAME\""
    exit 0
fi

echo "Found PIDs: $PIDS"
for PID in $PIDS; do
    # echo "Applying prlimit ($PRLIMIT_ARGS) to PID $PID"
    # sudo prlimit --pid "$PID" $PRLIMIT_ARGS
    #
    echo "Applying cpulimit ($CPU_LIMIT%) to PID $PID"
    sudo cpulimit -p "$PID" -l "$CPU_LIMIT" --background
done

echo "Done."
