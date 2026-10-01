#!/bin/bash
# Pre-action del scheme: Xcode Archive no conoce --dart-define-from-file, así que se
# reinyecta .env.<flavor> como DART_DEFINES (base64) + FLUTTER_BUILD_FLAVOR para appFlavor.

set -uo pipefail

ENV_NAME="${1:-.env.dev}"
ENV_FILE="${SRCROOT}/../${ENV_NAME}"
OUTPUT="${SRCROOT}/Flutter/DartDefines.xcconfig"

FLAVOR="${ENV_NAME#.env.}"

if [ ! -f "$ENV_FILE" ]; then
  echo "warning: env file not found: $ENV_FILE — DartDefines.xcconfig unchanged" >&2
  exit 0
fi

DEFINES=""
COUNT=0
while IFS= read -r line || [ -n "$line" ]; do
  line="${line%$'\r'}"
  case "$line" in ''|\#*) continue ;; esac
  case "$line" in *=*) ;; *) continue ;; esac
  encoded=$(printf '%s' "$line" | base64 | tr -d '\n')
  if [ -z "$DEFINES" ]; then DEFINES="$encoded"; else DEFINES="${DEFINES},${encoded}"; fi
  COUNT=$((COUNT + 1))
done < "$ENV_FILE"

mkdir -p "$(dirname "$OUTPUT")"
{
  echo "// Auto-generated — no editar ni commitear."
  echo "// Source: ${ENV_NAME} via generate_dart_defines_xcconfig.sh"
  echo "DART_DEFINES=${DEFINES}"
  echo "FLUTTER_BUILD_FLAVOR=${FLAVOR}"
} > "$OUTPUT"

echo "✓ DartDefines.xcconfig actualizado (${COUNT} defines, flavor=${FLAVOR})"
