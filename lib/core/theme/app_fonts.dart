// Cada valor debe coincidir con un `family` declarado en pubspec.yaml.
enum AppFont {
  outfit('Outfit'),
  playfairDisplay('PlayfairDisplay');

  AppFont(this.family);

  final String family;
}
