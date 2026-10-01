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
	@override String get appName => 'Warehouse';
	@override late final _Translations$nav$en nav = _Translations$nav$en._(_root);
	@override late final _Translations$actions$en actions = _Translations$actions$en._(_root);
	@override late final _Translations$theme$en theme = _Translations$theme$en._(_root);
	@override late final _Translations$failures$en failures = _Translations$failures$en._(_root);
	@override String environmentLabel({required Object env}) => 'Environment: ${env}';
	@override late final _Translations$summary$en summary = _Translations$summary$en._(_root);
	@override late final _Translations$products$en products = _Translations$products$en._(_root);
	@override late final _Translations$stock$en stock = _Translations$stock$en._(_root);
	@override late final _Translations$filters$en filters = _Translations$filters$en._(_root);
	@override late final _Translations$detail$en detail = _Translations$detail$en._(_root);
	@override late final _Translations$priceEdit$en priceEdit = _Translations$priceEdit$en._(_root);
	@override late final _Translations$validation$en validation = _Translations$validation$en._(_root);
	@override late final _Translations$form$en form = _Translations$form$en._(_root);
	@override late final _Translations$delete$en delete = _Translations$delete$en._(_root);
	@override late final _Translations$toasts$en toasts = _Translations$toasts$en._(_root);
	@override late final _Translations$share$en share = _Translations$share$en._(_root);
	@override late final _Translations$settings$en settings = _Translations$settings$en._(_root);
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
	@override String get refresh => 'Refresh';
	@override String get newProduct => 'New product';
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

// Path: summary
class _Translations$summary$en extends Translations$summary$es {
	_Translations$summary$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'CATALOG MANAGEMENT';
	@override String get title => 'Summary';
	@override String get searchHint => 'Search by name or SKU';
	@override String get inventoryValue => 'Inventory value';
	@override String syncedAt({required Object time}) => 'Synced ${time}';
	@override String get formula => 'Price × stock';
	@override String get statProducts => 'Products';
	@override String get statLowStock => 'Low stock';
	@override String get statOutOfStock => 'Out of stock';
	@override String get errorTitle => 'We couldn\'t load the catalog';
	@override String get errorMessage => 'Check your connection and try again.';
	@override String get emptyTitle => 'Sorry, there are no products yet';
	@override String get emptyMessage => 'Create your first product or refresh to check for records.';
}

