# How to Submit to App Store Connect — UstiaGo

> **App:** UstiaGo | **Bundle ID:** com.ggsheng.UstiaGo | **Version:** 1.0.0
> **Last Updated:** 2026-04-18

---

## Step 1: Prepare Build

1. Ensure latest code is on MacinCloud:
   ```bash
   cd ~/Desktop/ios-UstiaGo && git pull origin main
   ~/Desktop/xcodegen/bin/xcodegen generate
   ```

2. Build archive:
   ```bash
   xcodebuild archive -scheme UstiaGo -configuration Release \
     CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO \
     DEVELOPMENT_TEAM=9L6N2ZF26B
   ```

3. Open Xcode → Window → Organizer → Distribute App → App Store Connect → Sign and Upload

---

## Step 2: App Store Connect Configuration

Navigate to: https://appstoreconnect.apple.com → Apps → UstiaGo

### 2.1 App Information

| Field | Value |
|-------|-------|
| Default Language | English |
| Name | Ustia |
| Subtitle | Mindful Screen Time Companion |
| Category | Productivity |
| Primary Category | Productivity |
| Secondary Category | (None) |
| Age Rating | 4+ |

### 2.2 Pricing and Availability

| Field | Value |
|-------|-------|
| Price Schedule | Free |
| Availability | All territories |

### 2.3 App Privacy

| Field | Value |
|-------|-------|
| Privacy Policy | ✅ Required - URL to hosted PrivacyPolicy.html |
| Data Collection | No data collection - all local |

**Privacy Details:**
- **Health & Fitness:** No
- **Location:** No
- **Contact Info:** No
- **Identified Users:** No
- **Browsing History:** No
- **Purchases:** No
- **Crash Data:** No
- **Performance Data:** No
- **Advertising Data:** No

---

## Step 3: App Store Listing

### 3.1 Localized Info (English)

**Promotional Text** (optional):
```
Calm, beautiful screen time tracking that helps you reclaim your attention.
```

**Description** — Copy from `AppStore/Listing.md`:
```
Reclaim your attention.

Ustia is a calm, beautiful screen time companion that helps you understand your phone habits without the surveillance feel. Where other apps scream "YOU'RE DOING BADLY," Ustia whispers "Here's what's happening, and here's how to take control — on your terms."

[... Full description in Listing.md ...]
```

**Keywords:**
```
screen time, focus, productivity, mindfulness, concentration, habit tracker, time management, study, work, timer, concentration app, wind down, sleep routine, focus companion, attention
```

**Support URL:** Your website URL

### 3.2 Screenshots

Upload from `AppStore/Screenshots/` directory:

| Device | Size | Files |
|--------|------|-------|
| iPhone 6.7" | 1290×2796 | Screen1_Today.png, Screen2_Focus.png, Screen3_Insights.png, Screen4_Wind Down.png, Screen5_Settings.png |

**5 screenshots total** — UITests verified unique

### 3.3 App Icon

1024×1024 App Store Icon from `UstiaGo/Assets.xcassets/AppIcon.appiconset/`

---

## Step 4: Build Selection

After upload, select the build:
- Build **version 1.0** with status "Ready to Submit"

---

## Step 5: Certification

| Field | Value |
|-------|-------|
| Export Compliance | No |
| Ads Identifier | No |

---

## Step 6: Submit for Review

1. Click **Add for Review**
2. Confirm all information
3. Submit

---

## Quick Reference — UstiaGo App Store Content

All detailed content is in `AppStore/Listing.md`:
- Full description text
- Keywords list
- Screenshot specifications
- Version history

**Privacy Policy:** `AppStore/PrivacyPolicy.html` — host and provide URL

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build not appearing | Wait 5-10 minutes after upload |
| Screenshots wrong size | Must be exactly 1290×2796 for 6.7" |
| Missing screenshots | Run UITests to capture: `xcodebuild test -scheme UstiaGoUITests` |
| Privacy policy required | Host AppStore/PrivacyPolicy.html and enter URL |
