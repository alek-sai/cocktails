import UIKit

class BaseViewController: UIViewController, KeyboardStateDelegate {

    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
    }

    func setNavigationBarHidden(_ isHidden: Bool, animated: Bool) {
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(isHidden, animated: animated)
    }

    // MARK: - KeyboardStateDelegate

    func keyboardWillTransition(_ state: KeyboardState) {

    }

    func keyboardTransitionAnimation(_ state: KeyboardState) {

    }

    func keyboardDidTransition(_ state: KeyboardState) {
    }

    // MARK: - Helpers

    var baseNavigationController: BaseNavigationController? {
        guard let navigationController = navigationController as? BaseNavigationController else { return nil }
        return navigationController
    }
    
    func makeTabBarOpaque() {
        guard let tabBarController = tabBarController else { return }
        tabBarController.tabBar.isTranslucent = false
    }
    
    func makeTabBarTranslucent() {
        guard let tabBarController = tabBarController else { return }
        tabBarController.tabBar.isTranslucent = true
    }

}
