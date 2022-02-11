import UIKit
import CoordinatorAPI

open class DismissableNavigationController: UINavigationController, Dismissable {
    public var dismissHandler: ((DismissableNavigationController) -> Void)?

    private lazy var presentationControllerDelegate = AdaptivePresentationControllerDelegate(
        onDismiss: { [weak self] _ in
            guard let self = self else { return }

            for case let dismissableViewController as DismissableViewController in self.viewControllers {
                dismissableViewController.dismissHandler?(dismissableViewController)
            }

            self.dismissHandler?(self)
        }
    )

    open override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = presentationControllerDelegate
    }
}
