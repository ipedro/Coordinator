import UIKit
import CoordinatorAPI

public final class AdaptivePresentationControllerDelegate: NSObject, UIAdaptivePresentationControllerDelegate, Dismissable {
    public typealias ModalPresentationStyleProvider = (UIPresentationController, UITraitCollection) -> UIModalPresentationStyle

    public typealias DismissDecisionProvider = (UIPresentationController) -> Bool

    public var dismissHandler: ((AdaptivePresentationControllerDelegate) -> Void)?

    public let adaptivePresentationStyleProvider: ModalPresentationStyleProvider?

    public let shouldDismissProvider: DismissDecisionProvider?

    public let dismissAttemptHandler: (() -> Void)?

    public init(onDismiss dismissHandler: ((AdaptivePresentationControllerDelegate) -> Void)? = .none,
                adaptivePresentationStyle adaptivePresentationStyleProvider: ModalPresentationStyleProvider? = .none,
                shouldDismiss shouldDismissProvider: DismissDecisionProvider? = .none,
                onDismissAttempt dismissAttemptHandler: (() -> Void)? = .none)
    {
        self.dismissHandler = dismissHandler
        self.adaptivePresentationStyleProvider = adaptivePresentationStyleProvider
        self.shouldDismissProvider = shouldDismissProvider
        self.dismissAttemptHandler = dismissAttemptHandler
    }

    public func presentationControllerDidDismiss(_: UIPresentationController) {
        dismissHandler?(self)
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController,
                                          traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        if #available(iOS 13.0, *) {
            return adaptivePresentationStyleProvider?(controller, traitCollection) ?? .automatic
        } else {
            return adaptivePresentationStyleProvider?(controller, traitCollection) ?? .fullScreen
        }
    }

    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        shouldDismissProvider?(presentationController) ?? true
    }

    public func presentationControllerDidAttemptToDismiss(_: UIPresentationController) {
        dismissAttemptHandler?()
    }
}
