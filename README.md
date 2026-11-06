# dotfiles

My macOS, Linux, and Windows setup. [chezmoi](https://www.chezmoi.io/) manages it, and `home/` is the source of the home directory.

![Neovim and fish in Rex on macOS](images/rex.png)

## Install

These settings are mine. Read a file before you apply it.

On macOS, Linux, and WSL, run the command below. On macOS, run `xcode-select --install` first to get git.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply PunGrumpy
```

On Windows, chezmoi runs PowerShell scripts, so allow them first.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "&{$(irm 'https://get.chezmoi.io/ps1')} -- init --apply PunGrumpy"
```

`chezmoi apply` installs the packages in `home/Brewfile`, `home/apt-packages.txt`, `home/winget.json`, and `home/scoop-packages.txt`. It runs a package script again only when its list changes.

On a new Mac, finish with the steps in [macOS](macos/README.md). [Windows](windows/README.md) lists what the Windows setup covers.

## Terminal

I use [Rex](https://www.superlogical.com/rex). Rex runs only on macOS today, so Linux and Windows use another terminal until Rex supports them.

| System | Terminal | Shell |
| --- | --- | --- |
| macOS | Rex | fish |
| Linux | [Ghostty](https://ghostty.org/) | fish in tmux |
| Windows | [Windows Terminal](https://github.com/microsoft/terminal) | PowerShell, or fish in tmux on WSL |

Rex and Windows Terminal use GeistMono Nerd Font. Rex, tmux, Neovim, and the WSL profile in Windows Terminal use the Vercel colors. This repository has no Ghostty config yet.

## What you get

| Tool | Setup |
| --- | --- |
| Neovim | A flat config on the built-in `vim.pack`, with no plugin manager or distribution. See [Neovim](#neovim). |
| fish | The [Tide](https://github.com/IlanCosman/tide) prompt. [Fisher](https://github.com/jorgebucaran/fisher) installs fzf.fish, puffer-fish, and pisces. |
| tmux | Linux and WSL only. On macOS, Rex splits the panes. |
| PowerShell | The [Starship](https://starship.rs/) prompt, PSFzf, and eza. Windows only. |
| Git | [delta](https://github.com/dandavison/delta) as the pager, [lazygit](https://github.com/jesseduffield/lazygit), and [cz-git](https://github.com/Zhengqbbb/cz-git) for commit messages. |
| gwq | Creates worktrees in `~/.t3/worktrees/<repo>/<branch>`, where T3 Code keeps its worktrees. |
| mise | Go, Python, and Rust. [Vite+](https://viteplus.dev/) manages Node.js, Bun, and pnpm. |
| Agent skills | `chezmoi apply` installs my global skills with `bunx skills add`. |

## Neovim

The config needs Neovim 0.12 or later. The first start asks to confirm the plugin installs. [Mason](https://github.com/mason-org/mason.nvim) then installs the language servers and the formatters.

I tuned the config to review agent output.

| Key | Action |
| --- | --- |
| `;g` | Open lazygit in a float. |
| `<leader>dv` | Open [codediff](https://github.com/esmuellert/codediff.nvim). |
| `<leader>gd` | Toggle the [mini.diff](https://github.com/nvim-mini/mini.diff) overlay. |
| `<leader>yf`, `<leader>yp` | Copy the relative or the absolute path with a line reference, such as `src/app.ts#L42`, to paste into an agent prompt. |

Put machine-local plugins in `~/.config/nvim/lua/pungrumpy/plugins/local.lua`. chezmoi ignores that file.

## Keep a change that an app made

An app can change a deployed file. Run `chezmoi status` to see the difference. Then run `chezmoi re-add` to keep the change, or `chezmoi apply` to discard it.

`chezmoi re-add` skips templates. Copy a change to `~/.gitconfig` into `home/dot_gitconfig.tmpl` by hand.

## Credits

The Neovim structure and keymaps are based on [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles). Other ideas come from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) and [paulirish/dotfiles](https://github.com/paulirish/dotfiles).
