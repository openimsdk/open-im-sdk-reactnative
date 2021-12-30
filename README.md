# open-im-sdk-rn

OpenIM SDK for react-native

## Installation

```sh
npm install open-im-sdk-rn
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
    ipApi:"http://47.112.160.66:10000",
    ipWs:"ws://47.112.160.66:17778",
    dbDir:RNFS.DocumentDirectoryPath + '/tmp'
  }
  const data = await OpenIMSDKRN.initSDK(options)
}

const Login = async() => {
	const uid = "xxx"
  const token = "xxxxx"
  const data = await OpenIMSDKRN.login(uid,token)
}
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
