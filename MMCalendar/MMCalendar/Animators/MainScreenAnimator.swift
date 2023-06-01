import UIKit

enum MainScreenAnimator{
    
    
    static func closeView(view: UIView) -> UIViewPropertyAnimator{
        
        let animator = UIViewPropertyAnimator(duration: 0.7,
                                              curve: .easeIn)
        animator.addAnimations {
            view.alpha = 0
        }
        
        return animator
    }
    
    static func openView(view: UIView) -> UIViewPropertyAnimator{
        let animator = UIViewPropertyAnimator(duration: 1.4,
                                              curve: .easeOut)
        animator.addAnimations({
            view.alpha = 1
        }, delayFactor: 0.5)
        return animator
    }
}
