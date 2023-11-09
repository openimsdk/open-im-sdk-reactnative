# React Native SDK for OpenIM 👨‍💻💬


Here is the updated description for the React Native SDK for adding instant messaging capabilities using the OpenIM SDK:

**React Native OpenIM SDK**

The React Native OpenIM SDK empowers your application with instant messaging capabilities, making it easier than ever to integrate real-time communication features. By connecting to a self-hosted OpenIM server, you can seamlessly infuse your app with instant messaging functionality using just a few lines of code.

**Key Features:**

Cross-Platform Support: The underlying OpenIM SDK Core is implemented in OpenIM SDK Core. It offers versatile integration options for different platforms.

Android Integration with AAR Files: For Android integration, the OpenIM SDK Core can be compiled into an AAR (Android Archive) file using gomobile. Android applications interact with the OpenIM SDK Core through JSON, and the SDK offers a user-friendly API. Data storage on Android is seamlessly managed using the internal SQLite layer provided by the OpenIM SDK Core.

iOS Integration with XCFramework: On iOS, the OpenIM SDK Core can be compiled into an XCFramework for smooth integration. iOS applications communicate with the OpenIM SDK Core via JSON, and the SDK simplifies usage with its re-encapsulated API. Data storage on iOS leverages the internal SQLite layer provided by the OpenIM SDK Core.

Empower your application with instant messaging capabilities across web, Android, and iOS platforms, and enhance user engagement with real-time communication using the React Native OpenIM SDK.

For detailed integration instructions, refer to the OpenIM SDK Core documentation.


## Documentation 📚

Visit [https://doc.rentsoft.cn/](https://doc.rentsoft.cn/) for detailed documentation and guides.

For the SDK reference, see [https://doc.rentsoft.cn/sdks/quickstart/browser](https://doc.rentsoft.cn/sdks/quickstart/browser).

## Installation 💻

```sh
yarn add open-im-sdk-rn
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

## Examples 🌟

You can find a demo web app that uses the SDK in the [openim-pc-web-demo](https://github.com/openimsdk/openim-reactnative-demo) repository.
## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.


## Community :busts_in_silhouette:

- 📚 [OpenIM Community](https://github.com/OpenIMSDK/community)
- 💕 [OpenIM Interest Group](https://github.com/Openim-sigs)
- 🚀 [Join our Slack community](https://join.slack.com/t/openimsdk/shared_invite/zt-22720d66b-o_FvKxMTGXtcnnnHiMqe9Q)
- :eyes: [Join our wechat (微信群)](https://openim-1253691595.cos.ap-nanjing.myqcloud.com/WechatIMG20.jpeg)

## Community Meetings :calendar:

We want anyone to get involved in our community and contributing code, we offer gifts and rewards, and we welcome you to join us every Thursday night.

Our conference is in the [OpenIM Slack](https://join.slack.com/t/openimsdk/shared_invite/zt-22720d66b-o_FvKxMTGXtcnnnHiMqe9Q) 🎯, then you can search the Open-IM-Server pipeline to join

We take notes of each [biweekly meeting](https://github.com/orgs/OpenIMSDK/discussions/categories/meeting) in [GitHub discussions](https://github.com/openimsdk/open-im-server/discussions/categories/meeting), Our historical meeting notes, as well as replays of the meetings are available at [Google Docs :bookmark_tabs:](https://docs.google.com/document/d/1nx8MDpuG74NASx081JcCpxPgDITNTpIIos0DS6Vr9GU/edit?usp=sharing).

## Who are using OpenIM :eyes:

Check out our [user case studies](https://github.com/OpenIMSDK/community/blob/main/ADOPTERS.md) page for a list of the project users. Don't hesitate to leave a [📝comment](https://github.com/openimsdk/open-im-server/issues/379) and share your use case.

## License :page_facing_up:

OpenIM is licensed under the Apache 2.0 license. See [LICENSE](https://github.com/openimsdk/open-im-server/tree/main/LICENSE) for the full license text.

