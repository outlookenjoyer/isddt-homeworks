#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

step=1
hit=0
miss=0
numbers=()

while true; do
  my_number=${RANDOM: -1}

  echo "Step: $step"

  while true; do
    read -p "Please enter number from 0 to 9 (q - quit): " input

    case "$input" in
    [0-9])
      break
      ;;
    q)
      echo "Bye"
      exit 0
      ;;
    *)
      echo "Error! You need to enter one digit from 0 to 9"
      ;;
    esac
  done

  if [[ "$input" == "$my_number" ]]; then
    echo "Hit! My number: $my_number"
    hit=$((hit + 1))
    numbers+=("${GREEN}${my_number}${RESET}")
  else
    echo "Miss! My number: $my_number"
    miss=$((miss + 1))
    numbers+=("${RED}${my_number}${RESET}")
  fi

  total=$((hit + miss))
  hit_percent=$((hit * 100 / total))
  miss_percent=$((100 - hit_percent))

  echo "Hit: ${hit_percent}% Miss: ${miss_percent}%"
  start=$((${#numbers[@]} - 10))
  if [[ $start -lt 0 ]]; then
    start=0
  fi
  echo -e "Numbers: ${numbers[@]:$start}"
  echo ""

  step=$((step + 1))
done
