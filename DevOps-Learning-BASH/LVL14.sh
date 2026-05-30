#!/bin/bash

# **Mission**: Create an interactive script that presents a menu with options for different system tasks (e.g., check disk space, show system uptime, list users), and executes the chosen task.

show_menu() {
echo "1) Check disk space"
echo "2) Show system uptime"
echo "3) List logged in users"
echo "q) Quit"
}

task_disk() { df -h; }
task_uptime() { uptime; }
task_users() { who; }

while true; do
	show_menu
	read -rp "Choose: " choice 
	case "$choice" in
		1) task_disk ;;
		2) task_uptime ;;
		3) task_users ;;
		q|Q) exit 0 ;;
		*) echo "Invalid choice" ;;
	esac
	echo
	read -n1 -r -p "Press any key to return to menu..."
done
