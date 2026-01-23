
#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <command> [args...]"
  exit 1
fi

# Ensure we run in the caller's working directory
cd "$PWD" || exit 1

# Loop until command fails
while "$@"; do
  echo "Command succeeded, running again..."
done

echo "Command failed with exit code $?"
