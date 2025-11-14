# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

echo "$("$HOME/.local/bin/inxeoz_notes" --list)"

note() {
    local notes_dir="$HOME/.config/inxeoz_notes"
    local inxeoz_bin="$HOME/.local/bin/inxeoz_notes"

    # Check if the notes directory exists
    if [ ! -d "$notes_dir" ] || [ -z "$(ls -A "$notes_dir")" ]; then
        echo "❌ No notes found."
        return
    fi

    # If flags are passed (e.g., --list, --add, --del), use the inxeoz_notes binary
    if [ $# -gt 0 ] && [[ "$1" == "--"* ]]; then
        "$inxeoz_bin" "$@"
        return
    fi

    # If no arguments are passed, copy the content of the latest note
    if [ $# -eq 0 ]; then
        latest_note=$(ls "$notes_dir" | sort -n | tail -n 1)
        note_content=$(cat "$notes_dir/$latest_note")
        echo "$note_content" | wl-copy
        echo "📋 Copied latest note #$latest_note to clipboard."
        return
    fi
    
    # If a number is provided, show the note and copy its content
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        note_num="$1"
        note_path="$notes_dir/$note_num"
        
        if [ -f "$note_path" ]; then
            note_content=$(cat "$note_path")
            echo "$note_content" | wl-copy
            echo "$note_content"
            echo "📋 Copied note #$note_num to clipboard."
        else
            echo "❌ Note #$note_num not found."
        fi
        return
    fi
    
    # If no valid arguments or options, print usage
    echo "❌ Invalid argument. Usage: note [note_number] or note [--list | --add | --del]"
}
