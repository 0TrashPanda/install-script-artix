doas touch /etc/my-colors
doas chown admin: /etc/my-colors
cat /packages/install-script-artix/my-terminal-colors | tr -d '    ' > /etc/my-colors
setcolors /etc/my-colors

doas mkdir /etc/scripts
doas chown admin: /etc/scripts

echo "#!/bin/bash
setcolors /etc/my-colors
clear
" > /etc/scripts/set-colors.sh
doas chmod +x /etc/scripts/set-colors.sh

doas chown admin: /etc/rc.local
echo "/etc/scripts/set-colors.sh" >> /etc/rc.local

# change font
doas chown admin: /etc/fonts
curl -o /etc/fonts/zap-ext-vga16.psf https://www.zap.org.au/projects/console-fonts-zap/src/zap-ext-vga16.psf

setfont /etc/fonts/zap-ext-vga16.psf

doas chown admin: /etc/vconsole.conf
echo "FONT=/etc/fonts/zap-ext-vga16.psf" >> /etc/vconsole.conf