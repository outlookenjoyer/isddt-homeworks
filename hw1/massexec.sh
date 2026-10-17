#!/bin/bash

dirpath=$(pwd)
mask="*"
number=$(nproc)
command=""

while [[ $# -gt 0 ]]
do
    case "$1" in
        --path)
            dirpath="$2"
            shift 2
            ;;
        --mask)
            mask="$2"
            shift 2
            ;;
        --number)
            number="$2"
            shift 2
            ;;
        *)
            command="$1"
            shift
            ;;
    esac
done

if [[ ! -d "$dirpath" ]]
then
    echo "Ошибка: каталог $dirpath не существует"
    exit 1
fi

if [[ -z "$mask" ]]
then
    echo "Ошибка: маска не может быть пустой"
    exit 1
fi

if [[ ! "$number" =~ ^[0-9]+$ || "$number" -eq 0 ]]
then
    echo "Ошибка: number должно быть целым числом больше нуля"
    exit 1
fi

if [[ -z "$command" ]]
then
    echo "Ошибка: не указана команда"
    exit 1
fi

if [[ "$command" != */* ]]
then
    command=$(which "$command")
fi

if [[ ! -f "$command" || ! -x "$command" ]]
then
    echo "Ошибка: команда не существует или нет права на выполнение"
    exit 1
fi

dirpath=$(cd "$dirpath" && pwd)

running=0

for file in "$dirpath"/$mask
do
    if [[ ! -f "$file" || -L "$file" ]]
    then
        continue
    fi

    if [[ $running -ge $number ]]
    then
        wait -n
        running=$((running - 1))
    fi

    echo "Запуск: $command $file"
    "$command" "$file" &
    running=$((running + 1))
done

wait

echo "Все файлы обработаны"
