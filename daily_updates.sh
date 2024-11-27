#!/usr/bin/env bash
reset && clear

# Function to display error messages with failure reason and not exit
log_error() {
  local msg="$1"
  local cmd="$2"
  tput bold
  echo -e "\033[31m[ ERROR ]: $msg \033[0m"  # Red color for errors
  tput sgr0
  echo "$(date) - ERROR: $msg. Command: $cmd" >> "$LOG_FILE"
}

# Function to display success messages
log_success() {
  local msg="$1"
  local cmd="$2"
  tput bold
  echo -e "\033[32m[ SUCCESS ]: $msg \033[0m"  # Green color for success
  tput sgr0
  echo "$(date) - SUCCESS: $msg. Command: $cmd" >> "$LOG_FILE"
}

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  tput bold
  echo "Please run as root."
  tput sgr0
  exit 1
fi

# Log file to capture script execution details
LOG_FILE="/var/log/port_update.log"
echo "$(date) - Starting script execution" > "$LOG_FILE"

# Function to run commands with logging and error checking without exiting
run_command() {
  local cmd="$1"
  echo "Running: $cmd"
  echo "$(date) - Running: $cmd" >> "$LOG_FILE"
  
  # Execute the command, capturing both stdout and stderr
  output=$($cmd 2>&1)
  result=$?

  # Print output to terminal and log it
  echo "$output"
  echo "$output" >> "$LOG_FILE"

  # If the command succeeded, log as success
  if [ $result -eq 0 ]; then
    log_success "$cmd was successful" "$cmd"
  else
    log_error "Command failed with error" "$cmd"
    log_error "Error output: $output" "$cmd"
  fi
}

# Function to mark directories as safe for Git
mark_safe_directory() {
  local dir="$1"
  run_command "git config --global --add safe.directory $dir"
}

# Mark the important directories as safe
tput bold
echo "[ Marking Git directories as safe... ]"
tput sgr0

mark_safe_directory "/usr/ports"
mark_safe_directory "/usr/src"
# Add any additional directories you need to mark as safe:
# mark_safe_directory "/path/to/other/repository"

# Update /usr/ports git tree (split into cd and git pull for better error handling)
tput bold
echo "[ Updating /usr/ports git tree... ]"
tput sgr0
run_command "cd /usr/ports"
run_command "git pull"

# Update /usr/src git tree (split into cd and git pull for better error handling)
tput bold
echo "[ Updating /usr/src git tree... ]"
tput sgr0
run_command "cd /usr/src"
run_command "git pull"

# Update FreeBSD pkg repositories
tput bold
echo "[ Updating FreeBSD pkg repos... ]"
tput sgr0
run_command "pkg update"

# Clean port distfiles
tput bold
echo "[ Cleaning port distfiles... ]"
tput sgr0
run_command "/usr/local/sbin/portmaster -y --clean-distfiles"

# Clean stale port packages
tput bold
echo "[ Cleaning stale port packages... ]"
tput sgr0
run_command "/usr/local/sbin/portmaster -y --clean-packages"

# Check for stale entries in /var/db/ports
tput bold
echo "[ Checking for stale entries in /var/db/ports... ]"
tput sgr0
run_command "/usr/local/sbin/portmaster -v --check-port-dbdir"

# Check for portmaster upgrades
tput bold
echo "[ Checking portmaster for any upgrades... ]"
tput sgr0
run_command "/usr/local/sbin/portmaster -adyG"

tput bold
echo "[ All done! ]"
echo
tput sgr0

# End of script logging
echo "$(date) - Script execution completed." >> "$LOG_FILE"
