# Flutter Flavors Setup Guide

Complete guide to implement flavors (dev, staging, prod) in Flutter for both Android and iOS.

## 📋 Table of Contents

- [What are Flavors?](#what-are-flavors)
- [Project Structure](#project-structure)
- [Step 1: Create Flavor Configuration](#step-1-create-flavor-configuration)
- [Step 2: Create Entry Points](#step-2-create-entry-points)
- [Step 3: Android Setup](#step-3-android-setup)
- [Step 4: iOS Setup](#step-4-ios-setup)
- [Step 5: VS Code Configuration](#step-5-vs-code-configuration)
- [Step 6: API Configuration](#step-6-api-configuration)
- [Running Flavors](#running-flavors)
- [Building for Release](#building-for-release)
- [Troubleshooting](#troubleshooting)

---

## What are Flavors?

Flavors allow you to create multiple versions of your app from a single codebase, each with different configurations:

- **Development (dev)**: For active development and testing
- **Staging (UAT)**: For QA testing and client demos before production
- **Production (prod)**: Live app for end users

### Benefits:
✅ Different API endpoints per environment  
✅ Different app names and bundle IDs  
✅ Install all versions simultaneously on one device  
✅ Different configurations without changing code  
✅ Separate Firebase projects per flavor  

---

## Project Structure

```
lib/
├── flavors_config/
│   └── flavors_config.dart
├── core/
│   └── network/
│       ├── api_constants.dart
│       ├── api_endpoints.dart
│       └── apis.dart
├── main_dev.dart
├── main_staging.dart
├── main_prod.dart
└── common_main.dart
```

---

## Step 1: Create Flavor Configuration

Create `lib/flavors_config/flavors_config.dart`:

```dart
enum Environment { dev, staging, prod }

abstract class AppEnvironment {
  static late String baseUrl;
  static late String environmentName;
  static late bool enableLogging;
  static late bool debugMode;

  static late Environment _environment;
  static Environment get environment => _environment;

  static void setEnvironment(Environment environment) {
    _environment = environment;
    
    switch (environment) {
      case Environment.dev:
        baseUrl = 'https://dev-api.example.com/api/';
        environmentName = 'Development';
        enableLogging = true;
        debugMode = true;
        break;
        
      case Environment.staging:
        baseUrl = 'https://staging-api.example.com/api/';
        environmentName = 'Staging';
        enableLogging = true;
        debugMode = false;
        break;
        
      case Environment.prod:
        baseUrl = 'https://api.example.com/api/';
        environmentName = 'Production';
        enableLogging = false;
        debugMode = false;
        break;
    }
  }
  
  // Helper methods
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.prod;
}
```

---

## Step 2: Create Entry Points

### Create `lib/common_main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/flavors_config/flavors_config.dart';

void commonMain() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flavors',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Show environment banner in non-prod
      builder: (context, child) {
        if (AppEnvironment.isProduction) return child!;
        
        return Banner(
          message: AppEnvironment.environmentName,
          location: BannerLocation.topEnd,
          child: child!,
        );
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppEnvironment.environmentName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Environment: ${AppEnvironment.environmentName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Base URL: ${AppEnvironment.baseUrl}'),
          ],
        ),
      ),
    );
  }
}
```

### Create `lib/main_dev.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/common_main.dart';
import 'package:your_app/flavors_config/flavors_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setEnvironment(Environment.dev);
  commonMain();
}
```

### Create `lib/main_staging.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/common_main.dart';
import 'package:your_app/flavors_config/flavors_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setEnvironment(Environment.staging);
  commonMain();
}
```

### Create `lib/main_prod.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/common_main.dart';
import 'package:your_app/flavors_config/flavors_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setEnvironment(Environment.prod);
  commonMain();
}
```

---

## Step 3: Android Setup

### 3.1 Configure `android/app/build.gradle` (Groovy):

Add this inside the `android {}` block:

```gradle
android {
    // ... existing configurations

    flavorDimensions "environment"
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MyApp Dev"
        }
        
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MyApp Staging"
        }
        
        prod {
            dimension "environment"
            resValue "string", "app_name", "MyApp"
        }
    }
}
```

### 3.2 Or for `android/app/build.gradle.kts` (Kotlin DSL):

```kotlin
android {
    // ... existing configurations

    flavorDimensions += "environment"
    
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "MyApp Dev")
        }
        
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "MyApp Staging")
        }
        
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "MyApp")
        }
    }
}
```

### 3.3 Update `android/app/src/main/AndroidManifest.xml`:

Change the `android:label` to use the resource value:

```xml
<application
    android:label="@string/app_name"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
    <!-- ... -->
