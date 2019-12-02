//
//  TrainingViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

protocol TrainingViewDelegate {
    func save(numberOfReps: Int, successfulReps: Int, at index: Int)
}

class TrainingViewController: UIViewController, StatsViewDelegate {
    
    var urlString = "" // ссылка на видео
    var trainingIndex: Int? // номер ячейки, с которой осуществлялся переход
    var delegate: TrainingViewDelegate?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: nil) { _ in
                                                self.view.frame.origin = CGPoint(x: 0, y: -200)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: nil) { _ in
                                                self.view.frame.origin = CGPoint(x: 0, y: 0)
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.subviews.first?.removeFromSuperview()
    }
    
    // MARK: - Создание элементов view
    
    /// Название упражнения
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private var playerView: UIView = {
        let playerView = UIView()
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
    
    private let repsView: StatsView = {
        let view = StatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.exerciseTitle = "Повторы"
        return view
    }()
    
    private let successfulRepsView: StatsView = {
        let view = StatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.exerciseTitle = "Успешные повторы"
        return view
    }()
    
    private let percantageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0%"
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
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
        title = "Запишите свои результаты"
        
        let offsetFromNavBar = navigationController?.navigationBar.frame.maxY ?? 60
        let offsetFromTabBar = tabBarController?.tabBar.frame.height ?? view.frame.maxY
        let yOffset: CGFloat = 15
        let xOffset: CGFloat = 25
        let width = view.frame.width - 2 * xOffset
        let height: CGFloat = 40
        
        view.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: offsetFromNavBar + yOffset).isActive = true
        
        view.addSubview(playerView)
        playerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: view.frame.width*9/16).isActive = true
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: yOffset).isActive = true
        addPlayerView()
        
        view.addSubview(saveButton)
        saveButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -offsetFromTabBar - yOffset).isActive = true
        
        view.addSubview(percantageLabel)
        percantageLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        percantageLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        percantageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        percantageLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -yOffset).isActive = true
        
        view.addSubview(successfulRepsView)
        successfulRepsView.widthAnchor.constraint(equalToConstant: width).isActive = true
        successfulRepsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        successfulRepsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successfulRepsView.bottomAnchor.constraint(equalTo: percantageLabel.topAnchor, constant: -5).isActive = true
        successfulRepsView.delegate = self
        
        
        view.addSubview(repsView)
        repsView.widthAnchor.constraint(equalToConstant: width).isActive = true
        repsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        repsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        repsView.bottomAnchor.constraint(equalTo: successfulRepsView.topAnchor, constant: -5).isActive = true
        repsView.delegate = self
        
        view.addSubview(descriptionTextView)
        descriptionTextView.widthAnchor.constraint(equalToConstant: width).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: repsView.topAnchor, constant: -yOffset).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: yOffset).isActive = true
    }
    
    private func addPlayerView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width*9/16)
        let pv = PlayerView(frame: frame, urlString: urlString)
        playerView.addSubview(pv)
    }
    
    // Говорит делегату сохранить данные и убирает view с экрана
    @objc private func save() {
        if let index = trainingIndex,
            let repsString = repsView.textField.text, let numberOfReps = Int(repsString),
            let successString = successfulRepsView.textField.text, let successfulReps = Int(successString) {
            delegate?.save(numberOfReps: numberOfReps, successfulReps: successfulReps, at: index)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// При изменении введенных результатов тренировки, считаем процент успешных выполнений
    func updatePercantage() {
        if let repsString = repsView.textField.text,
            let successString = successfulRepsView.textField.text,
            let reps = Double(repsString),
            let success = Double(successString),
            success > 0,
            reps > 0 {
            percantageLabel.text = "\(Int(success/reps*100))%"
        }
        else {
            percantageLabel.text = "0%"
            return
        }
        
    }
    
}


