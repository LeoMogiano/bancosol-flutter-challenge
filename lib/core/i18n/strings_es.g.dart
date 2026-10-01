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

	/// es: 'Warehouse'
	String get appName => 'Warehouse';

	late final Translations$nav$es nav = Translations$nav$es.internal(_root);
	late final Translations$actions$es actions = Translations$actions$es.internal(_root);
	late final Translations$theme$es theme = Translations$theme$es.internal(_root);
	late final Translations$failures$es failures = Translations$failures$es.internal(_root);

	/// es: 'Ambiente: {env}'
	String environmentLabel({required Object env}) => 'Ambiente: ${env}';

	late final Translations$summary$es summary = Translations$summary$es.internal(_root);
	late final Translations$products$es products = Translations$products$es.internal(_root);
	late final Translations$stock$es stock = Translations$stock$es.internal(_root);
	late final Translations$filters$es filters = Translations$filters$es.internal(_root);
	late final Translations$detail$es detail = Translations$detail$es.internal(_root);
	late final Translations$priceEdit$es priceEdit = Translations$priceEdit$es.internal(_root);
	late final Translations$validation$es validation = Translations$validation$es.internal(_root);
	late final Translations$form$es form = Translations$form$es.internal(_root);
	late final Translations$delete$es delete = Translations$delete$es.internal(_root);
	late final Translations$toasts$es toasts = Translations$toasts$es.internal(_root);
	late final Translations$share$es share = Translations$share$es.internal(_root);
	late final Translations$settings$es settings = Translations$settings$es.internal(_root);
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

	/// es: 'Actualizar'
	String get refresh => 'Actualizar';

	/// es: 'Nuevo producto'
	String get newProduct => 'Nuevo producto';
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

// Path: summary
class Translations$summary$es {
	Translations$summary$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'GESTIÓN DE CATÁLOGO'
	String get eyebrow => 'GESTIÓN DE CATÁLOGO';

	/// es: 'Resumen'
	String get title => 'Resumen';

	/// es: 'Buscar por nombre o SKU'
	String get searchHint => 'Buscar por nombre o SKU';

	/// es: 'Valor del inventario'
	String get inventoryValue => 'Valor del inventario';

	/// es: 'Sincronizado {time}'
	String syncedAt({required Object time}) => 'Sincronizado ${time}';

	/// es: 'Precio × stock'
	String get formula => 'Precio × stock';

	/// es: 'Productos'
	String get statProducts => 'Productos';

	/// es: 'Stock bajo'
	String get statLowStock => 'Stock bajo';

	/// es: 'Sin stock'
	String get statOutOfStock => 'Sin stock';

	/// es: 'No pudimos cargar el catálogo'
	String get errorTitle => 'No pudimos cargar el catálogo';

	/// es: 'Revisa tu conexión e inténtalo nuevamente.'
	String get errorMessage => 'Revisa tu conexión e inténtalo nuevamente.';

	/// es: 'Lo sentimos, aún no hay productos'
	String get emptyTitle => 'Lo sentimos, aún no hay productos';

	/// es: 'Crea tu primer producto o actualiza para revisar si ya hay registros.'
	String get emptyMessage => 'Crea tu primer producto o actualiza para revisar si ya hay registros.';
}

// Path: products
class Translations$products$es {
	Translations$products$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'CATÁLOGO'
	String get eyebrow => 'CATÁLOGO';

	/// es: 'Productos'
	String get title => 'Productos';

	/// es: 'Nuevo'
	String get newShort => 'Nuevo';

	/// es: 'Nombre o SKU'
	String get searchHint => 'Nombre o SKU';

