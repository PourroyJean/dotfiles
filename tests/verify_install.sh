#!/usr/bin/env bash
# tests/verify_install.sh
#
# Staged verification of dotfiles install.
# Some stages WILL fail on master until corresponding blocker issues land.
# See tests/README.md for the expected-failure matrix.
#
# Exit code = number of failed checks (0 = all pass).

set -uo pipefail

DF_ROOT_PATH="${DF_ROOT_PATH:-$HOME/dotfiles}"
PASS=0
FAIL=0
declare -a FAILED_CHECKS

check() {
    local name="$1"; shift
    if "$@" >/dev/null 2>&1; then
        echo "  ✓ $name"
        PASS=$((PASS+1))
    else
        echo "  ✗ $name"
        FAIL=$((FAIL+1))
        FAILED_CHECKS+=("$name")
    fi
}

section() { echo; echo "=== $1 ==="; }

# Capture zsh startup output once for reuse
ZSH_LOG="$(mktemp)"
trap 'rm -f "$ZSH_LOG"' EXIT
zsh -ic 'true' >"$ZSH_LOG" 2>&1 || true

section "Stage 1: install.sh artifacts (should pass on master)"
check "~/.zshrc exists"                          test -f "$HOME/.zshrc"
check "DF_ROOT_PATH set in .zshrc"               grep -q "DF_ROOT_PATH" "$HOME/.zshrc"
check "my_zshrc.sh sourced from .zshrc"          grep -q "zsh/my_zshrc.sh" "$HOME/.zshrc"

section "Stage 2: oh-my-zsh installed (requires #2)"
check "OhMyZsh/ directory exists"                test -d "$DF_ROOT_PATH/OhMyZsh"
check "oh-my-zsh.sh present"                     test -f "$DF_ROOT_PATH/OhMyZsh/oh-my-zsh.sh"

section "Stage 3: zsh boots clean (requires #2, #6, #7)"
check "zsh -ic 'true' exits 0"                   zsh -ic 'true'
check "no 'command not found' in startup"        bash -c "! grep -q 'command not found' '$ZSH_LOG'"
check "no oh-my-zsh insecure-dir warning"        bash -c "! grep -q 'Insecure completion' '$ZSH_LOG'"
check "no 'no such file' in startup"             bash -c "! grep -q 'no such file or directory' '$ZSH_LOG'"

section "Stage 4: shopt no-op (requires #6)"
check "~/.zshenv exists"                         test -e "$HOME/.zshenv"
check "shopt defined as zsh function"            zsh -c 'source ~/.zshenv 2>/dev/null; type shopt 2>&1 | grep -q function'

section "Stage 5: SLURM defaults clean (requires #4)"
check "no LUMI project_462000031 in .zshrc"      bash -c "! grep -q 'project_462000031' '$HOME/.zshrc'"
check "no 'standard-g' partition in .zshrc"      bash -c "! grep -q 'standard-g' '$HOME/.zshrc'"

section "Stage 6: cat alias guarded (requires #8)"
check "cat alias only set when bat exists"       zsh -ic 'command -v bat >/dev/null || ! alias cat 2>/dev/null | grep -q bat'

echo
echo "================================"
echo "  Summary: $PASS passed, $FAIL failed"
echo "================================"

if [ "$FAIL" -gt 0 ]; then
    echo
    echo "Failed checks (likely tracked by issues #2-#8):"
    for c in "${FAILED_CHECKS[@]}"; do
        echo "  - $c"
    done
fi

exit "$FAIL"
