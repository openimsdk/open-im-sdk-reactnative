import * as React from 'react';
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn';
import { StyleSheet, View, Button } from 'react-native';
import { useEffect, useState } from 'react';
import RNFS from 'react-native-fs';
// const OpenIMEmitter = new NativeEventEmitter(OpenIMSDKRN);

export default function App() {
  const [text, setText] = useState('');

  useEffect(() => {
    Listener();
  }, []);

  const uuid = () => (Math.random() * 36).toString(36).slice(2) + new Date().getTime().toString()

  const Listener = () => {
    OpenIMEmitter.addListener('onConnectSuccess', (v) => {
      console.log(v);
    });
    OpenIMEmitter.addListener('onConversationChanged', (v) => {
      console.log('cve changed:::');
      console.log(v);
    });
    OpenIMEmitter.addListener('onRecvNewMessage', (v) => {
      console.log('rec new msg:::');
      console.log(v);
    });
    OpenIMEmitter.addListener('SendMessageProgress', (v) => {
      console.log('send msg progress:::');
      console.log(v);
    });
  };

  const Init = async () => {
    await RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp');
    const options = {
      platform: 2,
      api_addr: 'http://121.37.25.71:10000',
      ws_addr: 'ws://121.37.25.71:17778',
      data_dir: RNFS.DocumentDirectoryPath + '/tmp',
      log_level: 6,
      object_storage: 'cos',
    };
    const data = await OpenIMSDKRN.initSDK(options, uuid());
    console.log(data);
  };

  const Login = async () => {
    const tk =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVSUQiOiJ0ZXN0YWRkIiwiUGxhdGZvcm0iOiJXZWIiLCJleHAiOjE5NjE5OTc1MjYsIm5iZiI6MTY0NjYzNzUyNiwiaWF0IjoxNjQ2NjM3NTI2fQ.iei3xRbbpGHHOnb_Cslio6ZBgniLOn3H2UFW8tk5BTY';
    const data = await OpenIMSDKRN.login('testadd', tk, uuid());
    console.log(data);
  };

  const GetLoginStatus = async () => {
    const data = await OpenIMSDKRN.getLoginStatus();
    console.log(data);
  };

  const GetCveSplit = async () => {
    const data = await OpenIMSDKRN.getConversationListSplit(0, 1, uuid());
    console.log(data);
  };

  const GetUsersInfo = async () => {
    const data = await OpenIMSDKRN.getUsersInfo(['17396220460'], uuid());
    console.log(data);
  };

  const CreateTextMsg = async () => {
    const msg = await OpenIMSDKRN.createTextMessage('rn text msg', uuid());
    console.log(msg);
    setText(msg);
  };

  const SendMsg = async () => {
    const offlinePushInfo = {
      title: '你有一条新消息',
      desc: '',
      ex: '',
      iOSPushSound: '+1',
      iOSBadgeCount: true,
    };
    const data = await OpenIMSDKRN.sendMessage(
      text,
      '17396220460',
      '',
      offlinePushInfo,
      uuid()
    );
    console.log('send msg promise data::::', data);
  };
  return (
    <View style={styles.container}>
      <Button onPress={Init} title="Init" />
      <Button onPress={Login} title="Login" />
      <Button onPress={GetLoginStatus} title="getLoginStatus" />
      <Button onPress={GetUsersInfo} title="GetUsersInfo" />
      <Button onPress={CreateTextMsg} title="CreateTextMsg" />
      <Button onPress={SendMsg} title="SendMsg" />
      <Button onPress={GetCveSplit} title="getCveSplit" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
