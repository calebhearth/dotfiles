unset GEM_HOME_AUTO

if [ -z "$GEM_HOME_FILENAME" ]; then
  export GEM_HOME_FILENAME=".ruby-gemset"
fi

function gem_home_auto() {
	local dir="$PWD/" gem_dir

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -re gem_dir <"$dir/$GEM_HOME_FILENAME"; } 2>/dev/null || [[ -n "$gem_dir" ]]; then
			case "$gem_dir" in
				"$GEM_HOME_AUTO")
					return
					;;
				".")
					gem_dir=$dir
					;&
				*)
					GEM_HOME_AUTO="$gem_dir"
					gem_home "$gem_dir" > /dev/null
					return $?
					;;
			esac
		fi
	done

	if [[ -n "$GEM_HOME_AUTO" ]]; then
		gem_home - > /dev/null
		unset GEM_HOME_AUTO
	fi
}

# if [[ ! "$preexec_functions" == *gem_home_auto* ]]; then
#		preexec_functions+=("gem_home_auto")
# fi
