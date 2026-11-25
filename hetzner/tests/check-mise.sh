#!/usr/bin/env bash
# The CI check of the role "mise" (.github/workflows/hetzner.yml). It runs as the user who got the tools, in a login shell, so
# that ~/.profile puts mise's shims on the PATH:
#
#   su - <user> -c 'bash -s -- <dir> <mise> <ruby> <rails> <python> <node> <go>' < tests/check-mise.sh
#
# <dir>: an empty folder the user can write. The versions: the defaults the role installs.
set -euo pipefail

dir=$1 want_mise=$2 want_ruby=$3 want_rails=$4 want_python=$5 want_node=$6 want_go=$7

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
for tool in mise ruby gem rails python node npm go; do
  command -v "$tool" || { echo "$tool: not on the PATH"; exit 1; }
done
same mise "$(mise --version | grep -oE '[0-9]{4}\.[0-9]+\.[0-9]+' | head -n 1)" "$want_mise"
same Ruby "$(ruby -e 'print RUBY_VERSION')" "$want_ruby"
same Rails "$(rails --version)" "Rails $want_rails"
same Python "$(python -c 'import platform; print(platform.python_version())')" "$want_python"
same Node "$(node -p 'process.versions.node')" "$want_node"
same Go "$(go env GOVERSION)" "go$want_go"

step "The precompiled Ruby and Python bring their own libraries"
ruby -ropenssl -rpsych -e 'puts OpenSSL::OPENSSL_LIBRARY_VERSION, "libyaml #{Psych::LIBYAML_VERSION}"'
python -c 'import ssl, sqlite3; print(ssl.OPENSSL_VERSION); print("SQLite", sqlite3.sqlite_version)'

step "Rails $want_rails makes a minimal app on Ruby $want_ruby (without installing its gems)"
cd "$dir"
# < /dev/null here and below: this script arrives on stdin (bash -s), so a command that reads stdin would eat the rest of it.
rails new demo --minimal --skip-bundle --skip-git --quiet < /dev/null
test -f demo/config/application.rb
echo "demo/config/application.rb is there"

step "Node and Go run a program"
same "The Node program says" "$(node -e 'console.log("Hello from Node")')" "Hello from Node"
printf 'package main\n\nimport "fmt"\n\nfunc main() { fmt.Println("Hello from Go") }\n' > hello.go
same "The Go program says" "$(go run hello.go)" "Hello from Go"

step "Interactive shells activate mise (~/.bashrc)"
# Without the login shell's MISE_SHELL (if any), so the value can only come from ~/.bashrc.
same "MISE_SHELL in an interactive shell" \
  "$(env -u MISE_SHELL bash -ic 'printf %s "${MISE_SHELL:-}"' < /dev/null 2> /dev/null)" bash

step "Disk space used"
du -sh "$HOME/.local/share/mise" "$HOME/.local/bin/mise"
