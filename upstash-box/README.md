# Upstash Box

An [Upstash Box](https://upstash.com/docs/box) runs [T3 Code](https://t3.codes) and these dotfiles. Only `/workspace` survives a rebuild, so the box sets itself up again on every start.

## Create a box

1. In the Upstash Console, create a box and connect GitHub.
2. In **Settings → Init Command**, paste:

   ```sh
   d=/workspace/home/dotfiles; git -C $d pull -q --ff-only 2>/dev/null || git clone -q https://github.com/PunGrumpy/dotfiles $d; sh $d/upstash-box/start.sh
   ```

3. Start the box. T3 Code comes up in a few seconds. The dotfiles take longer, because Homebrew builds part of the Brewfile on arm64 Linux.

The box name becomes the T3 Code environment name.

## What runs on start

[`start.sh`](start.sh) runs first and returns quickly:

- It writes the box name to `/etc/machine-info`, where T3 Code reads it.
- It starts `t3 serve` on port 3773, and installs `t3` if the box lacks it.
- It links `~/.config/gh` to `/workspace` once your own gh login is saved there.

[`setup.sh`](setup.sh) then runs in the background:

- It installs the libraries and fonts that T3's browser needs.
- It runs `chezmoi init --apply` from the clone in `/workspace/home/dotfiles`.

Both log to `/workspace/home/.box-logs`.

## Log in to GitHub as yourself

Upstash's GitHub connection logs gh in with an app token. To use your own account, and keep the login after a rebuild:

```sh
GH_CONFIG_DIR=/workspace/home/.config/gh gh auth login --web --git-protocol https
```

The next start links `~/.config/gh` to it.

## Limits

- Chrome cannot use its own sandbox in the box: there is no AppArmor, and seccomp blocks user namespaces. T3 runs Chrome with `--no-sandbox`, so the container is the only isolation.
- Commits from the box are unsigned. The signing key lives in 1Password.
- The box cannot change its hostname, so the shell prompt shows the container id.
