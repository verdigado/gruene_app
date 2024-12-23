# Gruene App

## Contents

- [Setup](#setup)
- [Initial Setup](#initial-setup)
- [Run the App](#run-the-app)
- [Conventions](docs/conventions.md)
- [CI/CD](docs/cicd.md)

## Setup

### Initial Setup

1. Install the Android SDK via the [Android plugin](https://www.jetbrains.com/help/idea/create-your-first-android-application.html#754fd) or Android Studio
2. Install [fvm](https://fvm.app/documentation/getting-started/installation) (flutter version manager)
3. Install [fvm](https://fvm.app/documentation/getting-started/installation) (flutter version manager)
4. Install flutter
``` shell
fvm install
```
5. Configure local environment
``` shell
cp .env.dev .env
```
6. [Optional] Adjust the environment variables in `.env` as needed
7. [Optional] Open IntelliJ settings and
    - Install the Android plugin and set the Android SDK path
    - Install the Dart plugin and set the Dart SDK path
    - Install the Flutter plugin and set the Flutter SDK path

### Run the App

1. Update translations
``` shell
fvm dart run slang
```
2. Run build runner to update API definitions
``` shell
fvm dart run build_runner build
```
3. Run the app (`development`)

### Connecting to local Grüne API

TODO
