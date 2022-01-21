import UIKit

protocol CoordinatorInterface: AnyObject {
    var childCoordinators: [WeakCoordinatorInterface] { get set }
    func start()
}

final class WeakCoordinatorInterface {

    weak var value: CoordinatorInterface?

    init(value: CoordinatorInterface) {
        self.value = value
    }

}

class BaseCoordinator: NSObject, CoordinatorInterface {

	// MARK: - Coordinate variables

	var childCoordinators = [WeakCoordinatorInterface]()

	// MARK: - Navigation variables

	weak var window: UIWindow?
	weak var navigationController: UINavigationController?
	weak var rootViewController: UIViewController?

	// MARK: - Lifecycle

	init(window: UIWindow?) {
		self.window = window
	}

	init(rootViewController: UIViewController?) {
		self.rootViewController = rootViewController
	}

	init(navigationController: UINavigationController?) {
		self.navigationController = navigationController
	}

	deinit {
		childCoordinators.removeAll()
	}

	// MARK: - Public

	func start() {}

	func onNext(childCoordinator: BaseCoordinator) {
		childCoordinators.append(.init(value: childCoordinator))
		childCoordinator.start()
	}

}
