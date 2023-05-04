# RaspiOS ARM64 on QEMU for Apple M1

Это руководство и скрипты для развертывания и запуска RaspiOS Bullseye ARM64 на виртуальной машине QEMU на компьютере Apple M1.

## Установка Homebrew

1. Откройте терминал и вставьте следующую команду для установки Homebrew:

```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Добавьте Homebrew в вашу переменную PATH:

```sh
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

```

## Установка QEMU

```sh
brew install qemu
```

## Загрузка и запуск RaspiOS

1. Скачайте образ RaspiOS Bullseye arm64 с официального сайта:

```sh
git clone https://github.com/Romaxa55/raspios-arm64-on-qemu.git
```

2. Запустите скрипт:
```sh
./start-raspios-bullseye-arm64.sh
```