</application>
```

---

## Step 4: iOS Setup

### 4.1 Open Xcode:

```bash
cd ios
open Runner.xcworkspace
```

⚠️ **Important**: Always open `.xcworkspace`, NOT `.xcodeproj`!

### 4.2 Create Build Configurations:

1. In Xcode, select **Runner** project (blue icon in the left panel)
2. Select **Runner** under **PROJECT** (not TARGETS)
3. Go to the **Info** tab
4. Under **Configurations**, duplicate each configuration:

**Duplicate Debug:**
- Click **+** → Duplicate "Debug" → Rename to **Debug-dev**
- Duplicate "Debug" → Rename to **Debug-staging**
- Duplicate "Debug" → Rename to **Debug-prod**

**Duplicate Release:**
- Duplicate "Release" → Rename to **Release-dev**
- Duplicate "Release" → Rename to **Release-staging**
- Duplicate "Release" → Rename to **Release-prod**

**Final Result (6 configurations):**
```
Debug-dev
Debug-staging
Debug-prod
Release-dev
Release-staging
Release-prod
```

⚠️ **Delete any extra configurations** like "Profile-dev", "profile-staging", etc. You only need Debug and Release variants.

### 4.3 Create Schemes:

1. Go to **Product** → **Scheme** → **Manage Schemes**
2. Select **Runner** scheme → Click gear icon → **Duplicate**
3. Rename to **dev**
4. Click **Edit**
5. Set build configurations for each action:
   - **Run**: Debug-dev
   - **Test**: Debug-dev
   - **Profile**: Release-dev
   - **Analyze**: Debug-dev
   - **Archive**: Release-dev

6. Repeat for **staging** and **prod** schemes

**Final Schemes:**
- **dev** (uses Debug-dev / Release-dev)
- **staging** (uses Debug-staging / Release-staging)
- **prod** (uses Debug-prod / Release-prod)

### 4.4 Configure Bundle Identifiers:

1. Select **Runner** under **TARGETS**
2. Go to **Build Settings** tab
3. Search for "Product Bundle Identifier"
4. Click the arrow to expand
5. Set for each configuration:

```
Debug-dev:     com.yourcompany.appname.dev
Release-dev:   com.yourcompany.appname.dev

Debug-staging:     com.yourcompany.appname.staging
Release-staging:   com.yourcompany.appname.staging

Debug-prod:     com.yourcompany.appname
Release-prod:   com.yourcompany.appname
```

### 4.5 Configure App Display Names:

**Option 1: Using Build Settings**

1. In **Build Settings**, search for "Product Name"
2. Expand and set for each:

```
Debug-dev:     MyApp Dev
Release-dev:   MyApp Dev

Debug-staging:     MyApp Staging
Release-staging:   MyApp Staging

Debug-prod:     MyApp
Release-prod:   MyApp
```

**Option 2: Using User-Defined Settings (Recommended)**

1. In **Build Settings**, click **+** → **Add User-Defined Setting**
2. Name: `APP_DISPLAY_NAME`
3. Set values:

```
Debug-dev:     MyApp Dev
Release-dev:   MyApp Dev
Debug-staging:     MyApp Staging
Release-staging:   MyApp Staging
Debug-prod:     MyApp
Release-prod:   MyApp
```

4. Edit `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>$(APP_DISPLAY_NAME)</string>
```

### 4.6 Create xcconfig Files for Flutter Targets:

Create these files in `ios/Flutter/` directory:

**ios/Flutter/Dev.xcconfig:**
```
#include "Generated.xcconfig"
FLUTTER_TARGET=lib/main_dev.dart
```

**ios/Flutter/Staging.xcconfig:**
```
#include "Generated.xcconfig"
FLUTTER_TARGET=lib/main_staging.dart
```

**ios/Flutter/Prod.xcconfig:**
```
#include "Generated.xcconfig"
FLUTTER_TARGET=lib/main_prod.dart
```

### 4.7 Link xcconfig Files to Configurations:

1. Select **Runner** under **PROJECT**
2. Go to **Info** tab
3. Under **Configurations**, set configuration files:

For **Runner** target:
```
Debug-dev:     Flutter/Dev
Release-dev:   Flutter/Dev

Debug-staging:     Flutter/Staging
Release-staging:   Flutter/Staging

Debug-prod:     Flutter/Prod
Release-prod:   Flutter/Prod
```

---

## Step 5: VS Code Configuration

Create `.vscode/launch.json` in your project root:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": [
        "--flavor",
        "dev"
      ]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_staging.dart",
      "args": [
        "--flavor",
        "staging"
      ]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_prod.dart",
      "args": [
        "--flavor",
        "prod"
      ]
    }
  ]
}
```

### Using VS Code:
1. Press **F5** or go to **Run and Debug** (Ctrl+Shift+D)
2. Select flavor from dropdown
3. Press **F5** to run

---

## Step 6: API Configuration

### Create `lib/core/network/api_constants.dart`:

```dart
import 'package:your_app/flavors_config/flavors_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => AppEnvironment.baseUrl;
  static const String apiKey = 'your_api_key_here';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

### Create `lib/core/network/api_endpoints.dart`:

```dart
class ApiEndpoints {
  ApiEndpoints._();

  // Movies
  static const String movies = 'movie';
  static const String popular = 'popular';
  static const String topRated = 'top_rated';
  
  // TV
  static const String tv = 'tv';
  
  // Search
  static const String search = 'search';
}
```

### Create `lib/core/network/apis.dart`:

```dart
import 'api_constants.dart';
import 'api_endpoints.dart';

