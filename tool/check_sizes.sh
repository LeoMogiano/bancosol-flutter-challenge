#!/usr/bin/env bash
# Falla si un archivo de presentación supera el máximo de líneas del estándar (ver CONTRIBUTING.md).
set -euo pipefail

max=${1:-200}
status=0

while IFS= read -r file; do
  lines=$(wc -l < "$file" | tr -d " ")
  if (( lines > max )); then
    echo "$file: $lines líneas (máximo $max)"
    status=1
  fi
done < <(find lib -path '*/presentation/*' -name '*.dart')

exit $status
