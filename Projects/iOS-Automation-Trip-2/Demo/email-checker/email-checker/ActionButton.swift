//
//  ActionButton.swift
//  email-checker
//
//  Created by Евгений Иванов on 25.11.2020.
//

import UIKit

final class ActionButton: UIControl {
    
    // MARK: - Internal Properties
    
    var onTap: ((ActionButton) -> Void)?
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    // MARK: - Overridden
    
    override var isEnabled: Bool {
        didSet {
            contentView.alpha = isEnabled ? 1.0 : 0.5
            tapGestureRecognizer.isEnabled = isEnabled
        }
    }
    
    // MARK: - Private Properties
    
    private let tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.0
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        return label
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        addTapGestureRecognizer()
        addContentView()
        addTitleLabel()
    }
    
    private func addTapGestureRecognizer() {
        contentView.isUserInteractionEnabled = false
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        onTap?(self)
    }
}
