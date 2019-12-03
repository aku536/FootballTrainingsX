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
    let exerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let repsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private func setupUI() {
        let offset: CGFloat = 10
        let width = frame.height - 2 * offset
        
        contentView.addSubview(exerciseImageView)
        exerciseImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        exerciseImageView.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        exerciseImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: offset).isActive = true
        exerciseImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true
        
        contentView.addSubview(repsLabel)
        repsLabel.heightAnchor.constraint(equalToConstant: frame.height/2 - offset).isActive = true
        repsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        repsLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        repsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        
        contentView.addSubview(successLabel)
        successLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        successLabel.topAnchor.constraint(equalTo: repsLabel.bottomAnchor, constant: offset/2).isActive = true
        successLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        successLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true
        
        contentView.addSubview(percentageLabel)
        percentageLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        percentageLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        percentageLabel.rightAnchor.constraint(equalTo: successLabel.leftAnchor, constant: -offset).isActive = true
        percentageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true
        
        contentView.addSubview(exerciseLabel)
        exerciseLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        exerciseLabel.leftAnchor.constraint(equalTo: exerciseImageView.rightAnchor, constant: offset).isActive = true
        exerciseLabel.rightAnchor.constraint(equalTo: percentageLabel.leftAnchor, constant: -offset).isActive = true
        exerciseLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true
    }
    
}
