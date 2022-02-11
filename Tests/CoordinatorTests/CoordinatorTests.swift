import XCTest
import CoordinatorAPI
@testable import Coordinator

final class CoordinatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        CoordinatorSettings.printLogs = true
    }

    override func tearDown() {
        super.tearDown()
        CoordinatorSettings.printLogs = false
    }

    func testInitWithChildrenThenChildCountIsSame() {
        // Given: Coordinator instance
        let child = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        let sut   = Coordinator<Void, UIView, UIWindow>(presenter: UIView(), dependencies: (), children: [child])
        
        // Then: Object is equal to itself
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children.first as? Coordinator<Void, UIView, UINavigationController>, child)
    }

    func testRemoveFromParentThenRemoveChildIsCalledOnParent() {
        // Given: Coordinator instance
        let child = Coordinator<Void, UIView, UIWindow>(presenter: UIView(), dependencies: ())
        let sut = CoordinatorProtocolMock(children: child)

        // When: is removed from parent
        child.removeFromParent()

        // Then: parent's remove child is called
        XCTAssertEqual(sut.didRemoveChild as? Coordinator<Void, UIView, UIWindow>, child)
    }
    
    // MARK: - Hashable Protocol
    
    func testWhenAddCoordinatorToSetMultipleTimesAndCountIsOne() {
        // Given: Coordinator instance
        let sut = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        
        // When: add coordinator to set
        var set = Set<Coordinator<Void, UIView, UINavigationController>>()
        
        set.insert(sut)
        set.insert(sut)
        
        // Then: Object count is one
        XCTAssertEqual(set.count, 1)
    }
    
    func testEqualityWithTheDifferentObjectsThenIsNotEqual() {
        // Given: two different Coordinator instances of the same type
        let lhs = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        let rhs = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        
        // Then: Objects are not equal
        XCTAssertFalse(lhs == rhs)
    }
    
    func testEqualityWithSameObjectThenIsEqual() {
        // Given: two different Coordinator instances of the same type
        let coordinator = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        
        let lhs = coordinator
        let rhs = coordinator
        
        // Then: Objects are equal
        XCTAssertEqual(lhs, rhs)
    }
    
    // MARK: - Coordinator Protocol
    
    func testAddChildTwoTimesThenChildrenCountIsEqualToOne() {
        // Given: Coordinator instance and child coordinator
        let sut   = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        let child = Coordinator<Void, UIView, UIViewController>(presenter: UIView(), dependencies: ())
        
        // When: adding coordinator as child two times
        sut.addChild(child)
        sut.addChild(child)
        
        // Then: chidlren count is one
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(child.parent === sut)
    }
    
    func testRemoveChildThenChildrenCountIsZero() {
        // Given: Coordinator instance and child coordinator
        let child = Coordinator<Void, UIView, UIViewController>(presenter: UIView(), dependencies: ())
        
        let sut = Coordinator<Void, UIView, Void>(presenter: UIView(), dependencies: (), children: [child])
        XCTAssertEqual(sut.children.count, 1)
        
        // When: adding coordinator as child two times
        sut.removeChild(child)
        
        // Then: chidlren count is one
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertNil(child.parent)
    }
    
    func testRemoveChildThenChildrenCountIsOne() {
        // Given: Coordinator instance with two child coordinators
        let firstChild  = Coordinator<Void, UIView, UIViewController>(presenter: UIView(), dependencies: ())
        let secondChild = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        
        let sut = Coordinator<Void, UIView, Void>(presenter: UIView(), dependencies: (), children: [firstChild, secondChild])
        XCTAssertEqual(sut.children.count, 2)
        
        // When: remove first child coordinator
        sut.removeChild(firstChild)
        
        // Then: remaining child is second child
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children.first as? Coordinator<Void, UIView, UINavigationController>, secondChild)
        XCTAssertNil(firstChild.parent)
        XCTAssertTrue(secondChild.parent === sut)
    }

    func testRemoveChildrenOwnedByAnotherCoordinatorThenChildrenAreNotRemoved() {
        // Given: Coordinator instance with two child coordinators
        let firstChild  = Coordinator<Void, UIView, UIViewController>(presenter: UIView(), dependencies: ())
        let secondChild = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())

        let anotherCoordinator = Coordinator<Void, UIView, Void>(presenter: UIView(), dependencies: (), children: [firstChild, secondChild])

        let sut = Coordinator<Void, UIView, Void>(presenter: UIView(), dependencies: ())

        // When: remove children
        sut.removeChild(firstChild)
        sut.removeChild(secondChild)

        // Then: children are not removed
        XCTAssertEqual(anotherCoordinator.children.count, 2)
        XCTAssertTrue(firstChild.parent === anotherCoordinator)
        XCTAssertTrue(secondChild.parent === anotherCoordinator)
    }
    
    func testRemoveAllChildrenThenChildrenCountIsZero() {
        // Given: Coordinator instance with two child coordinators
        let firstChild  = Coordinator<Void, UIView, UIViewController>(presenter: UIView(), dependencies: ())
        let secondChild = Coordinator<Void, UIView, UINavigationController>(presenter: UIView(), dependencies: ())
        
        let sut = Coordinator<Void, UIView, Void>(presenter: UIView(), dependencies: (), children: [firstChild, secondChild])
        XCTAssertEqual(sut.children.count, 2)
        
        // When: remove all children
        sut.removeAllChildren()
        
        // Then: no children are left
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertNil(firstChild.parent)
        XCTAssertNil(secondChild.parent)
    }
}
