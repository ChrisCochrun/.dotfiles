#!/usr/bin/env fish

set -U fish_user_paths $fish_user_paths $HOME/.local/bin $HOME/scripts
set TERM "xterm-256color"
set EDITOR "emacsclient -t -a"
set VISUAL "emacsclient -c -a emacs"

### PROMPT ###
# name: scorphish

# This file is part of theme-scorphish

# Licensed under the MIT license:
# https://opensource.org/licenses/MIT
# Copyright (c) 2014, Pablo S. Blum de Aguiar <scorphus@gmail.com>


function fish_greeting -d "what's up, fish?"
    set_color $fish_color_autosuggestion[1]
    uname -npsr
    uptime
    set_color normal
end

function fish_title
    if [ "$theme_display_virtualenv" = 'no' -o -z "$VIRTUAL_ENV" ]
        printf '(%s) %s' $_ (prompt_pwd)
    else
        printf '(%s) %s' (basename "$VIRTUAL_ENV") (prompt_pwd)
    end
end

function _prompt_whoami -a sep_color -a color -d "Display user@host if on a SSH session"
    if set -q SSH_TTY
        echo -n -s $color (whoami)@(hostname) $sep_color '|'
    end
end

function _git_branch_name
    echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _git_ahead_count -a remote -a branch_name
    echo (command git log $remote/$branch_name..HEAD 2> /dev/null | \
    grep '^commit' | wc -l | tr -d ' ')
end

function _git_dirty_remotes -a remote_color -a ahead_color
    set current_branch (command git rev-parse --abbrev-ref HEAD 2> /dev/null)
    set current_ref (command git rev-parse HEAD 2> /dev/null)

    for remote in (git remote | grep 'origin\|upstream')

        set -l git_ahead_count (_git_ahead_count $remote $current_branch)

        set remote_branch "refs/remotes/$remote/$current_branch"
        set remote_ref (git for-each-ref --format='%(objectname)' $remote_branch)
        if test "$remote_ref" != ''
            if test "$remote_ref" != $current_ref
                if [ $git_ahead_count != 0 ]
                    echo -n "$remote_color!"
                    echo -n "$ahead_color+$git_ahead_count$normal"
                end
            end
        end
    end
end

function _prompt_git -a gray normal orange red yellow
    test "$theme_display_git" = no; and return
    set -l git_branch (_git_branch_name)
    test -z $git_branch; and return
    if test "$theme_display_git_dirty" = no
        echo -n -s $gray '‹' $yellow $git_branch $gray '› '
        return
    end
    set dirty_remotes (_git_dirty_remotes $red $orange)
    if [ (_is_git_dirty) ]
        echo -n -s $gray '‹' $yellow $git_branch $red '*' $dirty_remotes $gray '› '
    else
        echo -n -s $gray '‹' $yellow $git_branch $red $dirty_remotes $gray '› '
    end
end

function _prompt_pwd
    set_color -o cyan
    printf '%s' (prompt_pwd)
end

function _prompt_status_arrows -a exit_code
    if test $exit_code -ne 0
        set arrow_colors 600 900 c00 f00
    else
        set arrow_colors 060 090 0c0 0f0
    end

    for arrow_color in $arrow_colors
        set_color $arrow_color
        printf '»'
    end
end

function fish_prompt
    set -l exit_code $status

    set -l gray (set_color 666)
    set -l blue (set_color blue)
    set -l red (set_color red)
    set -l normal (set_color normal)
    set -l yellow (set_color yellow)
    set -l orange (set_color ff9900)
    set -l green (set_color green)

    printf $gray'['

    _prompt_whoami $gray $green

    if test "$theme_display_pwd_on_second_line" != yes
        _prompt_pwd
        printf '%s' $gray
    end

    printf '%s] ⚡️ %0.3fs' $gray (math $CMD_DURATION / 1000)

    if set -q SCORPHISH_GIT_INFO_ON_FIRST_LINE
        set theme_display_git_on_first_line
    end

    if set -q theme_display_git_on_first_line
        _prompt_git $gray $normal $orange $red $yellow
    end

    if test "$theme_display_pwd_on_second_line" = yes
        printf $gray'\n‹'
        _prompt_pwd
        printf $gray'›'
    end

    printf '\n'
    if not set -q theme_display_git_on_first_line
        _prompt_git $gray $normal $orange $red $yellow
    end
    _prompt_status_arrows $exit_code
    printf ' '

    set_color normal
end

function fish_right_prompt
    set -l exit_code $status
    if test $exit_code -ne 0
        set_color red
    else
        set_color green
    end
    printf '%d' $exit_code
    set_color -o 666
    echo '|'
    set_color -o 777
    printf '%s' (date +%H:%M:%S)
    set_color normal
end

### BANG BANG FUNCTIONS
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

### bindings
function fish_user_key_bindings
    fish_vi_key_bindings
    bind -M insert ! __history_previous_command
    bind -M insert '$' __history_previous_command_arguments
end


