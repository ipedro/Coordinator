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
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public typealias CoordinatorStartable = CoordinatorProtocol & Startable

// MARK: - UIViewController based StartType

public extension Startable where Self: CoordinatorProtocol, StartType: UIViewController {
    /// Starts a child Coordinator and presents its start view controller modally from the top view controller.
    /// - Parameters:
    ///   - coordinator: A Coordinator to be added as child.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    func start<AnyCoordinator: CoordinatorStartable>(presenting coordinator: AnyCoordinator,
                                                     animated: Bool) where AnyCoordinator.StartType: RootViewControllerProtocol
    {
        addChild(coordinator)

        let startViewController = coordinator.start()

        start().topViewController.present(startViewController, animated: animated)
    }
}

// MARK: - RootViewControllerProtocol based StartType

public extension Startable where Self: CoordinatorProtocol, StartType: RootViewControllerProtocol {
    /// Adds the child Coordinator to its children and then pushes the starting view controller onto the navigation controller's stack and updates the display.
    /// - Parameters:
    ///   - coordinator: A Coordinator to be added as child.
    ///   - navigationController: The navigation controller where the presentation will happen.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    func start<AnyCoordinator: CoordinatorStartable>(pushing coordinator: AnyCoordinator,
                                                     in navigationController: UINavigationController,
                                                     animated: Bool) where AnyCoordinator.StartType: UIViewController
    {
        addChild(coordinator)

        let startViewController = coordinator.start()

        navigationController.pushViewController(startViewController, animated: animated)
    }
}

// MARK: - UINavigationController based StartType

public extension Startable where Self: CoordinatorProtocol, StartType: UINavigationController {
    /// Adds the child Coordinator to its children and then pushes the starting view controller onto its start navigation controller's stack and updates the display.
    /// - Parameters:
    ///   - coordinator: A Coordinator to be added as child.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    func start<AnyCoordinator: CoordinatorStartable>(pushing coordinator: AnyCoordinator,
                                                     animated: Bool) where AnyCoordinator.StartType: UIViewController
    {
        addChild(coordinator)

        let startViewController = coordinator.start()

        start().pushViewController(startViewController, animated: animated)
    }
}

// MARK: - UIWindow based StartType

public extension Startable where Self: CoordinatorProtocol, StartType: UIWindow {
    /// Replaces existing children with the child coordinator and installs the starting view controller’s view as the content view of the window.
    /// - Parameter coordinator: A Coordinator to be added as child.
    func start<AnyCoordinator: CoordinatorStartable>(root coordinator: AnyCoordinator) where AnyCoordinator.StartType: RootViewControllerProtocol {
        removeAllChildren()

        addChild(coordinator)

        let startRootViewController = coordinator.start()

        start().rootViewController = startRootViewController
        start().makeKeyAndVisible()
    }

    /// Starts a child Coordinator and presents its start view controller modally from the starting window's top view controller.
    /// - Parameters:
    ///   - coordinator: A Coordinator to be added as child.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    func start<AnyCoordinator: CoordinatorStartable>(presenting coordinator: AnyCoordinator,
                                                     animated: Bool) where AnyCoordinator.StartType: RootViewControllerProtocol
    {
        addChild(coordinator)

        let startRootViewController = coordinator.start()

        start().makeKeyAndVisible()
        start().rootViewController?.topViewController.present(startRootViewController, animated: animated)
    }
}