class Apis {
  Apis._();

  static String get _base => ApiConstants.baseUrl;

  // Movies
  static String get moviesPopular => 
      '$_base${ApiEndpoints.movies}/${ApiEndpoints.popular}';
  
  static String get moviesTopRated => 
      '$_base${ApiEndpoints.movies}/${ApiEndpoints.topRated}';
  
  static String movieDetails(int movieId) => 
      '$_base${ApiEndpoints.movies}/$movieId';
  
  // TV Shows
  static String get tvPopular => 
      '$_base${ApiEndpoints.tv}/${ApiEndpoints.popular}';
  
  // Search
  static String searchMovies(String query) => 
      '$_base${ApiEndpoints.search}/${ApiEndpoints.movies}?query=${Uri.encodeComponent(query)}';
}
```

### Usage in Repository:

```dart
class MovieRepository {
  final Dio dio;
  
  Future<List<Movie>> getPopularMovies() async {
    final response = await dio.get(Apis.moviesPopular);
    // Process response
  }
  
  Future<Movie> getMovieDetails(int id) async {
    final response = await dio.get(Apis.movieDetails(id));
    // Process response
  }
}
```

---

## Running Flavors

### From Terminal:

```bash
# Development
flutter run -t lib/main_dev.dart --flavor dev

# Staging
flutter run -t lib/main_staging.dart --flavor staging

# Production
flutter run -t lib/main_prod.dart --flavor prod
```

### Android Only:

```bash
flutter run -t lib/main_dev.dart --flavor dev -d <device_id>
```

### iOS Only:

```bash
flutter run -t lib/main_dev.dart --flavor dev -d <device_id>
```

### List Devices:

```bash
flutter devices
```

---

## Building for Release

### Android APK:

```bash
# Development
flutter build apk -t lib/main_dev.dart --flavor dev --release

# Staging
flutter build apk -t lib/main_staging.dart --flavor staging --release

# Production
flutter build apk -t lib/main_prod.dart --flavor prod --release
```

### Android App Bundle (for Play Store):

```bash
flutter build appbundle -t lib/main_prod.dart --flavor prod --release
```

### iOS:

```bash
# Development
flutter build ios -t lib/main_dev.dart --flavor dev --release

# Staging
flutter build ios -t lib/main_staging.dart --flavor staging --release

# Production
flutter build ios -t lib/main_prod.dart --flavor prod --release
```

**Or use Xcode:**
1. Open `ios/Runner.xcworkspace`
2. Select scheme (dev/staging/prod)
3. Product → Archive

---

## Troubleshooting

### Android: "Task 'assembleDevDebug' not found"

**Solution**: Make sure you've added product flavors in `android/app/build.gradle`:

```bash
flutter clean
flutter pub get
flutter run -t lib/main_dev.dart --flavor dev
```

### iOS: "Scheme not found"

**Solution**: 
1. Ensure schemes are created and shared in Xcode
2. Check that scheme names match flavor names (lowercase)
3. Verify xcconfig files are properly linked

### iOS: "Multiple commands produce..."

**Solution**:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

### Different base URLs not working

**Solution**: Ensure you're calling `AppEnvironment.setEnvironment()` in each main file before `commonMain()`.

### Can't install multiple versions on same device

**Solution**: Check that each flavor has a different `applicationIdSuffix` (Android) and Bundle Identifier (iOS).

### VS Code doesn't show flavors

**Solution**: Make sure `.vscode/launch.json` exists and Flutter extension is installed.

---

## Verification Checklist

After setup, verify:

- [ ] All three flavors run successfully
- [ ] Different app names appear on device
- [ ] All three versions can be installed simultaneously
- [ ] Correct base URL is used for each environment
- [ ] Environment banner shows in dev/staging (not prod)
- [ ] Android bundle IDs are different (check in build.gradle)
- [ ] iOS bundle IDs are different (check in Xcode)
- [ ] VS Code dropdown shows all three configurations

---

## Additional Tips

### 1. Environment-specific Firebase:

```dart
// In main_dev.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.dev,
);

// In main_prod.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.prod,
);
```

### 2. Feature Flags:

```dart
class FeatureFlags {
  static bool get debugMenuEnabled => AppEnvironment.isDevelopment;
  static bool get analyticsEnabled => AppEnvironment.isProduction;
}
```

### 3. Different App Icons:

**Android**: Create flavor-specific resource directories:
```
android/app/src/dev/res/mipmap-*/ic_launcher.png
android/app/src/staging/res/mipmap-*/ic_launcher.png
android/app/src/prod/res/mipmap-*/ic_launcher.png
```

**iOS**: Use asset catalogs in Xcode Build Settings.

---

## Resources

- [Flutter Flavors Documentation](https://docs.flutter.dev/deployment/flavors)
- [Android Build Variants](https://developer.android.com/studio/build/build-variants)
- [Xcode Schemes](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project)

---

## License

MIT License - feel free to use this setup in your projects!

---

**Happy Coding! 🚀**