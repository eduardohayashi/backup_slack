#!/bin/bash
#
# Requirements: slack-cli
# pip install slack-cli 
#
# Author: Eduardo Hayashi Magagnin
# Version: 0.1

channels=`cat slack_channels.txt | grep -v '#'`
users=`cat slack_users.txt | grep -v '#'`


while read channel; do

	[[ -z $channels ]] && continue

	messages=`slack-cli -s "$channel" -l 100`
	
	[[ -z $messages ]] && continue

	touch channels/"$channel".txt
	echo "Channel - $channel"
	while read line; do
		[[ `grep -F "${line}" channels/"$channel".txt` ]] \
			|| echo $line | tee -a channels/"$channel".txt; 

	done <<< $messages

done <<< "${channels[@]}"


while read user; do

	[[ -z $users ]] && continue

	messages=`slack-cli -s "$user" -l 100`
	
	[[ -z $messages ]] && continue

	touch users/"$user".txt
	echo "User - $user"
	while read line; do
		[[ `grep -F "${line}" users/"$user".txt` ]] \
			|| echo $line | tee -a users/"$user".txt; 

	done <<< $messages

done <<< "${users[@]}"
