//
//  TrainingViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

protocol TrainingViewDelegate {
    func save(numberOfReps: Int, at index: Int)
}

class TrainingViewController: UIViewController {
    
    private var urlString: String // ссылка на видео
    private var trainingIndex: Int // номер ячейки, с которой осуществлялся переход
    var delegate: TrainingViewDelegate?
    
    /// При инициализации необходимо указать ссылку на видео и номер упражнения по порядку
    ///
    /// - Parameters:
    ///   - urlString: ссылка на видео
    ///   - index: номер ячейки, с которой осуществлялся переход
    init(urlString: String, index: Int) {
        self.urlString = urlString
        self.trainingIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Создание элементов view
    
    /// Название упражнения
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var playerView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width*9/16)
        let playerView = PlayerView(frame: frame, urlString: urlString)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    /// Описание упражнения
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        textView.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont(name: "ArialMT", size: 17)
        return textView
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperValueDidChanged(_:)), for: .touchUpInside)
        stepper.minimumValue = 0
        stepper.maximumValue = Double(Int16.max)
        return stepper
    }()
    
    private let repsTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        textField.textAlignment = .right
        textField.text = "0"
        textField.textColor = .white
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        
        let title = UILabel()
        let text = "Повторы"
        let width = text.width(withConstrainedHeight: 29, font: title.font)
        title.text = text
        title.textColor = .lightGray
        title.textAlignment = .center
        title.frame = CGRect(x: 15, y: 0, width: width + 15, height: 20)
        textField.leftView = title
        textField.leftViewMode = .always
        
        textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 20)
        button.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Приватные методы
    
    // Добавление элементов на view и настройка анкоров
    private func setupUI() {
        view.backgroundColor = .black
        
        let offsetFromNavBar = navigationController?.navigationBar.frame.maxY ?? 60
        let offsetFromTabBar = tabBarController?.tabBar.frame.height ?? view.frame.maxY
        let yOffset: CGFloat = 15
        let xOffset: CGFloat = 25
        let width = view.frame.width - 2 * xOffset
        
        view.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: offsetFromNavBar + yOffset).isActive = true
        
        view.addSubview(playerView)
        playerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: view.frame.width*9/16).isActive = true
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: yOffset).isActive = true

        view.addSubview(saveButton)
        saveButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offsetFromTabBar - yOffset).isActive = true
        
        view.addSubview(stepper)
        stepper.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -xOffset).isActive = true
        stepper.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -yOffset).isActive = true
        
        view.addSubview(repsTextField)
        repsTextField.delegate = self
        repsTextField.heightAnchor.constraint(equalToConstant: 29).isActive = true
        repsTextField.rightAnchor.constraint(equalTo: stepper.leftAnchor, constant: -xOffset).isActive = true
        repsTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: xOffset).isActive = true
        repsTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -yOffset).isActive = true
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil, queue: nil) { _ in
            self.view.frame.origin = CGPoint(x: 0, y: -200)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil, queue: nil) { _ in
            self.view.frame.origin = CGPoint(x: 0, y: 0)
        }
        
        view.addSubview(descriptionTextView)
        descriptionTextView.widthAnchor.constraint(equalToConstant: width).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: repsTextField.topAnchor, constant: -yOffset).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: yOffset).isActive = true
    }
    
    // Меняет текст при изменении значения степпера
    @objc private func stepperValueDidChanged(_ sender: UIStepper) {
        repsTextField.text = "\(Int(sender.value))"
    }
    
    // Меняет значение степпера при изменении значения текста
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        guard let text = sender.text, let textToInt = Int(text) else {
            stepper.value = 0.0
            return
        }
        stepper.value = Double(textToInt)
    }
    
    // Говорит делегату сохранить данные и убирает view с экрана
    @objc private func save() {
        guard let text = repsTextField.text, let numberOfReps = Int(text) else {
            navigationController?.popViewController(animated: true)
            return
        }
        delegate?.save(numberOfReps: numberOfReps, at: trainingIndex)
        navigationController?.popViewController(animated: true)
    }
    
}

extension TrainingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
