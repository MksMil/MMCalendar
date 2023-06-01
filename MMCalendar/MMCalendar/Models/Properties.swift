import Foundation


// task priority
enum Priority {
    case low
    case medium
    case high
    case celebrity
}

//structure that define single task, used for date
struct Task {
    var name: String
    var beginTime: Date?
    var endTime: Date?
    var priority: Priority
}
//State of Main Screen
enum State: Int {
    case initial
    case calendar
    case timer
    case scheduler
    case settings
}

