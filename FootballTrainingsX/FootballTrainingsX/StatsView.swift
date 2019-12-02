//
//  StatsView.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 02/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

protocol StatsViewDelegate {
    func updatePercantage()
}

class StatsView: UIView {
    
    var exerciseTitle = ""
    var delegate: StatsViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        
        stepper.minimumValue = 0
        stepper.maximumValue = Double(Int16.max)
        return stepper
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        let width = exerciseTitle.width(withConstrainedHeight: 29, font: label.font)
        label.text = exerciseTitle
        label.textColor = .lightGray
        label.textAlignment = .center
        label.frame = CGRect(x: 15, y: 0, width: width + 15, height: 20)
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        textField.textAlignment = .right
        textField.text = "0"
        textField.textColor = .white
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
    
        textField.leftView = title
        textField.leftViewMode = .always
        textField.rightView = stepper
        stepper.addTarget(self, action: #selector(stepperValueDidChanged(_:)), for: .allTouchEvents)
        textField.rightViewMode = .always
        
        textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // Меняет текст при изменении значения степпера
    @objc private func stepperValueDidChanged(_ sender: UIStepper) {
        textField.text = "\(Int(sender.value))"
        delegate?.updatePercantage()
    }
    
    // Меняет значение степпера при изменении значения текста
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        guard let text = sender.text, let textToDouble = Double(text) else {
            stepper.value = 0.0
            delegate?.updatePercantage()
            return
        }
        stepper.value = textToDouble
        delegate?.updatePercantage()
    }
    
}

// MARK: - UITextFieldDelegate
extension StatsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
