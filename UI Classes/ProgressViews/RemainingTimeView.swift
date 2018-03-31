//
//  RemainingTimeView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class RemainingTimeView: UIView {

    struct Const {
        static let trackTintColor = UIColor.white.withAlphaComponent(0.3)
        static let progressTintColor = UIColor.blue
        static let microOffset = 1
    }
    
    fileprivate let leftProgressView = UIProgressView()
    fileprivate let rightProgressView = UIProgressView()
    var progress: Float = 0 {
        didSet {
            leftProgressView.progress = progress
            rightProgressView.progress = progress
        }
    }
    
    init() {
        super.init(frame: CGRect())
        
        leftProgressView.trackTintColor = Const.trackTintColor
        leftProgressView.progressTintColor = Const.progressTintColor
        
        rightProgressView.trackTintColor = Const.trackTintColor
        rightProgressView.progressTintColor = Const.progressTintColor
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftProgressView.layer.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), -1, 1, 1)
    }
}

fileprivate extension RemainingTimeView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                leftProgressView,
                rightProgressView
            ]
        )
        
        leftProgressView.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.centerX).offset(Const.microOffset)
            make.centerY.height.left.equalToSuperview()
        }
        
        rightProgressView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(-Const.microOffset)
            make.centerY.height.right.equalToSuperview()
        }
    }
}
