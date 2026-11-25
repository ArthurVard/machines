#!/usr/bin/env bash
# The CI check of the role "haskell" (.github/workflows/hetzner.yml). It runs as the user who got the toolchain, in a login
# shell, so that ~/.profile sets the PATH:
#
#   su - <user> -c 'bash -s -- <dir> <ghc> <cabal> <stack> <hls>' < tests/check-haskell.sh
#
# <dir>: a folder the user can write, holding Hello.hs. The versions: the defaults the role installs.
set -euo pipefail

dir=$1 want_ghc=$2 want_cabal=$3 want_stack=$4 want_hls=$5

step() { printf '\n== %s\n' "$*"; }
same() {   # same <what> <found> <expected>
  if [ "$2" != "$3" ]; then
    echo "$1: found '$2', expected '$3'"
    exit 1
  fi
  echo "$1: $2"
}

step "The tools on the PATH, and their versions"
# One at a time: "command -v a b c" doesn't fail when only some are missing.
for tool in ghcup ghc cabal stack haskell-language-server-wrapper; do
  command -v "$tool" || { echo "$tool: not on the PATH"; exit 1; }
done
ghcup --version
same GHC "$(ghc --numeric-version)" "$want_ghc"
same Cabal "$(cabal --numeric-version)" "$want_cabal"
same Stack "$(stack --numeric-version)" "$want_stack"
same HLS "$(haskell-language-server-wrapper --numeric-version)" "$want_hls"

step "GHC builds and runs a program, with the threaded runtime"
cd "$dir"
ghc -threaded -O0 -outputdir build Hello.hs -o hello
same "The program says" "$(./hello)" "Hello from GHC"

step "HLS loads the file, with its binary for GHC $want_ghc"
haskell-language-server-wrapper Hello.hs

# In a project of its own: a stack.yaml here would make HLS above use Stack.
step "Stack gets GHC $want_ghc from ghcup, through its hook"
mkdir -p "$dir/stack-check"
cd "$dir/stack-check"
printf 'snapshot: ghc-%s\npackages: []\n' "$want_ghc" > stack.yaml
used=$(stack exec -- sh -c 'command -v ghc')
case "$used" in
  "$HOME"/.ghcup/*) echo "Stack's GHC: $used" ;;
  *) echo "Stack's GHC is $used, not ghcup's"; exit 1 ;;
esac

step "Disk space used"
du -sh "$HOME/.ghcup" "$HOME/.stack" "$HOME/.cabal"
