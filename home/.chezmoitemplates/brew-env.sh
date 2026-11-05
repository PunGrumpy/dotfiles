for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$candidate" ]; then
    eval "$("$candidate" shellenv)"
    break
  fi
done