	/// es: '(one) {{n} resultado} (other) {{n} resultados}'
	String results({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '${n} resultado',
		other: '${n} resultados',
	);

	/// es: 'Quitar filtros'
	String get clearFilters => 'Quitar filtros';

	/// es: 'Mostrando {from}–{to} de {total}'
	String showing({required Object from, required Object to, required Object total}) => 'Mostrando ${from}–${to} de ${total}';

	/// es: 'Desliza para actualizar'
	String get pullToRefresh => 'Desliza para actualizar';

	/// es: 'Suelta para actualizar'
	String get releaseToRefresh => 'Suelta para actualizar';

	/// es: 'No pudimos obtener los productos'
	String get errorTitle => 'No pudimos obtener los productos';

	/// es: 'Inténtalo nuevamente en unos segundos.'
	String get errorMessage => 'Inténtalo nuevamente en unos segundos.';

	/// es: 'Lo sentimos, no hay productos'
	String get emptyTitle => 'Lo sentimos, no hay productos';

	/// es: 'Todavía no hay registros en el catálogo. Crea uno nuevo para empezar.'
	String get emptyMessage => 'Todavía no hay registros en el catálogo. Crea uno nuevo para empezar.';

	/// es: 'Sin resultados para “{query}”'
	String noResultsTitle({required Object query}) => 'Sin resultados para “${query}”';

	/// es: 'Ningún producto coincide'
	String get noResultsNoQuery => 'Ningún producto coincide';

	/// es: 'Revisa el nombre o el SKU, o quita algunos filtros.'
	String get noResultsMessage => 'Revisa el nombre o el SKU, o quita algunos filtros.';

	/// es: 'Limpiar búsqueda'
	String get clearSearch => 'Limpiar búsqueda';

	/// es: 'Datos offline'
	String get offline => 'Datos offline';

	/// es: 'Última sincronización {time}'
	String lastSync({required Object time}) => 'Última sincronización ${time}';
}

// Path: stock
class Translations$stock$es {
	Translations$stock$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Sin stock'
	String get out => 'Sin stock';

	/// es: '{n} en stock'
	String units({required Object n}) => '${n} en stock';
}

// Path: filters
class Translations$filters$es {
	Translations$filters$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Ordenar y filtrar'
	String get title => 'Ordenar y filtrar';

	/// es: 'Ordenar por'
	String get sortBy => 'Ordenar por';

	/// es: 'Mayor precio'
	String get priceDesc => 'Mayor precio';

	/// es: 'Menor precio'
	String get priceAsc => 'Menor precio';

	/// es: 'Nombre A–Z'
	String get nameAsc => 'Nombre A–Z';

	/// es: 'SKU'
	String get sku => 'SKU';

	/// es: 'Rango de precio (BOB)'
	String get priceRange => 'Rango de precio (BOB)';

	/// es: 'Mínimo'
	String get min => 'Mínimo';

	/// es: 'Máximo'
	String get max => 'Máximo';

	/// es: 'Moneda'
	String get currency => 'Moneda';

	/// es: 'Todas'
	String get all => 'Todas';

	/// es: 'Solo con stock'
	String get inStockOnly => 'Solo con stock';

	/// es: 'Oculta productos con stock 0'
	String get inStockOnlyHint => 'Oculta productos con stock 0';

	/// es: 'Restablecer'
	String get reset => 'Restablecer';

	/// es: '(one) {Ver {n} producto} (other) {Ver {n} productos}'
	String apply({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: 'Ver ${n} producto',
		other: 'Ver ${n} productos',
	);

	/// es: 'El mínimo no puede ser mayor que el máximo'
	String get rangeError => 'El mínimo no puede ser mayor que el máximo';
}

// Path: detail
class Translations$detail$es {
	Translations$detail$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Detalle del producto'
	String get title => 'Detalle del producto';

	/// es: 'Precio'
	String get price => 'Precio';

	/// es: 'Actualizado'
	String get updated => 'Actualizado';

	/// es: 'SKU'
	String get sku => 'SKU';

	/// es: 'Stock'
	String get stock => 'Stock';

	/// es: 'Moneda'
	String get currency => 'Moneda';

	/// es: 'ID'
	String get id => 'ID';

	/// es: 'Solo el precio es editable. El stock y la moneda se gestionan desde el sistema de origen.'
	String get note => 'Solo el precio es editable. El stock y la moneda se gestionan desde el sistema de origen.';

	/// es: 'Compartir'
	String get share => 'Compartir';

	/// es: 'Editar precio'
	String get editPrice => 'Editar precio';
}

// Path: priceEdit
class Translations$priceEdit$es {
	Translations$priceEdit$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Editar precio'
	String get title => 'Editar precio';

	/// es: 'Precio actual'
	String get currentPrice => 'Precio actual';

