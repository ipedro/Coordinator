//  Copyright (c) 2021 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WorITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CoordinatorAPI
import UIKit

open class Coordinator<Dependencies, Presenter: UIResponder, StartType>: CoordinatorProtocol, Dismissable, Startable {
    open private(set) var presenter: Presenter

    public let dependencies: Dependencies

    open weak var parent: CoordinatorProtocol?

    open private(set) var children: [CoordinatorProtocol] = []

    private let identifier = UUID()

    open var dismissHandler: ((Coordinator<Dependencies, Presenter, StartType>) -> Void)?

    open var startObject: StartType!

    open private(set) var isStarted = false

    public init(presenter: Presenter,
                dependencies: Dependencies,
                parent: CoordinatorProtocol? = nil,
                children: [CoordinatorProtocol] = [])
    {
        self.dependencies = dependencies
        self.presenter = presenter
        self.parent = parent
        children.forEach { addChild($0) }
    }

    // MARK: - Start

    /// This method gets called before `start()` is called for the first time.
    open func loadStart() -> StartType { fatalError("loadStart() not implemented") }

    /// This method gets called every time `start()` is about to be called.
    open func willStart() {}

    /// This method gets called every time after `start()` has been called.
    open func didStart() {}

    open func start() -> StartType {
        let needsSetup = !isStarted
        isStarted = true

        if needsSetup {
            startObject = loadStart()
        }
        willStart()
        defer {
            if needsSetup {
                didStart()
            }
        }
        return startObject
    }

    // MARK: - Remove From Parent

    open func willRemoveFromParent() {}

    open func didRemoveFromParent() {}

    public func removeFromParent() {
        willRemoveFromParent()
        parent?.removeChild(self)
        dismissHandler?(self)
        didRemoveFromParent()
    }

    // MARK: - Add Child

    open func willAddChild(_ coordinator: CoordinatorProtocol) {}

    open func didAddChild(_ coordinator: CoordinatorProtocol) {}

    public func addChild(_ coordinator: CoordinatorProtocol) {
        coordinator.parent = self

        for child in children where child === coordinator {
            return debugLog("⚠️", className, "couldn't add child coordinator. \(coordinator.className) is already added")
        }

        willAddChild(coordinator)
        children.append(coordinator)
        didAddChild(coordinator)

        debugLog("✅", className, "added", coordinator.className, "(\(children.count) children total)")
    }

    // MARK: - Remove Child

    open func willRemoveChild(_ coordinator: CoordinatorProtocol) {}

    open func didRemoveChild(_ coordinator: CoordinatorProtocol) {}

    public func removeChild(_ coordinator: CoordinatorProtocol) {
        guard coordinator.parent === self else {
            return debugLog("⚠️", className, "can't remove ", coordinator.className, ", it's owned by \(String(describing: coordinator.parent?.className))")
        }

        coordinator.parent = nil

        if let index = children.firstIndex(where: { $0 === coordinator }) {
            willRemoveChild(coordinator)
            children.remove(at: index)
            didRemoveChild(coordinator)
            debugLog("🗑", className, "removed", coordinator.className, "\(children.count) children total.")
        }
        else {
            debugLog("⚠️", className, "can't remove, coordinator isn't a child", coordinator.className)
        }
    }

    public func removeAllChildren() {
        children.forEach { removeChild($0) }
    }

}

// MARK: - Convenience

public extension Coordinator where Dependencies == Void {
    convenience init(presenter: Presenter,
                     parent: CoordinatorProtocol? = nil,
                     children: [CoordinatorProtocol] = [])
    {
        self.init(presenter: presenter, dependencies: (), parent: parent, children: children)
    }
}

public extension Coordinator where Presenter: UIWindow {
    /// The window that is presenting this Coordinator's start type.
    var presentingWindow: Presenter { presenter }
}

public extension Coordinator where Presenter: UINavigationController {
    /// The navigation controller that is presenting this Coordinator's start type.
    var presentingNavigationController: Presenter { presenter }
}

public extension Coordinator where Presenter: UISplitViewController {
    /// The split view controller that is presenting this Coordinator's start type.
    var presentingSplitViewController: Presenter { presenter }
}

public extension Coordinator where Presenter: UITabBarController {
    /// The tab bar controller that is presenting this Coordinator's start type.
    var presentingTabBarController: Presenter { presenter }
}

public extension Coordinator where Presenter: UIViewController {
    /// The view controller that is presenting this Coordinator's start type.
    var presentingViewController: Presenter { presenter }
}

public extension Coordinator where Presenter: UIApplicationDelegate {
    /// The application delegate that is presenting this Coordinator's start type.
    var applicationDelegate: Presenter { presenter }
}

@available(iOS 13.0, *)
public extension Coordinator where Presenter: UISceneDelegate {
    /// The scene delegate that is presenting this Coordinator's start type.
    var sceneDelegate: Presenter { presenter }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public extension Coordinator where Presenter: UIHostingController<StartType>, StartType: View {
    var hostingController: Presenter { presenter }
}
#endif

// MARK: - Hashable

extension Coordinator: Hashable {
    public static func == (lhs: Coordinator<Dependencies, Presenter, StartType>, rhs: Coordinator<Dependencies, Presenter, StartType>) -> Bool {
        lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - Private Helpers

private extension Coordinator {
    func debugLog(_ items: String...) {
        if CoordinatorSettings.printLogs {
            print(items.joined(separator: " "))
        }
    }
}

private extension CoordinatorProtocol {
    var className: String { "'\(type(of: self))'" }
}
