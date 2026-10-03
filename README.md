# 🌌 Celestial Forge v3

A beautifully nerdy Flutter app to explore and draw perks from the **Celestial Forge (v3)**, a cosmic Swiss Army Knife of powerful perks, broken mechanics, and the Ultimate Power Creep.

Built with love, magic, and way too much CP. XD
  
**Author:** [@Adesh(POZ)]

---

### 📝 Author's Note

This app was built as a passion project — a love letter to the Celestial Forge and everything brokenly beautiful about it. You're welcome to use it, fork it, or expand on it as you like. I've intentionally kept things simple and (mostly) clean for others to build upon.  

All I ask is: **please don’t use this project for commercial purposes.** I don’t make any money from it. The authors of Celestial Forge Jumpchain Doc don't make any money out of it. And I’d like to keep it that way — a labor of love, by fans for the fans, not a source of profit. Also, it goes without saying, but try to give me/my project credits if you're using my project or any part of it.

In the same vein, thank you to the **Authors of Celestial Forge JumpChain Document** that made this project possible and relevant. Cheers to you folks!

---

## 🚀 What is This?

Celestial Forge v3 is a Flutter application designed to:
- Display hundreds of carefully categorized perks (not by me, mind you. I just structured them (as a JSON) for easier project development) across 38 Domains.
- Let users draw perks randomly based on your current CP.
- Keep track of owned perks.
- Perk Add Mode - which lets users add whichever perks/subperks they wish to add.
- Persist state with Hive, so your questionable perk choices survive app restarts.

---

## 🛠️ Features

- **Expandable Domain List** – with slick UI to view each perk.
- **Perk Draw System** – roll for perks using CP and gamble your way to godhood.
- **Persistent Storage** – powered by Hive + Riverpod.
- **Sub-Perk Support** – perks within perks. Because recursion is cool.

---

## 🧙 Getting Started

To run the project on your system, do the following in your terminal:

```bash
flutter pub get
flutter run
```

**Note:** *This project was created in Flutter `3.24.0`, then upgraded to `3.44.9`. So, you need the latter version of Flutter set up in your System. More detailed information in the `Development Notes` section below.*

**Note 2:** *If you want to just check out or use the App itself, you can find the latest apk file in the `apk` folder in the project directory. For iOS, you'll have to get your hands dirty because it's not possible to create a standalone installer for iOS Devices due to signing issues and a lack of a Mac System.*

---

## 🛠️ Development Notes

This project was built with the following tech stack and configuration:

### 🚀 Core Environment
- **Flutter:** `3.24.0` -> `3.44.9`
- **Dart:** `3.5.0` -> `3.12.2`
- **Perk Data Source:** Converted from a [Celestial Forge v3.docx](https://docs.google.com/document/d/1bIrBVFTVRXfmmbmqgQCbZSa8aB-NljtOIyaZ3gGNAs4/edit?tab=t.0) file found on a Google Drive link — parsed and semi-automatically transformed into structured JSON.


### Dev Note on Other Flutter Versions

You can probably run this project on newer Flutter versions, but you'll need to check the dependencies in `pubspec.yaml` for compatibility issues. For best result, I recommend using the above stated development environment, but if you **really** want to run it in other versions, you'll need some minor debugging and environment changes in the project.

Do note that this project has Null Safety (a default feature in any newer Flutter & Dart versions released in recent years), so you will encounter many errors and thus will be unable to compile this project if you try to compile with Dart versions that don't have Null Safety *(below Dart 3.0.0)*.

### Dev Note on the JSON ###

It was a b**ch and a half to create this JSON file and I had to manually, one by one, copy pasting all the perk descriptions and fix any mistakes I found to ensure it's accurate. (When I made this project, AI Models weren't able to perform the task accurately. That may have changed now)

It took me multiple hours (separated in several days) worth of time to finish the JSON.

Was it all worth it, though? ...IDK. You tell me.

---

### 🤖 Android Configuration
- **Gradle:** `8.6` -> `9.1.0`
- **Android Gradle Plugin (AGP):** `8.4.0` -> `9.0.1`
- **Kotlin:** `1.9.25` -> `2.3.20`
- **Compile SDK:** `35` -> `36`
- **Target SDK:** `35` -> `36`
- **Min SDK:** `21` -> `24` (default Flutter minimum unless overridden)
- **Java Compatibility:** `Java 17`
- **NDK Version:** `26.1.10909125` -> `flutter.ndkVersion`(Flutter Default)

---

### 🍎 iOS Configuration
- **iOS Platform Version:** `12.0`
- **Xcode Compatibility:** Xcode 16 (required for SDK 18.0+ development)
- **Swift Version:** Handled automatically by Flutter (if required by plugins)

---

### 📦 State Persistence
- **State Management:** `Riverpod`
- **Local Storage:** `Hive`
- **Perk Data:** Persisted using Hive boxes to maintain CP, owned perks, and draw pool across app sessions.
