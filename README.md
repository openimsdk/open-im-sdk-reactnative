# open-im-sdk-rn

OpenIM SDK for react-native

## Installation

```sh
npm install open-im-sdk-rn
```

## Usage

```js
yarn

yarn example ios

yarn example android
```
for android add following two urls to build gradle:
<br />

https://open-im-online.rentsoft.cn:51000/repository/maven2/
<br />

https://open-im-online.rentsoft.cn:51000/repository/maven2/
<br />
```
// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    ext {
        buildToolsVersion = "33.0.0"
        minSdkVersion = 21
        compileSdkVersion = 33
        targetSdkVersion = 33

        // We use NDK 23 which has both M1 support and is the side-by-side NDK version from AGP.
        ndkVersion = "23.1.7779620"
    }
    repositories {
        google()
        mavenCentral()
        maven {
            allowInsecureProtocol = true
            url 'https://open-im-online.rentsoft.cn:51000/repository/maven2/'
        }
    }
    dependencies {
        classpath("com.android.tools.build:gradle")
        classpath("com.facebook.react:react-native-gradle-plugin")
    }
}
allprojects {
    repositories {
        maven {
            allowInsecureProtocol = true
            url 'https://open-im-online.rentsoft.cn:51000/repository/maven2/'
        }
    }
}
```
## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
