#!/bin/sh

# Set the directories
source_dir="/usr/lib/aarch64-linux-gnu/tegra/"
target_dir="/usr/lib/aarch64-linux-gnu/"

# Loop through each file in the source directory
for file in "$source_dir"/*; do
    # Get the filename
    filename=$(basename "$file")

    # Check if the file already exists in the target directory
    if [ -e "$target_dir/$filename" ]; then
        echo "File '$filename' already exists in '$target_dir'"
    else
        # Create the symlink
        ln -s "$file" "$target_dir/$filename"
        echo "Symlink created for '$filename'"
    fi
done
