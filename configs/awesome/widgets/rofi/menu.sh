
# Без этого lua файлы не найдёт
cd  ~/.config/awesome/widgets/rofi/

theme="style"
dir="$HOME/.config/awesome/widgets/rofi/theme/menu"
appDir="/run/current-system/sw/share/applications"

echo $dir
echo $appDir
# Получаем название пункат меню, которое выбрали
SELECT=$(lua menu.lua --parse | rofi -dmenu -fuzzy -i -show-icons -kb-accept-alt "" -kb-custom-1 "Shift+Return" -no-lazy-grab -hover-select -me-select-entry '' -me-accept-entry 'MousePrimary' -theme $dir/"$theme")
STATUS=$?


# На основе переданного имени получаем команду выполнения
EXEC=$(lua menu.lua --exec "${SELECT}")

if [ "${STATUS}" = 0 ]
then
	# Запуск без рута
	lua menu.lua --history-update "${EXEC}"
	echo "${EXEC}"
	dex "${appDir}/${EXEC}"
elif [ "${STATUS}" = 10 ]
then
	# Запуск под рутом
	pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY dex "${appDir}/${EXEC}"
fi
