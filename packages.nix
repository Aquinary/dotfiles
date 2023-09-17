{ config, lib, pkgs, modulesPath, ... }:

{
    environment = {
        systemPackages = with pkgs; [
        # Система
        material-icons                                        # иконки, которые используются в панеле задач           
        libsForQt5.qtstyleplugin-kvantum     
        feh                                                   # управление обоями рабочего стола
        neofetch                                              # вывод инфо о системе
        lua
        ntfs3g                                                # возможность просматривать накопители с NTFS
        lm_sensors                                            # чтение информации с датчиков системного блока
        qemu                                                  # виртуализация других систем
        OVMF                                                  # поддержка UEFI для qemu
        pciutils                                              # просмотр сведений о pci-устройствах
        smem                                                  # репорт о ram    
        appimage-run                                          # запуск appimage бинарников
        xdg-user-dirs                                         # пользовательские директории в директории пользователи
        dex                                                   # запуск других программ через консоль

        # Утилиты
        rofi                                                  # всплывающие менюшки и т.д.
        (pkgs.callPackage ./pkgs/caja-extensions { })         # файловый проводник с расширениями
        mate.engrampa                                         # архиватор, хорошо интегрированный в caja-проводник
        virt-manager                                          # gui-управление виртуальными машиными
        lxappearance                                          # настройки внешнего вида
        gparted                                               # редактор разделов и накопителей
        xfce.catfish                                          # поиск файлов в системе
        input-remapper                                        # переназначение кнопок на мышке и клавиатуре
        unzip                                                 # распаковщик zip 
        unrar                                                 # распакавщик rar
        sakura                                                # gui для терминала
        btop                                                  # tui taskmanager
        killall                                               # уничтожение всех процессов одной командой
        ncdu                                                  # анализ занимаемого объёма на накопителе
        ranger                                                # консольный файловый менеджер
        unstable.looking-glass-client

        # Медиа
        volctl
        pavucontrol
        pinta                                                 # программа для редактирования изображений
        haruna                                                # видеопроигрыватель
        openh264                                              # H.264 кодек
        gthumb                                                # менеджер изображений

        # Офис
        copyq                                                 # сохранение истории буффера обмена
        calc                                                  # консольный компилятор
        crow-translate                                        # переводчик выделенного текста
        flameshot                                             # скриншотер
        gnome.gucharmap

        # Разработка
        unstable.jetbrains.webstorm                           # для веб-разработки    
        unstable.jetbrains.datagrip                           # для просмотра внутренностей баз данных  
        git                                                   # система контроля версий
        unstable.nodejs                                       # nodejs
        insomnia                                              # get/post и т.д. на бекенд
        vscode                                                # среда редактирования кода
        docker-compose                                        

        # Интернет
        vivaldi                                               # основной браузер
        vivaldi-ffmpeg-codecs                                 # поддержка кодеков для браузера
        discord                                               # для голосового общения
        wget                                                  # консольный загрузчик
        qbittorrent                                           # торрент-клиент
        chromium                                              # резервный браузер
        tdesktop                                              # телеграм
        anydesk                                               # управление удалённым рабочим столом
        networkmanagerapplet                                  # gui управление соединениями и сетевыми устройствами     

        # Безопасность
        veracrypt                                             # работа с зашифрованными контейнерами
        bitwarden                                             # менеджер паролей
        gnome.seahorse                                        # gui управление ключами и сертификатами
        keeweb                                                # менеджер паролей
        ];
    };
}