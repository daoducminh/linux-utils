#!/usr/bin/env bash

# Get the gcloud account from the first argument, use the default value if not provided
gcloud_account=${1:-20156051@student.hust.edu.vn}

# Get the output of the gcloud command
gcloud_output=$(gcloud cloud-shell ssh --authorize-session --force-key-file-overwrite --dry-run --account="$gcloud_account" 2>&1)

# Extract the public IP address and user from the gcloud output
public_ip=$(echo "$gcloud_output" | awk -F'@| -- ' '{print $2}')
user=$(echo "$gcloud_output" | awk -F'@| -- ' '{print $1}' | awk '{print $NF}')

# Check if host g_shell exists in ~/.ssh/config
if grep -q "Host g_shell" ~/.ssh/config; then
    # Check if the public IP address and user are not empty
    if [ -n "$public_ip" ] && [ -n "$user" ]; then
        # Replace the HostName and User for the g_shell host in ~/.ssh/config with the new IP address and user
        # sed -i "/^Host g_shell$/!b; {n; s/^    HostName .*/    HostName $public_ip/}" ~/.ssh/config
        # sed -i "/^Host g_shell$/!b; {n; s/^    User .*/    User $user/}" ~/.ssh/config
        sed -i -E "/^Host g_shell$/ { n; s/^\s*HostName\s+[^\s]+$/    HostName $public_ip/; n; s/^\s*User\s+[^\s]+$/    User $user/; }" ~/.ssh/config
        echo "Account $gcloud_account updated HostName and User for 'g_shell' with new IP address: $public_ip and user: $user"
    else
        echo "Failed to retrieve public IP address or user."
    fi
else
    # Append the new host profile to ~/.ssh/config
    echo "Host g_shell
    HostName $public_ip
    User $user
    Port 6000
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/google_compute_engine" >> ~/.ssh/config

    echo "Host profile g_shell created and added to ~/.ssh/config."
fi
