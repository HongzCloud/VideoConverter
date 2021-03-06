//
//  PlayerControlView.swift
//  VideoConverter
//
//  Created by 오킹 on 2021/11/22.
//

import UIKit

protocol PlayerControlViewDelegate: AnyObject {
    func didTappedPlayButton(_ button: UIButton)
    func didTappedBackwardButton()
    func didTappedForwardButton()
    func sliderValueChanged(_ slider: UISlider)
    func didTappedRepeatPlayButton(_ button: UIButton)
}

class PlayerControlView: UIView {

    weak var delegate: PlayerControlViewDelegate?
    
    var isSelectedRepeatPlayButton = false
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 30)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTappedPlayButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 30)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTappedBackwardButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 30)
        button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTappedForwardButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let durationSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.thumbTintColor = .greenAndMint
        slider.tintColor = .greenAndMint
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .greenAndMint
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let repeatPlayButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "repeat.1")!, for: .normal)
        let symbolSize = UIImage.SymbolConfiguration.init(pointSize: 25)
        button.addTarget(self, action: #selector(didTappedRepeatPlayButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIObject()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUIObject()
    }
    
    private func setUIObject() {
        setPlayButtonConstraints()
        setDurationSlider()
        setBackwardButton()
        setForwardButton()
        setCurrentTimeLabel()
        setEndTimeLabel()
        setRepeatPlayButton()
    }
    
    private func setPlayButtonConstraints() {
        self.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            self.playButton.topAnchor.constraint(equalTo: self.centerYAnchor),
            self.playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setDurationSlider() {
        self.addSubview(durationSlider)

        NSLayoutConstraint.activate([
            self.durationSlider.topAnchor.constraint(equalTo: self.topAnchor),
            self.durationSlider.bottomAnchor.constraint(equalTo: self.playButton.topAnchor),
            self.durationSlider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
  
            self.durationSlider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func setBackwardButton() {
        self.addSubview(backwardButton)
        
        NSLayoutConstraint.activate([
            self.backwardButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor),
            self.backwardButton.heightAnchor.constraint(equalTo: self.playButton.heightAnchor),
            self.backwardButton.widthAnchor.constraint(equalTo: self.playButton.widthAnchor),
            self.backwardButton.trailingAnchor.constraint(equalTo: self.playButton.leadingAnchor, constant: -20)
        ])
    }
    
    private func setForwardButton() {
        self.addSubview(forwardButton)
        
        NSLayoutConstraint.activate([
            self.forwardButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor),
            self.forwardButton.heightAnchor.constraint(equalTo: self.playButton.heightAnchor),
            self.forwardButton.widthAnchor.constraint(equalTo: self.playButton.widthAnchor),
            self.forwardButton.leadingAnchor.constraint(equalTo: self.playButton.trailingAnchor, constant: 20)
        ])
    }
    
    private func setCurrentTimeLabel() {
        self.addSubview(currentTimeLabel)
        
        NSLayoutConstraint.activate([
            self.currentTimeLabel.leadingAnchor.constraint(equalTo: self.durationSlider.leadingAnchor),
            self.currentTimeLabel.topAnchor.constraint(equalTo: self.durationSlider.bottomAnchor)
        ])
    }
    
    private func setEndTimeLabel() {
        self.addSubview(endTimeLabel)
        
        NSLayoutConstraint.activate([
            self.endTimeLabel.trailingAnchor.constraint(equalTo: self.durationSlider.trailingAnchor),
            self.endTimeLabel.topAnchor.constraint(equalTo: self.durationSlider.bottomAnchor)
        ])
    }
    
    private func setRepeatPlayButton() {
        self.addSubview(repeatPlayButton)
        
        NSLayoutConstraint.activate([
            self.repeatPlayButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.repeatPlayButton.centerYAnchor.constraint(equalTo: self.durationSlider.centerYAnchor),
            self.repeatPlayButton.trailingAnchor.constraint(equalTo: self.durationSlider.leadingAnchor),
            self.repeatPlayButton.heightAnchor.constraint(equalTo: self.durationSlider.heightAnchor)
        ])
    }
    @objc func didTappedPlayButton(_ sender: UIButton!) {
        self.delegate?.didTappedPlayButton(self.playButton)
    }
    
    @objc func didTappedBackwardButton(_ sender: UIButton!) {
        self.delegate?.didTappedBackwardButton()
    }
    
    @objc func didTappedForwardButton(_ sender: UIButton!) {
        self.delegate?.didTappedForwardButton()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider!) {
        self.delegate?.sliderValueChanged(self.durationSlider)
    }
    
    @objc func didTappedRepeatPlayButton(_ sender: UIButton) {
        self.delegate?.didTappedRepeatPlayButton(self.repeatPlayButton)
    }
    
    func configureSlider(maxValue: Float, minValue: Float, value: Float) {
        self.durationSlider.maximumValue = maxValue
        self.durationSlider.minimumValue = minValue
        self.durationSlider.value = value
    }
    
    func configureTimeLabel(currentTime: String = "00:00", endTime: String?) {
        self.currentTimeLabel.text = currentTime
        if let endTime = endTime {
            self.endTimeLabel.text = endTime
        }
    }
    
    func configurePlayButton(image: UIImage) {
        self.playButton.setImage(image, for: .normal)
    }
}
