import UIKit

/// The phone's own screen: the controller.
final class PhoneSceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else { return }

		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = ControllerViewController()
		self.window = window
		window.makeKeyAndVisible()
	}
}
