#!/usr/bin/env bash
# Uso: ./tool/setup.sh [--check] [--run]
set -euo pipefail

cd "$(dirname "$0")/.."

check=false
run=false
for arg in "$@"; do
  case $arg in
    --check) check=true ;;
    --run) run=true ;;
    *) echo "Opción desconocida: $arg (usar --check o --run)" >&2; exit 2 ;;
  esac
done

step() { printf '\n\033[1m▸ %s\033[0m\n' "$1"; }
warn() { printf '\033[33m! %s\033[0m\n' "$1"; }

step "Flutter"
command -v flutter >/dev/null || { echo "flutter no está en el PATH" >&2; exit 1; }
version=$(flutter --version | awk 'NR==1 {print $2}')
if [[ "$(printf '%s\n' 3.47.0 "$version" | sort -V | head -1)" != 3.47.0 ]]; then
  warn "Flutter $version; se recomienda 3.47 o superior"
else
  echo "Flutter $version"
fi

step "Variables de entorno"
for flavor in dev qa prod; do
  if [[ -f .env.$flavor ]]; then
    echo ".env.$flavor ya existe, no se toca"
  else
    cp .env.example ".env.$flavor"
    echo ".env.$flavor creado desde .env.example"
  fi
done

step "Dependencias"
flutter pub get

step "Traducciones"
dart run slang

if [[ "$(uname)" == Darwin && -f ios/Podfile ]]; then
  step "CocoaPods"
  if command -v pod >/dev/null; then
    (cd ios && pod install)
  else
    warn "pod no está instalado; iOS no compilará hasta correr 'pod install' en ios/"
  fi
fi

if $check; then
  step "Formato"
  dart format -l 120 --output=none --set-exit-if-changed lib test
  step "Análisis"
  flutter analyze
  step "Tamaño de pantallas"
  ./tool/check_sizes.sh
  step "Tests"
  flutter test --dart-define-from-file=.env.dev
fi

if $run; then
  step "Ejecutando (dev)"
  exec flutter run --flavor dev --dart-define-from-file=.env.dev
fi

printf '\n\033[32m✓ Listo.\033[0m Ejecutar: flutter run --flavor dev --dart-define-from-file=.env.dev (o F5 en VS Code)\n'
