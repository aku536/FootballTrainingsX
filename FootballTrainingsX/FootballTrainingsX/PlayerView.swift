//
//  PlayerView.swift
//  FootballTrainingsX
//
//  Created by Кирилл Афонин on 29/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    // MARK: - Переменные
    private var player: AVPlayer?
    private var isPlaying = false // играет ли видео в данный момент
    private var urlString: String
    private let timeFormatter = TimeFormatter() // помогает преобразовавать время в строку
    private var timeObserver: Any?
    
    // MARK: - Инициализация
    init(frame: CGRect, urlString: String) {
        self.urlString = urlString
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    deinit {
        if timeObserver != nil {
            player?.removeTimeObserver(timeObserver as Any)
        }
        player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        player = nil
    }
    
    // MARK: - Создание элементов UI
    private let playerControlsView: UIView = {
        var controlsView = UIView()
        controlsView.backgroundColor = .black
        return controlsView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    private let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    private let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        return label
    }()
    
    private let progressTracker: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .blue
        slider.thumbTintColor = .blue
        slider.addTarget(self, action: #selector(sliderDidChanged), for: .valueChanged)
        return slider
    }()

    private func setupUI() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOrHideControlsOnTap)))
        
        setupPlayerView()
        setupGradientLayer()
        
        playerControlsView.frame = frame
        addSubview(playerControlsView)
        playerControlsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showOrHideControlsOnTap)))
        
        playerControlsView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        playerControlsView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        playerControlsView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        playerControlsView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        playerControlsView.addSubview(progressTracker)
        progressTracker.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        progressTracker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        progressTracker.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        progressTracker.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    // MARK: - Приватные методы
    
    // Добавляет плеер и два обозревателя
    private func setupPlayerView() {
        guard let url = URL(string: urlString) else {
            return
        }
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.frame
        player?.pause()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
  
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (currentTime) in
            let seconds = CMTimeGetSeconds(currentTime)
            self?.currentTimeLabel.text = self?.timeFormatter.transformTimeToString(seconds: seconds)
            if let duration = self?.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self?.progressTracker.value = Float(seconds/durationSeconds)
            }
        })
    }
    
    // Затенение полоски слайдера
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1]
        playerControlsView.layer.addSublayer(gradientLayer)
    }
    
    // Ставит плеер на паузу / возобновляет проигрывание
    @objc private func handlePause() {
        player?.pause()
        if isPlaying {
            UIView.transition(with: pausePlayButton,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            })
        } else {
            player?.play()
            playerControlsView.isHidden = true
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    // При перемещении слайдера, перематываем видео
    @objc private func sliderDidChanged() {
        if let duration = player?.currentItem?.duration, !duration.isIndefinite {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(progressTracker.value) * totalSeconds
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            player?.seek(to: seekTime)
        }
    }
    
    // Прячет или показывает элементы управления плеером
    @objc private func showOrHideControlsOnTap() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        playerControlsView.layer.add(transition, forKey: nil)

        playerControlsView.isHidden = !playerControlsView.isHidden
    }
    
    // Когда видео загрузилось, убирает индикатор загрузки
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            playerControlsView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            
            if let duration = player?.currentItem?.duration, !duration.isIndefinite {
                let seconds = CMTimeGetSeconds(duration)
                videoLengthLabel.text = timeFormatter.transformTimeToString(seconds: seconds)
            }
        }
    }
    
}
