//  Created by David Seek on 11/21/16.
//  Copyright © 2016 David Seek. All rights reserved.

import UIKit

extension UIViewController {
    
    func transition(to controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        present(controller, animated: false)
    }
    
}
class SourceController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let interactor = Interactor()
    
    
    @IBAction func present(_ sender: Any) {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "VC2")
            as? DestinationController else {
                return
        }
        controller.modalPresentationStyle = .fullScreen
        controller.transitioningDelegate = self
        controller.interactor = interactor
        
        transition(to: controller)
    }
    
    // MARK: - Private
    
    
    // MARK: - Animation
    
    func animationController(
        forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            return DismissAnimator()
    }
    
    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            
            return interactor.hasStarted
                ? interactor
                : nil
    }
}

class DestinationController: UIViewController, UIViewControllerTransitioningDelegate {
    
    weak var interactor: Interactor? = nil
    let transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(gesture))
        
        recognizer.edges = .left
        view.addGestureRecognizer(recognizer)
    }
    
    // MARK: - Private
    
    func transitionDismissal() {
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: nil)
        dismiss(animated: false)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        // transitionDismissal()
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "VC3")
            as? ThirdViewController else {
                return
        }
        controller.modalPresentationStyle = .fullScreen
        controller.transitioningDelegate = self
        controller.interactor = interactor
        
        transition(to: controller)
    }
    
    @objc func gesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let fingerMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(fingerMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        switch sender.state {
        case .began:
            
            interactor?.hasStarted = true
            dismiss(animated: true)
            
        case .changed:
            
            interactor?.shouldFinish = progress > percentThreshold
            interactor?.update(progress)
            
        case .cancelled:
            
            interactor?.hasStarted = false
            interactor?.cancel()
            
        case .ended:
            
            guard let interactor = interactor else { return }
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
            
        default:
            break
        }
    }
}


class ThirdViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    weak var interactor: Interactor? = nil
    let transition = CATransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(gesture))
        
        recognizer.edges = .left
        view.addGestureRecognizer(recognizer)
    
    }
    
    // MARK: - Private
    
    func transitionDismissal() {
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window?.layer.add(transition, forKey: nil)
        dismiss(animated: false)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        transitionDismissal()
    }
    
    @objc func gesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let fingerMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(fingerMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        switch sender.state {
        case .began:
            
            interactor?.hasStarted = true
            dismiss(animated: true)
            
        case .changed:
            
            interactor?.shouldFinish = progress > percentThreshold
            interactor?.update(progress)
            
        case .cancelled:
            
            interactor?.hasStarted = false
            interactor?.cancel()
            
        case .ended:
            
            guard let interactor = interactor else { return }
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
            
        default:
            break
        }
    }
}
