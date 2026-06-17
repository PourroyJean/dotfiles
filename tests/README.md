# Tests

Verification infrastructure for the dotfiles install.

## Run locally

```bash
./install.sh                  # install (current state of master)
./tests/verify_install.sh     # verify, exits non-zero on any failed check
```

Some checks **will** fail on `master` until the blocker issues (#2-#8) land. See [Expected failures](#expected-failures-master--green-progression) below.

## Run in a clean container

Requires Docker (or Podman with `alias docker=podman`):

```bash
docker build -f tests/Dockerfile.test -t df-test .
```

The build runs `install.sh` and `verify_install.sh` inside a Rocky Linux 8 container as a non-root user. Build succeeds only when all verify stages pass.

## Expected failures (master → green progression)

| Stage | Check | Tracked by |
|---|---|---|
| 1 | `~/.zshrc` exists + sources `my_zshrc.sh` | (passes on master today) |
| 2 | oh-my-zsh installed at `$DF_ROOT_PATH/OhMyZsh` | #2 |
| 3 | zsh boots clean (no `command not found`, no insecure-dir warning, no `no such file`) | #2, #6, #7 |
| 4 | `~/.zshenv` exists with `shopt` no-op | #6 |
| 5 | SLURM defaults empty (not LUMI hardcoded) | #4 |
| 6 | `cat` alias only set when `bat` present | #8 |

When all blockers land, CI goes green and `continue-on-error: true` can be removed from `.github/workflows/test.yml`.

## For AI agents

Contract:

| Aspect | Contract |
|---|---|
| Exit code | `0` = all checks pass, `N>0` = N checks failed |
| Stdout | Human-readable list with `✓` / `✗` per check, summary at end |
| Side effects | None — read-only checks against `$HOME` and `$DF_ROOT_PATH` |
| Env vars | `DF_ROOT_PATH` (optional, defaults to `$HOME/dotfiles`) |
| Requirements | bash 4+, zsh in `$PATH`, `mktemp` |

### Adding a new check

Each check is one line via the `check` helper:

```bash
check "human description" bash-command-or-test-expression
```

Example:

```bash
check "fzf binary in PATH" command -v fzf
check "no LUMI vars in .zshrc" bash -c "! grep -q 'lumi' $HOME/.zshrc"
```

Group related checks under a `section "Stage N: description"`. New stages should map to a blocker issue when applicable.
