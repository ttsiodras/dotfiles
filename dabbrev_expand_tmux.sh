#!/bin/bash

function _print_all_panes() {
  for pane_id in $(tmux list-panes -F '#{pane_id}'); do
    tmux capture-pane -p -J -S 0 -E - -t "$pane_id" | tr ' ' '\n' | sort -u | grep -E '[a-zA-Z0-9]+'
  done
}

_tmux_pane_words() {
  local current_line="${READLINE_LINE}"
  local cursor_pos="${READLINE_POINT}"
  
  # Extract the word under cursor
  local before_cursor="${current_line:0:$cursor_pos}"
  local after_cursor="${current_line:$cursor_pos}"
  
  # Find the current word (everything after the last space before cursor)
  local current_word="${before_cursor##* }"
  local before_word="${before_cursor% *}"
  
  # Find where the current word ends after cursor
  local after_word=""
  if [[ "$after_cursor" =~ ^[^\ ]* ]]; then
    after_word="${after_cursor#${BASH_REMATCH[0]}}"
  else
    after_word="$after_cursor"
  fi
  
  # Create prompt showing context
  local prompt="${before_word} ␣ ${after_word} "
  
  # Get selected word from fzf
  local selected_word=$(_print_all_panes | fzf --query="$current_word" --prompt="$prompt" --height=20 --layout=reverse --no-sort --print-query | tail -n1)
  
  # If user selected something, replace the current word
  if [[ -n "$selected_word" && "$selected_word" != "$current_word" ]]; then
    local new_line="${before_word} ${selected_word}${after_word}"
    READLINE_LINE="$new_line"
    READLINE_POINT=$((${#before_word} + 1 + ${#selected_word}))
  fi
}

bind -x '"\C-k": _tmux_pane_words'
