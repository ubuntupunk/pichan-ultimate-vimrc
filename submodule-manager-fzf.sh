#!/bin/bash

# Ubuntupunk's nifty gitmodule update script for use with·  
# Ultimate Vimrc (Ubuntupunk Edition) 
# Copyright 2025 

#FIXME: This version with fzf for remove function

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo -e "${RED}fzf is not installed. Please install fzf to use this script.${NC}"
    exit 1
fi

# Prompt user for action
echo -e "${BLUE}Enter (a) for add, (r) for remove, or (u) for update:${NC}"
read -r action

case $action in
    a)
        # Prompt for submodule URL and name if the action is to add
        echo -e "${YELLOW}Please enter the submodule URL:${NC}"
        read -r submodule_url
        echo -e "${YELLOW}Please enter the name for the submodule:${NC}"
        read -r submodule_name
        echo -e "${GREEN}Adding submodule $submodule_name...${NC}"
        git submodule add "$submodule_url" "sources_non_forked/$submodule_name" || {
            echo -e "${RED}Failed to add submodule. Here's what you can do manually:${NC}"
            echo "git submodule add $submodule_url sources_non_forked/$submodule_name"
        }
        ;;
    r)
        # Use fzf for submodule selection for removal
        echo -e "${YELLOW}Please enter a pattern to match the submodule name to remove (use * for wildcard):${NC}"
        read -r pattern

        # Check if the directory exists
        if [ ! -d "sources_non_forked" ]; then
          echo -e "${RED}Directory 'sources_non_forked' does not exist or is not accessible.${NC}"
          exit 1
        fi

       # Debug: Print current working directory and list contents
        echo -e "${YELLOW}Current directory:${NC} $(pwd)"
        echo -e "${YELLOW}Contents of sources_non_forked:${NC}"
        ls -la sources_non_forked

        # Use find to list directories, then pipe to fzf for selection
        submodule_name=$(find ./sources_non_forked -maxdepth 1 -type d -name "$pattern" -printf "%f\n" | fzf --height 40% --prompt="Select submodule to remove: " --preview "echo {}")

        if [ -z "$submodule_name" ]; then
            echo -e "${RED}No submodule selected or found.${NC}"
        else
            echo -e "${GREEN}Removing submodule $submodule_name...${NC}"
            git submodule deinit -f "sources_non_forked/$submodule_name"
            git rm -f "sources_non_forked/$submodule_name"
            rm -rf .git/modules/"sources_non_forked/$submodule_name"
        
            # Nuke & commit action
            git rm --cached "sources_non_forked/$submodule_name"
            git commit -m "removed $submodule_name"

           echo -e "${GREEN}Submodule $submodule_name has been nuked and committed.${NC}"
        fi
        ;;
    u)
        # No prompts needed for update
        echo -e "${GREEN}Updating modules...${NC}"
        ;;
    *)
        echo -e "${RED}Invalid input. Please enter 'a' for add, 'r' for remove, or 'u' for update.${NC}"
        exit 1
        ;;
esac

# Update modules if the action is add, remove, or update
if [ "$action" = "a" ] || [ "$action" = "r" ] || [ "$action" = "u" ]; then
    echo -e "${GREEN}Updating all modules${NC}"
    git submodule update --init --recursive
fi
