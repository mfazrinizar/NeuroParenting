# NeuroParenting
![Icon](https://github.com/mfazrinizar/NeuroParenting/blob/main/assets/icons/logo.png?raw=true)

## Introduction

>“It is not our differences that divide us. It is our inability to recognize, accept, and celebrate those differences.” –   Audre Lorde

Welcome to NeuroParenting, an app designed to provide support and resources for parents who are raising neurodivergent children. Whether your child has autism, ADHD, dyslexia, DCD, or any other neurodivergent condition. With feature such as Games, Forum, Course and much more, this app aims to be a valuable tool to assist you in navigating the challenges and joys of parenting.

## Problem Statement
Inadequate foundational support during early childhood can have adverse effects on the development of neurodivergent children.

## Proposed Solution
Empower parents by providing them with the necessary knowledge, resources, and support to effectively address the distinctive requirements of neurodivergent children.

## Overview
NeuroParenting            | UI Scheme 1
:-------------------------:|:-------------------------:|
![NP](https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/1.png?raw=true)|![UI1](https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/2.jpg?raw=true)|

UI Scheme 2                      | UI Scheme 3
:-------------------------:|:-------------------------:|
![UI2](https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/3.jpg?raw=true)|![UI3](https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/4.jpg?raw=true)|

## Features
1. Forum, a supportive online forum designed for parents of neurodivergent children and experienced psychologists specializing in neurodevelopmental disorders. Our community is a safe and empathetic space where parents can come together to share experiences, seek advice, and build a network of support while benefiting from the professional insights provided by expert psychologists. another.

2. Articles, connects you to helpful articles from trusted sources outside the app. Get practical tips, the latest research, and personal stories covering various aspects of neurodivergence.NeuroParenting facilitates your exploration, ensuring that valuable information and support are readily accessible with just a tap.

3. Consult, Engage in real-time conversations with experienced psychologists, make a personalized consultationsz allowing you to seek guidance, ask questions, or discuss concerns directly.

4. Games, designed for neurodivergent children, these interactive games turn education into a fun and engaging experience. Each game is crafted to stimulate cognitive skills, creativity, and social interaction. Watch as your child learns and grows. With NeuroParenting, education becomes an adventure, making every moment a chance to play and thrive.

5. Course, These courses blend education and play, offering an interactive learning experience. From exciting lessons to vibrant visuals, each course is crafted to engage young minds. Watch as your child discovers new concepts and hones essential skills. 

6. Chatbot, This interactive feature is designed to provide quick answers to your questions, offer helpful tips, and guide you through various aspects of neurodiverse parenting. Seamlessly integrated into the app, our Chatbot is available 24/7, ensuring support is just a message away.

7. Campaign, consist of positive affirmation and encouragement for both the parent and children to take a step forward.

8. Donate, join us in our mission to increase the quality of education. Every donation, big or small, contributes to creating a positive impact. With a few clicks, you can be part of something meaningful, making the world a better place for everyone.

## Application Screenshots
1. Extremely adaptable and responsive UI.
2. Ultra-comfort theme changing.
3. Wide variety of features.
4. Accessible in two languages, English and Indonesian Language.

<div style="display:flex;">
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/OnBoarding1.png" alt="screen_1" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/OnBoarding1Dark.png" alt="screen_2" width="200"/>
  <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/OnBoarding2.png" alt="screen_3" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/OnBoarding2Dark.png" alt="screen_4" width="200"/>
</div>
<div style="display:flex;">
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Register.png" alt="screen_1" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/RegisterDark.png" alt="screen_2" width="200"/>
  <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Login.png" alt="screen_3" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/LoginDark.png" alt="screen_4" width="200"/>
</div>
<div style="display:flex;">
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Homepage.png" alt="screen_1" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/HomePageDark.png" alt="screen_2" width="200"/>
  <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Forum1.jpeg" alt="screen_3" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Forum1Dark.jpeg" alt="screen_4" width="200"/>
</div>
<div style="display:flex;">
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Forum2.jpeg" alt="screen_1" width="200"/>
   <img src="https://github.com/mfazrinizar/NeuroParenting/blob/main/NeuroParentingUI/Forum2Dark.jpeg" alt="screen_2" width="200"/>
</div>
## How to Compile & Run
1. Install Java JDK (add to PATH), Android Studio, VS Code (or any preferred IDE), Flutter SDK, etc. to install all needed tools (SDK, NDK, extra tools) for Android development toolchain, please refer to this [link](https://docs.flutter.dev/get-started/install/windows/mobile).
2. Clone this repository.
3. Run `flutter pub get` to get rid of problems of missing dependencies.
4. Generate keystore to sign in release mode with command `keytool -genkey -alias server -validity 9999 -keyalg RSA -keystore keystore` using keytool from Java.
5. Rename the generated keystore with `<anyName>.keystore`.
6. Place the `<anyName>.keystore` to app-level Android folder (android/app/).
7. Create new file with name `key.properties` inside project-level Android folder (android/) with properties/contents as follow:
`storePassword=<yourKeyPassword>
keyPassword=<yourKeyPassword>
keyAlias=<yourKeyAlias>
storeFile=<anyName>.keystore`
8. Run `flutter build apk --release --split-per-abi --obfuscate --split-debug-info=/debug_info/` for splitted APK (each architecture) or `flutter build apk --release --obfuscate --split-debug-info=/debug_info/` for FAT APK (contains all ABIs)
9. Your build should be at `build/app/outputs/flutter-apk`
Facing problems? Kindly open an issue.

## Tech Stack
- Flutter
- Firebase
- Android
- Midtrans API (Payment Gateway, not yet implemented)
- Gemini AI Model

## Downloads (Current Release)

Download the latest version of NeuroParenting according to your Android device's architecture type:
- [Fat Apk](https://github.com/mfazrinizar/NeuroParenting/releases/download/v0.0.2/NeuroParenting-release.apk) (Fat APK, if you don't know your Android architecture)
- [Arm64-v8a](https://github.com/mfazrinizar/NeuroParenting/releases/download/v0.0.2/NeuroParenting-arm64-v8a-release.apk) (APK for arm64-v8a)
- [Armeabi-v7a](https://github.com/mfazrinizar/NeuroParenting/releases/download/v0.0.2/NeuroParenting-armeabi-v7a-release.apk) (APK for armeabi-v7a or arm32)
- [x86_64](https://github.com/mfazrinizar/NeuroParenting/releases/download/v0.0.2/NeuroParenting-x86_64-release.apk) (APK for x86_64)

## About Us
Hey There! We're a group of four students developing NeuroParenting from Sriwijaya University. Each of our role is :
1. MUHAMMAD ZHAFRAN as a Hustler
2. AISYAH FATIMAH as a Hipster
3. M. FAZRI NIZAR as a Hacker
4. FACHRY GHIFARY as a Hacker
