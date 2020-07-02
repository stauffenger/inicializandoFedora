#!/usr/bin/env bash

#As variveis yourTheme, yourGitRepoPriv, yourIRC devem estar dentro de aspas duplas pois as aspas simples precisam entrar na confguração do arquivo

iAm=$USER

yourTheme="'powerline'";

yourGitRepoPriv="'git@git.domain.com'";

yourIRC="'irssi'";

bashrc='#!/usr/bin/env bash

# If not running interactively, dont do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="/home/'$USER'/.bash-it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='$yourTheme'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='$yourGitRepoPriv'

# Dont check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='$yourIRC'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

source "$BASH_IT"/bash_it.sh
';

#por ser um processo mais rapido a instalação do bash vem antes da instalação dos pacotes
echo 'Instalando Tema no bash';
git clone https://github.com/Bash-it/bash-it.git /home/$iAm/.bash-it/;
chmod +x /home/$iAm/.bash-it/install.sh;
echo 'y' | sh /home/$iAm/.bash-it/install.sh;
echo $bashrc >> /home/$iAm/.bashrc ;
sudo cp /home/$iAm/.bashrc /root/.bashrc ;

sudo ./installer.sh;

echo 'Configurando VS Code';
code --install-extension teabyii.ayu ;
code --install-extension dbaeumer.vscode-eslint ;
code --install-extension esbenp.prettier-vscode ;
code --install-extension ms-python.python;
code --install-extension vscode-icons-team.vscode-icons;
code --install-extension naumovs.color-highlight;

echo '{ 
	"workbench.iconTheme": "vscode-icons",
	 "workbench.colorTheme": "Ayu Mirage",
	  "editor.fontFamily": "Fira Code Retina",
	  "editor.formatOnType": true,
	  "explorer.compactFolders": false,
	  "editor.fontLigatures": true,
	  "explorer.confirmDelete": false,
	  "editor.formatOnSave": true,
	  "prettier.eslintIntegration": true,
	  "prettier.singleQuote": true,
	  "[javascript]": {"editor.defaultFormatter": "esbenp.prettier-vscode"},
	  }' > /home/$iAm/.config/Code/User/settings.json;