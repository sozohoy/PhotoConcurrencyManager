import Foundation
import Photos

public extension PhotoImageOptions {
    @frozen
    enum Version: Sendable {
        case current
        case unadjusted
        case original

        var option: PHImageRequestOptionsVersion {
            switch self {
            case .current: return .current
            case .unadjusted: return .unadjusted
            case .original: return .original
            }
        }
    }
}
