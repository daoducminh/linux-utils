#!/usr/bin/env bash

declare -A accounts=(
    [1]="minhdd@bravestars.com"
    [2]="20156051@student.hust.edu.vn"
)

declare -A host_names=(
    [1]="minhdd"
    [2]="20156051"
)

# Get the gcloud account from the first argument, use the default value if not provided
choice=${1:-1}
gcloud_account=${accounts[$choice]}
host_name=${host_names[$choice]}

# Get the output of the gcloud command
gcloud_output=$(gcloud cloud-shell ssh --authorize-session --force-key-file-overwrite --dry-run --account="$gcloud_account" 2>&1)

# Extract the public IP address and user from the gcloud output
public_ip=$(echo "$gcloud_output" | awk -F'@| -- ' '{print $2}')
user=$(echo "$gcloud_output" | awk -F'@| -- ' '{print $1}' | awk '{print $NF}')

# Check if host g_shell exists in ~/.ssh/config
if grep -q "Host $host_name" ~/.ssh/config; then
    # Check if the public IP address and user are not empty
    if [ -n "$public_ip" ] && [ -n "$user" ]; then
        # Replace the HostName and User for the $host_name host in ~/.ssh/config with the new IP address and user
        #sed -i "/^Host $host_name$/!b; {n; s/^    HostName .*/    HostName $public_ip/}" ~/.ssh/config
        #sed -i "/^Host $host_name$/!b; {n; s/^    User .*/    User $user/}" ~/.ssh/config
        sed -i -E "/^Host "$host_name"$/ { n; s/^\s*HostName\s+[^\s]+$/    HostName $public_ip/; n; s/^\s*User\s+[^\s]+$/    User $user/; }" ~/.ssh/config
        echo "Account $gcloud_account updated HostName and User for '$host_name' with new IP address: $public_ip and user: $user"
    else
        echo "Failed to retrieve public IP address or user."
    fi
else
    # Append the new host profile to ~/.ssh/config
    echo "Host $host_name
    HostName $public_ip
    User $user
    IdentityFile ~/.ssh/google_compute_engine
    Port 6000
    StrictHostKeyChecking no" >>~/.ssh/config

    echo "Host profile $host_name created and added to ~/.ssh/config."
fi
