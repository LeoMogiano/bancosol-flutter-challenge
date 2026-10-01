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
	@override String get appName => 'Warehouse';
	@override late final _Translations$nav$pt nav = _Translations$nav$pt._(_root);
	@override late final _Translations$actions$pt actions = _Translations$actions$pt._(_root);
	@override late final _Translations$theme$pt theme = _Translations$theme$pt._(_root);
	@override late final _Translations$failures$pt failures = _Translations$failures$pt._(_root);
	@override String environmentLabel({required Object env}) => 'Ambiente: ${env}';
	@override late final _Translations$summary$pt summary = _Translations$summary$pt._(_root);
	@override late final _Translations$products$pt products = _Translations$products$pt._(_root);
	@override late final _Translations$stock$pt stock = _Translations$stock$pt._(_root);
	@override late final _Translations$filters$pt filters = _Translations$filters$pt._(_root);
	@override late final _Translations$detail$pt detail = _Translations$detail$pt._(_root);
	@override late final _Translations$priceEdit$pt priceEdit = _Translations$priceEdit$pt._(_root);
	@override late final _Translations$validation$pt validation = _Translations$validation$pt._(_root);
	@override late final _Translations$form$pt form = _Translations$form$pt._(_root);
	@override late final _Translations$delete$pt delete = _Translations$delete$pt._(_root);
	@override late final _Translations$toasts$pt toasts = _Translations$toasts$pt._(_root);
	@override late final _Translations$share$pt share = _Translations$share$pt._(_root);
	@override late final _Translations$settings$pt settings = _Translations$settings$pt._(_root);
	@override late final _Translations$a11y$pt a11y = _Translations$a11y$pt._(_root);
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
	@override String get refresh => 'Atualizar';
	@override String get newProduct => 'Novo produto';
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
	@override String get validation => 'Os dados informados não são válidos. Revise-os e tente novamente.';
	@override String get unexpected => 'Um erro inesperado ocorreu. Tente novamente.';
}

// Path: summary
class _Translations$summary$pt extends Translations$summary$es {
	_Translations$summary$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'GESTÃO DE CATÁLOGO';
	@override String get title => 'Resumo';
	@override String get searchHint => 'Buscar por nome ou SKU';
	@override String get inventoryValue => 'Valor do estoque';
	@override String syncedAt({required Object time}) => 'Sincronizado ${time}';
	@override String get formula => 'Preço × estoque';
	@override String get statProducts => 'Produtos';
	@override String get statLowStock => 'Estoque baixo';
	@override String get statOutOfStock => 'Sem estoque';
	@override String get errorTitle => 'Não foi possível carregar o catálogo';
	@override String get errorMessage => 'Verifique sua conexão e tente novamente.';
	@override String get emptyTitle => 'Desculpe, ainda não há produtos';
	@override String get emptyMessage => 'Crie seu primeiro produto ou atualize para verificar se já há registros.';
}

