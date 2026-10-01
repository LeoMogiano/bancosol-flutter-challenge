import Flutter
import UIKit

final class ShareChannel: AppChannel {
  let name = "app/share"
  var handlers: [String: ChannelHandler] { ["shareText": shareText] }

  private func shareText(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any], let text = args["text"] as? String, !text.isEmpty,
          let presenter = topViewController() else {
      return result(FlutterError(code: "SHARE_FAILED", message: "nothing to share", details: nil))
    }
    let sheet = UIActivityViewController(activityItems: [text], applicationActivities: nil)
    // iPad exige un ancla para el popover.
    sheet.popoverPresentationController?.sourceView = presenter.view
    sheet.popoverPresentationController?.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.maxY, width: 0, height: 0)
    sheet.completionWithItemsHandler = { _, completed, _, _ in result(completed) }
    presenter.present(sheet, animated: true)
  }

  private func topViewController() -> UIViewController? {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first { $0.isKeyWindow }
    var top = window?.rootViewController
    while let presented = top?.presentedViewController { top = presented }
    return top
  }
}
