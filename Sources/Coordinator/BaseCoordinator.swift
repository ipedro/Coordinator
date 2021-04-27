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


import Foundation

open class BaseCoordinator<StartType> {
    private let identifier = UUID()
    
    open weak var parent: CoordinatorProtocol?
    
    open private(set) var children: [CoordinatorProtocol] = []
    
    public init(children: [CoordinatorProtocol] = []) {
        children.forEach { addChild($0) }
    }
}

// MARK: - CoordinatorProtocol

extension BaseCoordinator: CoordinatorProtocol {
    open func addChild(_ coordinator: CoordinatorProtocol) {
        coordinator.parent = self
        
        for child in children where child === coordinator {
            return
        }
        
        children.append(coordinator)
    }
    
    open func removeChild(_ coordinator: CoordinatorProtocol) {
        if let index = children.firstIndex(where: { $0 === coordinator }) {
            let child = children.remove(at: index)
            child.parent = nil
        }
    }
    
    open func removeAllChildren() {
        children.forEach { removeChild($0) }
    }
}

// MARK: - Hashable

extension BaseCoordinator: Hashable {
    public static func == (lhs: BaseCoordinator<StartType>, rhs: BaseCoordinator<StartType>) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        identifier.hash(into: &hasher)
    }
}
