import Flutter

enum PlatformChannels {
  private static let channels: [AppChannel] = [ShareChannel()]

  static func register(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "PlatformChannels") else { return }
    channels.forEach { $0.register(with: registrar.messenger()) }
  }
}
