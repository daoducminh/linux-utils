#!/usr/bin/env bash

INSTANCE_NAME="${1:-new-system-demo}"

# Get the public IP address using gcloud command
PUBLIC_IP=$(gcloud compute instances describe "$INSTANCE_NAME" --zone 'us-west1-b' --project 'data-analytics-2020' --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Check if the public IP address is not empty
if [ -n "$PUBLIC_IP" ]; then
    if grep -q "$INSTANCE_NAME" /etc/hosts; then
        # Update the hosts file with the new IP address
        sed -i "s/^.*$INSTANCE_NAME.*$/$PUBLIC_IP    $INSTANCE_NAME/" /etc/hosts
        echo "Hosts file updated with new IP address: $PUBLIC_IP"
    else
	# Add the new IP address to the hosts file
	echo "$PUBLIC_IP    $INSTANCE_NAME" | tee -a /etc/hosts
	echo "Hosts file updated with new IP address: $PUBLIC_IP"
    fi
else
    echo "Failed to retrieve public IP address for new-system-demo."
fi
