//
//  AnimatedHammerView.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/11/29.
//

import UIKit

class AnimatedGearView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        startAnimation()
    }
    
    private func setupView() {
        addSubview(imageView)
        imageView.image = Images.gear.withRenderingMode(.alwaysTemplate)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 5
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: "rotation")
    }
}
