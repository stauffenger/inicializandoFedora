# inicializandoFedora
um shell script que já configura tudo que preciso no fedora.

Após a execução do script executar o comando abaixo, selecionar português(Brasil) e clicar em 'ok'.
```shell
$ system-config-language
```

## Configurando vscode
```shell
$ code --install-extension teabyii.ayu 

$ echo '{ "workbench.iconTheme": "ayu", "workbench.colorTheme": "Ayu Mirage", "editor.fontFamily": "Fira Code Retina","editor.formatOnType": true,"editor.fontLigatures": true,"explorer.confirmDelete": false}' >> /home/$USER/.config/Code/User/settings.json
```
## Configurando Subllime Text
> Instale primeiramente o Package Control e o tema Ayu pelo Package Control

```shell
$ echo '{
	"color_scheme": "Packages/ayu/ayu-mirage.sublime-color-scheme",
	"ignored_packages":
	[
		"Vintage"
	],
	"theme": "ayu-mirage.sublime-theme",
	"font_face": "Fira Code Retina",
	"terminal":"gnome-terminal",
	"env": {"LD_PRELOAD": null}
}' >> /home/$USER/.config/sublime-text-3/Packages/User/Preferences.sublime-settings
```