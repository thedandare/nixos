#!/usr/bin/env bash
echo "Limpando travas..."
git merge --abort 2>/dev/null
git rebase --abort 2>/dev/null
rm -f .git/index.lock 2>/dev/null

echo "Apagando temporarios..."
find . -type f -name "*~" -delete
find . -type f -name "*~~" -delete

echo "Buscando atualizacoes..."
git fetch origin
BRANCH=$(git branch --show-current)
BRANCH=${BRANCH:-main}

echo "Restaurando pastas..."
git checkout origin/"$BRANCH" -- leonix/ 2>/dev/null || git checkout origin/master -- leonix/
git checkout --ours thumbnix/ arc.md rsync.sh 2>/dev/null || true

echo "Finalizando Git..."
git add .
git commit -m "Fix: theirs leonix, ours thumbnix" --no-verify
echo "=== CONCLUIDO ==="
git status -s
