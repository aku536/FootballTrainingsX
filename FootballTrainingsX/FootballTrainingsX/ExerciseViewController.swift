//
//  ExerciseViewController.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 25/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    // MARK: - Переменные
    var exerciseModel: ExerciseModel
    var percentageCalculator: PercentageCalculatorProtocol
    var networkWorker: NetworkWorker
    var exercise: Exercise
    
    // MARK: - Инициализация
    init(exerciseModel: ExerciseModel, calculator: PercentageCalculatorProtocol, networkWorker: NetworkWorker) {
        self.exerciseModel = exerciseModel
        self.networkWorker = networkWorker
        percentageCalculator = calculator
        let index = exerciseModel.presentedExerciseIndex ?? 0
        exercise = exerciseModel.exercisesList[index]
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
                                               queue: nil) { [weak self] _ in
                                                self?.view.frame.origin = CGPoint(x: 0, y: -115)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
                                                guard let self = self else {
                                                    return
                                                }
                                                self.view.frame.origin = CGPoint(x: 0, y: 0)
                                                self.stepperValueDidChanged((self.exerciseView.successfulRepsView.stepper))
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
        exerciseView.removeFromSuperview()
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
        if let localURLString = exercise.localURLString {
            exerciseView.urlString = localURLString
            exerciseView.downloadVideoButton.setImage(UIImage(named: "delete"), for: .normal)
        } else {
            exerciseView.urlString = exercise.urlString
            exerciseView.downloadVideoButton.setImage(UIImage(named: "download"), for: .normal)
        }
        exerciseView.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        exerciseView.repsView.stepper.addTarget(self, action: #selector(stepperValueDidChanged(_:)), for: .allTouchEvents)
        exerciseView.repsView.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        exerciseView.successfulRepsView.stepper.addTarget(self, action: #selector(stepperValueDidChanged(_:)), for: .allTouchEvents)
        exerciseView.successfulRepsView.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        view.addSubview(exerciseView)
        exerciseView.downloadVideoButton.addTarget(self, action: #selector(downloadVideo), for: .touchUpInside)
        exerciseView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0).isActive = true
        exerciseView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        exerciseView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        exerciseView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
    }
    
    // MARK: - Приватные методы
    
    // Преобразуем текст для заголовка
    private func makeAttributedText(from text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white,
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .font : UIFont(name: "TimesNewRomanPS-BoldMT", size: 35) as Any
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
      
    // Говорит делегату сохранить данные и убирает view с экрана
    @objc private func save() {
        if let repsString = exerciseView.repsView.textField.text, let numberOfReps = Int(repsString),
            let successString = exerciseView.successfulRepsView.textField.text, let successfulReps = Int(successString) {
            exercise.numberOfReps += Int16(numberOfReps)
            exercise.successfulReps += Int16(successfulReps)
            exerciseModel.save(exercise)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// При изменении введенных результатов тренировки, считаем процент успешных выполнений
    func updatePercantage() {
        if let success = exerciseView.successfulRepsView.textField.text, let reps = exerciseView.repsView.textField.text {
            exerciseView.percantageLabel.text = percentageCalculator.calculatePercenatge(count: success, total: reps)
        }
    }
    
    // Меняет текст при изменении значения степпера
    @objc private func stepperValueDidChanged(_ sender: UIStepper) {
        if sender == exerciseView.repsView.stepper {
            // Проверяем, что успешно выполненных упражнений меньше, чем всего
            if sender.value < exerciseView.successfulRepsView.stepper.value {
                exerciseView.successfulRepsView.stepper.value = sender.value
                stepperValueDidChanged(exerciseView.successfulRepsView.stepper)
            }
            exerciseView.repsView.textField.text = "\(Int(sender.value))"
        } else if sender == exerciseView.successfulRepsView.stepper {
            // Проверяем, что успешно выполненных упражнений меньше, чем всего
            if sender.value > exerciseView.repsView.stepper.value {
                sender.value = exerciseView.repsView.stepper.value
            }
            exerciseView.successfulRepsView.textField.text = "\(Int(sender.value))"
        }
        updatePercantage()
    }
    
    // Меняет значение степпера при изменении значения текста
    @objc private func textFieldDidChanged(_ sender: UITextField) {
        if sender == exerciseView.repsView.textField {
            guard let text = sender.text, let textToDouble = Double(text) else {
                exerciseView.repsView.stepper.value = 0.0
                updatePercantage()
                return
            }
            exerciseView.repsView.stepper.value = textToDouble
        } else if sender == exerciseView.successfulRepsView.textField {
            guard let text = sender.text, let textToDouble = Double(text) else {
                exerciseView.successfulRepsView.stepper.value = 0.0
                updatePercantage()
                return
            }
            exerciseView.successfulRepsView.stepper.value = textToDouble
        }
        updatePercantage()
    }
    
    // Загружаем видео в FileManager, либо удаляем его, если уже загружено
    @objc private func downloadVideo() {
        guard let videoURL = URL(string: exercise.urlString) else { return }
        exerciseView.downloadVideoButton.isHidden = true
        exerciseView.spinner.startAnimating()
        networkWorker.downloadVideo(with: videoURL) { /*[weak self]*/ (localURLString) in
            //guard let self = self else { return }
            self.exercise.localURLString = localURLString
            self.exerciseModel.save(self.exercise)
            DispatchQueue.main.async {
                self.exerciseView.spinner.stopAnimating()
                let imageName = (localURLString != nil) ? "delete" : "download"
                self.exerciseView.downloadVideoButton.setImage(UIImage(named: imageName), for: .normal)
                self.exerciseView.downloadVideoButton.isHidden = false
            }
        }      
    }
}

// MARK: - UITextFieldDelegate
extension ExerciseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
