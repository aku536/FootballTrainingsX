//
//  StatsTableViewCell.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 03/12/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    // MARK: - настройка UI
    
    /// Иконка упражнения
    let exerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Название упражнения
    let exerciseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    /// Процент успешности выполнения упражнения
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    /// Количество повторов
    let repsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    /// Количество успешно выполненных подходов
    let successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    private func setupUI() {
        let offset: CGFloat = 10
        let imageWidth = frame.height/2
        let labelWidth: CGFloat = 125
        
        contentView.addSubview(exerciseImageView)
        exerciseImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        exerciseImageView.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        exerciseImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        exerciseImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: offset).isActive = true
        
        contentView.addSubview(repsLabel)
        repsLabel.heightAnchor.constraint(equalToConstant: frame.height/3).isActive = true
        repsLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        repsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        repsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        
        contentView.addSubview(successLabel)
        successLabel.heightAnchor.constraint(equalToConstant: frame.height/3).isActive = true
        successLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        successLabel.topAnchor.constraint(equalTo: repsLabel.bottomAnchor).isActive = true
        successLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        
        contentView.addSubview(percentageLabel)
        percentageLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        percentageLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor).isActive = true
        percentageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        percentageLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView.addSubview(exerciseTitleLabel)
        exerciseTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        exerciseTitleLabel.leftAnchor.constraint(equalTo: exerciseImageView.rightAnchor, constant: offset).isActive = true
        exerciseTitleLabel.rightAnchor.constraint(equalTo: successLabel.leftAnchor, constant: -offset).isActive = true
        exerciseTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true
    }
    
}
