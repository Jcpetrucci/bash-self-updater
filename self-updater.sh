#/bin/bash
# Create: 2014-05-14 John C. Petrucci( http://johncpetrucci.com )
# Modify: 2014-05-15 John C. Petrucci
# Purpose: Function to retrieve latest version of a script and replace self if user wants.
# Usage: Update the variable masterURL with a path that the script will be retrieved from.  Script will compare its own "Modify" comment line with the master.
# ... For a PoC download this script and append a character to the "Modify:" line.  For value added change the final echo to say 'This is the body BEFORE UPDATING'.
#

masterURL='http://johncpetrucci.com/archive/self-updater.sh'
latestFile=$(curl "$masterURL" 2>/dev/null) || { printf '%s\n' 'Unable to check for updates.'; curlFailed=1; }
thisMod=$(grep -m1 '# Modify: ' $0)
latestMod=$(grep -m1 '# Modify: ' <<<"$latestFile")

doUpdate() {
	newTmp=$(mktemp)
	chmod +x "$newTmp"
	cat <<<"$latestFile" > "$newTmp"
	( "$newTmp"; mv "$newTmp" "$0" )
	exit
}

offerUpdate() {
        while IFS= read -n1 -r -p 'An update for this script is available.  Use latest version? [y/n]: '; do
                case $REPLY in
                        [Yy] )  printf '\n%s\n' 'Updating now.'; doUpdate; break;;
                        [Nn] )  printf '\n%s\n' 'Update was refused.'; break;;
                        * )     printf '\r';
                esac
        done
}

[[ "$thisMod" != "$latestMod" && ! -n "$curlFailed" ]] && offerUpdate

echo "This is the body of the program."