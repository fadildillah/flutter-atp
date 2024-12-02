## iOS Configuration for Dependencies

### Location

To use location services in iOS, you need to add the following permissions in `Info.plist`:

- `NSLocationWhenInUseUsageDescription`: This is probably the only one you need. Background location is supported by this, but a blue badge is shown in the status bar when the app is using location services while in the background.
- `NSLocationAlwaysUsageDescription`: Deprecated, use `NSLocationAlwaysAndWhenInUseUsageDescription` instead.
- `NSLocationAlwaysAndWhenInUseUsageDescription`: Use this very carefully. This key is required only if your iOS app uses APIs that access the user’s location information at all times, even if the app isn't running.

To receive location updates when the application is in the background, add the following property list key to `Info.plist`:

- `UIBackgroundModes` with the string value `location`.
