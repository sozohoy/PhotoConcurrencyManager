import Foundation

public extension PhotoImageOptions {
    @frozen
    enum SynchronousMode: Sendable {
        case sync
        case async

        var option: Bool {
            switch self {
            case .sync: return true
            case .async: return false
            }
        }
    }
}
