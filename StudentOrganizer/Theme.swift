//
//  Theme.swift
//  StudentOrganizer
//
//  The app's own visual style (allowed by the spec: "free to choose your own
//  accent colors and SF Symbols"). Lists sit on a soft accent-colored gradient,
//  and each row is a frosted-glass card that blurs that gradient behind it.
//

import UIKit

/// Background placed behind a table view. It draws a gentle diagonal gradient
/// using the app's accent color and, when `message` is not nil, shows the
/// empty-state text in the middle (built with emptyStateLabel from Helpers.swift).
final class GlassBackgroundView: UIView {

    private let gradientLayer = CAGradientLayer()

    init(message: String?) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground

        // Top-left corner gets a tint of the accent color that fades out
        // toward the middle of the screen.
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 0.6]
        layer.addSublayer(gradientLayer)
        updateGradientColors()

        // Only add the label when there is something to say (empty list).
        if let message = message {
            let label = emptyStateLabel(message)
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds   // keep the gradient as big as the view
    }

    // CGColor does not switch between light and dark mode by itself,
    // so the colors are recalculated whenever the appearance changes.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGradientColors()
    }

    private func updateGradientColors() {
        let accent = (UIColor(named: "AccentColor") ?? .systemTeal)
            .resolvedColor(with: traitCollection)
        let alpha: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.28 : 0.20
        gradientLayer.colors = [accent.withAlphaComponent(alpha).cgColor,
                                accent.withAlphaComponent(0).cgColor]
    }
}

extension UITableViewCell {
    /// Gives a row the frosted-glass look: a light blur of whatever is behind it
    /// plus a see-through fill, so the gradient shows through softly.
    func applyGlassBackground() {
        var background = UIBackgroundConfiguration.listGroupedCell()
        background.visualEffect = UIBlurEffect(style: .systemThinMaterial)
        background.backgroundColor = UIColor.secondarySystemGroupedBackground
            .withAlphaComponent(0.55)
        backgroundConfiguration = background
    }
}

extension UIViewController {
    /// Puts the gradient behind a plain (non-list) screen such as a form.
    /// It is inserted at index 0 so it sits behind every other control.
    func addGlassBackground() {
        let background = GlassBackgroundView(message: nil)
        background.frame = view.bounds
        background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(background, at: 0)
    }
}
