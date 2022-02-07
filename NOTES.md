# NOTES

## Links

based on awesome package and demo from `flutter_appauth`

- [flutter_appauth](https://github.com/MaikuB/flutter_appauth.git)
- [flutter_appauth master](https://github.com/MaikuB/flutter_appauth/tree/master/flutter_appauth): code for the plugin
- [flutter_appauth_platform_interface](https://github.com/MaikuB/flutter_appauth/tree/master/flutter_appauth_platform_interface): the code for common platform interface

```shell
$ cd flutter_appauth/example
$ flutter run
```

## TODO

finish `HYDRA.md` notes and create a NEW FINAL pkce client for web, android and ios to double check that it works
with notes to run flutter and ionic6 capacitor 3 projects

slim contrib cors AND put final optimized version in `HYDRA.md`

- postgres create a new user to simulate citizencard create users
- create a simple rust-diesel api to work with users
- 810 node project web, check rust?
- web ui chakra/tailwindcss, ui to create a oauth2 login flow
- request a dummy api with protected route checked by hydra
- try with oauthkeeper

## Run Project

```shell
$ cd flutter_appauth/example
$ flutter run
```

## Configure for Ory Hydra Kuartzo Client

`lib/main.dart`

```dart
  // For a list of client IDs, go to https://demo.identityserver.io
  // final String _clientId = 'interactive.public';
  // final String _redirectUrl = 'io.identityserver.demo:/oauthredirect';
  // final String _issuer = 'https://demo.identityserver.io';
  // final String _discoveryUrl =
  //   'https://demo.identityserver.io/.well-known/openid-configuration';
  // final String _postLogoutRedirectUrl = 'io.identityserver.demo:/';

  // get hydra details from https://kuartzo.com:444/.well-known/openid-configuration
  final String _clientId = 'oauth-pkce5';
  final String _redirectUrl = 'com.appauth.demo://callback';
  final String _issuer = 'https://kuartzo.com:444';
  final String _discoveryUrl =
      'https://kuartzo.com:444/.well-known/openid-configuration';
  final String _postLogoutRedirectUrl = 'com.appauth.demo://endSession';

  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
    // dont uncomment this, will create the open/close phenomenum in ios
    // 'api'
  ];

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    // authorizationEndpoint: 'https://demo.identityserver.io/connect/authorize',
    // tokenEndpoint: 'https://demo.identityserver.io/connect/token',
    // endSessionEndpoint: 'https://demo.identityserver.io/connect/endsession',

    authorizationEndpoint: 'https://kuartzo.com:444/oauth2/auth',
    tokenEndpoint: 'https://kuartzo.com:444/oauth2/token',
    endSessionEndpoint: 'https://kuartzo.com:444/oauth2/sessions/logout',
  );
```

## IOS Changes

require to recongnize the url scheme

```xml
	<!-- seems that this is not needed
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.appauth.demo</string>
			</array>
		</dict>
	</array> -->
```

> project was tested with this comment and url scheme works, strange, maybe it uses `PRODUCT_BUNDLE_IDENTIFIER = com.appauth.demo;` created when we upgrade project to flutter 2.0 with org with command `flutter create --org com.appauth --project-name demo .`, seems that this will do the trick

## Fix : Upgrading pre 1.12 Android projects

- [Upgrading pre 1.12 Android projects · flutter/flutter Wiki](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)

### Migrate Flutter App to 2.x

Your Flutter application is created using an older version of the Android
embedding. It is being deprecated in favor of Android embedding v2. Follow the
steps at

- [https://flutter.dev/go/android-project-migration](https://flutter.dev/go/android-project-migration)

```shell
$ flutter run

to migrate your project. You may also pass the --ignore-deprecation flag to
ignore this check and continue with the deprecated v1 embedding. However,
the v1 Android embedding will be removed in future versions of Flutter.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
The detected reason was:

  /mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/main/AndroidManifest.xml uses
  `android:name="io.flutter.app.FutterApplication"`
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Build failed due to use of deprecated Android v1 embedding.
```

1. Delete the `android` and `iOS` files.
2. Then run `flutter create .` to fix the issue.

> The command will recreate your Android and iOS file.

- [How to Fix Flutter Warning: Your Flutter application is created using an older version](https://stackoverflow.com/questions/64425132/how-to-fix-flutter-warning-your-flutter-application-is-created-using-an-older-v)

fix

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

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

## Fix : Attribute data@scheme at AndroidManifest.xml requires a placeholder substitution but no value for <appAuthRedirectScheme> is provided

```shell
$ flutter run
/mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/debug/AndroidManifest.xml Error:
        Attribute data@scheme at AndroidManifest.xml requires a placeholder substitution but no value for <appAuthRedirectScheme> is provided
```

add to `android/app/build.gradle`

```
defaultConfig {
	manifestPlaceholders = [
		'appAuthRedirectScheme': 'com.appauth.demo'
	]
}
```

## Fix : Attribute application@name at AndroidManifest.xml:5:9-42 requires a placeholder substitution but no value for <applicationName> is provided. 

- [Why is the value for ${applicationName} not supplied after migrating my Flutter app to Android embedding v2?](https://stackoverflow.com/questions/69896828/why-is-the-value-for-applicationname-not-supplied-after-migrating-my-flutter/70364612)

```shell
$ fluter run

/mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/main/AndroidManifest.xml:5:9-42 Error:
        Attribute application@name at AndroidManifest.xml:5:9-42 requires a placeholder substitution but no value for <applicationName> is provided.
/mnt/storage/Development/@OAuth2/Flutter/FlutterOAuth2OpenIdConnectHydraDemo/flutter_appauth/example/android/app/src/debug/AndroidManifest.xml Error:
        Validation failed, exiting
...

add to `android/app/build.gradle`

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

now it builds

```
Running Gradle task 'assembleDebug'...                             64.4s
✓  Built build/app/outputs/flutter-apk/app-debug.apk.
```

now on run fire bellow error

```shell
Installing build/app/outputs/flutter-apk/app.apk...                33.8s
E/AndroidRuntime(31898): FATAL EXCEPTION: main
E/AndroidRuntime(31898): Process: com.appauth.demo, PID: 31898
E/AndroidRuntime(31898): java.lang.RuntimeException: Unable to instantiate application com.appauth.demo: java.lang.ClassNotFoundException: Didn\'t find class "com.appauth.demo" on path: DexPathList[[zip file "/data/app/~~IYSAxQ71dDHAQhCDVz3SoA==/com.appauth.demo-hLnX7gCaI7jkZIgGRk1Z6Q==/base.apk"],nativeLibraryDirectories=[/data/app/~~IYSAxQ71dDHAQhCDVz3SoA==/com.appauth.demo-hLnX7gCaI7jkZIgGRk1Z6Q==/lib/arm64, /data/app/~~IYSAxQ71dDHAQhCDVz3SoA==/com.appauth.demo-hLnX7gCaI7jkZIgGRk1Z6Q==/base.apk!/lib/arm64-v8a, /system/lib64, /system_ext/lib64]]

finde: java.lang.RuntimeException: Unable to instantiate application  java.lang.ClassNotFoundException: Didn\'t find class  on path: DexPathList
```

seems that this is wrong `[applicationName: "com.appauth.demo"]` was `[applicationName: "com.appauth.demo.MainActivity"]`

now

```shell
E/AndroidRuntime(25619): java.lang.RuntimeException: Unable to instantiate application com.appauth.demo.MainActivity: java.lang.ClassCastException: com.appauth.demo.MainActivity cannot be cast to android.app.Application
```

the solution is using `android.app.Application` ex `manifestPlaceholders = [applicationName: "android.app.Application"]`, and not `com.appauth.demo` or `com.appauth.demo.MainActivity`