	/// es: 'Guardar precio'
	String get save => 'Guardar precio';

	/// es: 'Guardando…'
	String get saving => 'Guardando…';

	/// es: 'No se actualizó el precio'
	String get errorTitle => 'No se actualizó el precio';

	/// es: 'Ocurrió un problema con el servidor. Inténtalo nuevamente.'
	String get serverError => 'Ocurrió un problema con el servidor. Inténtalo nuevamente.';

	/// es: 'Sin conexión. Podrás guardar cuando vuelvas a estar en línea.'
	String get offlineError => 'Sin conexión. Podrás guardar cuando vuelvas a estar en línea.';

	/// es: 'Ej.: 1,500.50 · los miles se separan solos'
	String get help => 'Ej.: 1,500.50 · los miles se separan solos';

	/// es: 'Cambio de {percent}% respecto al actual. Verifica el monto.'
	String bigChange({required Object percent}) => 'Cambio de ${percent}% respecto al actual. Verifica el monto.';
}

// Path: validation
class Translations$validation$es {
	Translations$validation$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Ingresa un precio'
	String get priceEmpty => 'Ingresa un precio';

	/// es: 'Completa los centavos'
	String get priceIncomplete => 'Completa los centavos';

	/// es: 'El precio debe ser mayor a 0'
	String get priceNotPositive => 'El precio debe ser mayor a 0';

	/// es: 'El precio máximo es 999,999.99'
	String get priceTooHigh => 'El precio máximo es 999,999.99';

	/// es: 'La moneda no puede estar vacía'
	String get currencyEmpty => 'La moneda no puede estar vacía';

	/// es: 'Es el mismo precio actual'
	String get priceUnchanged => 'Es el mismo precio actual';

	/// es: 'El SKU es obligatorio'
	String get skuEmpty => 'El SKU es obligatorio';

	/// es: 'Mínimo 4 caracteres'
	String get skuTooShort => 'Mínimo 4 caracteres';

	/// es: 'Solo letras, números y guiones (ej. SKU-1029)'
	String get skuFormat => 'Solo letras, números y guiones (ej. SKU-1029)';

	/// es: 'Ya existe un producto con este SKU'
	String get skuDuplicate => 'Ya existe un producto con este SKU';

	/// es: 'El nombre es obligatorio'
	String get nameEmpty => 'El nombre es obligatorio';

	/// es: 'Mínimo 3 caracteres'
	String get nameTooShort => 'Mínimo 3 caracteres';

	/// es: 'El nombre no puede ser solo números'
	String get nameOnlyDigits => 'El nombre no puede ser solo números';

	/// es: 'Ya existe un producto con este nombre'
	String get nameDuplicate => 'Ya existe un producto con este nombre';

	/// es: 'Ingresa el stock'
	String get stockEmpty => 'Ingresa el stock';

	/// es: 'Máximo 99,999'
	String get stockTooHigh => 'Máximo 99,999';
}

// Path: form
class Translations$form$es {
	Translations$form$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Nuevo producto'
	String get title => 'Nuevo producto';

	/// es: 'SKU'
	String get sku => 'SKU';

	/// es: 'Nombre'
	String get name => 'Nombre';

	/// es: 'Precio'
	String get price => 'Precio';

	/// es: 'Stock'
	String get stock => 'Stock';

	/// es: 'Moneda'
	String get currency => 'Moneda';

	/// es: 'Crear producto'
	String get create => 'Crear producto';

	/// es: 'Creando…'
	String get creating => 'Creando…';

	/// es: 'No se creó el producto. Inténtalo nuevamente.'
	String get serverError => 'No se creó el producto. Inténtalo nuevamente.';

	/// es: 'Sin conexión. No se creó el producto.'
	String get offlineError => 'Sin conexión. No se creó el producto.';
}

// Path: delete
class Translations$delete$es {
	Translations$delete$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: '¿Eliminar producto?'
	String get title => '¿Eliminar producto?';

	/// es: 'Se eliminará {name} ({sku}) del catálogo. Esta acción no se puede deshacer.'
	String message({required Object name, required Object sku}) => 'Se eliminará ${name} (${sku}) del catálogo. Esta acción no se puede deshacer.';

