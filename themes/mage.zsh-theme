# The prompt


# PROMPT='%{%f%k%b%}
# %{%K{black}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{black}%}%~%{%B%F{green}%}$(git_prompt_info)%E%{%f%k%b%}
# %{%K{black}%}$(_prompt_char)%{%K{black}%} %#%{%f%k%b%} '

PROMPT='%{%f%k%b%}
%{%K{${bkg}}%F{green}%}%n%{%F{blue}%}@%{%F{cyan}%}%m %{$fg[green]%}[%{$fg[yellow]%}%~%{$fg[green]%}] %{$fg[magenta]%}$(git_prompt_info)%{%K{${bkg}}%} $(git_prompt_status) $(git_time_since_commit)%{%K{${bkg}}%}%E%{%f%k%b%}
%{%K{${bkg}}%}%#%{%f%k%b%} '

#%{$fg[magenta]%}[%d] %{%f%k%b%} '

# The right-hand prompt

# RPROMPT='${time} %{$fg[magenta]%}$(git_prompt_info)%{%f%b%}$(git_prompt_status)%{%f%b%}'
#RPROMPT='%{$fg[magenta]%}$(git_prompt_info)%{%f%b%}  $(git_prompt_status)%{%f%b%} $(git_time_since_commit) ${time}%{%f%b%}'
RPROMPT='%{%F{blue}%}!%!%{%f%b%}'


# time=%(?.%{$fg[green]%}.%{$fg[red]%})%*%{%f%b%}
time=

ZSH_THEME_GIT_PROMPT_PREFIX=" ± %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%b%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ⚐" # Ⓓ
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓" # Ⓞ

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

# More symbols to choose from:
# ☀ ✹ ☄ ♆ ♀ ♁ ♐ ♇ ♈ ♉ ♚ ♛ ♜ ♝ ♞ ♟ ♠ ♣ ⚢ ⚲ ⚳ ⚴ ⚥ ⚤ ⚦ ⚒ ⚑ ⚐ ♺ ♻ ♼ ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷
# ✡ ✔ ✖ ✚ ✱ ✤ ✦ ❤ ➜ ➟ ➼ ✂ ✎ ✐ ⨀ ⨁ ⨂ ⨍ ⨎ ⨏ ⨷ ⩚ ⩛ ⩡ ⩱ ⩲ ⩵  ⩶ ⨠
# ⬅ ⬆ ⬇ ⬈ ⬉ ⬊ ⬋ ⬒ ⬓ ⬔ ⬕ ⬖ ⬗ ⬘ ⬙ ⬟  ⬤ 〒 ǀ ǁ ǂ ĭ Ť Ŧ

function moveup() {
    echo -ne "\033[1A"
}

function prompt_char() {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[green]%}±%{%f%b%}" && return
  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[red]%}☿%{%f%b%}" && return
  echo "%{$fg[cyan]%}◯%{%f%b%}"
}

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{%f%b%}"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "$COLOR${HOURS}h${SUB_MINUTES}m%{%f%b%}"
            else
                echo "$COLOR${MINUTES}m%{%f%b%}"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "$COLOR~%{%f%b%}"
        fi
    fi
}
