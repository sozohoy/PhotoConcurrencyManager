import Foundation

public extension PhotoImageOptions {
    @frozen
    enum iCloudAccessMode: Sendable {
        case allowed
        case deny

        var option: Bool {
            switch self {
            case .allowed: return true
            case .deny: return false
            }
        }
    }
}