	/// es: 'Eliminar'
	String get confirm => 'Eliminar';

	/// es: 'Eliminando…'
	String get deleting => 'Eliminando…';

	/// es: 'No se eliminó el producto. Inténtalo nuevamente.'
	String get serverError => 'No se eliminó el producto. Inténtalo nuevamente.';

	/// es: 'Sin conexión. No se eliminó el producto.'
	String get offlineError => 'Sin conexión. No se eliminó el producto.';
}

// Path: toasts
class Translations$toasts$es {
	Translations$toasts$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Precio actualizado'
	String get priceUpdated => 'Precio actualizado';

	/// es: 'Producto creado'
	String get created => 'Producto creado';

	/// es: 'Producto eliminado'
	String get deleted => 'Producto eliminado';

	/// es: 'Lista actualizada'
	String get listUpdated => 'Lista actualizada';

	/// es: 'Catálogo sincronizado'
	String get synced => 'Catálogo sincronizado';

	/// es: 'Compartido'
	String get shared => 'Compartido';

	/// es: 'Error de prueba enviado · {id}'
	String sentrySent({required Object id}) => 'Error de prueba enviado · ${id}';

	/// es: 'Sentry no está activo en este build'
	String get sentryDisabled => 'Sentry no está activo en este build';
}

// Path: share
class Translations$share$es {
	Translations$share$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'Nombre: {name} Precio: {price} {currency} SKU: {sku}'
	String text({required Object name, required Object price, required Object currency, required Object sku}) => 'Nombre: ${name}\nPrecio: ${price} ${currency}\nSKU: ${sku}';
}

// Path: settings
class Translations$settings$es {
	Translations$settings$es.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// es: 'PREFERENCIAS'
	String get eyebrow => 'PREFERENCIAS';

	/// es: 'Ajustes'
	String get title => 'Ajustes';

	/// es: 'Apariencia'
	String get appearance => 'Apariencia';

	/// es: 'Idioma'
	String get language => 'Idioma';

	/// es: 'Del dispositivo'
	String get deviceLanguage => 'Del dispositivo';

	/// es: 'Datos'
	String get data => 'Datos';

	/// es: 'Cache local'
	String get cache => 'Cache local';

	/// es: 'Muestra el último listado sin conexión'
	String get cacheHint => 'Muestra el último listado sin conexión';

	/// es: 'Sincronizar ahora'
	String get syncNow => 'Sincronizar ahora';

	/// es: 'Sincronizado {time}'
	String syncedAt({required Object time}) => 'Sincronizado ${time}';

	/// es: 'Sin sincronizar'
	String get neverSynced => 'Sin sincronizar';

	/// es: 'Acerca de'
	String get about => 'Acerca de';

	/// es: 'Versión'
	String get version => 'Versión';

	/// es: 'Diagnóstico'
	String get diagnostics => 'Diagnóstico';

	/// es: 'Probar Sentry'
	String get sentryTest => 'Probar Sentry';

