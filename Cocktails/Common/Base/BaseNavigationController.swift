import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavigationBar()
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .gray
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }

    private func configureNavigationBar() {
        let backIcon = #imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysOriginal)
        if #available(iOS 13, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBar.standardAppearance.shadowColor = .none
            navigationBarAppearance.setBackIndicatorImage(backIcon, transitionMaskImage: backIcon)
            navigationBar.standardAppearance = navigationBarAppearance
        } else {
            navigationBar.backIndicatorImage = backIcon
            navigationBar.backIndicatorTransitionMaskImage = backIcon
        }
    }

    func makeNavigationBarBackgroundTransparent() {
        navigationBar.isTranslucent = true
        if #available(iOS 13, *) {
            navigationBar.standardAppearance.configureWithTransparentBackground()
            navigationBar.standardAppearance.backgroundColor = .clear
        } else {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }

    func setNavigationBarSeparatorHidden(_ isHidden: Bool) {
        let shadowColor: UIColor? = isHidden ? .none : .lightGray
        navigationBar.shadowImage = UIImage()
        if #available(iOS 13, *) {
            navigationBar.standardAppearance.shadowColor = shadowColor
        }
    }

}
