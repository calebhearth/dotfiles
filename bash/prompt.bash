# Nabbed from relevance/etc
# Original author Muness Alrubaie (https://github.com/muness)
# https://github.com/relevance/etc/blob/master/bash/bash_vcs.sh
_bold=$(tput bold)
_normal=$(tput sgr0)

# http://gist.github.com/48207
function parse_git_deleted {
  [[ $(`which git` status 2> /dev/null | grep 'deleted:') != "" ]] && echo "−"
}
function parse_git_added {
  [[ $(`which git` status 2> /dev/null | grep "Untracked files:") != "" ]] && echo '+'
}
function parse_git_modified {
  [[ $(`which git` status 2> /dev/null | egrep '\tmodified:|\tnew file:') != "" ]] && echo "*"
}
function parse_git_both_modified {
  [[ $(`which git` status 2> /dev/null | grep 'both modified:') != "" ]] && echo "💥"
}
function git_state_indicators {
  echo "$(parse_git_added)$(parse_git_modified)$(parse_git_deleted)$(parse_git_both_modified)"
}

function git_divergence_indicator {
  git_status="$(`which git` status 2> /dev/null)"
  remote_pattern="# Your branch is (.*) '"
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead of" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi
  echo $remote
}

function git_branch_and_indicator {
  git_status="$(`which git` status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo "${branch}$_bold$(git_state_indicators)$(git_divergence_indicator)$_normal"
  fi
}

__prompt_command() {
  local vcs vcs_indicator base_dir sub_dir ref last_command
  sub_dir() {
    local sub_dir
    sub_dir=$(stat -f "${PWD}")
    sub_dir=${sub_dir#$1}
    echo ${sub_dir#/}
  }

  git_dir() {
    base_dir=$(`which git` rev-parse --show-cdup 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir=$(`which git` rev-parse --show-prefix)
    sub_dir="/${sub_dir%/}"
        ref=$(git_branch_and_indicator)
    vcs='git'
    vcs_indicator=''
  }

  svn_dir() {
    [ -d ".svn" ] || return 1
    base_dir="."
    while [ -d "$base_dir/../.svn" ]; do base_dir="$base_dir/.."; done
    base_dir=`cd $base_dir; pwd`
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=`svnversion`
    vcs="svn"
    vcs_indicator="(svn)"
  }

  bzr_dir() {
    base_dir=$(bzr root 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=$(bzr revno 2>/dev/null)
    vcs="bzr"
    vcs_indicator="(bzr)"
  }

  git_dir || svn_dir || bzr_dir

  if [ -n "$vcs" ]; then
    alias st="$vcs status"
    alias d="$vcs diff"
    alias up="pull"
    alias cdb="cd $base_dir"
    base_dir="$(basename "${base_dir}")"
        project="$base_dir:"
    __vcs_label="$vcs_indicator"
    __vcs_details="[$ref]"
    __vcs_sub_dir="${sub_dir}"
    __vcs_base_dir="${base_dir}"
  else
    __vcs_label=''
    __vcs_details=''
    __vcs_sub_dir=''
    __vcs_base_dir="${PWD}"
  fi

  last_command=$(history 5 | awk '{print $2}' | grep -v "^exit$" | tail -n 1)
  __tab_title="$project[$last_command]"
  __pretty_pwd="${PWD/$HOME/~}"
  hostname=`hostname -s`
}

PROMPT_COMMAND=__prompt_command
PS1='${__vcs_label}\[$_bold\]${__vcs_base_dir}\[$_normal\]${__vcs_details}\[$_bold\]${__vcs_sub_dir}\[$_normal\]\n↪ '
