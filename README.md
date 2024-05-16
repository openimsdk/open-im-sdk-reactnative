# React Native Client SDK for OpenIM 👨‍💻💬

Use this SDK to add instant messaging capabilities to your application. By connecting to a self-hosted [OpenIM](https://www.openim.io) server, you can quickly integrate instant messaging capabilities into your app with just a few lines of code.

The iOS SDK core is implemented in [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core). Using [gomobile](https://github.com/golang/mobile), it can be compiled into an XCFramework for iOS integration. iOS interacts with the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core) through JSON, and the SDK exposes a re-encapsulated API for easy usage. In terms of data storage, iOS utilizes the SQLite layer provided internally by the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core).

The android SDK core is implemented in [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core). Using [gomobile](https://github.com/golang/mobile), it can be compiled into an AAR file for Android integration. Android interacts with the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core) through JSON, and the SDK exposes a re-encapsulated API for easy usage. In terms of data storage, Android utilizes the SQLite layer provided internally by the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core).

The React Native Client SDK use [NativeModule](https://reactnative.dev/docs/native-modules-intro) system exposes instances of Java/Objective-C classes to JavaScript (JS) as JS objects, thereby allowing you to execute arbitrary native code from within JS.

## Tips 🔔

1. The open-im-sdk-rn@3.5.1 has contains ***significant disruptive updates***. If you need to upgrade, please check the incoming data and the returned data.

2. Unlike other SDKS, React Native SDK operationID is not optional, but required.

## Documentation 📚

Visit [https://doc.rentsoft.cn](https://doc.rentsoft.cn) for detailed documentation and guides.

For the SDK reference, see [https://doc.rentsoft.cn/sdks/quickstart/reactnative](https://doc.rentsoft.cn/sdks/quickstart/reactnative).

## Installation 💻

### Adding Dependencies

```sh
yarn add open-im-sdk-rn
```

### For android add following urls to build gradle:

https://open-im-online.rentsoft.cn:51000/repository/maven2/

```gradle
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

## Usage 🚀

The following examples demonstrate how to use the SDK. TypeScript is used, providing complete type hints.

### Importing the SDK and init

```typescript
import OpenIMSDKRN from 'open-im-sdk-rn';
import RNFS from 'react-native-fs';

RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp');

OpenIMSDKRN.initSDK({
  platformID: 2,  // 1: ios, 2: android
  apiAddr: 'http://your-server-ip:10002',
  wsAddr: 'ws://your-server-ip:10001',
  dataDir: RNFS.DocumentDirectoryPath + '/tmp',
  logLevel: 5,
  isLogStandardOutput: true,
}, 'opid');
```

### Logging In and Listening for Connection Status

```typescript
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn';

OpenIMSDKRN.login({
  userID: 'IM user ID',
  token: 'IM user token',
}, 'opid');

OpenIMEmitter.addListener('onConnecting', () => {
  console.log('onConnecting');
});

OpenIMEmitter.addListener('onConnectSuccess', () => {
  console.log('onConnectSuccess');
});

OpenIMEmitter.addListener('onConnectFailed', ({ errCode, errMsg }) => {
  console.log('onConnectFailed', errCode, errMsg);
});
```

To log into the IM server, you need to create an account and obtain a user ID and token. Refer to the [access token documentation](https://doc.rentsoft.cn/restapi/userManagement/userRegister) for details.

### Receiving and Sending Messages 💬

OpenIM makes it easy to send and receive messages. By default, there is no restriction on having a friend relationship to send messages (although you can configure other policies on the server). If you know the user ID of the recipient, you can conveniently send a message to them.

```typescript
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn';
import type { MessageItem } from 'open-im-sdk-rn';

OpenIMEmitter.addListener('onRecvNewMessages', (data: MessageItem[]) => {
  console.log('onRecvNewMessages', data);
});

const message = await OpenIMSDKRN.createTextMessage('hello openim', 'opid');

OpenIMSDKRN.sendMessage({
  recvID: 'recipient user ID',
  groupID: '',
  message,
}, 'opid')
  .then(() => {
    // Message sent successfully ✉️
  })
  .catch(err => {
    // Failed to send message ❌
    console.log(err);
  });
```

## Examples 🌟

You can find a demo web app that use the SDK in the [openim-reactnative-demo](https://github.com/openimsdk/openim-reactnative-demo) repository.

or:

Use the examples(only the simplest SDK calls) under this project to try it out:

```sh
yarn

yarn example android

yarn example ios
```

## Community :busts_in_silhouette:

- 📚 [OpenIM Community](https://github.com/OpenIMSDK/community)
- 💕 [OpenIM Interest Group](https://github.com/Openim-sigs)
- 🚀 [Join our Slack community](https://join.slack.com/t/openimsdk/shared_invite/zt-2ijy1ys1f-O0aEDCr7ExRZ7mwsHAVg9A)
- :eyes: [Join our wechat (微信群)](https://openim-1253691595.cos.ap-nanjing.myqcloud.com/WechatIMG20.jpeg)

## Community Meetings :calendar:

We want anyone to get involved in our community and contributing code, we offer gifts and rewards, and we welcome you to join us every Thursday night.

Our conference is in the [OpenIM Slack](https://join.slack.com/t/openimsdk/shared_invite/zt-2ijy1ys1f-O0aEDCr7ExRZ7mwsHAVg9A) 🎯, then you can search the Open-IM-Server pipeline to join

We take notes of each [biweekly meeting](https://github.com/orgs/OpenIMSDK/discussions/categories/meeting) in [GitHub discussions](https://github.com/openimsdk/open-im-server/discussions/categories/meeting), Our historical meeting notes, as well as replays of the meetings are available at [Google Docs :bookmark_tabs:](https://docs.google.com/document/d/1nx8MDpuG74NASx081JcCpxPgDITNTpIIos0DS6Vr9GU/edit?usp=sharing).

## Who are using OpenIM :eyes:

Check out our [user case studies](https://github.com/OpenIMSDK/community/blob/main/ADOPTERS.md) page for a list of the project users. Don't hesitate to leave a [📝comment](https://github.com/openimsdk/open-im-server/issues/379) and share your use case.

## License :page_facing_up:

OpenIM is licensed under the Apache 2.0 license. See [LICENSE](https://github.com/openimsdk/open-im-server/tree/main/LICENSE) for the full license text.
