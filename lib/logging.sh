#!/bin/bash

export RED="\033[0;31m"
export GREEN="\033[0;32m"
export BLUE="\033[0;34m"
export YELLOW="\033[0;33m"
export ORANGE="\033[38;5;208m"
export CYAN="\033[36m"
export NO_COLOR="\033[0m"

#######################################
# Prints an informative message with cyan prefix.
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

  printf "\n%b󰌵 [INFO]%b %s\n" "$CYAN" "$NO_COLOR" "$1"
  shift

  local INDENTATION="         " # prefix length

  if [[ "$#" -gt 0 ]]; then
    printf "$INDENTATION%s\n" "$@"
  fi
}

#######################################
# Prints a warning message with orange prefix.
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

  printf "\n%b  [WARNING]%b %s\n" "$ORANGE" "$NO_COLOR" "$1"
  shift

  local INDENTATION="             " # prefix length

  if [[ "$#" -gt 0 ]]; then
    printf "$INDENTATION%s\n" "$@"
  fi
}

#######################################
# Prints an error message with red prefix.
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

  printf "\n%b [ERROR]%b %s\n" "$RED" "$NO_COLOR" "$1" >&2
  shift

  local INDENTATION="          " # prefix length

  if [[ "$#" -gt 0 ]]; then
    printf "$INDENTATION%s\n" "$@" >&2
  fi
}

#######################################
# Prints a success message with green prefix.
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

  printf "\n%b [SUCCESS]%b %s\n" "$GREEN" "$NO_COLOR" "$1"
  shift

  local INDENTATION="            " # prefix length

  if [[ "$#" -gt 0 ]]; then
    printf "$INDENTATION%s\n" "$@"
  fi
}
