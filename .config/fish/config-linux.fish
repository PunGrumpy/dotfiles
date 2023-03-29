if test -x /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

if test -x /home/linuxbrew/.linuxbrew/bin/deno
  export PATH="$HOME/.deno/bin:$PATH"
end

if test -x /home/.cargo/env
  source /home/.cargo/env
end

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

if test -n "$WSL_DISTRO_NAME"
  alias open="xdg-open"
  alias c: "cd /mnt/c"
  alias d: "cd /mnt/d"
end
