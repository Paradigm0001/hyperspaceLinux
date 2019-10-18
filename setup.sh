#!/bin/sh

### FTL Hyperspace walkthough script, Written by Paradigm#0001 (Discord Tag), Paradigm0001 (Github profile)

## Define vars
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

## Check if required software is installed
checkInstalled "wine"
checkInstalled "steam"
checkInstalled "xclip"
checkInstalled "xdg-open" "xdg-utils"

## Enviroment check where we are
## If we dont have the dll file, exit
ls | grep -q "Hyperspace.dll" || error "Cannot find Hyperspace.dll, likely an incorrect working directory!"

## Link the Hyperspace desktop file to the users Desktop
printf "[Desktop Entry]\nType=Application\nVersion=1.0.1\nEncoding=UTF-8\nName=FTL Hyperspace\nComment=The FTL Hyperspace executable\nExec=/usr/bin/wine $PWD/FTLGame.exe\nIcon=$PWD/resources/ftl.png\nTerminal=false" > Hyperspace.desktop
ln -s "$PWD/Hyperspace.desktop" "$HOME/Desktop/" >/dev/null 2>&1

## Open the steam console with xdg-open and place the command string in the users clipboard
xdg-open steam://nav/console >/dev/null 2>&1 &
printf "download_depot 212680 212681 7584602879744021840" | xclip -selection clipboard
printf 'Steam loading...\n'
printf "Please enter the command \"download_depot 212680 212681 7584602879744021840\" into the steam console (No quotes)\nThe command should be copied into your clipboard already, if not then manually copy it.\n"

## Wait until user has entered the command, then continue when ready
while true; do
	read -p "Type \"Ready\" when the steam depot download completes: " RESPONCE
	[ "$RESPONCE" = "Ready" ] && break
done

## Copy the steam depo files to the current directory
echo "Please wait..."
cp -r $(find $HOME -name depot_212681 | grep -Fi 'steam')/* . || error "Cannot find FTL steam depot, ensure you ran the correct steam console command."
clear

## Startup the wine config and xdg-open the picture walkthough
printf "Please follow the instructions in the following pictures.\nOnce you have completed all the steps in a picture, close the image preview and the next step will appear.\n\n"
nohup winecfg >/dev/null 2>&1 &
for i in 1 2 3 4 5; do
	xdg-open ./resources/docs${i}.png
done

## Create the "RUN_GAME.sh" script
printf "#!/bin/sh\nwine ./FTLGame.exe" >> ./RUN_GAME.sh
chmod +x ./RUN_GAME.sh
clear

## Print exit message and exit
printf "Last step, Patch the windows FTL version with Slipstream Mod Manager using the provided Hyperspace.ftl mod in the current directory.\n"
printf "Once completed, you can execute the FTLGame.exe binary with wine, use the Hyperspace desktop file on your desktop or execute RUN_GAME.sh in the current directory.\n"
exit 0
