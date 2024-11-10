import Foundation
import Photos

public extension PhotoImageOptions {
    @frozen
    enum ContentMode: Sendable {
        case aspectFit
        case aspectFill

        var option: PHImageContentMode {
            switch self {
            case .aspectFit: return .aspectFit
            case .aspectFill: return .aspectFill
            }
        }
    }
}
