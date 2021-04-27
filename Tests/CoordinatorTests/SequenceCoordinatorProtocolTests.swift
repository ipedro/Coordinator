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


import XCTest
@testable import Coordinator

final class SequenceCoordinatorProtocolTests: XCTestCase {
    
    func testWhenFilterNavigationControllerCoordinatorMockThenCountIsOne() {
        // Given: coordinator protocol mock with two children of different types
        let firstChild  = ViewControllerCoordinatorMock()
        let secondChild = NavigationControllerCoordinatorMock()
        
        let sut = CoordinatorProtocolMock(children: firstChild, secondChild)
        sut.addChild(firstChild)
        sut.addChild(secondChild)
        
        // When: filter children of type navigation controller coordinator mock
        let result = sut.children.filter(type: NavigationControllerCoordinatorMock.self)
        
        // Then: no children are left
        XCTAssertEqual(sut.children.count, 2)
        XCTAssertEqual(result, [secondChild])
    }
    
    func testWhenLoopForEachNavigationControllerCoordinatorMockThenExecutionCountIsOne() {
        // Given: coordinator protocol mock with two children of different types
        let firstChild  = ViewControllerCoordinatorMock()
        let secondChild = NavigationControllerCoordinatorMock()
        
        let sut = CoordinatorProtocolMock(children: firstChild, secondChild)
        sut.addChild(firstChild)
        sut.addChild(secondChild)
        
        var loopedItems = [CoordinatorProtocol]()
        
        // When: filter children of type view controller coordinator mock
        sut.children.forEach(type: ViewControllerCoordinatorMock.self) {
            loopedItems.append($0)
        }
        
        // Then: no children are left
        XCTAssertEqual(sut.children.count, 2)
        XCTAssertEqual(loopedItems.count, 1)
        XCTAssertTrue(loopedItems.first === firstChild)
    }
    
}
