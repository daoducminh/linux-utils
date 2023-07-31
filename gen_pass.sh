#!/usr/bin/env bash

# Set default password length
PASSWORD_LENGTH=16

# Check if an argument is provided for the password length
if [ $# -eq 1 ]; then
  PASSWORD_LENGTH=$1
fi

# Generate password
PASSWORD=$(base64 < /dev/urandom | head -c"$PASSWORD_LENGTH");

# Raw password
echo "$PASSWORD";

# Hashed password with SHA-256
echo -n "$PASSWORD" | sha256sum | tr -d '-'
