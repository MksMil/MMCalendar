import UIKit

class DigitalClock: UIView, MyClock{
    func updateFrame() {
        setNeedsDisplay()
    }
    

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
    
    let timeLabel = UILabel()
    
    var timer = Timer()
    
    override func draw(_ rect: CGRect) {
        timeLabel.frame = frame

        
        let font = UIFont.boldSystemFont(ofSize: self.bounds.height / 5)
        timeLabel.font = font
        
        addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:  self.bounds.height / 4),
//            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        timer = Timer(timeInterval: 1, repeats: true, block: { _ in
            DispatchQueue.main.async {
                self.updateLabel()
            }
        })
        
        RunLoop.current.add(timer, forMode: .default)
    }

    private func updateLabel(){
        timeLabel.text = "\(hourNow > 9 ? "\(hourNow)" : "0\(hourNow)") : \(minNow > 9 ? "\(minNow)" : "0\(minNow)") : \(secNow > 9 ? "\(secNow)" : "0\(secNow)")"
    }
    
    deinit{
        timer.invalidate()
    }
}