// Path: products
class _Translations$products$pt extends Translations$products$es {
	_Translations$products$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'CATÁLOGO';
	@override String get title => 'Produtos';
	@override String get newShort => 'Novo';
	@override String get searchHint => 'Nome ou SKU';
	@override String results({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '${n} resultado',
		other: '${n} resultados',
	);
	@override String get clearFilters => 'Limpar filtros';
	@override String showing({required Object from, required Object to, required Object total}) => 'Mostrando ${from}–${to} de ${total}';
	@override String get pullToRefresh => 'Deslize para atualizar';
	@override String get releaseToRefresh => 'Solte para atualizar';
	@override String get errorTitle => 'Não foi possível obter os produtos';
	@override String get errorMessage => 'Tente novamente em alguns segundos.';
	@override String get emptyTitle => 'Desculpe, não há produtos';
	@override String get emptyMessage => 'Ainda não há registros no catálogo. Crie um novo para começar.';
	@override String noResultsTitle({required Object query}) => 'Sem resultados para “${query}”';
	@override String get noResultsNoQuery => 'Nenhum produto corresponde';
	@override String get noResultsMessage => 'Verifique o nome ou o SKU, ou remova alguns filtros.';
	@override String get clearSearch => 'Limpar busca';
	@override String get offline => 'Dados offline';
	@override String lastSync({required Object time}) => 'Última sincronização ${time}';
}

// Path: stock
class _Translations$stock$pt extends Translations$stock$es {
	_Translations$stock$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get out => 'Sem estoque';
	@override String units({required Object n}) => '${n} em estoque';
}

// Path: filters
class _Translations$filters$pt extends Translations$filters$es {
	_Translations$filters$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ordenar e filtrar';
	@override String get sortBy => 'Ordenar por';
	@override String get priceDesc => 'Maior preço';
	@override String get priceAsc => 'Menor preço';
	@override String get nameAsc => 'Nome A–Z';
	@override String get sku => 'SKU';
	@override String get priceRange => 'Faixa de preço (BOB)';
	@override String get min => 'Mínimo';
	@override String get max => 'Máximo';
	@override String get currency => 'Moeda';
	@override String get all => 'Todas';
	@override String get inStockOnly => 'Somente com estoque';
	@override String get inStockOnlyHint => 'Oculta produtos com estoque 0';
	@override String get reset => 'Redefinir';
	@override String apply({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: 'Ver ${n} produto',
		other: 'Ver ${n} produtos',
	);
	@override String get rangeError => 'O mínimo não pode ser maior que o máximo';
}

// Path: detail
class _Translations$detail$pt extends Translations$detail$es {
	_Translations$detail$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Detalhe do produto';
	@override String get price => 'Preço';
	@override String get updated => 'Atualizado';
	@override String get sku => 'SKU';
	@override String get stock => 'Estoque';
	@override String get currency => 'Moeda';
	@override String get id => 'ID';
	@override String get note => 'Somente o preço é editável. Estoque e moeda são gerenciados no sistema de origem.';
	@override String get share => 'Compartilhar';
	@override String get editPrice => 'Editar preço';
}

// Path: priceEdit
class _Translations$priceEdit$pt extends Translations$priceEdit$es {
	_Translations$priceEdit$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Editar preço';
	@override String get currentPrice => 'Preço atual';
	@override String get save => 'Salvar preço';
	@override String get saving => 'Salvando…';
	@override String get errorTitle => 'O preço não foi atualizado';
	@override String get serverError => 'Ocorreu um problema no servidor. Tente novamente.';
	@override String get offlineError => 'Sem conexão. Você poderá salvar quando voltar a ficar online.';
	@override String get help => 'Ex.: 1,500.50 · os milhares são separados automaticamente';
	@override String bigChange({required Object percent}) => 'Mudança de ${percent}% em relação ao atual. Verifique o valor.';
}

// Path: validation
class _Translations$validation$pt extends Translations$validation$es {
	_Translations$validation$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get priceEmpty => 'Informe um preço';
	@override String get priceIncomplete => 'Complete os centavos';
	@override String get priceNotPositive => 'O preço deve ser maior que 0';
	@override String get priceTooHigh => 'O preço máximo é 999,999.99';
	@override String get currencyEmpty => 'A moeda não pode estar vazia';
	@override String get priceUnchanged => 'É o mesmo preço atual';
	@override String get skuEmpty => 'O SKU é obrigatório';
	@override String get skuTooShort => 'Mínimo de 4 caracteres';
	@override String get skuFormat => 'Somente letras, números e hífens (ex. SKU-1029)';
	@override String get skuDuplicate => 'Já existe um produto com este SKU';
	@override String get nameEmpty => 'O nome é obrigatório';
	@override String get nameTooShort => 'Mínimo de 3 caracteres';
	@override String get nameOnlyDigits => 'O nome não pode ser apenas números';
	@override String get nameDuplicate => 'Já existe um produto com este nome';
	@override String get stockEmpty => 'Informe o estoque';
	@override String get stockTooHigh => 'Máximo 99,999';
}

// Path: form
class _Translations$form$pt extends Translations$form$es {
	_Translations$form$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Novo produto';
	@override String get sku => 'SKU';
	@override String get name => 'Nome';
	@override String get price => 'Preço';
	@override String get stock => 'Estoque';
	@override String get currency => 'Moeda';
	@override String get create => 'Criar produto';
	@override String get creating => 'Criando…';
	@override String get serverError => 'O produto não foi criado. Tente novamente.';
	@override String get offlineError => 'Sem conexão. O produto não foi criado.';
}

// Path: delete
class _Translations$delete$pt extends Translations$delete$es {
	_Translations$delete$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Excluir produto?';
	@override String message({required Object name, required Object sku}) => '${name} (${sku}) será removido do catálogo. Esta ação não pode ser desfeita.';
	@override String get confirm => 'Excluir';
	@override String get deleting => 'Excluindo…';
	@override String get serverError => 'O produto não foi excluído. Tente novamente.';
	@override String get offlineError => 'Sem conexão. O produto não foi excluído.';
}

// Path: toasts
class _Translations$toasts$pt extends Translations$toasts$es {
	_Translations$toasts$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get priceUpdated => 'Preço atualizado';
	@override String get created => 'Produto criado';
	@override String get deleted => 'Produto excluído';
	@override String get listUpdated => 'Lista atualizada';
	@override String get synced => 'Catálogo sincronizado';
	@override String get shared => 'Compartilhado';
	@override String sentrySent({required Object id}) => 'Erro de teste enviado · ${id}';
	@override String get sentryDisabled => 'O Sentry não está ativo neste build';
}

// Path: share
class _Translations$share$pt extends Translations$share$es {
	_Translations$share$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String text({required Object name, required Object price, required Object currency, required Object sku}) => 'Nome: ${name}\nPreço: ${price} ${currency}\nSKU: ${sku}';
}

// Path: settings
class _Translations$settings$pt extends Translations$settings$es {
	_Translations$settings$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'PREFERÊNCIAS';
	@override String get title => 'Ajustes';
	@override String get appearance => 'Aparência';
	@override String get language => 'Idioma';
	@override String get deviceLanguage => 'Do dispositivo';
	@override String get data => 'Dados';
	@override String get cache => 'Cache local';
	@override String get cacheHint => 'Mostra a última lista sem conexão';
	@override String get syncNow => 'Sincronizar agora';
	@override String syncedAt({required Object time}) => 'Sincronizado ${time}';
	@override String get neverSynced => 'Ainda não sincronizado';
	@override String get about => 'Sobre';
	@override String get version => 'Versão';
	@override String get diagnostics => 'Diagnóstico';
	@override String get sentryTest => 'Testar Sentry';
	@override String get sentryTestHint => 'Envia um erro de teste ao painel';
}

// Path: a11y
class _Translations$a11y$pt extends Translations$a11y$es {
	_Translations$a11y$pt._(TranslationsPt root) : this._root = root, super.internal(root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String page({required Object n}) => 'Página ${n}';
}

/// The flat map containing all translations for locale <pt>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPt {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Warehouse',
			'nav.summary' => 'Resumo',
			'nav.products' => 'Produtos',
			'nav.settings' => 'Configurações',
			'actions.retry' => 'Tentar novamente',
			'actions.cancel' => 'Cancelar',
			'actions.refresh' => 'Atualizar',
			'actions.newProduct' => 'Novo produto',
			'theme.light' => 'Claro',
			'theme.dark' => 'Escuro',
			'failures.network' => 'Sem conexão. Verifique sua conexão e tente novamente.',
			'failures.timeout' => 'O servidor demorou muito para responder. Tente novamente.',
			'failures.notFound' => 'Este produto não existe mais. Atualize a lista.',
			'failures.rateLimit' => 'Você fez muitas solicitações seguidas. Aguarde alguns segundos e tente novamente.',
			'failures.server' => 'Um erro no servidor ocorreu. Tente novamente.',
			'failures.cache' => 'Não conseguimos ler os dados armazenados no seu dispositivo.',
			'failures.validation' => 'Os dados informados não são válidos. Revise-os e tente novamente.',
			'failures.unexpected' => 'Um erro inesperado ocorreu. Tente novamente.',
			'environmentLabel' => ({required Object env}) => 'Ambiente: ${env}',
			'summary.eyebrow' => 'GESTÃO DE CATÁLOGO',
			'summary.title' => 'Resumo',
			'summary.searchHint' => 'Buscar por nome ou SKU',
			'summary.inventoryValue' => 'Valor do estoque',
			'summary.syncedAt' => ({required Object time}) => 'Sincronizado ${time}',
			'summary.formula' => 'Preço × estoque',
			'summary.statProducts' => 'Produtos',
			'summary.statLowStock' => 'Estoque baixo',
			'summary.statOutOfStock' => 'Sem estoque',
			'summary.errorTitle' => 'Não foi possível carregar o catálogo',
			'summary.errorMessage' => 'Verifique sua conexão e tente novamente.',
			'summary.emptyTitle' => 'Desculpe, ainda não há produtos',
			'summary.emptyMessage' => 'Crie seu primeiro produto ou atualize para verificar se já há registros.',
			'products.eyebrow' => 'CATÁLOGO',
			'products.title' => 'Produtos',
			'products.newShort' => 'Novo',
			'products.searchHint' => 'Nome ou SKU',
			'products.results' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '${n} resultado', other: '${n} resultados', ), 
			'products.clearFilters' => 'Limpar filtros',
			'products.showing' => ({required Object from, required Object to, required Object total}) => 'Mostrando ${from}–${to} de ${total}',
			'products.pullToRefresh' => 'Deslize para atualizar',
			'products.releaseToRefresh' => 'Solte para atualizar',
			'products.errorTitle' => 'Não foi possível obter os produtos',
			'products.errorMessage' => 'Tente novamente em alguns segundos.',
			'products.emptyTitle' => 'Desculpe, não há produtos',
			'products.emptyMessage' => 'Ainda não há registros no catálogo. Crie um novo para começar.',
			'products.noResultsTitle' => ({required Object query}) => 'Sem resultados para “${query}”',
			'products.noResultsNoQuery' => 'Nenhum produto corresponde',
			'products.noResultsMessage' => 'Verifique o nome ou o SKU, ou remova alguns filtros.',
			'products.clearSearch' => 'Limpar busca',
			'products.offline' => 'Dados offline',
			'products.lastSync' => ({required Object time}) => 'Última sincronização ${time}',
			'stock.out' => 'Sem estoque',
			'stock.units' => ({required Object n}) => '${n} em estoque',
			'filters.title' => 'Ordenar e filtrar',
			'filters.sortBy' => 'Ordenar por',
			'filters.priceDesc' => 'Maior preço',
			'filters.priceAsc' => 'Menor preço',
			'filters.nameAsc' => 'Nome A–Z',
			'filters.sku' => 'SKU',
			'filters.priceRange' => 'Faixa de preço (BOB)',
			'filters.min' => 'Mínimo',
			'filters.max' => 'Máximo',
			'filters.currency' => 'Moeda',
			'filters.all' => 'Todas',
			'filters.inStockOnly' => 'Somente com estoque',
			'filters.inStockOnlyHint' => 'Oculta produtos com estoque 0',
			'filters.reset' => 'Redefinir',
			'filters.apply' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: 'Ver ${n} produto', other: 'Ver ${n} produtos', ), 
			'filters.rangeError' => 'O mínimo não pode ser maior que o máximo',
			'detail.title' => 'Detalhe do produto',
			'detail.price' => 'Preço',
			'detail.updated' => 'Atualizado',
			'detail.sku' => 'SKU',
			'detail.stock' => 'Estoque',
			'detail.currency' => 'Moeda',
			'detail.id' => 'ID',
			'detail.note' => 'Somente o preço é editável. Estoque e moeda são gerenciados no sistema de origem.',
			'detail.share' => 'Compartilhar',
			'detail.editPrice' => 'Editar preço',
			'priceEdit.title' => 'Editar preço',
			'priceEdit.currentPrice' => 'Preço atual',
			'priceEdit.save' => 'Salvar preço',
			'priceEdit.saving' => 'Salvando…',
			'priceEdit.errorTitle' => 'O preço não foi atualizado',
			'priceEdit.serverError' => 'Ocorreu um problema no servidor. Tente novamente.',
			'priceEdit.offlineError' => 'Sem conexão. Você poderá salvar quando voltar a ficar online.',
			'priceEdit.help' => 'Ex.: 1,500.50 · os milhares são separados automaticamente',
			'priceEdit.bigChange' => ({required Object percent}) => 'Mudança de ${percent}% em relação ao atual. Verifique o valor.',
			'validation.priceEmpty' => 'Informe um preço',
			'validation.priceIncomplete' => 'Complete os centavos',
			'validation.priceNotPositive' => 'O preço deve ser maior que 0',
			'validation.priceTooHigh' => 'O preço máximo é 999,999.99',
			'validation.currencyEmpty' => 'A moeda não pode estar vazia',
			'validation.priceUnchanged' => 'É o mesmo preço atual',
			'validation.skuEmpty' => 'O SKU é obrigatório',
			'validation.skuTooShort' => 'Mínimo de 4 caracteres',
			'validation.skuFormat' => 'Somente letras, números e hífens (ex. SKU-1029)',
			'validation.skuDuplicate' => 'Já existe um produto com este SKU',
			'validation.nameEmpty' => 'O nome é obrigatório',
			'validation.nameTooShort' => 'Mínimo de 3 caracteres',
			'validation.nameOnlyDigits' => 'O nome não pode ser apenas números',
			'validation.nameDuplicate' => 'Já existe um produto com este nome',
			'validation.stockEmpty' => 'Informe o estoque',
			'validation.stockTooHigh' => 'Máximo 99,999',
			'form.title' => 'Novo produto',
			'form.sku' => 'SKU',
			'form.name' => 'Nome',
			'form.price' => 'Preço',
			'form.stock' => 'Estoque',
			'form.currency' => 'Moeda',
			'form.create' => 'Criar produto',
			'form.creating' => 'Criando…',
			'form.serverError' => 'O produto não foi criado. Tente novamente.',
			'form.offlineError' => 'Sem conexão. O produto não foi criado.',
			'delete.title' => 'Excluir produto?',
			'delete.message' => ({required Object name, required Object sku}) => '${name} (${sku}) será removido do catálogo. Esta ação não pode ser desfeita.',
			'delete.confirm' => 'Excluir',
			'delete.deleting' => 'Excluindo…',
			'delete.serverError' => 'O produto não foi excluído. Tente novamente.',
			'delete.offlineError' => 'Sem conexão. O produto não foi excluído.',
			'toasts.priceUpdated' => 'Preço atualizado',
			'toasts.created' => 'Produto criado',
			'toasts.deleted' => 'Produto excluído',
			'toasts.listUpdated' => 'Lista atualizada',
			'toasts.synced' => 'Catálogo sincronizado',
			'toasts.shared' => 'Compartilhado',
			'toasts.sentrySent' => ({required Object id}) => 'Erro de teste enviado · ${id}',
			'toasts.sentryDisabled' => 'O Sentry não está ativo neste build',
			'share.text' => ({required Object name, required Object price, required Object currency, required Object sku}) => 'Nome: ${name}\nPreço: ${price} ${currency}\nSKU: ${sku}',
			'settings.eyebrow' => 'PREFERÊNCIAS',
			'settings.title' => 'Ajustes',
			'settings.appearance' => 'Aparência',
			'settings.language' => 'Idioma',
			'settings.deviceLanguage' => 'Do dispositivo',
			'settings.data' => 'Dados',
			'settings.cache' => 'Cache local',
			'settings.cacheHint' => 'Mostra a última lista sem conexão',
			'settings.syncNow' => 'Sincronizar agora',
			'settings.syncedAt' => ({required Object time}) => 'Sincronizado ${time}',
			'settings.neverSynced' => 'Ainda não sincronizado',
			'settings.about' => 'Sobre',
			'settings.version' => 'Versão',
			'settings.diagnostics' => 'Diagnóstico',
			'settings.sentryTest' => 'Testar Sentry',
			'settings.sentryTestHint' => 'Envia um erro de teste ao painel',
			'a11y.page' => ({required Object n}) => 'Página ${n}',
			_ => null,
		};
	}
}
