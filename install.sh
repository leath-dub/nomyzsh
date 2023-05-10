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
plug() {
	PLUGIN_NAME="${1#*/}"

	# create plugin directory if not exists
	[ ! -d "$ZDOTDIR/.zsh_plugins" ] && mkdir -p $ZDOTDIR/.zsh_plugins

	# fetch plugin if not exists
	[ ! -f "$ZDOTDIR/.zsh_plugins/$PLUGIN_NAME/$2" ] && git clone "https://github.com/$1" $ZDOTDIR/.zsh_plugins/$PLUGIN_NAME

	source "$ZDOTDIR/.zsh_plugins/$PLUGIN_NAME/$2"
}

plug "zdharma-continuum/fast-syntax-highlighting" "fast-syntax-highlighting.plugin.zsh"
plug "zsh-users/zsh-autosuggestions" "zsh-autosuggestions.plugin.zsh"

autoload -U colors && colors
export PS1="%{$fg[green]%}%n%{$fg[white]%}@%m %{$fg[green]%}%c%{$fg[white]%}> "
EOF
