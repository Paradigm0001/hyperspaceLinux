#!/bin/sh
error() {
	printf "$1\nSetup will now abort.\n"
	exit 1
}
checkInstalled() {
	if [ "$#" -gt "1" ]; then
		BINARY="$2"
	else
		BINARY="$1"
	fi
	[ -n "$(whereis $1 | cut -d: -f2)" ] || error "Cannot find $BINARY, Its likely not installed."
}
checkInstalled "wine"
checkInstalled "steam"
checkInstalled "xclip"
checkInstalled "xdg-open" "xdg-utils"
ls | grep -q "Hyperspace.desktop" || error "Cannot find Hyperspace.desktop, likely an incorrect working directory!"
ln -s "$PWD/Hyperspace.desktop" "$HOME/Desktop/" >/dev/null 2>&1
xdg-open steam://nav/console >/dev/null 2>&1 &
printf "download_depot 212680 212681 7584602879744021840" | xclip -selection clipboard
printf 'Steam loading...\n'
printf "Please enter the command \"download_depot 212680 212681 7584602879744021840\" into the steam console (No quotes)\nThe command should be copied into your clipboard already, if not then manually copy it.\n"
while true; do
	read -p "Type \"Ready\" when the steam depot download completes: " RESPONCE
	[ "$RESPONCE" = "Ready" ] && break
done
echo "Please wait..."
cp -r $(find $HOME -name depot_212681 | grep -Fi 'steam')/* . || error "Cannot find FTL steam depot, ensure you ran the correct steam console command."
clear
printf "Please follow the instructions in the following pictures.\nOnce you have completed all the steps in a picture, close the image preview and the next step will appear.\n\n"
nohup winecfg >/dev/null 2>&1 &
for i in 1 2 3 4 5; do
	xdg-open ./docs/${i}.png
done
printf "#!/bin/sh\nwine ./FTLGame.exe" >> ./RUN_GAME.sh
chmod +x ./RUN_GAME.sh
clear
printf "Last step, Patch the windows FTL version with Slipstream Mod Manager using the provided Hyperspace.ftl mod in the current directory.\n"
printf "Once completed, you can execute the FTLGame.exe binary with wine, use the Hyperspace desktop file on your desktop or execute RUN_GAME.sh in the current directory.\n"
