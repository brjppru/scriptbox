#!/usr/bin/env bash
# ~/.claude/statusline-command.sh
# Claude Code status line mirroring the user's Starship prompt layout:
#   directory  git:branch  git_status  battery  |  model  ctx%  time

input=$(cat)

cwd=$(echo "$input"    | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input"  | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
time_str=$(date +%H:%M:%S)

# --- Directory: truncate to 3 trailing components, ~ for home (mirrors truncation_length=3)
short_dir=$(echo "$cwd" | sed "s|^$HOME|~|")
short_dir=$(echo "$short_dir" | awk -F'/' '{
  n = NF
  if (n <= 3) { print $0; next }
  r = ""
  for (i = n-2; i <= n; i++) r = r "/" $i
  print r
}')

# --- Git: branch + full porcelain status mirroring Starship git_status symbols
git_branch=""
git_status_str=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
               || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [[ -n "$git_branch" ]]; then
    porcelain=$(git -C "$cwd" --no-optional-locks status --porcelain=v1 2>/dev/null)
    ahead=0; behind=0
    ab_line=$(git -C "$cwd" --no-optional-locks rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null || true)
    if [[ -n "$ab_line" ]]; then
      behind=$(echo "$ab_line" | awk '{print $1}')
      ahead=$(echo  "$ab_line" | awk '{print $2}')
    fi
    staged=0; modified=0; untracked=0; deleted=0; renamed=0; typechanged=0; conflicted=0
    while IFS= read -r line; do
      x="${line:0:1}"; y="${line:1:1}"
      [[ "$x$y" == "??" ]] && (( untracked++ )) && continue
      [[ "$x$y" == "UU" || "$x$y" == "AA" || "$x$y" == "DD" ]] && (( conflicted++ )) && continue
      [[ "$x" == "R" ]] && (( renamed++ ))
      [[ "$x" == "T" || "$y" == "T" ]] && (( typechanged++ ))
      [[ "$x" == "D" || "$y" == "D" ]] && (( deleted++ ))
      [[ "$x" =~ [MARC] ]] && (( staged++ ))
      [[ "$y" =~ [MD] ]]   && (( modified++ ))
    done <<< "$porcelain"
    stash_count=$(git -C "$cwd" --no-optional-locks stash list 2>/dev/null | wc -l | tr -d ' ')
    parts=""
    [[ $conflicted  -gt 0 ]] && parts="${parts}=${conflicted}"
    [[ $ahead -gt 0 && $behind -gt 0 ]] && parts="${parts}<>${ahead}/${behind}"
    [[ $ahead -gt 0 && $behind -eq 0 ]] && parts="${parts}>${ahead}"
    [[ $behind -gt 0 && $ahead -eq 0 ]] && parts="${parts}<${behind}"
    [[ $deleted     -gt 0 ]] && parts="${parts}x${deleted}"
    [[ $renamed     -gt 0 ]] && parts="${parts}r${renamed}"
    [[ $typechanged -gt 0 ]] && parts="${parts}t${typechanged}"
    [[ $staged      -gt 0 ]] && parts="${parts}+${staged}"
    [[ $modified    -gt 0 ]] && parts="${parts}!${modified}"
    [[ $untracked   -gt 0 ]] && parts="${parts}?${untracked}"
    [[ $stash_count -gt 0 ]] && parts="${parts}\$${stash_count}"
    [[ -n "$parts" ]] && git_status_str="($parts)"
  fi
fi

# --- Battery: mirrors Starship battery thresholds (<=20 red, <=50 yellow, else blue)
bat_str=""
if command -v pmset >/dev/null 2>&1; then
  bat_info=$(pmset -g batt 2>/dev/null)
  bat_pct=$(echo "$bat_info" | grep -o '[0-9]*%' | head -1 | tr -d '%')
  if [[ -n "$bat_pct" ]]; then
    if echo "$bat_info" | grep -q "AC Power"; then
      bat_sym="bat+"
    elif [[ "$bat_pct" -eq 100 ]]; then
      bat_sym="bat="
    elif [[ "$bat_pct" -le 5 ]]; then
      bat_sym="bat!"
    else
      bat_sym="bat"
    fi
    if   [[ "$bat_pct" -le 20 ]]; then bat_color="\033[1;31m"
    elif [[ "$bat_pct" -le 50 ]]; then bat_color="\033[1;33m"
    else                               bat_color="\033[1;34m"
    fi
    bat_str=$(printf "${bat_color}%s %d%%\033[0m" "$bat_sym" "$bat_pct")
  fi
fi

# --- Context usage: color-coded like battery in Starship (blue/yellow/red)
ctx_str=""
if [[ -n "$used_pct" ]]; then
  used_int=$(printf "%.0f" "$used_pct")
  if   [[ $used_int -ge 80 ]]; then ctx_color="\033[1;31m"   # bold red
  elif [[ $used_int -ge 50 ]]; then ctx_color="\033[1;33m"   # bold yellow
  else                               ctx_color="\033[1;34m"   # bold blue
  fi
  ctx_str=$(printf "${ctx_color}ctx:%d%%\033[0m" "$used_int")
fi

# --- Assemble left: cyan dir  green git:branch  yellow git_status  blue battery
left=$(printf "\033[1;36m%s\033[0m" "$short_dir")
if [[ -n "$git_branch" ]]; then
  left="${left} $(printf "\033[1;32mgit:%s\033[0m" "$git_branch")"
  [[ -n "$git_status_str" ]] && \
    left="${left} $(printf "\033[1;33m%s\033[0m" "$git_status_str")"
fi
[[ -n "$bat_str" ]] && left="${left} ${bat_str}"

# --- Assemble right: magenta model  ctx  cyan time
right=$(printf "\033[1;35m%s\033[0m" "$model")
[[ -n "$ctx_str" ]] && right="${right}  ${ctx_str}"
right="${right}  $(printf "\033[1;36m%s\033[0m" "$time_str")"

printf "%b  |  %b\n" "$left" "$right"
