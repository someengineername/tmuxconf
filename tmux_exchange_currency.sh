#!/usr/bin/env bash
set -euo pipefail

input_flag=$1

function create_file {
	touch ~/tmuxconf/.currency
	usd=$(curl -s https://www.cbr.ru/currency_base/daily/ | grep '<td>Доллар США</td>' -A 1 | tail -n 1 | awk '{print$1}' | sed 's/.\{6\}$//' | sed 's/^.\{4\}//')
	eur=$(curl -s https://www.cbr.ru/currency_base/daily/ | grep '<td>Евро</td>' -A 1 | tail -n 1 | awk '{print$1}' | sed 's/.\{6\}$//' | sed 's/^.\{4\}//')
	echo "usd $(date +"%d-%m-%y") $usd" >> ~/tmuxconf/.currency
	echo "eur $(date +"%d-%m-%y") $eur" >> ~/tmuxconf/.currency
}

function read_data {

	# if date in current ".currency" file (or data/date) is broken - just remake file
	# if OK - display currency value

	if [[ "$(date +"%d-%m-%y")" = "$(cat ~/tmuxconf/.currency | grep "usd" | awk '{print$2}')" ]]; then
		display_currency
	else
		rm ~/tmuxconf/.currency
		create_file
	fi
}

function display_currency {

	if [[ $input_flag == "usd" ]]; then
                temp_var1="$(cat ~/tmuxconf/.currency | grep "usd" | awk '{print$3}')"
		temp_var2="\$ $(echo $temp_var1 | cut -d ',' -f 1),$(echo $temp_var1 | cut -d ',' -f 2 | cut -c -2)"
		echo "$temp_var2"
        elif [[ $input_flag == "eur" ]]; then
                temp_var1="$(cat ~/tmuxconf/.currency | grep "eur" | awk '{print$3}')"
		temp_var2="€ $(echo $temp_var1 | cut -d ',' -f 1),$(echo $temp_var1 | cut -d ',' -f 2 | cut -c -2)"
		echo "$temp_var2"
        else
                echo "incorrect input flag"
        fi

}

function main {

	if [[ -e ~/tmuxconf/.currency ]];then
        	read_data
	else
        	create_file
	fi
}

# run script
main

####\$ $(echo $var1 | cut -d ',' -f 1),$(echo $var1 | cut -d ',' -f 2 | cut -c -2)
