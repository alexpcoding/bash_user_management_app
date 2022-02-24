#!/bin/bash
PS3=$'\n'"Select an option: "
menu () {
    echo -e "1) List all users\n2) List user details\n3) Create user\n4) Option 4\n5) Quit"
}
options=("List all users" "List user details" "Create user" "Option 4" "Quit")
select opt in "${options[@]}"
do
        case $opt in
                "List all users")       cat /etc/passwd | cut -d ":" -f1
                        ;;
                "List user details")    echo  "";   read -p "Enter user name: " user;

if id $user &> /dev/null; then 
echo ""
echo "user name: " `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f1` | tr -s " "
echo "user id: "   `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f3` | tr -s " "
echo "group id: "  `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f4` | tr -s " "
echo "groups: "    `id $user | egrep -o "groups.+"` | tr -s " "
echo "home path: " `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f6` | tr -s " "
echo "shell: "     `cat /etc/passwd | egrep "^$user:x" | cut -d ":" -f7` | tr -s " "
echo -n "password set: " ; if [[ `passwd --status $user | cut -d " " -f2` == "P" ]]; then echo "yes";else echo "no"; fi | tr -s " "
else echo "user does not exist"
fi
                        ;;
                "Create user")
echo ""
read -p "user id: " user_id;                   if [ -n "$user_id" ]; then v1="useradd -u $user_id"; else v1="useradd";fi
read -p "group id: " group_id;                 if [ -n "$group_id" ]; then v2="$v1 -g $group_id" ; else v2=$v1;fi
read -p "home path: " home_path;               if [ -n "$home_path" ]; then v3="$v2 -m -d $home_path"; else v3=$v2;fi
read -p "comment: " comment;                    if [ -n "$comment" ]; then v4="$v3 -c $comment"; else v4=$v3;fi
read -p "secondary groups: " secondary_groups;  if [ -n "$scondary_groups" ]; then v5="$v4 -G $secondary_groups"; else v5=$v4;fi
read -p "shell: " shell;                        if [ -n "$shell" ]; then v6="$v5 -s $shell"; else v6=$v5;fi
read -p "user name: " user_name;                v="$v6 $user_name"

#useradd -u $user_id -g $group_id  -m -d $home_path -c $comment -G $secondary_groups -s $shell $user_name

echo $v



                        ;;
                "Option 4")      echo "You selected forth option"
                        ;;
                "Quit") echo "Bye!"
                        break
                        ;;
                *)      echo "Invalid option"
                        ;;
        esac
done
