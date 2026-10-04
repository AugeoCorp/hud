import OSLog
import UIKit

/// The glasses. A full-screen web view that takes no touches.
final class ExternalDisplaySceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	private let logger = Logger(subsystem: "com.augeocorp.hud", category: "display")

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else { return }

		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = ExternalDisplayViewController()
		self.window = window
		window.makeKeyAndVisible()
		reportSize(of: windowScene)
	}

	func windowScene(
		_ windowScene: UIWindowScene,
		didUpdate previousCoordinateSpace: UICoordinateSpace,
		interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation,
		traitCollection previousTraitCollection: UITraitCollection
	) {
		reportSize(of: windowScene)
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// When the glasses switch modes, the new scene can connect before the
		// old one goes away. Only let go of the web view if it's still ours.
		let webView = HUDDisplay.shared.webView
		if let window, webView.window === window {
			webView.removeFromSuperview()
			HUDDisplay.shared.displayDisconnected()
		}
		window = nil
	}

	private func reportSize(of windowScene: UIWindowScene) {
		let screen = windowScene.screen
		let modes = screen.availableModes.map { "\($0.size)" }
		let message =
			"bounds \(screen.bounds.size), scale \(screen.scale), "
			+ "modes \(modes.joined(separator: ", "))"
		logger.info("Glasses display: \(message, privacy: .public)")
		HUDDisplay.shared.displayConnected(size: screen.bounds.size)
	}
}

private final class ExternalDisplayViewController: UIViewController {
	override func loadView() {
		let view = UIView()
		view.backgroundColor = .black

		let webView = HUDDisplay.shared.webView
		webView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(webView)
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: view.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])

		self.view = view
	}
}
