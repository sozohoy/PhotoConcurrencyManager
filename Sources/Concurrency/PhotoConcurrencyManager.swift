import Photos
import UIKit

public final class PhotoConcurrencyManager: @unchecked Sendable {
    public enum ImageQuality: @unchecked Sendable  {
        case low(UIImage)
        case high(UIImage)
    }

    public enum ImageLoadingError: Error {
        case loadingFailed(Error)
        case cancelled
        case noImage
        case unauthorized
    }

    private let imageCacheManager = ImageCacheManager()
    private let imageManager = PHCachingImageManager()
    var currentRequests: [String: PHImageRequestID] = [:]

    public init() {}

    @MainActor
    public func requestAuthorization() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        return status == .authorized
    }

    public func fetchAssets(identifiers: [String]) -> PHFetchResult<PHAsset> {
        PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
    }

    public func fetchAssets() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate =  NSPredicate(
            format: "mediaType == %d || mediaType == %d",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaType.video.rawValue
        )
        let fetchAssets = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []
        fetchAssets.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        return assets
    }

    public func prefetchImages(
        for assets: [PHAsset],
        targetSize: CGSize,
        contentMode: PhotoImageOptions.ContentMode
    ) {
        imageManager.stopCachingImagesForAllAssets()

        imageManager.startCachingImages(
            for: assets,
            targetSize: targetSize,
            contentMode: contentMode.option,
            options: nil
        )
    }

    public func cancelPrefetching(
        for assets: [PHAsset],
        targetSize: CGSize,
        contentMode: PhotoImageOptions.ContentMode
    ) {
        imageManager.stopCachingImages(
            for: assets,
            targetSize: targetSize,
            contentMode: contentMode.option,
            options: nil
        )
    }

    public func loadImage(
        id: String,
        asset: PHAsset,
        targetSize: CGSize,
        contentMode: PhotoImageOptions.ContentMode,
        configuration: PhotoImageOptions.Configuration
    ) -> AsyncThrowingStream<ImageQuality, Error> {
        AsyncThrowingStream { continuation in

            if let requestId = currentRequests[id] {
                imageManager.cancelImageRequest(requestId)
                currentRequests.removeValue(forKey: id)
            }

            imageManager.stopCachingImagesForAllAssets()

            let cacheKey = ImageCacheManager.CacheKey(
                identifier: asset.localIdentifier,
                targetSize: targetSize
            )

            if let cachedImage = imageCacheManager.getImage(cacheKey: cacheKey) {
                continuation.yield(.high(cachedImage))
                continuation.finish()
                return
            }

            let requestId = imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode.option,
                options: configuration.toPHImageRequestOptions()
            ) { [weak self] image, info in
                guard let self else { return }

                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.finish(throwing: ImageLoadingError.loadingFailed(error))
                    return
                }

                if let cancelled = info?[PHImageCancelledKey] as? Bool, cancelled {
                    continuation.finish(throwing: ImageLoadingError.cancelled)
                    return
                }

                guard let image else {
                    continuation.finish(throwing: ImageLoadingError.noImage)
                    return
                }

                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false

                if isDegraded {
                    continuation.yield(.low(image))
                } else {
                    currentRequests.removeValue(forKey: id)
                    self.imageCacheManager.saveImage(image, cacheKey: cacheKey)
                    continuation.yield(.high(image))
                    continuation.finish()
                }
            }
            currentRequests[id] = requestId
        }
    }
}
