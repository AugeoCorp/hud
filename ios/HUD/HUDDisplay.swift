import UIKit
import WebKit

/// State shared by the phone and glasses scenes. Both live in one process, so
/// this is a plain object. The web view lives here, not in the glasses scene,
/// so the page survives the display reconnecting when the glasses switch
/// between 2D and Full SBS.
@MainActor
final class HUDDisplay {
	static let shared = HUDDisplay()

	let webView: WKWebView
	private(set) var url: URL?
	/// Size of the connected glasses display in points, nil when none.
	private(set) var displaySize: CGSize? {
		didSet { onChange?() }
	}
	var onChange: (() -> Void)?

	private static let urlKey = "hudURL"

	private init() {
		webView = WKWebView(frame: .zero)
		webView.isOpaque = false
		webView.backgroundColor = .black
		webView.scrollView.contentInsetAdjustmentBehavior = .never

		if let saved = UserDefaults.standard.url(forKey: Self.urlKey) {
			load(saved)
		} else {
			webView.loadHTMLString(Self.placeholderHTML, baseURL: nil)
		}
	}

	func load(_ url: URL) {
		self.url = url
		UserDefaults.standard.set(url, forKey: Self.urlKey)
		webView.load(URLRequest(url: url))
	}

	func displayConnected(size: CGSize) {
		displaySize = size
	}

	func displayDisconnected() {
		displaySize = nil
	}

	private static let placeholderHTML = """
		<meta name="viewport" content="width=device-width">
		<body style="background:#000;color:#fff;font:48px -apple-system;
		display:grid;place-items:center;height:100vh;margin:0">
		Set the HUD address on your phone
		</body>
		"""
}
