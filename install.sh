#!/bin/sh

case $1 in
  --xdg) ZDOTDIR=$HOME/.config/zsh && mkdir -p $HOME/.config/zsh ;; # install in ~/.config/zsh
  *) ZDOTDIR=$HOME ;; # install in home directory
esac

[ -f "$HOME/.zshenv" ] && { # backup if already exists
	mv $HOME/.zshenv $HOME/.zshenv.bak
}

# write to the file
cat > $HOME/.zshenv << EOF
export ZDOTDIR=$ZDOTDIR
EOF


[ -f "$ZDOTDIR/.zshrc" ] && { # backup if already exists
    mv $ZDOTDIR/.zshrc $ZDOTDIR/.zshrc.bak
}

cat > $ZDOTDIR/.zshrc << 'EOF'
: ${PLUGINDIR:=$ZDOTDIR/.zsh_plugins}

plug() {
	PLUGIN_NAME="${1#*/}"

	# create plugin directory if not exists
	[ ! -d "$PLUGINDIR" ] && mkdir -p $PLUGINDIR

	# fetch plugin if not exists
	[ ! -f "$PLUGINDIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" ] && git clone "https://github.com/$1" $ZDOTDIR/.zsh_plugins/$PLUGIN_NAME

	source "$PLUGINDIR/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
}

plug "zdharma-continuum/fast-syntax-highlighting"
plug "zsh-users/zsh-autosuggestions"

autoload -U colors && colors
export PS1="%{$fg[green]%}%n%{$fg[white]%}@%m %{$fg[green]%}%c%{$fg[white]%}> "
EOF
