//
//  AddStatsView.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 02/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

// Вспомогательное представление, содержит элементы для изменения количества выполненных повторов
class AddStatsView: UIView {
    
    var exerciseTitle = ""
    
    // MARK: - Настройка UI
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    /// Изменяет число в textField на 1
    let stepper: UIStepper = {
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

    /// Содержит количество повторов
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
        textField.rightViewMode = .always
        return textField
    }()
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(textField)
        textField.text = "0"
        stepper.value = 0.0
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

