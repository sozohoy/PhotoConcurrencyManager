# PhotoConcurrencyManager

A concurrent photo loading and caching manager for iOS that provides efficient photo asset handling with support for both high and low-quality image loading states.

## Features

- ✨ Concurrent photo loading with async/await support
- 🎯 Multiple image quality delivery modes (low/high quality)
- 💾 Built-in memory caching
- 🔄 Prefetching support for smooth scrolling
- 📱 iCloud photo access handling
- 🎨 Flexible image loading configurations
- 🏃‍♂️ Performance optimized for scrolling

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/sozohoy/PhotoConcurrencyManager", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
let manager = PhotoConcurrencyManager()

// Request photo library authorization
let isAuthorized = await manager.requestAuthorization()

// Load an image
let stream = manager.loadImage(
    asset: photoAsset,
    targetSize: CGSize(width: 300, height: 300),
    contentMode: .aspectFill,
    configuration: .thumbnail
)

for try await quality in stream {
    switch quality {
    case .low(let image):
        // Handle low quality image (e.g., show as placeholder)
    case .high(let image):
        // Handle high quality image
    }
}
```

### Prefetching Images

```swift
// Start prefetching
manager.prefetchImages(
    for: assets,
    targetSize: CGSize(width: 300, height: 300),
    contentMode: .aspectFill,
    configuration: .scrolling
)

// Cancel prefetching when needed
manager.cancelPrefetching(
    for: assets,
    targetSize: CGSize(width: 300, height: 300),
    contentMode: .aspectFill,
    configuration: .scrolling
)
```

### Loading Images While Scrolling

```swift
let image = try await manager.loadImageWhenScrolling(
    asset: asset,
    targetSize: CGSize(width: 300, height: 300),
    contentMode: .aspectFill,
    configuration: .scrolling
)
```

## Configuration Options

### Image Quality Configuration

The library provides several preset configurations:

```swift
// Default configuration for optimal quality/performance balance
.opportunisticFit

// High quality synchronous loading
.highQualitySync

// Fast loading for thumbnails
.thumbnail

// Optimized for scroll performance
.scrolling
```

### Custom Configuration

Create custom configurations by specifying:
- Synchronous/Asynchronous loading
- Delivery mode (fast/opportunistic/high quality)
- Content mode (aspect fit/fill)
- iCloud access mode
- Resize mode
- Version requirements

```swift
let customConfig = PhotoImageOptions.Configuration(
    synchronousMode: .async,
    deliveryMode: .highQuality,
    contentMode: .aspectFill,
    iCloudAccessMode: .allowed,
    resizeMode: .exact,
    version: .current
)
```

## Error Handling

The library provides detailed error cases:

```swift
public enum ImageLoadingError: Error {
    case loadingFailed(Error)
    case cancelled
    case noImage
    case unauthorized
}
```

## Performance Considerations

- Built-in memory cache management with configurable size limits
- Automatic cache cleanup
- Optimized for scroll performance with dedicated configurations
- Prefetching support for smooth scrolling experiences

## Requirements

- iOS 16.0+
- Swift 6.0+
- Xcode 14.0+

## License

This library is released under the MIT license. See [LICENSE](https://github.com/sozohoy/PhotoConcurrencyManager/blob/main/LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
