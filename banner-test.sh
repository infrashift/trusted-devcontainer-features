create_banner() {
  local comment="$1"
  local lines_count="${2:-1}" # Default to 1 separation line, allow 2
  local char="${3:-*}"       # Default to '*' for separator, allow custom

  local total_width=80       # The desired total width of the banner

  # --- Function to print a separator line ---
  print_separator() {
    local count="$1"
    local sep_char="$2"
    for ((i=0; i<count; i++)); do
      printf "%${total_width}s\n" "" | tr ' ' "$sep_char"
    done
  }

  # --- Print top separator lines ---
  print_separator "$lines_count" "$char"

  # --- Process and print comment lines ---
  # Use 'readarray' (Bash 4+) or 'read -a' with 'IFS' for splitting
  # If 'comment' might contain actual newlines, this is robust.
  # Otherwise, we rely on the caller to provide newlines correctly.
  
  # The following line is crucial for handling actual newlines passed to the function
  IFS=$'\n' read -d '' -ra comment_lines <<< "$comment"

  for line in "${comment_lines[@]}"; do
    local line_length=${#line}
    local padding_left=$(( (total_width - line_length) / 2 ))
    local padding_right=$(( total_width - line_length - padding_left ))

    printf "%*s%s%*s\n" "$padding_left" "" "$line" "$padding_right" ""
  done

  # --- Print bottom separator lines ---
  print_separator "$lines_count" "$char"
}

# Using printf (recommended for robustness)
create_banner "$(printf "This is the first line.\nAnd this is the second line.\nFinally, the third line.")"

# Using echo -e (less robust than printf, but common)
create_banner "$(echo -e "This is the first line.\nAnd this is the second line.\nFinally, the third line.")"

create_banner "Started..." 2 "+"