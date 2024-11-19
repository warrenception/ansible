#!/bin/bash

ACCOUNT=kobe-eth

# Ensure ansible-vault is installed
if ! command -v ansible-vault &> /dev/null; then
    echo "Error: ansible-vault is not installed"
    exit 1
fi

# Create .ssh directory if it doesn't exist in current location
mkdir -p .ssh

# Find all key files in home .ssh directory and encrypt them
find ~/.ssh/$ACCOUNT -type f \( -name "id_*" -o -name "*.pem" -o -name "known_hosts" -o -name "authorized_keys" \) -print0 | while IFS= read -r -d '' file; do
    # Get just the filename without the path
    filename=$(basename "$file")
    
    # Create encrypted version in current directory's .ssh folder
    ansible-vault encrypt --vault-id default@prompt "$file" --output ".ssh/$filename.vault"
    
    echo "Encrypted $filename to .ssh/$filename.vault"
done

echo "Encryption complete. Encrypted files are stored in $(pwd)/.ssh/"