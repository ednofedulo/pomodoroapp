//
//  CircularIndicator.swift
//  PomodoroApp
//
//  Created by Edno Fedulo on 05/10/19.
//  Copyright © 2019 Fedulo. All rights reserved.
//

import UIKit

class CircularIndicator: UIView {

    var clockwise = true

    lazy private var circleView: UIView = {
        let view = UIView()
        return view
    }()

    lazy private var indicatorView: UIView = {
        let view = UIView()
        return view
    }()

    lazy private var circle: CAShapeLayer = {
        let layer = CAShapeLayer()

        layer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        layer.lineWidth = 7
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round

        return layer
    }()

    lazy private var circleIndicator: CAShapeLayer = {
        let layer = CAShapeLayer()

        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 7
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.strokeEnd = self.clockwise ? 0 : 1

        return layer
    }()

    private var first = false
    private var started = false
    private var paused = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        setupConstraints()
        setupView()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !first {

            let startAngle = -(CGFloat.pi/2)
            let endAngle = startAngle+(2*CGFloat.pi*(clockwise ? 1.0 : -1.0))

            let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: self.frame.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            circleIndicator.path = circularPath.cgPath
            circle.path = circularPath.cgPath
            first = true
        }
    }

    private func addSubViews(){
        circleView.layer.addSublayer(circle)
        indicatorView.layer.addSublayer(circleIndicator)

        self.addSubview(circleView)
        self.addSubview(indicatorView)
    }

    private func setupConstraints(){

        circleView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor),
            circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            indicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ])
    }

    private func setupView(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTap(){
        if paused {
            resumeTimer()
            paused = false
        } else if !started {
            start(withDuration: 5)
            started = true
        } else {
            pauseTimer()
            paused = true
        }
    }

    func resumeTimer(){
        let pausedTime = circleIndicator.timeOffset
        circleIndicator.speed = 1.0;
        circleIndicator.timeOffset = 0.0;
        circleIndicator.beginTime = 0.0;
        let timeSincePause = circleIndicator.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        circleIndicator.beginTime = timeSincePause;
    }

    func pauseTimer(){
        //let pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        let pausedTime = circleIndicator.convertTime(CACurrentMediaTime(), from: nil)
        circleIndicator.speed = 0.0;
        circleIndicator.timeOffset = pausedTime;
    }

    func start(withDuration duration: Double){
        self.indicatorView.alpha = 1.0
        CATransaction.begin()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = self.clockwise ? 1 : 0
        basicAnimation.duration = duration
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = !clockwise

        CATransaction.setCompletionBlock {
            if !self.paused {
                self.doPulseAnimation()
            }
        }
        circleIndicator.add(basicAnimation, forKey: "anim")
        CATransaction.commit()
    }

    func doPulseAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.circleView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.circleView.alpha = 0.0

        }) { (completed) in

            guard completed else { return }

            UIView.animate(withDuration: 0.3, animations: {
                self.indicatorView.alpha = 0.0

            }) { (completed) in

                guard completed else { return }

                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.circleView.alpha = 1.0
                self.started = false

            }
        }
    }

    private func generateUIBezierPath(clockwise: Bool) -> UIBezierPath {
        return UIBezierPath()
    }

}
