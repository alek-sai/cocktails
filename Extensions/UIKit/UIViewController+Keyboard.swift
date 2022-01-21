import Foundation
import UIKit
import ObjectiveC

/**
 Keyboard state
 - ActiveWithHeight: Keyboard is visible with provided height
 - Hidden: Keyboard is hidden
 */
enum KeyboardState {
    case activeWithHeight(CGFloat)
    case hidden
}

/**
 Keyboard delegate
 */
protocol KeyboardStateDelegate: AnyObject {
    
    /**
     Notifies the receiver that the keyboard will show or hide with specified parameters. This method is called before keyboard animation.
     
     - parameter state: Keyboard state
     */
    func keyboardWillTransition(_ state: KeyboardState)
    
    /**
     Keyboard animation. This method is called inside `UIView` animation block with the same animation parameters as keyboard animation.
     
     - parameter state: Keyboard state
     */
    func keyboardTransitionAnimation(_ state: KeyboardState)
    
    /**
     Notifies the receiver that the keyboard animation finished. This method is called after keyboard animation.
     
     - parameter state: Keyboard state
     */
    func keyboardDidTransition(_ state: KeyboardState)
}

// MARK: - Keyboard

extension UIViewController {
    
    // MARK: Public
    
    /// Current keyboard state
    var keyboardState: KeyboardState {
        return keyboardHeight > 0 ? .activeWithHeight(keyboardHeight) : .hidden
    }
    
    /**
     Register for `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification` notifications.
     
     - parameter keyboardStateDelegate: Keyboard state delegate
     :discussion: It is recommended to call this method in `viewWillAppear:`
     */
    func registerForKeyboardNotifications(_ keyboardStateDelegate: KeyboardStateDelegate) {
        self.keyboardStateDelegate = keyboardStateDelegate
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self,
                                  selector: #selector(UIViewController.keyboardWillShow(_:)),
                                  name: UIResponder.keyboardWillShowNotification,
                                  object: nil)
        defaultCenter.addObserver(self,
                                  selector: #selector(UIViewController.keyboardWillHide(_:)),
                                  name: UIResponder.keyboardWillHideNotification,
                                  object: nil)
    }
    
    /**
     Unregister from `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification` notifications.
     
     :discussion: It is recommended to call this method in `viewWillDisappear:`
     */
    func unregisterFromKeyboardNotifications() {
        self.keyboardStateDelegate = nil
        
        let defaultCenter = NotificationCenter.default
        defaultCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        defaultCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Private
    
    /// Handler for `UIKeyboardWillShowNotification`
    @objc private dynamic func keyboardWillShow(_ notificaion: Notification) {
        if let userInfo = notificaion.userInfo,
            let rect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            
            keyboardHeight = rect.height
            keyboardAnimationToState(.activeWithHeight(keyboardHeight),
                                     duration: duration,
                                     curve: UIView.AnimationCurve(rawValue: curve)!)
            
        }
    }
    
    /// Handler for `UIKeyboardWillHideNotification`
    @objc private dynamic func keyboardWillHide(_ notificaion: Notification) {
        if let userInfo = notificaion.userInfo,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
            
            keyboardHeight = 0.0
            keyboardAnimationToState(.hidden,
                                     duration: duration,
                                     curve: UIView.AnimationCurve(rawValue: curve)!)
        }
    }
    
    /// Keyboard animation
    private func keyboardAnimationToState(_ state: KeyboardState, duration: TimeInterval, curve: UIView.AnimationCurve) {
        keyboardStateDelegate?.keyboardWillTransition(state)
        let curveOption = animationOptions(fromAnimationCurve: curve)
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, curveOption],
                       animations: {
        },
                       completion: { _ in
            self.keyboardAnimationDidStop()
        })
        keyboardStateDelegate?.keyboardTransitionAnimation(state)
    }

    private func animationOptions(fromAnimationCurve curve: UIView.AnimationCurve) -> UIView.AnimationOptions {
        switch curve {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        @unknown default:
            return .overrideInheritedCurve
        }
    }
    
    /// Keyboard animation did stop selector
    @objc private dynamic func keyboardAnimationDidStop() {
        keyboardStateDelegate?.keyboardDidTransition(keyboardState)
    }
    
    // MARK: Private Variables
    
    /**
     Associated keys for private properties
     */
    private struct AssociatedKeys {
        static var KeyboardHeight: UInt8 = 0
        static var KeyboardDelegate: UInt8 = 0
    }
    
    /// Class-container to provide weak semantics for associated properties
    private class WeakObjectContainer {
        weak var delegate: KeyboardStateDelegate?
        
        init(_ delegate: KeyboardStateDelegate?) {
            self.delegate = delegate
        }
    }
    
    /// Keyboard state delegate container
    private var keyboardStateDelegate: KeyboardStateDelegate? {
        get {
            if let delegateContainer = objc_getAssociatedObject(self, &AssociatedKeys.KeyboardDelegate) as? WeakObjectContainer {
                return delegateContainer.delegate
            } else {
                return nil
            }
        }
        set {
            let value: WeakObjectContainer? = newValue != nil ? WeakObjectContainer(newValue!) : nil
            
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.KeyboardDelegate,
                                     value,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /// Keyboard height container
    private var keyboardHeight: CGFloat {
        get {
            guard let keyboardHeight = objc_getAssociatedObject(self, &AssociatedKeys.KeyboardHeight) as? NSNumber else { return 0 }
            return CGFloat(keyboardHeight.floatValue)
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.KeyboardHeight,
                                     NSNumber(value: Float(newValue) as Float),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let isButtonTouched = touch.view?.isKind(of: UIButton.self) else { return true }
        return !isButtonTouched
    }

}
