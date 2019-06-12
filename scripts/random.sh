#!/bin/bash
#
#random.helper "1000"		<---- will return a random between 1 and 1000
#random.helper "file.txt"	<---- will return a random based on the number of lines from the given file
#random.helper				<---- without passing parameter, means to return a random file name for any usage
random.helper() {
	local var reg amount random_number
	var=$1
	reg='^[0-9]+$'

	if [[ ! $var =~ $re ]] || [[ -f $var ]]; then
    	amount=$(cat ${var} | wc -l)
		random_number=$(shuf -i 1-${amount} -n 1)
	elif [[ $var =~ $re ]] && [[ ! -z $var ]]; then
		random_number=$(shuf -i 1-${var} -n 1)
	fi
	if [[ -z $var ]]; then
		random_number=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 16 | head -n 1)
	fi
	
	echo "${random_number}"
}