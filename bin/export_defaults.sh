#!/bin/bash

# Default output directories for various options
default_dir="$HOME/.config/defaults"
dropbox_dir="$HOME/Dropbox/config/defaults"
icloud_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/config/defaults"
workdocs_dir="$HOME/Library/CloudStorage/WorkDocsDrive-Documents/config/defaults"
box_dir="$HOME/Library/CloudStorage/Box-Box/config/defaults"  # Box.com default directory

# Show help if the user asks for it
function show_help {
    echo "Usage: $0 [custom_output_directory] [options]"
    echo "Options:"
    echo "  -d, --dropbox        Use Dropbox default output directory"
    echo "  -i, --icloud         Use iCloud default output directory"
    echo "  -wd, --workdocs      Use WorkDocs default output directory"
    echo "  -b, --box            Use Box.com default output directory"
    echo "  -h, --help           Show this help message"
    echo "If no option is provided, ~/.config/defaults will be used."
    exit 0
}

# Initialize output_dir to the default directory
output_dir="$default_dir"

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dropbox)
            output_dir="$dropbox_dir"
            shift
            ;;
        -i|--icloud)
            output_dir="$icloud_dir"
            shift
            ;;
        -wd|--workdocs)
            output_dir="$workdocs_dir"
            shift
            ;;
        -b|--box)
            output_dir="$box_dir"
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            # If the argument is not a predefined option, treat it as a custom directory
            output_dir="$1"
            shift
            ;;
    esac
done

# Create the custom output directory if it doesn't exist
if [[ ! -d "$output_dir" ]]; then
    echo "Directory $output_dir does not exist, creating it now..."
    mkdir -p "$output_dir"
fi

# Display the output directory being used
echo "Using output directory: $output_dir"

# Get all defaults domains
domains=$(defaults domains | tr -d ',')

# Initialize a counter for the number of files created
file_count=0

# Loop through each domain and export the settings
for domain in $domains; do
    # Replace dots in domain with underscores for file naming
    sanitized_domain=$(echo "$domain" | tr '.' '_')
    output_file="$output_dir/$sanitized_domain.plist"

    # Export the domain settings as a plist file
    defaults export "$domain" "$output_file"

    echo "Exported $domain to $output_file"
    file_count=$((file_count + 1)) # Increment the file counter
done

# Print the final message
echo -e "\n***\n\nAll exports are complete. $file_count .plist files were created in $output_dir."
