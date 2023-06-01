import UIKit

class AnalogClock: UIView, MyClock {
    
    // MARK: - Properties
    //clock layers
    private let clockFaceLayer: CAShapeLayer = CAShapeLayer()
    private let hourPointer: CAShapeLayer = CAShapeLayer()
    private let minutePointer: CAShapeLayer = CAShapeLayer()
    private let secondsPointer: CAShapeLayer = CAShapeLayer()
    private let circleLayer: CAShapeLayer = CAShapeLayer()
    
    private var width: CGFloat {
        get{ min(frame.height, frame.width) * 0.75 }
    }
    private var height: CGFloat {
        get{ min(frame.height, frame.width) * 0.75 }
    }
    
    //angle steps
    private let secondAngle: CGFloat = CGFloat.pi / 30
    private let minutesAngle: CGFloat = CGFloat.pi / 30
    private let hourAngle: CGFloat = 5 * CGFloat.pi / 30
    
    //time components
    private var hourNow: Int  {
        get{
            Calendar.current.component(.hour, from: Date.now)
        }
    }
    private var minNow: Int {
        get{
            Calendar.current.component(.minute, from: Date.now)
        }
    }
    private var secNow: Int {
        get{
            Calendar.current.component(.second, from: Date())
        }
    }
    
    
    // MARK: - Lifecycle
    override func draw(_ rect: CGRect){
        setupClock()
        animatePointers()
        print(secNow)
    }
    
    func updateFrame(){
//        if let superView = superview{
//            setNeedsDisplay(superView.bounds)
//            print("updated")
//        }
        setNeedsDisplay()
    }
    
    // MARK: - ClockFace
    private func setupClock(){
        addClockFace()
        addHourPointer()
        addMinutePointer()
        addCircle()
        addSecondsPointer()
    }
    
    private func addClockFace(){
        clockFaceLayer.frame = CGRect(x: self.center.x, y: self.center.y, width: 0, height: 0)
        let path = CGMutablePath()
        stride(from: 0, to: CGFloat.pi * 2 , by: CGFloat.pi / 30).forEach { angle in
            var transform = CGAffineTransform(rotationAngle: angle).translatedBy(x: 0, y: height / 2)
            if (angle / (CGFloat.pi / 30) >= 5  || angle == 0) &&
                (angle / (CGFloat.pi / 30)).truncatingRemainder(dividingBy: 5) == 0 {
                let piece = CGPath(rect: CGRect(x: -2, y: 0, width: 4, height: 20), transform: &transform)
                path.addPath(piece)
            } else {
                let piece = CGPath(rect: CGRect(x: -1, y: 0, width: 2, height: 10), transform: &transform)
                path.addPath(piece)
            }
        }
        clockFaceLayer.path = path
        clockFaceLayer.fillColor = UIColor.black.cgColor
        layer.addSublayer(clockFaceLayer)
    }
    
    // MARK: - Pointers
    private func addHourPointer(){
        hourPointer.frame = CGRect.zero
        let path = CGMutablePath()
        let transform = CGAffineTransform(translationX: 0, y: -height / 3)
        path.addRect(CGRect(x: -6, y: 0, width: 12, height: height / 3),transform: transform)
        hourPointer.path = path
        hourPointer.fillColor = UIColor.black.cgColor
        clockFaceLayer.addSublayer(hourPointer)
    }
    
    private func addMinutePointer(){
        minutePointer.frame = CGRect.zero
        let path = CGMutablePath()
        let transform = CGAffineTransform(translationX: 0, y: -height / 2)
        path.addRect(CGRect(x: -3, y: 0, width: 6, height: height / 2), transform: transform)
        minutePointer.path = path
        minutePointer.fillColor = UIColor.gray.cgColor
        clockFaceLayer.addSublayer(minutePointer)
    }
    
    private func addSecondsPointer(){
        secondsPointer.frame = CGRect.zero
        let path = CGMutablePath()
        let transform = CGAffineTransform(translationX: 0, y: -(20 + height / 2))
        path.addRect(CGRect(x: -1.5,
                            y: 0,
                            width: 3,
                            height: 20 + height / 2),
                     transform: transform)
        secondsPointer.path = path
        secondsPointer.fillColor = UIColor.white.cgColor
        clockFaceLayer.addSublayer(secondsPointer)
    }
    
    private func addCircle(){
        circleLayer.frame = CGRect(x: -9,
                                   y: -9,
                                   width: 18,
                                   height: 18)
        circleLayer.cornerRadius = 9
        circleLayer.backgroundColor = UIColor.black.cgColor
        clockFaceLayer.addSublayer(circleLayer)
    }
    
    // MARK: - Animation
    
    fileprivate func animateHourPointer() {
        let hourAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        hourAnimation.repeatCount = CFloat.infinity
        hourAnimation.duration = 3600 * 12
        hourAnimation.fromValue = self.hourAngle * CGFloat(self.hourNow) + self.hourAngle * CGFloat(self.minNow) / 60
        hourAnimation.byValue = 2 * CGFloat.pi
        hourAnimation.isRemovedOnCompletion = false
        hourAnimation.timingFunction = .init(name: .linear)
        self.hourPointer.add(hourAnimation, forKey: nil)
    }
    
    fileprivate func animateMinutePointer() {
        let minuteAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        minuteAnimation.repeatCount = CFloat.infinity
        minuteAnimation.duration = 3600
        minuteAnimation.fromValue = self.minutesAngle * CGFloat(self.minNow) + self.minutesAngle * CGFloat(self.secNow) / 60
        minuteAnimation.byValue = 2 * CGFloat.pi
        minuteAnimation.isRemovedOnCompletion = false
        minuteAnimation.timingFunction = .init(name: .linear)
        self.minutePointer.add(minuteAnimation, forKey: nil)
    }
    
    fileprivate func animateSecondsPointer() {
        let secondsAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        secondsAnimation.repeatCount = CFloat.infinity
        secondsAnimation.duration = 60
        secondsAnimation.fromValue = self.secondAngle * CGFloat(self.secNow)
        secondsAnimation.byValue = 2 * CGFloat.pi
        secondsAnimation.isRemovedOnCompletion = false
        secondsAnimation.timingFunction = .init(name: .linear)
        self.secondsPointer.add(secondsAnimation, forKey: nil)
    }
    
    func animatePointers(){
        animateHourPointer()
        animateMinutePointer()
        animateSecondsPointer()
    }
}
//extension AnalogClock: CAAnimationDelegate{
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        guard let name = anim.value(forKey: "name") as? String, name == "seconds" else { return }
//        secondsPointer.removeAllAnimations()
//        secondsPointer.transform = CATransform3DRotate(secondsPointer.transform,secondAngle * CGFloat(secNow), 0, 0, 1)
//        animateSecondsPointer()
//    }
//}
