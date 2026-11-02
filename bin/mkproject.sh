#!/bin/sh
# mkproject.sh [dir] -- build compile_commands.json, tags and cscope.out.
set -eu
cd "${1:-.}"
warn() { echo "mkproject: $*" >&2; }

# 1. compile_commands.json
if [ -f CMakeLists.txt ]; then
  cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  ln -sf build/compile_commands.json compile_commands.json
elif [ -f Makefile ] || [ -f makefile ] || [ -f GNUmakefile ]; then
  if command -v bear >/dev/null 2>&1; then
    bear -- make -B          # -B: force full rebuild so every file is recorded
  else
    warn "bear not found; skipping compile_commands.json (dnf install bear)"
  fi
else
  warn "no CMakeLists.txt or Makefile; skipping compile_commands.json"
fi

# 2. ctags (Fedora's ctags package is Universal Ctags)
if ctags --version 2>/dev/null | grep -q 'Universal Ctags'; then
  ctags -R --fields=+iaS --extras=+q --exclude=.git --exclude=build .
else
  warn "Universal Ctags not found; skipping tags (dnf install ctags)"
fi

# 3. cscope: -R only scans C files, so list C++ sources explicitly
if command -v cscope >/dev/null 2>&1; then
  find . \( -name .git -o -name build \) -prune -o -type f \
    \( -name '*.[ch]' -o -name '*.cc' -o -name '*.cpp' -o -name '*.cxx' \
       -o -name '*.hh' -o -name '*.hpp' -o -name '*.hxx' \) -print > cscope.files
  cscope -bqk -i cscope.files
else
  warn "cscope not found; skipping cscope.out"
fi
echo "mkproject: done in $(pwd)"
