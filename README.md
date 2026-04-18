# UstiaGo

> Mindful Screen Time Companion for iPhone

**Version:** 1.0.0 | **Bundle ID:** com.ggsheng.UstiaGo

---

## App Store

- [App Store Listing Content](AppStore/Listing.md)
- [App Store Connect Submission Guide](AppStore/HOW-TO-AppStoreConnect.md)
- [Privacy Policy](AppStore/PrivacyPolicy.html)
- [Product Specification](SPEC.md)

## Screenshots

Captured screenshots available in `AppStore/Screenshots/` (5 unique UITest-verified screenshots).

---

## Build Instructions

### MacinCloud Build

```bash
cd ~/Desktop/ios-UstiaGo
git pull origin main
~/Desktop/xcodegen/bin/xcodegen generate
xcodebuild archive -scheme UstiaGo -configuration Release \
  CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO \
  DEVELOPMENT_TEAM=9L6N2ZF26B
```

### Xcode Build (MacinCloud Desktop)

1. Open `ios/UstiaGo.xcodeproj`
2. Select iPhone simulator
3. Cmd+B to build

### Upload to App Store Connect

1. Xcode → Window → Organizer
2. Select UstiaGo archive
3. Distribute App → App Store Connect → Sign and Upload

---

## Project Structure

```
ios-UstiaGo/
├── AppStore/
│   ├── Listing.md              # App Store listing content
│   ├── HOW-TO-AppStoreConnect.md # Submission guide
│   ├── PrivacyPolicy.html       # Privacy policy template
│   └── Screenshots/             # UITest screenshots (5)
├── ios/
│   ├── UstiaGo.xcodeproj/
│   ├── project.yml              # XcodeGen config
│   └── UstiaGo/
│       ├── Sources/
│       │   ├── App/            # App entry point
│       │   ├── Models/         # Data models
│       │   ├── ViewModels/     # AppState, etc.
│       │   ├── Views/          # SwiftUI views (5 tabs)
│       │   └── Utils/          # Theme, SoundManager
│       └── Assets.xcassets/    # App icons, colors
└── SPEC.md                     # Product specification
```

---

## Features

| Tab | Features |
|-----|----------|
| Today | Daily summary, streak tracking |
| Focus | Focus sessions, multiple modes |
| Insights | Weekly/monthly reports |
| Wind Down | Pre-sleep routine |
| Settings | Preferences, achievements |

---

## Development

- **XcodeGen** for project generation
- **SwiftUI** for UI
- **UserDefaults** for local persistence
- **No external dependencies** (fully offline capable)
