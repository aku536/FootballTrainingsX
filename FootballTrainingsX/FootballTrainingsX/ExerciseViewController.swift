//
//  ExerciseViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, AddStatsViewDelegate {
    // MARK: - Переменные
    var exercise: Exercise
    private let stack = CoreDataStack.shared
    
    // MARK: - Инициализация
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        exerciseView.playerView.subviews.first?.removeFromSuperview()
    }
    
    // MARK: - Настройка UI
    private let exerciseView: ExerciseView = {
        let view = ExerciseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupUI() {
        title = "Запишите свои результаты"
        
        exerciseView.titleLabel.attributedText = makeAttributedText(from: exercise.type)
        exerciseView.descriptionTextView.text = exercise.exerciseDescription
        exerciseView.urlString = exercise.urlString
        exerciseView.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        exerciseView.successfulRepsView.delegate = self
        exerciseView.repsView.delegate = self
        view.addSubview(exerciseView)
        exerciseView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0).isActive = true
        exerciseView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        exerciseView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        exerciseView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
    }
    
    // Преобразуем текст для заголовка
    private func makeAttributedText(from text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .font : UIFont(name: "TimesNewRomanPS-BoldMT", size: 40)!
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    // MARK: - Приватные методы
    
    // Говорит делегату сохранить данные и убирает view с экрана
    @objc private func save() {
        if let repsString = exerciseView.repsView.textField.text, let numberOfReps = Int(repsString),
            let successString = exerciseView.successfulRepsView.textField.text, let successfulReps = Int(successString) {
            exercise.numberOfReps += Int16(numberOfReps)
            exercise.successfulReps += Int16(successfulReps)
            stack.save(exercise)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// При изменении введенных результатов тренировки, считаем процент успешных выполнений
    func updatePercantage() {
        if let success = exerciseView.successfulRepsView.textField.text, let reps = exerciseView.repsView.textField.text {
            exerciseView.percantageLabel.text = PercentageCalculator.calculatePercenatge(count: success, total: reps)
        }
    }
    
}


