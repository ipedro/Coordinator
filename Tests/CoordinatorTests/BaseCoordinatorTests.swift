import XCTest
import CoordinatorAPI
@testable import Coordinator

final class BaseCoordinatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        kCoordinatorVerboseLogsEnabled = true
    }

    override func tearDown() {
        super.tearDown()
        kCoordinatorVerboseLogsEnabled = false
    }

    func testInitWithChildrenThenChildCountIsSame() {
        // Given: BaseCoordinator instance
        let child = BaseCoordinator<UINavigationController>()
        let sut   = BaseCoordinator<Void>(children: [child])
        
        // Then: Object is equal to itself
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children.first as? BaseCoordinator<UINavigationController>, child)
    }
    
    // MARK: - Hashable Protocol
    
    func testWhenAddCoordinatorToSetMultipleTimesAndCountIsOne() {
        // Given: BaseCoordinator instance
        let sut = BaseCoordinator<UINavigationController>()
        
        // When: add coordinator to set
        var set = Set<BaseCoordinator<UINavigationController>>()
        
        set.insert(sut)
        set.insert(sut)
        
        // Then: Object count is one
        XCTAssertEqual(set.count, 1)
    }
    
    func testEqualityWithTheDifferentObjectsThenIsNotEqual() {
        // Given: two different BaseCoordinator instances of the same type
        let lhs = BaseCoordinator<UINavigationController>()
        let rhs = BaseCoordinator<UINavigationController>()
        
        // Then: Objects are not equal
        XCTAssertFalse(lhs == rhs)
    }
    
    func testEqualityWithSameObjectThenIsEqual() {
        // Given: two different BaseCoordinator instances of the same type
        let coordinator = BaseCoordinator<UINavigationController>()
        
        let lhs = coordinator
        let rhs = coordinator
        
        // Then: Objects are equal
        XCTAssertEqual(lhs, rhs)
    }
    
    // MARK: - Coordinator Protocol
    
    func testAddChildTwoTimesThenChildrenCountIsEqualToOne() {
        // Given: BaseCoordinator instance and child coordinator
        let sut   = BaseCoordinator<UINavigationController>()
        let child = BaseCoordinator<UIViewController>()
        
        // When: adding coordinator as child two times
        sut.addChild(child)
        sut.addChild(child)
        
        // Then: chidlren count is one
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(child.parent === sut)
    }
    
    func testRemoveChildThenChildrenCountIsZero() {
        // Given: BaseCoordinator instance and child coordinator
        let child = BaseCoordinator<UIViewController>()
        
        let sut = BaseCoordinator<Void>(children: [child])
        XCTAssertEqual(sut.children.count, 1)
        
        // When: adding coordinator as child two times
        sut.removeChild(child)
        
        // Then: chidlren count is one
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertNil(child.parent)
    }
    
    func testRemoveChildThenChildrenCountIsOne() {
        // Given: BaseCoordinator instance with two child coordinators
        let firstChild  = BaseCoordinator<UIViewController>()
        let secondChild = BaseCoordinator<UINavigationController>()
        
        let sut = BaseCoordinator<Void>(children: [firstChild, secondChild])
        XCTAssertEqual(sut.children.count, 2)
        
        // When: remove first child coordinator
        sut.removeChild(firstChild)
        
        // Then: remaining child is second child
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertEqual(sut.children.first as? BaseCoordinator<UINavigationController>, secondChild)
        XCTAssertNil(firstChild.parent)
        XCTAssertTrue(secondChild.parent === sut)
    }

    func testRemoveChildrenOwnedByAnotherCoordinatorThenChildrenAreNotRemoved() {
        // Given: BaseCoordinator instance with two child coordinators
        let firstChild  = BaseCoordinator<UIViewController>()
        let secondChild = BaseCoordinator<UINavigationController>()

        let anotherCoordinator = BaseCoordinator<Void>(children: [firstChild, secondChild])

        let sut = BaseCoordinator<Void>()

        // When: remove children
        sut.removeChild(firstChild)
        sut.removeChild(secondChild)

        // Then: children are not removed
        XCTAssertEqual(anotherCoordinator.children.count, 2)
        XCTAssertTrue(firstChild.parent === anotherCoordinator)
        XCTAssertTrue(secondChild.parent === anotherCoordinator)
    }
    
    func testRemoveAllChildrenThenChildrenCountIsZero() {
        // Given: BaseCoordinator instance with two child coordinators
        let firstChild  = BaseCoordinator<UIViewController>()
        let secondChild = BaseCoordinator<UINavigationController>()
        
        let sut = BaseCoordinator<Void>(children: [firstChild, secondChild])
        XCTAssertEqual(sut.children.count, 2)
        
        // When: remove all children
        sut.removeAllChildren()
        
        // Then: no children are left
        XCTAssertTrue(sut.children.isEmpty)
        XCTAssertNil(firstChild.parent)
        XCTAssertNil(secondChild.parent)
    }
}
