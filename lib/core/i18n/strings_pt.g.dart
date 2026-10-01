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
class TranslationsPt extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPt({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.pt,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsPt _root = this; // ignore: unused_field

	@override 
	TranslationsPt $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPt(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'WareHouse';
	@override late final _Translations$nav$pt nav = _Translations$nav$pt._(_root);
	@override late final _Translations$actions$pt actions = _Translations$actions$pt._(_root);
	@override late final _Translations$theme$pt theme = _Translations$theme$pt._(_root);
	@override String get languageLabel => 'Idioma';
	@override late final _Translations$failures$pt failures = _Translations$failures$pt._(_root);
	@override String environmentLabel({required Object env}) => 'Ambiente: ${env}';
}

// Path: nav
class _Translations$nav$pt extends Translations$nav$es {
	_Translations$nav$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get summary => 'Resumo';
	@override String get products => 'Produtos';
	@override String get settings => 'Configurações';
}

// Path: actions
class _Translations$actions$pt extends Translations$actions$es {
	_Translations$actions$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get retry => 'Tentar novamente';
	@override String get cancel => 'Cancelar';
}

// Path: theme
class _Translations$theme$pt extends Translations$theme$es {
	_Translations$theme$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get light => 'Claro';
	@override String get dark => 'Escuro';
}

// Path: failures
class _Translations$failures$pt extends Translations$failures$es {
	_Translations$failures$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get network => 'Sem conexão. Verifique sua conexão e tente novamente.';
	@override String get timeout => 'O servidor demorou muito para responder. Tente novamente.';
	@override String get notFound => 'Este produto não existe mais. Atualize a lista.';
	@override String get rateLimit => 'Você fez muitas solicitações seguidas. Aguarde alguns segundos e tente novamente.';
	@override String get server => 'Um erro no servidor ocorreu. Tente novamente.';
	@override String get cache => 'Não conseguimos ler os dados armazenados no seu dispositivo.';
	@override String get unexpected => 'Um erro inesperado ocorreu. Tente novamente.';
}

/// The flat map containing all translations for locale <pt>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPt {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'WareHouse',
			'nav.summary' => 'Resumo',
			'nav.products' => 'Produtos',
			'nav.settings' => 'Configurações',
			'actions.retry' => 'Tentar novamente',
			'actions.cancel' => 'Cancelar',
			'theme.light' => 'Claro',
			'theme.dark' => 'Escuro',
			'languageLabel' => 'Idioma',
			'failures.network' => 'Sem conexão. Verifique sua conexão e tente novamente.',
			'failures.timeout' => 'O servidor demorou muito para responder. Tente novamente.',
			'failures.notFound' => 'Este produto não existe mais. Atualize a lista.',
			'failures.rateLimit' => 'Você fez muitas solicitações seguidas. Aguarde alguns segundos e tente novamente.',
			'failures.server' => 'Um erro no servidor ocorreu. Tente novamente.',
			'failures.cache' => 'Não conseguimos ler os dados armazenados no seu dispositivo.',
			'failures.unexpected' => 'Um erro inesperado ocorreu. Tente novamente.',
			'environmentLabel' => ({required Object env}) => 'Ambiente: ${env}',
			_ => null,
		};
	}
}
