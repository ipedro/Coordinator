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

@testable import Coordinator
import CoordinatorAPI
import XCTest

final class StartableCoordinatorProtocolTests: XCTestCase {
    func testStartContainerViewControllerCoordinatorPresentingFromViewControllerCoordinatorThenIsPresented() {
        // Given: view controller coordinator
        let sut = ViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut.start()
        window.makeKeyAndVisible()

        // When: starts presenting child
        let child = ContainerViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())
        sut.start(presenting: child, animated: false)

        // Then: child start is presented
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.children.first === child)
        XCTAssertTrue(sut.start().presentedViewController === child.start())
    }

    func testStartViewControllerCoordinatorPushingInNavigationControllerFromContainerViewControllerCoordinatorThenIsPushed() {
        // Given: root view controller coordinator
        let sut = ContainerViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut.start()
        window.makeKeyAndVisible()

        // When: pushes child into navigation controller
        let navigationController = UINavigationController(rootViewController: UIViewController())
        sut.start().present(navigationController, animated: false)

        let child = ViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())

        sut.start(pushing: child, in: navigationController, animated: false)

        // Then: child start is pushed in navigation controller
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.children.first === child)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertTrue(navigationController.viewControllers.last === child.start())
    }

    func testStartViewControllerCoordinatorPushingFromNavigationControllerCoordinatorStartThenIsPushed() {
        // Given: navigation view controller coordinator
        let sut = NavigationControllerCoordinatorMock(presenter: UIView(), dependencies: ())

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut.start()
        window.makeKeyAndVisible()

        // When: pushes child
        let child = ViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())

        sut.start(pushing: child, animated: false)

        // Then: child start is pushed in navigation controller
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.children.first === child)
        XCTAssertEqual(sut.start().viewControllers.count, 2)
        XCTAssertTrue(sut.start().viewControllers.last === child.start())
    }

    func testStartContainerViewControllerCoordinatorInRootFromWindowCoordinatorStartThenIsRoot() {
        // Given: window coordinator with children
        let sut = WindowCoordinatorMock(
            presenter: UIView(), dependencies: (),
            children: [
                ContainerViewControllerCoordinatorMock(presenter: UIView(), dependencies: ()),
                ContainerViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())
            ])

        // When: starts child as root
        let child = ContainerViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())
        sut.start(root: child)

        // Then: child start is window root view controller
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.children.first === child)
        XCTAssertTrue(sut.start().rootViewController === child.start())
    }

    func testStartContainerViewControllerCoordinatorPresentingFromRootFromWindowCoordinatorStartThenIsPushed() {
        // Given: window coordinator
        let sut = WindowCoordinatorMock(presenter: UIView(), dependencies: ())
        sut.start().rootViewController = UIViewController()

        // When: starts pushing child
        let child = ContainerViewControllerCoordinatorMock(presenter: UIView(), dependencies: ())
        sut.start(presenting: child, animated: false)

        // Then: child start is presented
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(sut.children.first === child)
        XCTAssertTrue(sut.start().rootViewController?.presentedViewController === child.start())
    }
}
