import UIKit

public final class Weak<Object: AnyObject> {
    private let objectIdentifier: ObjectIdentifier
    public weak var weakReference: Object?

    public init(_ object: Object) {
        self.objectIdentifier = ObjectIdentifier(object)
        self.weakReference = object
    }
}

extension Weak: Hashable {
    public static func == (lhs: Weak<Object>, rhs: Weak<Object>) -> Bool {
        lhs.objectIdentifier == rhs.objectIdentifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier)
    }
}
