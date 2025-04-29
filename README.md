workflows:
  flutter-android:
    name: Build Android APK
    environment:
      flutter: stable
      android_signing:
        keystore_reference: null
    scripts:
      - name: Install dependencies
        script: flutter pub get
      - name: Build APK
        script: flutter build apk --release
    artifacts:
      - build/app/outputs/flutter-apk/app-release.apk
