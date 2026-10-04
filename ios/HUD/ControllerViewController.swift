import UIKit

/// The phone screen. Sets the HUD address and shows the glasses' status.
/// Registering the scene accessory here is what gets the app a glasses scene
/// (iOS 27+), and that scene only lives while this controller is shown.
final class ControllerViewController: UIViewController, UITextFieldDelegate {
	private var displayRegistration: UISceneAccessoryRegistration?
	private let addressField = UITextField()
	private let statusLabel = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		layout()

		let configuration = UISceneConfiguration()
		configuration.delegateClass = ExternalDisplaySceneDelegate.self
		displayRegistration = registerSceneAccessory(
			UISceneAccessory.externalNonInteractive(
				sceneConfiguration: configuration
			)
		)

		HUDDisplay.shared.onChange = { [weak self] in self?.updateStatus() }
		updateStatus()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Keep the phone awake. The glasses scene probably drops when the phone
		// locks; not yet checked on a device.
		UIApplication.shared.isIdleTimerDisabled = true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if let url = Self.url(from: textField.text ?? "") {
			HUDDisplay.shared.load(url)
		}
		return true
	}

	private func updateStatus() {
		guard let size = HUDDisplay.shared.displaySize else {
			statusLabel.text = "No glasses connected"
			return
		}
		let mode = size.width / size.height >= 3 ? "Full SBS 3D" : "2D"
		statusLabel.text =
			"Glasses: \(Int(size.width))×\(Int(size.height)), \(mode)"
	}

	private func layout() {
		addressField.placeholder = "http://100.x.y.z:3000"
		addressField.text = HUDDisplay.shared.url?.absoluteString
		addressField.borderStyle = .roundedRect
		addressField.keyboardType = .URL
		addressField.autocapitalizationType = .none
		addressField.autocorrectionType = .no
		addressField.returnKeyType = .go
		addressField.clearButtonMode = .whileEditing
		addressField.delegate = self

		statusLabel.font = .preferredFont(forTextStyle: .body)
		statusLabel.textColor = .secondaryLabel
		statusLabel.numberOfLines = 0

		let stack = UIStackView(arrangedSubviews: [addressField, statusLabel])
		stack.axis = .vertical
		stack.spacing = 16
		stack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stack)

		let margins = view.layoutMarginsGuide
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.topAnchor,
				constant: 24
			),
			stack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
		])
	}

	/// Accepts "100.1.2.3:3000" as well as a full URL.
	private static func url(from text: String) -> URL? {
		let trimmed = text.trimmingCharacters(in: .whitespaces)
		guard !trimmed.isEmpty else { return nil }
		return URL(string: trimmed.contains("://") ? trimmed : "http://\(trimmed)")
	}
}
