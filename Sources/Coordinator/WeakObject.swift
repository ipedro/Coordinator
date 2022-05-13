import UIKit

public final class Weak<Object: AnyObject> {
    public weak var weakReference: Object?

    public init(_ object: Object) {
        self.weakReference = object
    }
}
