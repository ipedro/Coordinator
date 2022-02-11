import UIKit
import CoordinatorAPI

open class DismissableViewController: UIViewController, Dismissable {
    open var dismissHandler: ((DismissableViewController) -> Void)?

    override open func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard isViewLoaded, parent == .none else { return }
        dismissHandler?(self)
    }

}
