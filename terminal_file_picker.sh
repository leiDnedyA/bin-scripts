
#!/bin/bash
# ~/bin/terminal_file_picker.sh

START_DIR="${1:-$HOME}"

while true; do
    echo
    echo "Current Directory: $START_DIR"
    echo

    IFS=$'\n' files=($(ls -Ap "$START_DIR"))
    for i in "${!files[@]}"; do
        printf "[%d] %s\n" "$i" "${files[$i]}"
    done

    echo
    echo "Enter number to cd / pick, '..' to up, 'q' to cancel"
    read -p "> " choice

    if [[ "$choice" == "q" ]]; then
        exit 1
    elif [[ "$choice" == ".." ]]; then
        START_DIR="$(dirname "$START_DIR")"
    elif [[ "$choice" =~ ^[0-9]+$ ]]; then
        sel="${files[$choice]}"
        path="$START_DIR/$sel"
        if [[ -d "$path" ]]; then
            START_DIR="$path"
        elif [[ -f "$path" ]]; then
            echo "$path"
            exit 0
        else
            echo "Invalid."
        fi
    else
        echo "Invalid."
    fi
done
