# Panduan Mengatasi Masalah Kamera iOS

## Masalah Layar Putih Setelah Mengakses Kamera

### Penyebab Umum
1. **Missing Permission** - Tidak ada permission untuk kamera di Info.plist
2. **Permission Ditolak User** - User menolak akses kamera saat diminta
3. **Camera Error Handling** - Error tidak ditangani dengan baik
4. **iOS Version Issues** - Compatibility issues dengan versi iOS tertentu

### Solusi yang Sudah Diterapkan

#### 1. Info.plist Permissions
Sudah ditambahkan ke `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi ini memerlukan akses kamera untuk mengambil foto dokumen pegawai seperti KTP, KK, dan Ijazah.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi ini memerlukan akses galeri foto untuk memilih dokumen pegawai yang sudah ada.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Aplikasi ini memerlukan akses mikrofon untuk fitur video jika diperlukan.</string>
```

#### 2. Enhanced Error Handling
File `lib/services/file_service.dart` sudah diperbaiki dengan:
- Logging detail untuk debugging
- Validasi file sebelum menyimpan
- Parameter `requestFullMetadata: false` untuk iOS
- Re-throw exceptions untuk UI handling

#### 3. Improved UI Feedback
File `lib/widgets/file_upload_widget.dart` sudah diperbaiki dengan:
- Loading states yang lebih baik
- Error messages yang informatif
- Success/info notifications
- Permission-specific error handling

#### 4. AppDelegate Orientation Fix
File `ios/Runner/AppDelegate.swift` sudah ditambahkan:
```swift
override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
}
```

### Debugging Steps

#### 1. Cek Permission Status
Saat kamera diakses, iOS akan menampilkan dialog permission. Pastikan:
- User tap "Allow" untuk mengizinkan akses kamera
- Jika sudah ditolak sebelumnya, buka Settings > Privacy & Security > Camera > [App Name] dan aktifkan

#### 2. Cek Console Logs
Gunakan Xcode Console untuk melihat logs:
```
🎥 Membuka kamera...
✅ Foto berhasil diambil: [path]
❌ Error taking photo: [error]
```

#### 3. Alternative Testing Methods
Gunakan widget `CameraPickerWidget` untuk testing yang lebih robust:
```dart
CameraPickerWidget(
  label: 'Test Kamera',
  onImageSelected: (path) {
    print('Image selected: $path');
  },
)
```

### Cara Testing

#### 1. Fresh Install Testing
- Uninstall app dari iPhone
- Clean build: `flutter clean && flutter pub get`
- Build dan install ulang: `flutter run -d [device-id]`
- Test kamera untuk pertama kali (harus muncul permission dialog)

#### 2. Permission Reset Testing
- Settings > General > Transfer or Reset iPhone > Reset > Reset Location & Privacy
- Restart app dan test ulang

#### 3. Different Camera Sources
Test kedua source:
- Camera (kamera belakang/depan)
- Photo Library (galeri foto)

### Common iOS-Specific Issues

#### 1. iOS 16.2+ Issues
Beberapa device dengan iOS 16.2 ada masalah dengan image picker. Solusi:
- Update ke iOS versi terbaru jika memungkinkan
- Gunakan alternatif picker widget

#### 2. Simulator vs Real Device
- Simulator tidak memiliki kamera fisik
- Selalu test di real device untuk kamera
- Simulator hanya bisa test photo library

#### 3. Development vs Release Build
- Development build: Lebih verbose logging
- Release build: Logging minimal, performance better

### Monitoring dan Maintenance

#### 1. Crash Reporting
Monitor crashes terkait kamera:
```dart
try {
  // camera code
} catch (e) {
  // Log to crash reporting service
  print('Camera error: $e');
}
```

#### 2. User Analytics
Track kamera usage:
- Success rate pengambilan foto
- Error types yang paling sering
- Device/iOS version correlation

#### 3. Performance Monitoring
Monitor:
- Time to open camera
- Image processing time
- Memory usage during camera operations

### Emergency Workarounds

Jika kamera masih bermasalah:

#### 1. Fallback ke Photo Library Only
```dart
// Disable camera, only allow photo library
FileUploadWidget(
  isImageOnly: false, // Force document picker
  // ... other props
)
```

#### 2. External Camera Apps
Integrate dengan camera apps external jika diperlukan.

#### 3. Progressive Enhancement
Provide fallback for devices without camera access.

### Support Information

- **Flutter Version**: 3.32.8
- **Dart Version**: 3.8.1
- **image_picker Version**: 1.2.0
- **Minimum iOS Version**: 12.0+
- **Tested iOS Versions**: 16.2

Untuk issues lebih lanjut, cek:
1. Flutter image_picker documentation
2. iOS developer documentation for camera
3. Stack Overflow flutter ios camera issues
