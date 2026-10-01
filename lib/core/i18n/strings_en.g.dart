///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'WareHouse';
	@override late final _Translations$nav$en nav = _Translations$nav$en._(_root);
	@override late final _Translations$actions$en actions = _Translations$actions$en._(_root);
	@override late final _Translations$theme$en theme = _Translations$theme$en._(_root);
	@override String get languageLabel => 'Language';
	@override late final _Translations$failures$en failures = _Translations$failures$en._(_root);
	@override String environmentLabel({required Object env}) => 'Environment: ${env}';
}

// Path: nav
class _Translations$nav$en extends Translations$nav$es {
	_Translations$nav$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get summary => 'Summary';
	@override String get products => 'Products';
	@override String get settings => 'Settings';
}

// Path: actions
class _Translations$actions$en extends Translations$actions$es {
	_Translations$actions$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get retry => 'Retry';
	@override String get cancel => 'Cancel';
}

// Path: theme
class _Translations$theme$en extends Translations$theme$es {
	_Translations$theme$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get light => 'Light';
	@override String get dark => 'Dark';
}

// Path: failures
class _Translations$failures$en extends Translations$failures$es {
	_Translations$failures$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get network => 'No connection. Check your connection and try again.';
	@override String get timeout => 'The server took too long to respond. Try again.';
	@override String get notFound => 'This product no longer exists. Refresh the list.';
	@override String get rateLimit => 'You made too many requests in a row. Wait a few seconds and try again.';
	@override String get server => 'A server error occurred. Try again.';
	@override String get cache => 'We couldn\'t read the data stored on your device.';
	@override String get unexpected => 'An unexpected error occurred. Try again.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'WareHouse',
			'nav.summary' => 'Summary',
			'nav.products' => 'Products',
			'nav.settings' => 'Settings',
			'actions.retry' => 'Retry',
			'actions.cancel' => 'Cancel',
			'theme.light' => 'Light',
			'theme.dark' => 'Dark',
			'languageLabel' => 'Language',
			'failures.network' => 'No connection. Check your connection and try again.',
			'failures.timeout' => 'The server took too long to respond. Try again.',
			'failures.notFound' => 'This product no longer exists. Refresh the list.',
			'failures.rateLimit' => 'You made too many requests in a row. Wait a few seconds and try again.',
			'failures.server' => 'A server error occurred. Try again.',
			'failures.cache' => 'We couldn\'t read the data stored on your device.',
			'failures.unexpected' => 'An unexpected error occurred. Try again.',
			'environmentLabel' => ({required Object env}) => 'Environment: ${env}',
			_ => null,
		};
	}
}
