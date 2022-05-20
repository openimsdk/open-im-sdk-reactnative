# open-im-sdk-rn

OpenIM SDK for react-native

## Installation

```sh
npm install open-im-sdk-rn
```

## Android
- Add dependencies

```
// ./android/build.gradle
...
repositories{
  ...
  maven {
            allowInsecureProtocol = true
            url 'http://121.37.25.71:8081/repository/maven2/'
        }
}

```

## Usage

```js
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn'

// ...
OpenIMEmitter.addListener("onConnectSuccess",(v)=>{
      console.log(v);
  })

const Init = async () => {
 await RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp')
  const options = {
    platform: 2,
    api_addr: 'http://121.37.25.71:10000',
    ws_addr: 'ws://121.37.25.71:17778',
    data_dir: RNFS.DocumentDirectoryPath + '/tmp',
    log_level: 6,
    object_storage: 'cos',
  }
  const data = await OpenIMSDKRN.initSDK(options, uuid())
}

const Login = async() => {
	const uid = "xxx"
  const token = "xxxxx"
  const data = await OpenIMSDKRN.login(uid,token,uuid())
}
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
