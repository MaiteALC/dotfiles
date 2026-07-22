#!/bin/bash

export RED="\033[0;31m"
export GREEN="\033[0;32m"
export BLUE="\033[0;34m"
export YELLOW="\033[0;33m"
export ORANGE="\033[38;5;208m"
export CYAN="\033[36m"
export NO_COLOR="\033[0m"

#######################################
# Prints an informative message in cyan.
#
# Globals:
#   CYAN
#   NO_COLOR
#
# Arguments:
#   ... (String) The messages to print. Each argument is printed on a
#   new line. Only the first argument is prefixed with '󰌵 [INFO] '.
#
# Outputs:
#   Writes the formatted message to stdout.
#
# Returns:
#   0 if successful.
#   1 if called with no arguments.
#######################################
info() {
  if [[ "$#" -eq 0 ]]; then
    return 1
  fi

  printf "\n%b󰌵 [INFO] %s\n" "$CYAN" "$1"
  shift

  if [[ "$#" -gt 0 ]]; then
    printf "%s\n" "$@"
  fi

  printf "%b" "$NO_COLOR"
}

#######################################
# Prints a warning message in orange.
#
# Globals:
#   ORANGE
#   NO_COLOR
#
# Arguments:
#   ... (String) The messages to print. Each argument is printed on a
#   new line. Only the first argument is prefixed with '  [WARNING] '.
#
# Outputs:
#   Writes the formatted message to stdout.
#
# Returns:
#   0 if successful.
#   1 if called with no arguments.
#######################################
warn() {
  if [[ "$#" -eq 0 ]]; then
    return 1
  fi

  printf "\n%b  [WARNING] %s\n" "$ORANGE" "$1"
  shift

  if [[ "$#" -gt 0 ]]; then
    printf "%s\n" "$@"
  fi

  printf "%b" "$NO_COLOR"
}

#######################################
# Prints an error message in red.
#
# Globals:
#   RED
#   NO_COLOR
#
# Arguments:
#   ... (String) The messages to print. Each argument is printed on a
#   new line. Only the first argument is prefixed with ' [ERROR] '.
#
# Outputs:
#   Writes the formatted message to stderr.
#
# Returns:
#   0 if successful.
#   1 if called with no arguments.
#######################################
error() {
  if [[ "$#" -eq 0 ]]; then
    return 1
  fi

  printf "\n%b [ERROR] %s\n" "$RED" "$1" >&2
  shift

  if [[ "$#" -gt 0 ]]; then
    printf "%s\n" "$@" >&2
  fi

  printf "%b" "$NO_COLOR"
}

#######################################
# Prints a success message in green.
#
# Globals:
#   GREEN
#   NO_COLOR
#
# Arguments:
#   ... (String) The messages to print. Each argument is printed on a
#   new line. Only the first argument is prefixed with ' [SUCCESS] '.
#
# Outputs:
#   Writes the formatted message to stdout.
#
# Returns:
#   0 if successful.
#   1 if called with no arguments.
#######################################
success() {
  if [[ "$#" -eq 0 ]]; then
    return 1
  fi

  printf "\n%b [SUCCESS] %s\n" "$GREEN" "$1"
  shift

  if [[ "$#" -gt 0 ]]; then
    printf "%s\n" "$@"
  fi

  printf "%b" "$NO_COLOR"
}
