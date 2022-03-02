#!/bin/bash
echo ""
PS3=$'\n'"Select an option: "
echo "(Press enter for menu)"
menu () {
    echo -e "\n1) List all users\n2) List user details\n3) Create user\n4) Delete user\n5) Change/lock password\n6) Quit"
}
inside_menu() {
    echo -e "\n1) Set/change password\n2) Lock/unlock password\n3) Back to main menu\n4) Quit"
}
options=("List all users" "List user details" "Create user" "Delete user" "Change/lock password" "Quit")

select opt in "${options[@]}"
do
    case $opt in # starting 1st menu
        "List all users") echo ""; cat /etc/passwd | cut -d ":" -f1; menu
                        ;;
        "List user details") echo  ""
while :
do
    read -p "Enter user name (press CTRL+D for prev menu): " user
    if [ $? -eq 1 ]; then echo ""; menu; break; else
    if id $user &> /dev/null; then
    echo ""
    echo "user name: " `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f1` | tr -s " "
    echo "user id: "   `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f3` | tr -s " "
    echo "group id: "  `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f4` | tr -s " "
    echo "groups: "    `id $user | awk -F 'groups=' '{print $2}'`| tr -s " "
    echo "home path: " `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f6` | tr -s " "
    echo "shell: "     `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f7` | tr -s " "
    echo -n "password set: " ; if [[ `passwd --status $user | cut -d " " -f2` == "P" ]]; then echo "yes"; else echo "no"; fi | tr -s " "
    echo ""
    else echo "user does not exist"
    fi
    fi
done
                        ;;
        "Create user")
echo ""
echo "(press enter for default)"
while :
do
    read -p "user id (press CTRL+D for prev menu): " user_id;
    if [ $? -eq 1 ]; then echo ""; menu; break; else if [ -n "$user_id" ]; then v1="useradd -u $user_id"; else v1="useradd"; fi
    read -p "group id: " group_id;                 if [ -n "$group_id" ]; then v2="$v1 -g $group_id" ; else v2=$v1; fi
    read -p "home path: " home_path;               if [ -n "$home_path" ]; then v3="$v2 -m -d $home_path"; else v3=$v2; fi
    read -p "comment: " comment;                   if [ -n "$comment" ]; then v4="$v3 -c $comment"; else v4=$v3;fi
    read -p "secondary groups: " secondary_groups; if [ -n "$secondary_groups" ]; then v5="$v4 -G $secondary_groups"; else v5=$v4; fi
    read -p "shell: " shell;                       if [ -n "$shell" ]; then v6="$v5 -s $shell"; else v6=$v5;fi
    read -p "user name: " user_name;               v="$v6 $user_name"
    eval $v # executing create user command
    if [ $? -eq 0 ]; then echo -e "\nUser was created. "; else echo -e "\nUser was not created. "; fi
    fi
done
                        ;;
        "Delete user")
echo ""
while :
do
    read -p "user name: (press CTRL+D for prev menu) " user_to_remove
    if [ $? -eq 1 ]; then echo ""; menu; break; else
    userdel -r $user_to_remove
    if [ $? -eq 0 ]; then echo -e "\nUser was deleted. "; else echo -e "\nUser was not deleted. "; fi
    fi
done
                        ;;
	"Change/lock password")
echo ""
PS3=$'\n'"Select an option: "
options1=("Set/change password" "Lock/unlock password" "Back to main menu" "Quit")

select opt1 in "${options1[@]}"
do
    case $opt1 in # starting 2nd menu
	"Set/change password")
echo ""
while :
do
    read -p "user name(press CTRL+D for prev menu): " user_passwd
    if [ $? -eq 1 ]; then echo ""; inside_menu; break; else
    passwd $user_passwd; if [ $? -eq 0 ]; then echo "Password set."; echo ""; else echo "Password not set."; echo ""; fi
    fi
done
		        ;;
	"Lock/unlock password")
echo ""
while :
do
    read -p "user name (press CTRL+d for prev menu): " user_lock;
    if [ $? -eq 1 ]; then echo ""; inside_menu; break
    else if  id $user_lock &> /dev/null; then
    if [[ `passwd --status $user_lock | cut -d " " -f2` == "P" ]]; then echo -n  "Password for user $user_lock is unlocked. Lock password ?" ; read -p " y/n " answer1
    if [ $answer1 == "y" ]; then passwd -l $user_lock; echo -e "Password locked.\n";else echo ""; fi
    else
    echo -n "Password for user $user_lock is locked. Unlock password ?" ; read -p " y/n " answer2
    if [ $answer2 == "y" ]; then passwd -u $user_lock;echo -e "Password unlocked.\n"; else echo ""; fi
    fi
    else echo -e "User doesn't exist.\n"; continue; fi
    fi
done
		        ;;
	"Back to main menu") menu; break
			;;
	"Quit") echo "Bye!" ; break 2
			;;
		*) echo "Invalid option"
			;;
    esac # ending 2nd menu
done
			;;
        "Quit") echo "Bye!"; break
                        ;;
        *) echo "Invalid option"
                        ;;
    esac # ending 1st menu
done
