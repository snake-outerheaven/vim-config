#!/bin/sh
# install.sh [--no-packages] [--dry-run] -- set this config up on Fedora.
# Safe to run again: it never overwrites or removes anything in $HOME.
set -eu

PACKAGES='vim-* awesome-vim-colorschemes gcc gcc-c++ make cmake gdb
  clang-tools-extra bear ctags cscope ripgrep cppcheck valgrind cascadia-code-fonts'
COMMANDS='vim clangd clang-format gcc g++ make cmake gdb bear ctags cscope rg
  cppcheck valgrind'

packages=1
dry_run=0
for arg in "$@"; do
  case $arg in
    --no-packages) packages=0 ;;
    -n|--dry-run)  dry_run=1 ;;
    -h|--help)     sed -n 2,3p "$0" | cut -c3-; exit 0 ;;
    *)             echo "install: unknown option: $arg (try --help)" >&2; exit 2 ;;
  esac
done

say()  { echo "install: $*"; }
warn() { echo "install: warning: $*" >&2; }
die()  { echo "install: error: $*" >&2; exit 1; }
run() {
  if [ "$dry_run" -eq 1 ]; then
    echo "would run: $*"
  else
    "$@"
  fi
}

repo=$(cd "$(dirname "$0")/.." && pwd -P)
[ -f "$repo/vimrc" ] || die "no vimrc in $repo"

# 1. Vim only reads ~/.vim, so a clone elsewhere needs a link there.
if [ ! -e "$HOME/.vim" ] && [ ! -L "$HOME/.vim" ]; then
  run ln -s "$repo" "$HOME/.vim"
elif [ "$(cd "$HOME/.vim" 2>/dev/null && pwd -P)" != "$repo" ]; then
  die "$HOME/.vim exists and is not this repository ($repo); move it and rerun"
fi

# 2. Packages.  vim-default-editor is excluded because the vim-* glob would
# otherwise conflict with Fedora's nano-default-editor and fail the transaction.
if [ "$packages" -eq 1 ]; then
  command -v dnf >/dev/null 2>&1 || die "dnf not found; use --no-packages to skip this step"
  # shellcheck disable=SC2086  # the list must split; set -f keeps vim-* literal
  set -f
  if [ "$(id -u)" -eq 0 ]; then
    run dnf install --exclude=vim-default-editor $PACKAGES
  else
    run sudo dnf install --exclude=vim-default-editor $PACKAGES
  fi
  set +f
fi

# 3. Config files.  An existing file that differs is the user's: keep it.
install_file() {  # source-relative-to-home/
  src=$repo/home/$1
  dst=$HOME/$1
  if [ ! -e "$dst" ] && [ ! -L "$dst" ]; then
    run mkdir -p "$(dirname "$dst")"
    run cp "$src" "$dst"
    [ "$dry_run" -eq 1 ] || say "installed $dst"
  elif cmp -s "$src" "$dst"; then
    say "$dst is up to date"
  else
    warn "kept your $dst; it differs from $src"
  fi
}
install_file .clang-format
install_file .config/clangd/config.yaml

# 4. Things that would silently change how this config behaves.
for f in .vimrc .gvimrc; do
  [ ! -e "$HOME/$f" ] || warn "$HOME/$f takes precedence over ~/.vim/${f#.}; remove or rename it"
done

missing=
for c in $COMMANDS; do
  command -v "$c" >/dev/null 2>&1 || missing="$missing $c"
done
if [ -n "$missing" ]; then
  [ "$dry_run" -eq 1 ] && say "not installed yet:$missing" || warn "not found:$missing"
fi
say "done"
