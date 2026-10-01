# Contribuir

## Ramas

Gitflow: `main` (releases) ← `cert` (certificación) ← `develop` (integración) ← `feature/<tema>` / `fix/<tema>`. Cada rama se integra con `git merge --no-ff`; un cambio solo sube a `cert` cuando `develop` está cerrado, y a `main` cuando `cert` está aprobado.

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
./tool/check_sizes.sh                             # ningún archivo de presentación > 200 líneas
flutter test --dart-define-from-file=.env.dev
```

## Reglas de código

- Toda pantalla usa `CustomScaffold`, nunca `Scaffold` directo.
- Cerrar una ruta de go_router: `context.canPop() ? context.pop() : context.go(<ruta base>)`, así un deep link sin historial no deja el stack vacío. Hojas y dialogs (rutas imperativas que el router no conoce) se cierran con `Navigator.of(context).pop(result)`: con `StatefulShellRoute`, `context.pop()` puede cerrar la pantalla de la rama en vez de la hoja.
- Textos visibles solo desde slang (`context.t`); nada escrito a mano.
- Colores solo desde `context.colors`.
- `fontSize` solo con valores `.sp` de la tabla px → sp; paddings, radios y alturas son fijos.
- Estado de un Bloc en la UI: ver [Reconstrucciones](#reconstrucciones). Los formularios guardan su estado en un cubit, no en `setState`.
- Comentarios solo para explicar un porqué que no es obvio.
- Tests: pocos y esenciales, cada uno con una regla concreta y nombre en español.

## Tamaño de pantallas

| Qué | Máximo |
|---|---|
| Archivo en `presentation/` (pantalla, hoja, widget) | 200 líneas, lo valida `tool/check_sizes.sh` en CI |
| `build` de una pantalla | ~60 líneas: solo compone secciones |
| Widget privado | ~80 líneas |
| Anidación dentro de un `build` | ~6 niveles |

- La pantalla conserva su estado (controllers, focos, flags), los listeners y los handlers que navegan; las secciones van como widgets.
- Las secciones propias de una pantalla viven en `presentation/widgets/<pantalla>/` y son públicas; las que se usan en un solo archivo quedan privadas.
- Bloques repetidos (chips, stats, opciones) se generan desde una lista de records, no se copian.
- Un `switch` de error a texto va en una extensión `*_i18n.dart`, no dentro del widget.
- Al extraer una sección, que lea su propio dato con `context.select` (ver [Reconstrucciones](#reconstrucciones)) en vez de recibirlo de una pantalla que lo seleccione completo.

## Widgets costosos

| Evitar | Usar |
|---|---|
| `IntrinsicHeight` / `IntrinsicWidth` (miden dos veces cada layout) | Alturas fijas o `minHeight`; hijos con el mismo contenido ya miden lo mismo |
| `ListView` / `GridView` con `shrinkWrap: true` para pocos ítems fijos | `Column` / `Row` con `Expanded` |
| `Opacity` animado (`TweenAnimationBuilder`, `setState`) | `FadeTransition` / `AnimatedOpacity`: animan la capa sin repintar al hijo |
| `MediaQuery.of(context).x` | `MediaQuery.xOf(context)` (`sizeOf`, `paddingOf`, `viewInsetsOf`): reconstruye solo si cambia ese dato |
| `ClipPath`, `ShaderMask`, `BackdropFilter` sin necesidad | Solo si el diseño lo exige, dentro de un `RepaintBoundary` |

## Reconstrucciones

Objetivo: que un cambio de estado reconstruya solo lo que muestra ese dato.

| Caso | Usar |
|---|---|
| Widget chico cuyo `build` depende del dato (campo, sección de hoja, tile, footer) | `context.select` al inicio del `build` |
| Trozo dentro de un `build` grande (pantalla, `CustomScaffold`) que no amerita un widget propio | `BlocSelector` alrededor de ese trozo |
| El `BlocProvider` se crea en el mismo `build` (el `context` está por encima) | `BlocSelector` / `BlocBuilder` debajo del provider |
| Efectos: toasts, navegación, foco | `BlocListener`, nunca dentro de `build` |

```dart
@override
Widget build(BuildContext context) {
  final t = context.t;
  final data = context.select<ProductsBloc, ({int page, int pageCount})>(
    (bloc) => (page: bloc.state.page, pageCount: bloc.state.pageCount),
  );
  return AppPaginator(page: data.page, pageCount: data.pageCount, onChanged: onPageChanged);
}
```

- `context.select` reconstruye **todo** el `build` del widget dueño del `context`: nunca en una pantalla entera. Si el dato se usa en un trozo, se extrae ese trozo a un widget o se usa `BlocSelector`.
- Se selecciona lo mínimo: un valor o un record. Los records se comparan por valor, así que varios campos en un record no reconstruyen si ninguno cambió.
- Nunca seleccionar una lista recién calculada (`pageItems`, `where(...).toList()`): es una instancia nueva en cada acceso y reconstruye siempre. Se seleccionan las fuentes (`visible`, `page`) y se calcula en el `build`.
- Genéricos explícitos (`context.select<Bloc, T>((bloc) => ...)`): el lint `avoid_types_on_closure_parameters` no permite tipar el parámetro.
- Solo en `build`, al inicio y antes de cualquier `return`. Nunca en callbacks, `initState` ni `itemBuilder`; ahí va `context.read`.
- `BlocBuilder` sin `buildWhen` solo en hojas cortas donde todo el contenido depende del estado.
- Hijos que no dependen del dato van `const` o en widgets propios, así no se reconstruyen con el padre.
