#!/bin/bash

# Prompt user for action
echo "Enter (a) for add, (r) for remove, or (u) for update:"
read action

case $action in
    a)
        # Prompt for submodule URL and name if the action is to add
        echo "Please enter the submodule URL:"
        read submodule_url
        echo "Please enter the name for the submodule:"
        read submodule_name
        echo "Adding submodule $submodule_name..."
        git submodule add "$submodule_url" "sources_non_forked/$submodule_name" || {
            echo "Failed to add submodule. Here's what you can do manually:"
            echo "git submodule add $submodule_url sources_non_forked/$submodule_name"
        }
        ;;
    r)
        # Prompt just for submodule name if the action is to remove
        echo "Please enter the name of the submodule to remove:"
        read submodule_name
        echo "Removing submodule $submodule_name..."
        git submodule deinit -f "sources_non_forked/$submodule_name"
        git rm -f "sources_non_forked/$submodule_name"
        rm -rf .git/modules/"sources_non_forked/$submodule_name"
        ;;
    u)
        # No prompts needed for update
        echo "Updating modules..."
        ;;
    *)
        echo "Invalid input. Please enter 'a' for add, 'r' for remove, or 'u' for update."
        exit 1
        ;;
esac

# Update modules if the action is add, remove, or update
if [ "$action" = "a" ] || [ "$action" = "r" ] || [ "$action" = "u" ]; then
    echo "Updating all modules"
    git submodule update --init --recursive
fi
