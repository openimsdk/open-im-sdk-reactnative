import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'open-im-sdk-rn' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const OpenIMSDKRN = NativeModules.OpenIMSDKRN
  ? NativeModules.OpenIMSDKRN
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export const OpenIMEmitter = new NativeEventEmitter(OpenIMSDKRN);

export default OpenIMSDKRN
