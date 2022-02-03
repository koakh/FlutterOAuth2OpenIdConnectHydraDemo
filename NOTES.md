# NOTES

based on awesome package and demo from 

https://github.com/MaikuB/flutter_appauth.git

- [flutter_appauth](https://github.com/MaikuB/flutter_appauth/tree/master/flutter_appauth): code for the plugin
- [flutter_appauth_platform_interface](https://github.com/MaikuB/flutter_appauth/tree/master/flutter_appauth_platform_interface): the code for common platform interface

cd flutter_appauth/example
flutter run
## WIP

finish hydra.md notes and create a NEW FINAL pkce client for web, android and ios :)
with notes to run flutter and ionic6 capacitor 3 projects


slim contrib cors NAD put final optimized version in hydra.md

- postgres create a new user to simulate citizencard create users

create a simple rust-diesel api to work with users

810 node project web, check rust?

- web ui chakra, ui to create a oauth2 login flow

- request a dummy api with protected route checked by hydra
- try with oauthkeeper









---------------------------------------------------------------------------------------------------


MIGRATE APP 

https://stackoverflow.com/questions/64425132/how-to-fix-flutter-warning-your-flutter-application-is-created-using-an-older-v

Your Flutter application is created using an older version of the Android
embedding. It is being deprecated in favor of Android embedding v2. Follow the
steps at

https://flutter.dev/go/android-project-migration

to migrate your project. You may also pass the --ignore-deprecation flag to
ignore this check and continue with the deprecated v1 embedding. However,
the v1 Android embedding will be removed in future versions of Flutter.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
The detected reason was:

  /mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/main/AndroidManifest.xml uses
  `android:name="io.flutter.app.FutterApplication"`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Build failed due to use of deprecated Android v1 embedding.



Delete the android and iOS files.

Then run flutter create . to fix the issue.

The command will recreate your Android and iOS file.


fis

```shell
$ rm ios android -r
# flutter create .

# use beloow to define org and name and keep original name of `com.appauth.demo`, use . to use curent directory
$  flutter create --org com.appauth --project-name demo .
```

> this will generate files on domain example/android/app/src/main/kotlin/com/appauth/demo

`android/app/src/main/kotlin/com/appauth/demo/MainActivity.kt`

```kotlin
package com.appauth.demo
```

---------------------------------------------------------------------------------------------------

android/app/build.gradle

add

```
defaultConfig {
	manifestPlaceholders = [
		'appAuthRedirectScheme': 'com.appauth.demo'
	]
}

...

buildTypes {
	release {
		manifestPlaceholders = [applicationName: "android.app.Application"]
	}
	debug {
		manifestPlaceholders = [applicationName: "android.app.Application"]
	}
	build{
		manifestPlaceholders = [applicationName: "android.app.Application"]
	}
}
```

https://stackoverflow.com/questions/69896828/why-is-the-value-for-applicationname-not-supplied-after-migrating-my-flutter/70364612


mario@koakh-laptop:/mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example> flutter run 
Launching lib/main.dart on M2012K11AG in debug mode...
/mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/main/AndroidManifest.xml:5:9-42 Error:
        Attribute application@name at AndroidManifest.xml:5:9-42 requires a placeholder substitution but no value for <applicationName> is provided.
/mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/debug/AndroidManifest.xml Error:
        Validation failed, exiting
        
flutter run

now it builds

Running Gradle task 'assembleDebug'...                             64.4s
✓  Built build/app/outputs/flutter-apk/app-debug.apk.


now on run fire bellow error

Installing build/app/outputs/flutter-apk/app.apk...                33.8s
E/AndroidRuntime(31898): FATAL EXCEPTION: main
E/AndroidRuntime(31898): Process: com.appauth.demo, PID: 31898
E/AndroidRuntime(31898): java.lang.RuntimeException: Unable to instantiate application com.appauth.demo: java.lang.ClassNotFoundException: Didn't find class "com.appauth.demo" on path: DexPathList[[zip file "/data/app/~~IYSAxQ71dDHAQhCDVz3SoA==/com.appauth.demo-hLnX7gCaI7jkZIgGRk1Z6Q==/base.apk"],nativeLibraryDirectories=[/data/app/~~IYSAxQ71dDHAQhCDVz3SoA==/com.appauth.demo-hLnX7gCaI7jkZIgGRk1Z6Q==/lib/arm64, /data/app/~~IYSAxQ71dDHAQhCDVz3SoA==/com.appauth.demo-hLnX7gCaI7jkZIgGRk1Z6Q==/base.apk!/lib/arm64-v8a, /system/lib64, /system_ext/lib64]]

finde: java.lang.RuntimeException: Unable to instantiate application  java.lang.ClassNotFoundException: Didn't find class  on path: DexPathList

seemts that this is wrong `[applicationName: "com.appauth.demo"]` was `[applicationName: "com.appauth.demo.MainActivity"]`


now

E/AndroidRuntime(25619): java.lang.RuntimeException: Unable to instantiate application com.appauth.demo.MainActivity: java.lang.ClassCastException: com.appauth.demo.MainActivity cannot be cast to android.app.Application



the solution is using `android.app.Application` ex `manifestPlaceholders = [applicationName: "android.app.Application"]`

