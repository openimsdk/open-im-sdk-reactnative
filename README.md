# React Native Client SDK for OpenIM 👨‍💻💬

Use this SDK to add instant messaging capabilities to your application. By connecting to a self-hosted [OpenIM](https://www.openim.io) server, you can quickly integrate instant messaging capabilities into your app with just a few lines of code.

The iOS SDK core is implemented in [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core). Using [gomobile](https://github.com/golang/mobile), it can be compiled into an XCFramework for iOS integration. iOS interacts with the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core) through JSON, and the SDK exposes a re-encapsulated API for easy usage. In terms of data storage, iOS utilizes the SQLite layer provided internally by the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core).

The Android SDK core is implemented in [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core). Using [gomobile](https://github.com/golang/mobile), it can be compiled into an AAR file for Android integration. Android interacts with the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core) through JSON, and the SDK exposes a re-encapsulated API for easy usage. In terms of data storage, Android utilizes the SQLite layer provided internally by the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core).

The React Native Client SDK uses the [NativeModule](https://reactnative.dev/docs/native-modules-intro) system to expose instances of Java/Objective-C classes to JavaScript (JS) as JS objects, thereby allowing you to execute arbitrary native code from within JS.

## Tips 🔔

1. **Android 16KB page-size support:** Starting from `v3.8.3-patch.12`, the Android core dependency is upgraded to `io.openim:core-sdk:3.8.3-patch12+1`, adding compatibility for devices using 16KB memory page size.

2. **Expo support:** Expo custom dev client workflow is supported from `v3.8.3-patch.10.3` and later.

3. **Event Binding API:** Starting from `v3.8.3-patch.10.2`, you can use `OpenIMSDK.on()` to listen for events with better TypeScript type hints. Earlier versions must use the `OpenIMEmitter` object. Both approaches remain compatible with the latest version.

4. **operationID Parameter:** This parameter is used for backend log querying. Starting from `v3.8.3-patch.10.2`, the `operationID` parameter is optional for all APIs (the SDK will auto-generate one if not provided). For earlier versions, this parameter is required and must be passed explicitly.

5. Starting from `v3.8.3-patch.10`, the package name has been changed from `open-im-sdk-rn` to `@openim/rn-client-sdk`.

6. The `v3.5.1` contains ***significant disruptive updates***. If you need to upgrade, please check the incoming data and the returned data.

## Documentation 📚

Visit [https://docs.openim.io](https://docs.openim.io) for detailed documentation and guides.

For the SDK reference, see [https://docs.openim.io/sdks/quickstart/reactNative](https://docs.openim.io/sdks/quickstart/reactNative).

## Installation 💻

### Install with React Native CLI

```sh
# install the SDK
npm install @openim/rn-client-sdk

# iOS native dependencies
cd ios && pod install && cd ..
```

### Install with Expo

`v3.8.3-patch.10.3` and later support Expo via the custom development client (prebuild) workflow. This package bridges native modules, so Expo projects must run in a prebuild/custom development client workflow rather than Expo Go.

```sh
# install the SDK
npm install @openim/rn-client-sdk

# generate native projects and run
npx expo prebuild
npx expo run:android
npx expo run:ios

# optional: Expo Go–like dev client experience
npx expo install expo-dev-client
```

## Usage 🚀

The following examples demonstrate how to use the SDK. TypeScript is used, providing complete type hints.

### Importing the SDK and init

```typescript
import OpenIMSDK from '@openim/rn-client-sdk';
import RNFS from 'react-native-fs';

RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp');

OpenIMSDK.initSDK({
  apiAddr: 'http://your-server-ip:10002',
  wsAddr: 'ws://your-server-ip:10001',
  dataDir: RNFS.DocumentDirectoryPath + '/tmp',
  logFilePath: RNFS.DocumentDirectoryPath + '/tmp',
  logLevel: 5,
  isLogStandardOutput: true,
});
```

### Logging In and Listening for Connection Status

```typescript
import OpenIMSDK from '@openim/rn-client-sdk';

OpenIMSDK.login({
  userID: 'IM user ID',
  token: 'IM user token',
});

OpenIMSDK.on('onConnecting', () => {
  console.log('onConnecting');
});

OpenIMSDK.on('onConnectSuccess', () => {
  console.log('onConnectSuccess');
});

OpenIMSDK.on('onConnectFailed', ({ errCode, errMsg }) => {
  console.log('onConnectFailed', errCode, errMsg);
});
```

**For versions prior to v3.8.3-patch.10.2:**

```typescript
import OpenIMSDKRN, { OpenIMEmitter } from '@openim/rn-client-sdk';

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

To log into the IM server, you need to create an account and obtain a user ID and token. Refer to the [access token documentation](https://docs.openim.io/restapi/apis/usermanagement/userregister) for details.

### Receiving and Sending Messages 💬

OpenIM makes it easy to send and receive messages. By default, there is no restriction on having a friend relationship to send messages (although you can configure other policies on the server). If you know the user ID of the recipient, you can conveniently send a message to them.

```typescript
import OpenIMSDK from '@openim/rn-client-sdk';
import type { MessageItem } from '@openim/rn-client-sdk';

OpenIMSDK.on('onRecvNewMessages', (messages: MessageItem[]) => {
  console.log('onRecvNewMessages', messages);
});

const message = await OpenIMSDK.createTextMessage('hello openim');

OpenIMSDK.sendMessage({
  recvID: 'recipient user ID',
  groupID: '',
  message,
})
  .then(() => {
    // Message sent successfully ✉️
  })
  .catch(err => {
    // Failed to send message ❌
    console.log(err);
  });
```

**For versions prior to v3.8.3-patch.10.2:**

```typescript
import OpenIMSDKRN, { OpenIMEmitter } from '@openim/rn-client-sdk';

OpenIMEmitter.addListener('onRecvNewMessages', (messages) => {
  console.log('onRecvNewMessages', messages);
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

You can find a demo React-Native app that use the SDK in the [openim-reactnative-demo](https://github.com/openimsdk/openim-reactnative-demo) repository.

or:

Use the examples(only the simplest SDK calls) under this project to try it out:

```sh
yarn

yarn example android

yarn example ios
```

> **Note for iOS:** When running the iOS example project, you may encounter dependency installation errors or build failures. Please refer to [iOS Example Project Running Notes](./docs/IOS-EXAMPLE-WARN.md) for detailed solutions.

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
