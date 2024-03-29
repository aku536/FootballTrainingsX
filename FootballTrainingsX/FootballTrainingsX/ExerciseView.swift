//
//  ExerciseView.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 04/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

// Представление, отображающее одно упражнение
class ExerciseView: UIView {
    
    var urlString = ""
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    /// Содержит view с плеером
    let playerView: UIView = {
        let playerView = UIView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    /// Кнопка сохранения видео
    let downloadVideoButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Сохранить видео", for: .normal)
        return button
    }()
    
    /// Индикатор загрузки видео на устройство
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
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
    
    /// Содержит элементы добавления количества выполненных упражнений
    let repsView: AddStatsView = {
        let view = AddStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.exerciseTitle = "Повторы"
        return view
    }()
    
    /// Содержит элементы добавления количества успешно выполненных упражнений
    let successfulRepsView: AddStatsView = {
        let view = AddStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.exerciseTitle = "Успешно"
        return view
    }()
    
    /// Отображает процент успешности выполнения упражнений
    let percantageLabel: UILabel = {
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
    
    /// Сохраняет количество выполнений
    let saveButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 20)
        button.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return button
    }()
    
    // MARK: - Приватные методы
    
    // Добавление элементов на view и настройка анкоров
    private func setupUI() {
        backgroundColor = .black
        
        let yOffset: CGFloat = 10
        let xOffset: CGFloat = 15
        let width = frame.width - 2 * xOffset
        let height: CGFloat = 30
        let videoFormat: CGFloat = 9/16
        let titleLabelHeight = titleLabel.text?.height(withConstrainedWidth: width, font: titleLabel.font) ?? height
        
        addSubview(downloadVideoButton)
        downloadVideoButton.widthAnchor.constraint(equalToConstant: height/1.5).isActive = true
        downloadVideoButton.heightAnchor.constraint(equalToConstant: height/1.5).isActive = true
        downloadVideoButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -xOffset).isActive = true
        downloadVideoButton.topAnchor.constraint(equalTo: topAnchor, constant: height/2).isActive = true
        
        addSubview(titleLabel)
        titleLabel.rightAnchor.constraint(equalTo: downloadVideoButton.leftAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: yOffset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(playerView)
        playerView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: frame.width * videoFormat).isActive = true
        playerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        addPlayerView()
        
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: downloadVideoButton.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: downloadVideoButton.centerYAnchor).isActive = true
        
        addSubview(saveButton)
        saveButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -yOffset).isActive = true
        
        addSubview(percantageLabel)
        percantageLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        percantageLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        percantageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percantageLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -yOffset).isActive = true
        percantageLabel.text = "0%"
        
        addSubview(successfulRepsView)
        successfulRepsView.widthAnchor.constraint(equalToConstant: width).isActive = true
        successfulRepsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        successfulRepsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        successfulRepsView.bottomAnchor.constraint(equalTo: percantageLabel.topAnchor, constant: -5).isActive = true
        
        
        addSubview(repsView)
        repsView.widthAnchor.constraint(equalToConstant: width).isActive = true
        repsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        repsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        repsView.bottomAnchor.constraint(equalTo: successfulRepsView.topAnchor, constant: -5).isActive = true
        
        addSubview(descriptionTextView)
        descriptionTextView.widthAnchor.constraint(equalToConstant: width).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: repsView.topAnchor, constant: -yOffset).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: yOffset).isActive = true
    }
    
    private func addPlayerView() {
        let playerFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width*9/16)
        let pv = PlayerView(frame: playerFrame, urlString: urlString)
        playerView.addSubview(pv)
    }
}
