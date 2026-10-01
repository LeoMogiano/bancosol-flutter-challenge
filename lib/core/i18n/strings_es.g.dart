///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEs = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// es: 'WareHouse'
	String get appName => 'WareHouse';

	late final Translations$nav$es nav = Translations$nav$es.internal(_root);
	late final Translations$actions$es actions = Translations$actions$es.internal(_root);
	late final Translations$theme$es theme = Translations$theme$es.internal(_root);

	/// es: 'Idioma'
	String get languageLabel => 'Idioma';

	late final Translations$failures$es failures = Translations$failures$es.internal(_root);

	/// es: 'Ambiente: {env}'
	String environmentLabel({required Object env}) => 'Ambiente: ${env}';
}

// Path: nav
class Translations$nav$es {
	Translations$nav$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Resumen'
	String get summary => 'Resumen';

	/// es: 'Productos'
	String get products => 'Productos';

	/// es: 'Ajustes'
	String get settings => 'Ajustes';
}

// Path: actions
class Translations$actions$es {
	Translations$actions$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Reintentar'
	String get retry => 'Reintentar';

	/// es: 'Cancelar'
	String get cancel => 'Cancelar';
}

// Path: theme
class Translations$theme$es {
	Translations$theme$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Claro'
	String get light => 'Claro';

	/// es: 'Oscuro'
	String get dark => 'Oscuro';
}

// Path: failures
class Translations$failures$es {
	Translations$failures$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Sin conexión. Revisa tu conexión e inténtalo nuevamente.'
	String get network => 'Sin conexión. Revisa tu conexión e inténtalo nuevamente.';

	/// es: 'El servidor tardó demasiado en responder. Inténtalo nuevamente.'
	String get timeout => 'El servidor tardó demasiado en responder. Inténtalo nuevamente.';

	/// es: 'Este producto ya no existe. Actualiza la lista.'
	String get notFound => 'Este producto ya no existe. Actualiza la lista.';

	/// es: 'Hiciste muchas solicitudes seguidas. Espera unos segundos e inténtalo nuevamente.'
	String get rateLimit => 'Hiciste muchas solicitudes seguidas. Espera unos segundos e inténtalo nuevamente.';

	/// es: 'Ocurrió un problema con el servidor. Inténtalo nuevamente.'
	String get server => 'Ocurrió un problema con el servidor. Inténtalo nuevamente.';

	/// es: 'No pudimos leer los datos guardados en el dispositivo.'
	String get cache => 'No pudimos leer los datos guardados en el dispositivo.';

	/// es: 'Ocurrió un problema inesperado. Inténtalo nuevamente.'
	String get unexpected => 'Ocurrió un problema inesperado. Inténtalo nuevamente.';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'WareHouse',
			'nav.summary' => 'Resumen',
			'nav.products' => 'Productos',
			'nav.settings' => 'Ajustes',
			'actions.retry' => 'Reintentar',
			'actions.cancel' => 'Cancelar',
			'theme.light' => 'Claro',
			'theme.dark' => 'Oscuro',
			'languageLabel' => 'Idioma',
			'failures.network' => 'Sin conexión. Revisa tu conexión e inténtalo nuevamente.',
			'failures.timeout' => 'El servidor tardó demasiado en responder. Inténtalo nuevamente.',
			'failures.notFound' => 'Este producto ya no existe. Actualiza la lista.',
			'failures.rateLimit' => 'Hiciste muchas solicitudes seguidas. Espera unos segundos e inténtalo nuevamente.',
			'failures.server' => 'Ocurrió un problema con el servidor. Inténtalo nuevamente.',
			'failures.cache' => 'No pudimos leer los datos guardados en el dispositivo.',
			'failures.unexpected' => 'Ocurrió un problema inesperado. Inténtalo nuevamente.',
			'environmentLabel' => ({required Object env}) => 'Ambiente: ${env}',
			_ => null,
		};
	}
}