// Path: products
class _Translations$products$en extends Translations$products$es {
	_Translations$products$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'CATALOG';
	@override String get title => 'Products';
	@override String get newShort => 'New';
	@override String get searchHint => 'Name or SKU';
	@override String results({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '${n} result',
		other: '${n} results',
	);
	@override String get clearFilters => 'Clear filters';
	@override String showing({required Object from, required Object to, required Object total}) => 'Showing ${from}–${to} of ${total}';
	@override String get pullToRefresh => 'Pull to refresh';
	@override String get releaseToRefresh => 'Release to refresh';
	@override String get errorTitle => 'We couldn\'t get the products';
	@override String get errorMessage => 'Try again in a few seconds.';
	@override String get emptyTitle => 'Sorry, there are no products';
	@override String get emptyMessage => 'There are no records in the catalog yet. Create one to get started.';
	@override String noResultsTitle({required Object query}) => 'No results for “${query}”';
	@override String get noResultsNoQuery => 'No product matches';
	@override String get noResultsMessage => 'Check the name or SKU, or remove some filters.';
	@override String get clearSearch => 'Clear search';
	@override String get offline => 'Offline data';
	@override String lastSync({required Object time}) => 'Last sync ${time}';
}

// Path: stock
class _Translations$stock$en extends Translations$stock$es {
	_Translations$stock$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get out => 'Out of stock';
	@override String units({required Object n}) => '${n} in stock';
}

// Path: filters
class _Translations$filters$en extends Translations$filters$es {
	_Translations$filters$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sort and filter';
	@override String get sortBy => 'Sort by';
	@override String get priceDesc => 'Highest price';
	@override String get priceAsc => 'Lowest price';
	@override String get nameAsc => 'Name A–Z';
	@override String get sku => 'SKU';
	@override String get priceRange => 'Price range (BOB)';
	@override String get min => 'Minimum';
	@override String get max => 'Maximum';
	@override String get currency => 'Currency';
	@override String get all => 'All';
	@override String get inStockOnly => 'In stock only';
	@override String get inStockOnlyHint => 'Hides products with stock 0';
	@override String get reset => 'Reset';
	@override String apply({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Show ${n} product',
		other: 'Show ${n} products',
	);
	@override String get rangeError => 'Minimum cannot be greater than maximum';
}

// Path: detail
class _Translations$detail$en extends Translations$detail$es {
	_Translations$detail$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Product detail';
	@override String get price => 'Price';
	@override String get updated => 'Updated';
	@override String get sku => 'SKU';
	@override String get stock => 'Stock';
	@override String get currency => 'Currency';
	@override String get id => 'ID';
	@override String get note => 'Only the price is editable. Stock and currency are managed in the source system.';
	@override String get share => 'Share';
	@override String get editPrice => 'Edit price';
}

// Path: priceEdit
class _Translations$priceEdit$en extends Translations$priceEdit$es {
	_Translations$priceEdit$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edit price';
	@override String get currentPrice => 'Current price';
	@override String get save => 'Save price';
	@override String get saving => 'Saving…';
	@override String get errorTitle => 'The price was not updated';
	@override String get serverError => 'A server error occurred. Try again.';
	@override String get offlineError => 'No connection. You\'ll be able to save when you\'re back online.';
	@override String get help => 'E.g. 1,500.50 · thousands are separated automatically';
	@override String bigChange({required Object percent}) => '${percent}% change from current. Check the amount.';
}

// Path: validation
class _Translations$validation$en extends Translations$validation$es {
	_Translations$validation$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get priceEmpty => 'Enter a price';
	@override String get priceIncomplete => 'Complete the cents';
	@override String get priceNotPositive => 'Price must be greater than 0';
	@override String get priceTooHigh => 'Maximum price is 999,999.99';
	@override String get currencyEmpty => 'Currency cannot be empty';
	@override String get priceUnchanged => 'It\'s the same as the current price';
	@override String get skuEmpty => 'SKU is required';
	@override String get skuTooShort => 'At least 4 characters';
	@override String get skuFormat => 'Only letters, numbers and hyphens (e.g. SKU-1029)';
	@override String get skuDuplicate => 'A product with this SKU already exists';
	@override String get nameEmpty => 'Name is required';
	@override String get nameTooShort => 'At least 3 characters';
	@override String get nameOnlyDigits => 'Name cannot be only numbers';
	@override String get nameDuplicate => 'A product with this name already exists';
	@override String get stockEmpty => 'Enter the stock';
	@override String get stockTooHigh => 'Maximum 99,999';
}

// Path: form
class _Translations$form$en extends Translations$form$es {
	_Translations$form$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'New product';
	@override String get sku => 'SKU';
	@override String get name => 'Name';
	@override String get price => 'Price';
	@override String get stock => 'Stock';
	@override String get currency => 'Currency';
	@override String get create => 'Create product';
	@override String get creating => 'Creating…';
	@override String get serverError => 'The product was not created. Try again.';
	@override String get offlineError => 'No connection. The product was not created.';
}

// Path: delete
class _Translations$delete$en extends Translations$delete$es {
	_Translations$delete$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delete product?';
	@override String message({required Object name, required Object sku}) => '${name} (${sku}) will be removed from the catalog. This action cannot be undone.';
	@override String get confirm => 'Delete';
	@override String get deleting => 'Deleting…';
	@override String get serverError => 'The product was not deleted. Try again.';
	@override String get offlineError => 'No connection. The product was not deleted.';
}

// Path: toasts
class _Translations$toasts$en extends Translations$toasts$es {
	_Translations$toasts$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get priceUpdated => 'Price updated';
	@override String get created => 'Product created';
	@override String get deleted => 'Product deleted';
	@override String get listUpdated => 'List updated';
	@override String get synced => 'Catalog synced';
	@override String get shared => 'Shared';
	@override String sentrySent({required Object id}) => 'Test error sent · ${id}';
	@override String get sentryDisabled => 'Sentry is not enabled in this build';
}

// Path: share
class _Translations$share$en extends Translations$share$es {
	_Translations$share$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String text({required Object name, required Object price, required Object currency, required Object sku}) => 'Name: ${name}\nPrice: ${price} ${currency}\nSKU: ${sku}';
}

// Path: settings
class _Translations$settings$en extends Translations$settings$es {
	_Translations$settings$en._(TranslationsEn root) : this._root = root, super.internal(root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get eyebrow => 'PREFERENCES';
	@override String get title => 'Settings';
	@override String get appearance => 'Appearance';
	@override String get language => 'Language';
	@override String get deviceLanguage => 'Device';
	@override String get data => 'Data';
	@override String get cache => 'Local cache';
	@override String get cacheHint => 'Shows the last list while offline';
	@override String get syncNow => 'Sync now';
	@override String syncedAt({required Object time}) => 'Synced ${time}';
	@override String get neverSynced => 'Not synced yet';
	@override String get about => 'About';
	@override String get version => 'Version';
	@override String get diagnostics => 'Diagnostics';
	@override String get sentryTest => 'Test Sentry';
	@override String get sentryTestHint => 'Sends a test error to the dashboard';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Warehouse',
			'nav.summary' => 'Summary',
			'nav.products' => 'Products',
			'nav.settings' => 'Settings',
			'actions.retry' => 'Retry',
			'actions.cancel' => 'Cancel',
			'actions.refresh' => 'Refresh',
			'actions.newProduct' => 'New product',
			'theme.light' => 'Light',
			'theme.dark' => 'Dark',
			'failures.network' => 'No connection. Check your connection and try again.',
			'failures.timeout' => 'The server took too long to respond. Try again.',
			'failures.notFound' => 'This product no longer exists. Refresh the list.',
			'failures.rateLimit' => 'You made too many requests in a row. Wait a few seconds and try again.',
			'failures.server' => 'A server error occurred. Try again.',
			'failures.cache' => 'We couldn\'t read the data stored on your device.',
			'failures.unexpected' => 'An unexpected error occurred. Try again.',
			'environmentLabel' => ({required Object env}) => 'Environment: ${env}',
			'summary.eyebrow' => 'CATALOG MANAGEMENT',
			'summary.title' => 'Summary',
			'summary.searchHint' => 'Search by name or SKU',
			'summary.inventoryValue' => 'Inventory value',
			'summary.syncedAt' => ({required Object time}) => 'Synced ${time}',
			'summary.formula' => 'Price × stock',
			'summary.statProducts' => 'Products',
			'summary.statLowStock' => 'Low stock',
			'summary.statOutOfStock' => 'Out of stock',
			'summary.errorTitle' => 'We couldn\'t load the catalog',
			'summary.errorMessage' => 'Check your connection and try again.',
			'summary.emptyTitle' => 'Sorry, there are no products yet',
			'summary.emptyMessage' => 'Create your first product or refresh to check for records.',
			'products.eyebrow' => 'CATALOG',
			'products.title' => 'Products',
			'products.newShort' => 'New',
			'products.searchHint' => 'Name or SKU',
			'products.results' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '${n} result', other: '${n} results', ), 
			'products.clearFilters' => 'Clear filters',
			'products.showing' => ({required Object from, required Object to, required Object total}) => 'Showing ${from}–${to} of ${total}',
			'products.pullToRefresh' => 'Pull to refresh',
			'products.releaseToRefresh' => 'Release to refresh',
			'products.errorTitle' => 'We couldn\'t get the products',
			'products.errorMessage' => 'Try again in a few seconds.',
			'products.emptyTitle' => 'Sorry, there are no products',
			'products.emptyMessage' => 'There are no records in the catalog yet. Create one to get started.',
			'products.noResultsTitle' => ({required Object query}) => 'No results for “${query}”',
			'products.noResultsNoQuery' => 'No product matches',
			'products.noResultsMessage' => 'Check the name or SKU, or remove some filters.',
			'products.clearSearch' => 'Clear search',
			'products.offline' => 'Offline data',
			'products.lastSync' => ({required Object time}) => 'Last sync ${time}',
			'stock.out' => 'Out of stock',
			'stock.units' => ({required Object n}) => '${n} in stock',
			'filters.title' => 'Sort and filter',
			'filters.sortBy' => 'Sort by',
			'filters.priceDesc' => 'Highest price',
			'filters.priceAsc' => 'Lowest price',
			'filters.nameAsc' => 'Name A–Z',
			'filters.sku' => 'SKU',
			'filters.priceRange' => 'Price range (BOB)',
			'filters.min' => 'Minimum',
			'filters.max' => 'Maximum',
			'filters.currency' => 'Currency',
			'filters.all' => 'All',
			'filters.inStockOnly' => 'In stock only',
			'filters.inStockOnlyHint' => 'Hides products with stock 0',
			'filters.reset' => 'Reset',
			'filters.apply' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Show ${n} product', other: 'Show ${n} products', ), 
			'filters.rangeError' => 'Minimum cannot be greater than maximum',
			'detail.title' => 'Product detail',
			'detail.price' => 'Price',
			'detail.updated' => 'Updated',
			'detail.sku' => 'SKU',
			'detail.stock' => 'Stock',
			'detail.currency' => 'Currency',
			'detail.id' => 'ID',
			'detail.note' => 'Only the price is editable. Stock and currency are managed in the source system.',
			'detail.share' => 'Share',
			'detail.editPrice' => 'Edit price',
			'priceEdit.title' => 'Edit price',
			'priceEdit.currentPrice' => 'Current price',
			'priceEdit.save' => 'Save price',
			'priceEdit.saving' => 'Saving…',
			'priceEdit.errorTitle' => 'The price was not updated',
			'priceEdit.serverError' => 'A server error occurred. Try again.',
			'priceEdit.offlineError' => 'No connection. You\'ll be able to save when you\'re back online.',
			'priceEdit.help' => 'E.g. 1,500.50 · thousands are separated automatically',
			'priceEdit.bigChange' => ({required Object percent}) => '${percent}% change from current. Check the amount.',
			'validation.priceEmpty' => 'Enter a price',
			'validation.priceIncomplete' => 'Complete the cents',
			'validation.priceNotPositive' => 'Price must be greater than 0',
			'validation.priceTooHigh' => 'Maximum price is 999,999.99',
			'validation.currencyEmpty' => 'Currency cannot be empty',
			'validation.priceUnchanged' => 'It\'s the same as the current price',
			'validation.skuEmpty' => 'SKU is required',
			'validation.skuTooShort' => 'At least 4 characters',
			'validation.skuFormat' => 'Only letters, numbers and hyphens (e.g. SKU-1029)',
			'validation.skuDuplicate' => 'A product with this SKU already exists',
			'validation.nameEmpty' => 'Name is required',
			'validation.nameTooShort' => 'At least 3 characters',
			'validation.nameOnlyDigits' => 'Name cannot be only numbers',
			'validation.nameDuplicate' => 'A product with this name already exists',
			'validation.stockEmpty' => 'Enter the stock',
			'validation.stockTooHigh' => 'Maximum 99,999',
			'form.title' => 'New product',
			'form.sku' => 'SKU',
			'form.name' => 'Name',
			'form.price' => 'Price',
			'form.stock' => 'Stock',
			'form.currency' => 'Currency',
			'form.create' => 'Create product',
			'form.creating' => 'Creating…',
			'form.serverError' => 'The product was not created. Try again.',
			'form.offlineError' => 'No connection. The product was not created.',
			'delete.title' => 'Delete product?',
			'delete.message' => ({required Object name, required Object sku}) => '${name} (${sku}) will be removed from the catalog. This action cannot be undone.',
			'delete.confirm' => 'Delete',
			'delete.deleting' => 'Deleting…',
			'delete.serverError' => 'The product was not deleted. Try again.',
			'delete.offlineError' => 'No connection. The product was not deleted.',
			'toasts.priceUpdated' => 'Price updated',
			'toasts.created' => 'Product created',
			'toasts.deleted' => 'Product deleted',
			'toasts.listUpdated' => 'List updated',
			'toasts.synced' => 'Catalog synced',
			'toasts.shared' => 'Shared',
			'toasts.sentrySent' => ({required Object id}) => 'Test error sent · ${id}',
			'toasts.sentryDisabled' => 'Sentry is not enabled in this build',
			'share.text' => ({required Object name, required Object price, required Object currency, required Object sku}) => 'Name: ${name}\nPrice: ${price} ${currency}\nSKU: ${sku}',
			'settings.eyebrow' => 'PREFERENCES',
			'settings.title' => 'Settings',
			'settings.appearance' => 'Appearance',
			'settings.language' => 'Language',
			'settings.deviceLanguage' => 'Device',
			'settings.data' => 'Data',
			'settings.cache' => 'Local cache',
			'settings.cacheHint' => 'Shows the last list while offline',
			'settings.syncNow' => 'Sync now',
			'settings.syncedAt' => ({required Object time}) => 'Synced ${time}',
			'settings.neverSynced' => 'Not synced yet',
			'settings.about' => 'About',
			'settings.version' => 'Version',
			'settings.diagnostics' => 'Diagnostics',
			'settings.sentryTest' => 'Test Sentry',
			'settings.sentryTestHint' => 'Sends a test error to the dashboard',
			_ => null,
		};
	}
}
