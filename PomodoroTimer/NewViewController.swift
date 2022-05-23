//
//  NewViewController.swift
//  PomodoroTimer
//
//  Created by Andrey Oala on 21.05.2022.
//

import UIKit


class NewViewController: UIViewController {
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    // MARK: - UI Elements
    
    private lazy var startPauseTimeButton: UIButton = {
       let startPauseTimeButton = UIButton()
        startPauseTimeButton.tintColor = .orange
        startPauseTimeButton.setImage(UIImage(systemName: "play"), for: .normal)
        startPauseTimeButton.imageView?.contentMode = .center
        startPauseTimeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        startPauseTimeButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return startPauseTimeButton
    }()

    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
    let shapePosition = CGPoint(x: 200, y: 250)
        let circularPath = UIBezierPath(arcCenter: shapePosition, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
     shapeLayer.path = circularPath.cgPath
        shapeLayer.lineCap = CAShapeLayerLineCap.round
     shapeLayer.strokeColor = UIColor.orange.cgColor
     shapeLayer.lineWidth = 5
     shapeLayer.strokeEnd = 0
     shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()
    
    private lazy var shadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        let shadowLayerPosition = CGPoint(x: 200, y: 250)
        let shadowLayerPath = UIBezierPath(arcCenter: shadowLayerPosition, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shadowLayer.path = shadowLayerPath.cgPath
        shadowLayer.lineCap = CAShapeLayerLineCap.round
        shadowLayer.strokeColor = UIColor.orange.cgColor
        shadowLayer.lineWidth = 1
        shadowLayer.fillColor = UIColor.clear.cgColor
        return shadowLayer
    }()
    
    private lazy var timerLabel: UILabel = {
       let timerLabel = UILabel()
        timerLabel.text = "\(mins):0\(secs)"
        timerLabel.textColor = .orange
        timerLabel.textAlignment = .center
        timerLabel.font = .systemFont(ofSize: 45)
        return timerLabel
    }()
  
    
    
// MARK: - Time variables
    lazy var hours: Int = 0
    // timeForTask is also animation duration variable
    lazy var timeForTask: Int = 1500
    lazy var mins: Int = timeForTask / 60
    lazy var secs: Int = (timeForTask % 60) % 60
    var timer = Timer()

    
    
// MARK: - Booleans
    var isWorkingTime: Bool = false
    var timeIsCounting: Bool = false
    var buttonIsPressed: Bool = false
    
    // MARK: - Logics
    
    private func updateLabel() {
        timerLabel.text = "\(mins):\(secs)"
        timerLabel.textAlignment = .center
        if secs < 10 {
            timerLabel.text = "\(mins):0\(secs)"
        }
    }
    
    @objc func startButtonTapped() {
        let startAnimation = CABasicAnimation(keyPath: "strokeEnd")
               startAnimation.toValue = 1
                 startAnimation.duration = CFTimeInterval(timeForTask)
                 startAnimation.fillMode = .forwards
               startAnimation.isRemovedOnCompletion = false
               shapeLayer.add(startAnimation, forKey: "urSoBasic")
        if timeIsCounting == false {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        startPauseTimeButton.setImage(UIImage(systemName: "pause"), for: .normal)
        timeIsCounting = true
        } else {
            timer.invalidate()
            timeIsCounting = false
            startPauseTimeButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
    func changeAppearance() {
        if shadowLayer.strokeColor == UIColor.orange.cgColor {
            shadowLayer.strokeColor = UIColor.systemGreen.cgColor
            shapeLayer.strokeColor = UIColor.systemGreen.cgColor
            startPauseTimeButton.tintColor = .systemGreen
            timerLabel.textColor = .systemGreen
            
        } else if shadowLayer.strokeColor == UIColor.systemGreen.cgColor {
            shadowLayer.strokeColor = UIColor.orange.cgColor
            shapeLayer.strokeColor = UIColor.orange.cgColor
            startPauseTimeButton.tintColor = .orange
            timerLabel.textColor = .orange
        }
        
    }
    
    func changeCountDownTime() {
        if shadowLayer.strokeColor == UIColor.orange.cgColor && mins == 0 && secs == 0 {
            changeAppearance()
            mins += 5
            updateLabel()
        } else if shadowLayer.strokeColor == UIColor.systemGreen.cgColor && mins == 0 && secs == 0 {
            changeAppearance()
            mins += 25
            updateLabel()
        }
    }
    
    @objc func timerAction() {
        if self.secs > 0 {
                         self.secs = self.secs - 1
                     } else if self.mins > 0 && self.secs == 0 {
                         self.mins = self.mins - 1
                         self.secs = 59
                     } else if self.hours > 0 && self.mins == 0 && self.secs == 0 {
                         self.hours = self.hours - 1
                         self.mins = 59
                         self.secs = 59
                     }
        if secs == 0 && mins == 0 {
        buttonIsPressed = false
            timer.invalidate()
            startPauseTimeButton.setImage(UIImage(systemName: "play"), for: .normal)
            print("timer stopeed")
            changeCountDownTime()
            timeIsCounting = false
        }
        updateLabel()
    }
    

    
    //MARK: - Settings
    private func setupHierarchy() {
        view.layer.addSublayer(shadowLayer)
        view.addSubview(startPauseTimeButton)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(timerLabel)
    }
    
    private func setupLayout() {
        startPauseTimeButton.translatesAutoresizingMaskIntoConstraints = false
        startPauseTimeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 280).isActive = true
        startPauseTimeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 180).isActive = true
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        timerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 135).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
      
    }
}
