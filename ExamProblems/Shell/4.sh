#a)
find . -type f -size 0 | xargs rm 

#b)
find "$(cat /etc/passwd | grep $(whoami) | cut -d ":" -f6)" -type f -printf "%p %s \n" | sort -rn -k2 | head -n 5 | awk '{print $1}' | xargs rm

