# Contribuir

## Ramas

Gitflow: `main` (releases) ← `develop` (integración) ← `feature/<tema>` / `fix/<tema>`. Cada rama se integra con `git merge --no-ff`.

## Commits

`type(scope): Descripción corta`, en commits pequeños y por tema.

```
feat(catalog): Add products bloc with search, sort, filters and pagination
fix(i18n): Pluralize filter results button
test(catalog): Cover action cubits, share channel and price sheet
build(ios): Add flavor schemes and dart-defines xcconfig pipeline
```

Tipos: `feat`, `fix`, `test`, `refactor`, `docs`, `chore`, `build`, `ci`.

## Antes de subir

```bash
dart format -l 120 lib test
flutter analyze                                   # 0 issues
flutter test --dart-define-from-file=.env.dev
```

## Reglas de código

- Toda pantalla usa `CustomScaffold`, nunca `Scaffold` directo.
- Textos visibles solo desde slang (`context.t`); nada escrito a mano.
- Colores solo desde `context.colors`.
- `fontSize` solo con valores `.sp` de la tabla px → sp; paddings, radios y alturas son fijos.
- `BlocSelector` en las hojas del árbol; los formularios guardan su estado en un cubit, no en `setState`.
- Comentarios solo para explicar un porqué que no es obvio.
- Tests: pocos y esenciales, cada uno con una regla concreta y nombre en español.
