setopt PROMPT_SUBST
GIT_PS1_DESCRIBE_STYLE=branch
GIT_PS1_SHOWUPSTREAM="auto git"
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWDIRTYSTATE=1

__show_jobs () {
	if [[ $#jobstates -gt 0 ]]
	then
		local -a jobnums
		jobnums=(${(k@)jobstates})
		local jobslist
		local thisjob
		for thisjob in "$jobnums[@]"
		do
			# We only care about jobs that are suspended.
			if [[ "$jobstates[$thisjob]" = suspended:* ]]
			then
				jobslist="$jobslist${jobtexts[$thisjob]%% *}:$thisjob "
			fi
		done
	fi
	if [[ $#jobslist -gt 0 ]]
	then
		# Strip off the last space character.
		echo "[${jobslist[1,-2]}]"
	fi
}

precmd () {
	if git rev-parse --git-dir > /dev/null 2>&1; then
		toplevel=$(git rev-parse --show-toplevel)
		psvar[1]=$(basename $toplevel)
		psvar[2]=${PWD#$toplevel}
	else
		psvar[1]=${${PWD/\/Users\//"~"}/caleb.thompson/calebhearth}
		psvar[2]=''
	fi
	__show_jobs
	__git_ps1 "%3 %1v" "%2v ❯ " "(%s)"
}
