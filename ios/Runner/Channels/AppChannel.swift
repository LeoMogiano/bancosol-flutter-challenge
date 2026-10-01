import Flutter

typealias ChannelHandler = (FlutterMethodCall, @escaping FlutterResult) -> Void

protocol AppChannel: AnyObject {
  var name: String { get }
  var handlers: [String: ChannelHandler] { get }
}

extension AppChannel {
  func register(with messenger: FlutterBinaryMessenger) {
    FlutterMethodChannel(name: name, binaryMessenger: messenger).setMethodCallHandler { [self] call, result in
      guard let handler = handlers[call.method] else { return result(FlutterMethodNotImplemented) }
      handler(call, result)
    }
  }
}
