#!/usr/bin/env bash

# Get the gcloud account from the first argument, use the default value if not provided
gcloud_account=${1:-minhdd@bravestars.com}

# Get the output of the gcloud command
gcloud_output=$(gcloud cloud-shell ssh --authorize-session --force-key-file-overwrite --dry-run --account="$gcloud_account" 2>&1)

# Extract the public IP address and user from the gcloud output
public_ip=$(echo "$gcloud_output" | awk -F'@| -- ' '{print $2}')
user=$(echo "$gcloud_output" | awk -F'@| -- ' '{print $1}' | awk '{print $NF}')

# Check if the public IP address and user are not empty
if [ -n "$public_ip" ] && [ -n "$user" ]; then
    # Replace the HostName and User for the g_shell host in ~/.ssh/config with the new IP address and user
    sed -i "/^Host g_shell$/!b; {n; s/^    HostName .*/    HostName $public_ip/}" ~/.ssh/config
    sed -i "/^Host g_shell$/!b; {n; s/^    User .*/    User $user/}" ~/.ssh/config
    echo "Account $gcloud_account updated HostName and User for 'g_shell' with new IP address: $public_ip and user: $user"
else
    echo "Failed to retrieve public IP address or user."
fi
