import UIKit

actor ImageCacheManager {
    static let shared = ImageCacheManager()

    private enum Constants {
        static let maxMemoryCacheSize = 150 * 1024 * 1024
        static let maxElementsCount = 50
    }

    struct CacheKey: Hashable {
        let identifier: String
        let targetSize: CGSize

        var keyForGetImage: String {
            "\(identifier)-\(Int(targetSize.width))-\(Int(targetSize.height))"
        }
    }

    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = Constants.maxMemoryCacheSize
        cache.countLimit = Constants.maxElementsCount
        return cache
    }()

    init() { }

    func saveImage(
        _ image: UIImage,
        cacheKey: CacheKey
    ) {
        cache.setObject(image, forKey: cacheKey.keyForGetImage as NSString)
    }

    func getImage(cacheKey: CacheKey) -> UIImage? {
        return cache.object(forKey: cacheKey.keyForGetImage as NSString)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
