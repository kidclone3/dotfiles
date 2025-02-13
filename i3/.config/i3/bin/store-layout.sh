#!/bin/bash
set -e
IFS=$'\n\t'
ACTION=${1:save}
SAVEPATH="$HOME/.i3/i3-resurrect"

DEPS='i3-resurrect
jq'
# Check if dependencies are installed, and bail out if they aren't
for dep in $DEPS; do
    if $dep --version > /dev/null ; then
    	true
    else
    	echo "$dep is not installed!"
    	notify-send "i3-resurrect" "$dep is not installed!"
    	exit 1
    fi
done

# i3r
# this program saves and restores all currently active workspaces with i3-resurrect - 
# arguments: takes one argument and assumes .i3/i3r is at "~/"
# expected output: showin what workspace is currently being saved and sends a notification when done
# example suggested usages:
#  i3r save
#  i3r restore

ALLWORKSPACES=$(i3-msg -t get_workspaces)

case $ACTION in
    restore)
        # #save current workspace
        # CUR_WORKSPACE=$(echo $ALLWORKSPACES | jq -r '.[] | select(.visible == true) | .name')

        # # Find saved files; we now expect filenames of the form "workspace__output.json"
        # saved_files=$(find "$SAVEPATH" -type f -iname '*.json')
        # if [ -z "$saved_files" ]; then
        #     echo "No saved workspace files found."
        #     notify-send "i3-resurrect" "No saved workspaces found."
        #     exit 1
        # fi

        # echo "Found saved workspace files:"
        # while IFS= read -r file; do
        #     echo "  $(basename "$file")"
        # done <<< "$saved_files"
    
        i3-resurrect ls | awk '{print $2}' | sort -u | while IFS= read -r ws_id; do
            if [[ -n "$ws_id" ]]; then
                i3-resurrect restore -w "$ws_id"
                echo "Restored workspace: $ws_id"
            fi
        done
    
        # Wait for all background jobs to complete
        wait

        notify-send "i3-resurrect" "Restored all workspaces"
        # Return to the original workspace (without output tag)
        i3-msg workspace "$CUR_WORKSPACE"
	    ;;
    *)
        # Find running workspaces
        workspaces=$(jq -c '.[]' <<< "$ALLWORKSPACES")
        echo "Found workspaces:"
        echo "$workspaces" | jq '.'

        # # Remove old saves (safely handling paths with spaces)
        # find "${SAVEPATH}" -type f -delete

        echo "Removing old workspace saves..."
        i3-resurrect ls | awk '{print $2}' | sort -u | while IFS= read -r ws_id; do
            if [[ -n "$ws_id" ]]; then
                i3-resurrect rm -w "$ws_id"
                echo "Removed save for workspace: $ws_id"
            fi
        done
        # Save workspaces with programs running
        while IFS= read -r ws; do
            name=$(jq -r '.name' <<< "$ws")
            output=$(jq -r '.output' <<< "$ws")
            combined="${name}__${output}"

            echo "Saving workspace '$name' on output '$output' with combined name '$combined'"
            # Create a combined identifier using a double underscore separator
            i3-resurrect save -w "$name" &
        done < <(jq -c '.[]' <<< "$ALLWORKSPACES")

        # Wait for all save operations to complete
        wait

        notify-send "i3-resurrect" "Saved all workspaces"
	    ;;
esac