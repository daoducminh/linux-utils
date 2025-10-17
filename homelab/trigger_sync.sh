#!/usr/bin/env bash

##############################################################################
# Wrapper script to ensure network connectivity before running Python script
##############################################################################

# Configuration
MAX_WAIT=300  # Maximum wait time in seconds (5 minutes)
CHECK_INTERVAL=5  # Check network every 5 seconds
PYTHON_SCRIPT="/home/minhdao/Projects/linux-utils/homelab/sync_home_ip.py"
LOG_PREFIX="[IP-Sync]"

# Log only errors by default, use -v for verbose output
VERBOSE=0
if [ "$1" = "-v" ]; then
    VERBOSE=1
fi

# Logging function
log() {
    echo "$LOG_PREFIX $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

debug() {
    [ "$VERBOSE" -eq 1 ] && log "DEBUG: $1"
}

# Check if internet is available
check_internet() {
    # Only check one reliable host to reduce unnecessary output
    if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Wait for network to be ready
wait_for_network() {
    local elapsed=0
    
    debug "Waiting for network connectivity..."
    
    while [ $elapsed -lt $MAX_WAIT ]; do
        if check_internet; then
            debug "Network is ready (took ${elapsed}s)"
            return 0
        fi
        
        sleep $CHECK_INTERVAL
        elapsed=$((elapsed + CHECK_INTERVAL))
        
        [ $((elapsed % 30)) -eq 0 ] && debug "Waiting for network... (${elapsed}s)"
    done
    
    log "ERROR: Network not available after ${MAX_WAIT}s"
    return 1
}

# Main execution
main() {
    debug "Starting IP sync script"
    
    if [ ! -f "$PYTHON_SCRIPT" ]; then
        log "ERROR: Script not found: $PYTHON_SCRIPT"
        exit 1
    fi
    
    if ! wait_for_network; then
        log "ERROR: No network connectivity"
        exit 1
    fi
    
    # Short delay for network stability
    sleep 2
    
    debug "Running IP sync script..."
    python3 "$PYTHON_SCRIPT"
    exit_code=$?
    
    [ $exit_code -ne 0 ] && log "Script failed with code $exit_code"
    exit $exit_code
}

main "$@"
