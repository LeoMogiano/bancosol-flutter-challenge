import Flutter

enum PlatformChannels {
  private static let channels: [AppChannel] = [ShareChannel()]

  static func register(with registry: FlutterPluginRegistry) {
    guard let messenger = registry.registrar(forPlugin: "PlatformChannels")?.messenger() else { return }
    channels.forEach { $0.register(with: messenger) }
  }
}
