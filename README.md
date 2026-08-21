# Smart Calculator Plus

Modern all-in-one calculator for Android (and Windows) — built to stand out from basic calculator apps.

**Folder:** `D:\projects\smart calculator`  
**Package ID:** `com.smartcalc.smart_calculator`  
**Version:** 1.0.0+1

## Why it is different

Most “smart calculators” only add a scientific pad. This app includes:

| Tab | Features |
|-----|----------|
| **Standard** | Clean calculator, live preview, ±, %, history save |
| **Scientific** | sin/cos/tan, ln/log, √, π, e, ^, abs, parentheses |
| **Tools** | **Live Currency (real-time FX)**, Tip & bill split, Discount/Markup, Loan EMI, Unit converter, BMI, Fuel cost |

| **History** | Last 100 results, tap to copy, clear |

Modern dark UI (ink + mint), offline, no login.

## Run (dev)

```powershell
cd "D:\projects\smart calculator"
$env:Path = "C:\flutter\bin;" + $env:Path
flutter pub get
flutter run
```

Android device/emulator: `flutter run`  
Windows desktop: `flutter run -d windows`

## Release APK (later for Play)

```powershell
flutter build apk --release
```

Play Store later needs **AAB**:

```powershell
flutter build appbundle --release
```

## Before Play Store

1. Buy Play Developer account ($25)
2. Change branding/screenshots if needed
3. Add Privacy Policy URL (even for offline tools)
4. Optional: rename package if you want personal brand (`com.yourname.smartcalc`)

## Note

BMI tool is educational only — not medical advice.
