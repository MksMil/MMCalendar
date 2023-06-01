import UIKit

class ViewController: UIViewController {
    
    //main screen state
    var state: State = .calendar
    
    //data
    var tasks: [Task] = [Task(name: "Morning", beginTime: nil, endTime: nil, priority: .medium),
                         Task(name: "Завтрак", priority: .high),
                         Task(name: "HappyBirthday!!!", priority: .celebrity)]
    
    var taskList: [String: [Task]] = [:]
    var currentDate: Date = Date.now
    
    
    var mainView: MMMainView!
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //load tasks
        
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)

        mainView = MMMainView(frame: view.frame)
        view.addSubview(mainView)
        mainView.setupMainView(state: state)
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //animation testing
//        print("begin animation")
//        UIView.animate(withDuration: 15,
//                       delay: 5,
//                       options: []) {
//            self.mainView.viewsFractionVerticalRegular = 1/6
//            self.mainView.layoutIfNeeded()
//        } completion: { _ in
//            print("finish animation")
//        }

    }
    
}
