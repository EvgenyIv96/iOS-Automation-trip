//
//  ViewController.swift
//  email-checker
//
//  Created by Евгений Иванов on 23.11.2020.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Private Properties
    
    private let containerView = UIView(frame: .zero)
    
    private let errorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Invalid email"
        label.isHidden = true
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Enter email"
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var verifyButton: ActionButton = {
        let button = ActionButton()
        button.title = "Verify"
        button.isEnabled = false
        button.onTap = { [weak self] _ in self?.validateEmail() }
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Actions

    @objc
    func textChanged(_ textField: UITextField) {
        verifyButton.isEnabled = (textField.text?.count ?? 0) > 0
    }

    // MARK: - UI Configuration
    
    private func configure() {
        addContainer()
        addTextField()
        addErrorLabel()
        addButton()
        updateAccessibility()
    }
    
    private func addContainer() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func addTextField() {
        containerView.addSubview(emailField)
        emailField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emailField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32.0),
            emailField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32.0)
        ])
    }
    
    private func addErrorLabel() {
        containerView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: -12.0)
        ])
    }
    
    private func addButton() {
        containerView.addSubview(verifyButton)
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verifyButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12.0),
            verifyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            verifyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12.0)
        ])
    }
    
    // MARK: - Private
    
    private func validateEmail() {
        let isValid = isValidEmail(emailField.text ?? "")
        
        if isValid {
            let alert = UIAlertController(title: "Info", message: "Entered email is valid!", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(doneAction)
            present(alert, animated: true, completion: nil)
            errorLabel.isHidden = true
        } else {
            errorLabel.isHidden = false
            shake(emailField)
        }
        updateAccessibility()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func shake(_ view: UIView, value: CGFloat = 5.0) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 2.0
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: .init(x: view.center.x - value, y: view.center.y))
        animation.toValue = NSValue(cgPoint: .init(x: view.center.x + value, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
 
    private func updateAccessibility() {
        view.isAccessibilityElement = false
        view.accessibilityElements = [emailField] + (errorLabel.isHidden ? [] : [errorLabel])
    }
    
}
