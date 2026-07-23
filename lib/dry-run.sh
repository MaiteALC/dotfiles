#!/bin/bash

#######################################
# Executes a command or prints it if dry-run mode is enabled.
#
# Globals:
#   DRY_RUN_MODE
#
# Arguments:
#   ... (String) The command and its arguments to execute or print.
#
# Outputs:
#   Writes the formatted dry-run message to stdout if DRY_RUN_MODE is true.
#   Otherwise, any output depends entirely on the executed command.
#
# Returns:
#   1 if called with no arguments.
#   0 if DRY_RUN_MODE is true.
#   Otherwise, returns the exit status of the executed command.
#######################################
dry_run() {
  if [[ "$#" -eq 0 ]]; then
    return 1
  fi

  local YELLOW="\033[0;33m"
  local RESET="\033[0m"

  if [ "$DRY_RUN_MODE" = "true" ]; then
    printf "%b[DRY-RUN] Would execute:%b %s\n" "$YELLOW" "$RESET" "$*"
  else
    "$@"
  fi
}
