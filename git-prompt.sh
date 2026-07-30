# zsh git prompt support
#
# Copyright (C) 2020 David Xu
# Copyright (C) 2026 Elias Toivanen
#
# Based on the earlier work by Shawn O. Pearce <spearce@spearce.org>
# Distributed under the GNU General Public License, version 2.0.
#
# This script has been modified by Elias Toivanen in 2026.
# Optimized for zsh-only environments.
#

# Convenience function to set PS1 to show git status. Must supply two
# arguments that specify the prefix and suffix of the git status string.
#
# This function should be called in PROMPT_COMMAND or similar.
__posh_git_ps1 ()
{
    local ps1pc_prefix=
    local ps1pc_suffix=
    case "$#" in
        2)
            ps1pc_prefix=$1
            ps1pc_suffix=$2
            ;;
        *)
            echo __posh_git_ps1: bad number of arguments >&2
            return
            ;;
    esac
    local gitstring=$(__posh_git_echo)
    PS1=$ps1pc_prefix$gitstring$ps1pc_suffix
}

__posh_color () {
    echo %{$1%}
}

# Echoes the git status string.
__posh_git_echo () {
    local g=$(__posh_gitdir)
    [[ -z "$g" ]] && return

    # Color definitions
    local Red='\033[0;31m'
    local Green='\033[0;32m'
    local BrightRed='\033[0;91m'
    local BrightGreen='\033[0;92m'
    local BrightYellow='\033[1;30m'
    local BrightCyan='\033[1;30m'

    local DefaultForegroundColor=$(__posh_color '\e[m')
    local BeforeText='['
    local BeforeForegroundColor=$(__posh_color $BrightYellow)
    local DelimText=' |'
    local DelimForegroundColor=$(__posh_color $BrightYellow)
    local AfterText=']'
    local AfterForegroundColor=$(__posh_color $BrightYellow)
    local BranchForegroundColor=$(__posh_color $BrightCyan)
    local BranchAheadForegroundColor=$(__posh_color $BrightGreen)
    local BranchBehindForegroundColor=$(__posh_color $BrightRed)
    local IndexForegroundColor=$(__posh_color $Green)
    local WorkingForegroundColor=$(__posh_color $Red)
    local StashForegroundColor=$(__posh_color $BrightRed)
    local BeforeStash='('
    local AfterStash=')'
    local LocalWorkingStatusSymbol=' !'
    local LocalWorkingStatusColor=$(__posh_color "$Red")
    local LocalStagedStatusSymbol=' ~'
    local LocalStagedStatusColor=$(__posh_color "$BrightCyan")
    local RebaseForegroundColor=$(__posh_color '\e[0m')

    local BranchIdenticalStatusSymbol=''
    local BranchAheadStatusSymbol=''
    local BranchBehindStatusSymbol=''
    local BranchBehindAndAheadStatusSymbol=''
    local BranchWarningStatusSymbol=''

    local EnableStatusSymbol=true
    if $EnableStatusSymbol; then
      BranchIdenticalStatusSymbol=$' \xE2\x89\xA1' # Three horizontal lines
      BranchAheadStatusSymbol=$' \xE2\x86\x91' # Up Arrow
      BranchBehindStatusSymbol=$' \xE2\x86\x93' # Down Arrow
      BranchBehindAndAheadStatusSymbol=$'\xE2\x86\x95' # Up and Down Arrow
      BranchWarningStatusSymbol=' ?'
    fi

    # Detection of special states (rebase, merge, etc.)
    local rebase='' b='' step='' total=''
    if [[ -d "$g/rebase-merge" ]]; then
        b=$(<"$g/rebase-merge/head-name" 2>/dev/null)
        step=$(<"$g/rebase-merge/msgnum" 2>/dev/null)
        total=$(<"$g/rebase-merge/end" 2>/dev/null)
        rebase=$([[ -f "$g/rebase-merge/interactive" ]] && echo "|REBASE-i" || echo "|REBASE-m")
    elif [[ -d "$g/rebase-apply" ]]; then
        step=$(<"$g/rebase-apply/next" 2>/dev/null)
        total=$(<"$g/rebase-apply/last" 2>/dev/null)
        if [[ -f "$g/rebase-apply/rebasing" ]]; then rebase='|REBASE'
        elif [[ -f "$g/rebase-apply/applying" ]]; then rebase='|AM'
        else rebase='|AM/REBASE'; fi
    elif [[ -f "$g/MERGE_HEAD" ]]; then rebase='|MERGING'
    elif [[ -f "$g/CHERRY_PICK_HEAD" ]]; then rebase='|CHERRY-PICKING'
    elif [[ -f "$g/REVERT_HEAD" ]]; then rebase='|REVERTING'
    elif [[ -f "$g/BISECT_LOG" ]]; then rebase='|BISECTING'
    fi

    [[ -n "$step" && -n "$total" ]] && rebase="$rebase $step/$total"

    # Single git status call for everything else
    local status_output=$(git status --branch --porcelain 2>/dev/null)
    [[ -z "$status_output" ]] && return

    local -a status_lines=("${(f)status_output}")

    # Parse first line (## branchname...upstream [ahead X, behind Y])
    local head_line="${status_lines[1]}"
    local isBare=false
    if [[ "$head_line" == *"BARE:"* ]]; then isBare=true; fi
    
    if [[ -z "$b" ]]; then
        b="${head_line#\#\# }"
        b="${b%%...*}"
        if [[ "$b" == "No branch" || "$b" == "HEAD (no branch)" ]]; then
            # Detached HEAD, fallback to describe if needed
            b=$(git describe --tags --exact-match HEAD 2>/dev/null || cut -c1-7 "$g/HEAD" 2>/dev/null || echo "unknown")
            b="($b)"
        fi
    fi

    # Status counts using zsh array filtering (much faster)
    local indexAdded=${#${(M)status_lines:#A? *}}
    local indexModified=${#${(M)status_lines:#[MRTC]? *}}
    local indexDeleted=${#${(M)status_lines:#D? *}}
    local indexUnmerged=${#${(M)status_lines:#U? *}}
    
    local filesAdded=${#${(M)status_lines:#?\? *}}
    local filesModified=${#${(M)status_lines:#?[MT] *}}
    local filesDeleted=${#${(M)status_lines:#?D *}}
    local filesUnmerged=${#${(M)status_lines:#?U *}}

    # Stash count (avoiding wc -l)
    local stashCount=0 hasStash=false
    if git rev-parse --verify -q refs/stash >/dev/null 2>&1; then
        hasStash=true
        stashCount=${#${(f)"$(git stash list 2>/dev/null)"}}
    fi

    local gitstring=""
    local branchstring="$([[ "$isBare" == "true" ]] && echo "BARE:" || echo "")${b##refs/heads/}"

    gitstring="$BeforeForegroundColor$BeforeText"
    gitstring+="$BranchForegroundColor$branchstring$BranchIdenticalStatusSymbol"
    gitstring+="${rebase:+$RebaseForegroundColor$rebase}"

    local indexCount=$(( indexAdded + indexModified + indexDeleted + indexUnmerged ))
    local workingCount=$(( filesAdded + filesModified + filesDeleted + filesUnmerged ))

    if (( indexCount != 0 )); then
        gitstring+="$IndexForegroundColor +$indexAdded ~$indexModified -$indexDeleted"
        [[ $indexUnmerged != 0 ]] && gitstring+=" $IndexForegroundColor!$indexUnmerged"
    fi
    if (( indexCount != 0 && workingCount != 0 )); then
        gitstring+="$DelimForegroundColor$DelimText"
    fi
    if (( workingCount != 0 )); then
        gitstring+="$WorkingForegroundColor +$filesAdded ~$filesModified -$filesDeleted"
        [[ $filesUnmerged != 0 ]] && gitstring+=" $WorkingForegroundColor!$filesUnmerged"
    fi

    local localStatusSymbol=""
    local localStatusColor=$DefaultForegroundColor
    if (( workingCount != 0 )); then
        localStatusSymbol=$LocalWorkingStatusSymbol
        localStatusColor=$LocalWorkingStatusColor
    elif (( indexCount != 0 )); then
        localStatusSymbol=$LocalStagedStatusSymbol
        localStatusColor=$LocalStagedStatusColor
    fi

    gitstring+="$localStatusColor$localStatusSymbol$DefaultForegroundColor"

    if [[ "$hasStash" == "true" ]]; then
        gitstring+=" $StashForegroundColor$BeforeStash$stashCount$AfterStash"
    fi

    gitstring+="$AfterForegroundColor$AfterText$DefaultForegroundColor"
    echo -e "$gitstring"
}

# Returns the location of the .git/ directory.
__posh_gitdir ()
{
    if [ -z "${1-}" ]; then
        if [ -n "${__posh_git_dir-}" ]; then
            echo "$__posh_git_dir"
        elif [ -n "${GIT_DIR-}" ]; then
            test -d "${GIT_DIR-}" || return 1
            echo "$GIT_DIR"
        elif [ -d .git ]; then
            echo .git
        else
            git rev-parse --git-dir 2>/dev/null
        fi
    elif [ -d "$1/.git" ]; then
        echo "$1/.git"
    else
        echo "$1"
    fi
}

precmd() {
    __posh_git_ps1 '%~ ' '$ '
}
