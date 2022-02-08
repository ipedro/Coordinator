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
import Foundation

public var kCoordinatorVerboseLogsEnabled = false

open class BaseCoordinator<StartType>: CoordinatorProtocol, Hashable {
    private let identifier = UUID()

    public var debugLogs: Bool = kCoordinatorVerboseLogsEnabled

    open weak var parent: CoordinatorProtocol?

    open private(set) var children: [CoordinatorProtocol] = []

    public init(parent: CoordinatorProtocol? = nil,
                children: [CoordinatorProtocol] = []) {
        self.parent = parent
        children.forEach { addChild($0) }
    }

    // MARK: - CoordinatorProtocol

    open func didAddChild(_ coordinator: CoordinatorProtocol) {}

    open func addChild(_ coordinator: CoordinatorProtocol) {
        coordinator.parent = self
        
        for child in children where child === coordinator {
            if debugLogs {
                print("⚠️", className, "couldn't add child coordinator. \(coordinator.className) is already added")
            }
            return
        }
        
        children.append(coordinator)
        didAddChild(coordinator)

        if debugLogs {
            print("✅", className, "added", coordinator.className, "(\(children.count) children total)")
        }
    }

    open func didRemoveChild(_ coordinator: CoordinatorProtocol) {}
    
    open func removeChild(_ coordinator: CoordinatorProtocol) {
        guard coordinator.parent == nil || coordinator.parent === self else {
            if debugLogs {
                print("⚠️", className, "can't remove,", coordinator.className, "because it's owned by \(String(describing: coordinator.parent?.className))")
            }
            return
        }

        coordinator.parent = nil

        if let index = children.firstIndex(where: { $0 === coordinator }) {
            children.remove(at: index)
            didRemoveChild(coordinator)

            if debugLogs {
                print("🗑", className, "removed", coordinator.className, "(\(children.count) children total)")
            }
        }
        else {
            if debugLogs {
                print("⚠️", className, "can't remove, coordinator isn't a child", coordinator.className)
            }
        }
    }

    open func didRemoveAllChildren(_ coordinators: [CoordinatorProtocol]) {}

    open func removeAllChildren() {
        let oldValue = children
        children.forEach { $0.parent = nil }
        children.removeAll()
        didRemoveAllChildren(oldValue)
        
        if debugLogs {
            print(className, #function)
            print(className, children)
        }
    }

    public static func == (lhs: BaseCoordinator<StartType>, rhs: BaseCoordinator<StartType>) -> Bool {
        lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - Private Helpers

private extension CoordinatorProtocol {
    var className: String { "'\(type(of: self))'" }
}
