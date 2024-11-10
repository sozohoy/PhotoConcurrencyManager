import Photos
import Foundation

public extension PhotoImageOptions {
    struct Configuration: Sendable {
        public let synchronousMode: SynchronousMode
        public let deliveryMode: DeliveryMode
        public let contentMode: ContentMode
        public let iCloudAccessMode: iCloudAccessMode
        public let resizeMode: ResizeMode
        public let version: Version

        public init(
            synchronousMode: SynchronousMode = .async,
            deliveryMode: DeliveryMode = .opportunistic,
            contentMode: ContentMode = .aspectFill,
            iCloudAccessMode: iCloudAccessMode = .allowed,
            resizeMode: ResizeMode = .exact,
            version: Version = .current
        ) {
            self.synchronousMode = synchronousMode
            self.deliveryMode = deliveryMode
            self.contentMode = contentMode
            self.iCloudAccessMode = iCloudAccessMode
            self.resizeMode = resizeMode
            self.version = version
        }

        public static let opportunisticFit = Configuration(
            synchronousMode: .async,
            deliveryMode: .opportunistic,
            contentMode: .aspectFit,
            iCloudAccessMode: .allowed,
            resizeMode: .exact,
            version: .current
        )

        public static let highQualitySync = Configuration(
            synchronousMode: .sync,
            deliveryMode: .highQuality,
            contentMode: .aspectFit,
            iCloudAccessMode: .allowed,
            resizeMode: .exact,
            version: .current
        )

        public static let thumbnail = Configuration(
            synchronousMode: .async,
            deliveryMode: .opportunistic,
            contentMode: .aspectFill,
            iCloudAccessMode: .allowed,
            resizeMode: .fast,
            version: .current
        )

        func toPHImageRequestOptions() -> PHImageRequestOptions {
            let options = PHImageRequestOptions()
            options.isSynchronous = synchronousMode.option
            options.deliveryMode = deliveryMode.option
            options.isNetworkAccessAllowed = iCloudAccessMode.option
            options.resizeMode = resizeMode.option
            options.version = version.option
            return options
        }
    }
}
