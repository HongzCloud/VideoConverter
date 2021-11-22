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
}

class PlayerControlView: UIView {

    weak var delegate: PlayerControlViewDelegate?
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
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
  
            self.durationSlider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
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
    
    @objc func didTappedPlayButton(_ sender: UIButton!) {
        self.delegate?.didTappedPlayButton(playButton)
    }
    
    @objc func didTappedBackwardButton(_ sender: UIButton!) {
        self.delegate?.didTappedBackwardButton()
    }
    
    @objc func didTappedForwardButton(_ sender: UIButton!) {
        self.delegate?.didTappedForwardButton()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider!) {
        self.delegate?.sliderValueChanged(durationSlider)
    }
    
    func configureSlider(maxValue: Float, minValue: Float, value: Float) {
        self.durationSlider.maximumValue = maxValue
        self.durationSlider.minimumValue = minValue
        self.durationSlider.value = value
    }
}
