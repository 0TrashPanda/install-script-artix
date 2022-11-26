# zsh for human installation
if command -v curl >/dev/null 2>&1; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

cat /packages/install-script-artix/assets/zsh/.zshrc >> ~/.zshrc

sed -i '/z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H/d' ~/.zshrc
sed -i "s/command tmux -u new -A -D -t z4h/command tmux -2 -u new -A -D -t z4h/" ~/.zshrc