	/// es: 'Envía un error de prueba al dashboard'
	String get sentryTestHint => 'Envía un error de prueba al dashboard';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Warehouse',
			'nav.summary' => 'Resumen',
			'nav.products' => 'Productos',
			'nav.settings' => 'Ajustes',
			'actions.retry' => 'Reintentar',
			'actions.cancel' => 'Cancelar',
			'actions.refresh' => 'Actualizar',
			'actions.newProduct' => 'Nuevo producto',
			'theme.light' => 'Claro',
			'theme.dark' => 'Oscuro',
			'failures.network' => 'Sin conexión. Revisa tu conexión e inténtalo nuevamente.',
			'failures.timeout' => 'El servidor tardó demasiado en responder. Inténtalo nuevamente.',
			'failures.notFound' => 'Este producto ya no existe. Actualiza la lista.',
			'failures.rateLimit' => 'Hiciste muchas solicitudes seguidas. Espera unos segundos e inténtalo nuevamente.',
			'failures.server' => 'Ocurrió un problema con el servidor. Inténtalo nuevamente.',
			'failures.cache' => 'No pudimos leer los datos guardados en el dispositivo.',
			'failures.unexpected' => 'Ocurrió un problema inesperado. Inténtalo nuevamente.',
			'environmentLabel' => ({required Object env}) => 'Ambiente: ${env}',
			'summary.eyebrow' => 'GESTIÓN DE CATÁLOGO',
			'summary.title' => 'Resumen',
			'summary.searchHint' => 'Buscar por nombre o SKU',
			'summary.inventoryValue' => 'Valor del inventario',
			'summary.syncedAt' => ({required Object time}) => 'Sincronizado ${time}',
			'summary.formula' => 'Precio × stock',
			'summary.statProducts' => 'Productos',
			'summary.statLowStock' => 'Stock bajo',
			'summary.statOutOfStock' => 'Sin stock',
			'summary.errorTitle' => 'No pudimos cargar el catálogo',
			'summary.errorMessage' => 'Revisa tu conexión e inténtalo nuevamente.',
			'summary.emptyTitle' => 'Lo sentimos, aún no hay productos',
			'summary.emptyMessage' => 'Crea tu primer producto o actualiza para revisar si ya hay registros.',
			'products.eyebrow' => 'CATÁLOGO',
			'products.title' => 'Productos',
			'products.newShort' => 'Nuevo',
			'products.searchHint' => 'Nombre o SKU',
			'products.results' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '${n} resultado', other: '${n} resultados', ), 
			'products.clearFilters' => 'Quitar filtros',
			'products.showing' => ({required Object from, required Object to, required Object total}) => 'Mostrando ${from}–${to} de ${total}',
			'products.pullToRefresh' => 'Desliza para actualizar',
			'products.releaseToRefresh' => 'Suelta para actualizar',
			'products.errorTitle' => 'No pudimos obtener los productos',
			'products.errorMessage' => 'Inténtalo nuevamente en unos segundos.',
			'products.emptyTitle' => 'Lo sentimos, no hay productos',
			'products.emptyMessage' => 'Todavía no hay registros en el catálogo. Crea uno nuevo para empezar.',
			'products.noResultsTitle' => ({required Object query}) => 'Sin resultados para “${query}”',
			'products.noResultsNoQuery' => 'Ningún producto coincide',
			'products.noResultsMessage' => 'Revisa el nombre o el SKU, o quita algunos filtros.',
			'products.clearSearch' => 'Limpiar búsqueda',
			'products.offline' => 'Datos offline',
			'products.lastSync' => ({required Object time}) => 'Última sincronización ${time}',
			'stock.out' => 'Sin stock',
			'stock.units' => ({required Object n}) => '${n} en stock',
			'filters.title' => 'Ordenar y filtrar',
			'filters.sortBy' => 'Ordenar por',
			'filters.priceDesc' => 'Mayor precio',
			'filters.priceAsc' => 'Menor precio',
			'filters.nameAsc' => 'Nombre A–Z',
			'filters.sku' => 'SKU',
			'filters.priceRange' => 'Rango de precio (BOB)',
			'filters.min' => 'Mínimo',
			'filters.max' => 'Máximo',
			'filters.currency' => 'Moneda',
			'filters.all' => 'Todas',
			'filters.inStockOnly' => 'Solo con stock',
			'filters.inStockOnlyHint' => 'Oculta productos con stock 0',
			'filters.reset' => 'Restablecer',
			'filters.apply' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: 'Ver ${n} producto', other: 'Ver ${n} productos', ), 
			'filters.rangeError' => 'El mínimo no puede ser mayor que el máximo',
			'detail.title' => 'Detalle del producto',
			'detail.price' => 'Precio',
			'detail.updated' => 'Actualizado',
			'detail.sku' => 'SKU',
			'detail.stock' => 'Stock',
			'detail.currency' => 'Moneda',
			'detail.id' => 'ID',
			'detail.note' => 'Solo el precio es editable. El stock y la moneda se gestionan desde el sistema de origen.',
			'detail.share' => 'Compartir',
			'detail.editPrice' => 'Editar precio',
			'priceEdit.title' => 'Editar precio',
			'priceEdit.currentPrice' => 'Precio actual',
			'priceEdit.save' => 'Guardar precio',
			'priceEdit.saving' => 'Guardando…',
			'priceEdit.errorTitle' => 'No se actualizó el precio',
			'priceEdit.serverError' => 'Ocurrió un problema con el servidor. Inténtalo nuevamente.',
			'priceEdit.offlineError' => 'Sin conexión. Podrás guardar cuando vuelvas a estar en línea.',
			'priceEdit.help' => 'Ej.: 1,500.50 · los miles se separan solos',
			'priceEdit.bigChange' => ({required Object percent}) => 'Cambio de ${percent}% respecto al actual. Verifica el monto.',
			'validation.priceEmpty' => 'Ingresa un precio',
			'validation.priceIncomplete' => 'Completa los centavos',
			'validation.priceNotPositive' => 'El precio debe ser mayor a 0',
			'validation.priceTooHigh' => 'El precio máximo es 999,999.99',
			'validation.currencyEmpty' => 'La moneda no puede estar vacía',
			'validation.priceUnchanged' => 'Es el mismo precio actual',
			'validation.skuEmpty' => 'El SKU es obligatorio',
			'validation.skuTooShort' => 'Mínimo 4 caracteres',
			'validation.skuFormat' => 'Solo letras, números y guiones (ej. SKU-1029)',
			'validation.skuDuplicate' => 'Ya existe un producto con este SKU',
			'validation.nameEmpty' => 'El nombre es obligatorio',
			'validation.nameTooShort' => 'Mínimo 3 caracteres',
			'validation.nameOnlyDigits' => 'El nombre no puede ser solo números',
			'validation.nameDuplicate' => 'Ya existe un producto con este nombre',
			'validation.stockEmpty' => 'Ingresa el stock',
			'validation.stockTooHigh' => 'Máximo 99,999',
			'form.title' => 'Nuevo producto',
			'form.sku' => 'SKU',
			'form.name' => 'Nombre',
			'form.price' => 'Precio',
			'form.stock' => 'Stock',
			'form.currency' => 'Moneda',
			'form.create' => 'Crear producto',
			'form.creating' => 'Creando…',
			'form.serverError' => 'No se creó el producto. Inténtalo nuevamente.',
			'form.offlineError' => 'Sin conexión. No se creó el producto.',
			'delete.title' => '¿Eliminar producto?',
			'delete.message' => ({required Object name, required Object sku}) => 'Se eliminará ${name} (${sku}) del catálogo. Esta acción no se puede deshacer.',
			'delete.confirm' => 'Eliminar',
			'delete.deleting' => 'Eliminando…',
			'delete.serverError' => 'No se eliminó el producto. Inténtalo nuevamente.',
			'delete.offlineError' => 'Sin conexión. No se eliminó el producto.',
			'toasts.priceUpdated' => 'Precio actualizado',
			'toasts.created' => 'Producto creado',
			'toasts.deleted' => 'Producto eliminado',
			'toasts.listUpdated' => 'Lista actualizada',
			'toasts.synced' => 'Catálogo sincronizado',
			'toasts.shared' => 'Compartido',
			'toasts.sentrySent' => ({required Object id}) => 'Error de prueba enviado · ${id}',
			'toasts.sentryDisabled' => 'Sentry no está activo en este build',
			'share.text' => ({required Object name, required Object price, required Object currency, required Object sku}) => 'Nombre: ${name}\nPrecio: ${price} ${currency}\nSKU: ${sku}',
			'settings.eyebrow' => 'PREFERENCIAS',
			'settings.title' => 'Ajustes',
			'settings.appearance' => 'Apariencia',
			'settings.language' => 'Idioma',
			'settings.deviceLanguage' => 'Del dispositivo',
			'settings.data' => 'Datos',
			'settings.cache' => 'Cache local',
			'settings.cacheHint' => 'Muestra el último listado sin conexión',
			'settings.syncNow' => 'Sincronizar ahora',
			'settings.syncedAt' => ({required Object time}) => 'Sincronizado ${time}',
			'settings.neverSynced' => 'Sin sincronizar',
			'settings.about' => 'Acerca de',
			'settings.version' => 'Versión',
			'settings.diagnostics' => 'Diagnóstico',
			'settings.sentryTest' => 'Probar Sentry',
			'settings.sentryTestHint' => 'Envía un error de prueba al dashboard',
			_ => null,
		};
	}
}
