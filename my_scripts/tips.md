#Some tips to work better as a programmer.

#1- Colour your bash terminal and show git branches where you are.
	source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
	export PS1='\[\033[36m\]\u \[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \[\033[00m\]\$'
