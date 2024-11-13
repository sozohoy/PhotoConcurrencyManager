import Foundation
import Photos

public extension PhotoImageOptions {
    enum DeliveryMode: Sendable {
        case fast
        case opportunistic
        case highQuality

        var option: PHImageRequestOptionsDeliveryMode {
            switch self {
            case .fast: return .fastFormat
            case .opportunistic: return .opportunistic
            case .highQuality: return .highQualityFormat
            }
        }
    }
}

