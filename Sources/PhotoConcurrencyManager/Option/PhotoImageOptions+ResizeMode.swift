import Foundation
import Photos

public extension PhotoImageOptions {
    @frozen
    enum ResizeMode: Sendable {
        case exact
        case fast
        case none

        var option: PHImageRequestOptionsResizeMode {
            switch self {
            case .exact: return .exact
            case .fast: return .fast
            case .none: return .none
            }
        }
    }
}
