passwd_error_check() {
    if [ $? -ne 0 ]; then
        echo "Error: Passwords do not match."
        return true
    fi
}

# update the system
$ = false
while $
do
    sudo pacman neofetch
    passwd_error_check
done