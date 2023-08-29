import * as React from 'react';
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn';
import { StyleSheet, View, Button, TurboModuleRegistry } from 'react-native';
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
    OpenIMEmitter.addListener('onConnectFailed', (v) => {
      console.log(v);
    });
    OpenIMEmitter.addListener('onNewConversation', (v) => {
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
    const config = {
      platformID: 5,
      apiAddr: 'https://web.rentsoft.cn/api',
      wsAddr: 'wss://web.rentsoft.cn/msg_gateway',
      dataDir: RNFS.DocumentDirectoryPath + '/tmp',
      logLevel: 6,
      isLogStandardOutput: true,
    };
    try {
      const opid = uuid();
      const result = await OpenIMSDKRN.initSDK(config, opid);
      console.log(result); // Success message

    } catch (error) {
      console.error('Error initializing SDK:', error); // Log the error
    }
  };

  const Login = async () => {
    const tk =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiI2OTYwNTYyODA1IiwiUGxhdGZvcm1JRCI6NSwiZXhwIjoxNzAxMDY5OTM0LCJuYmYiOjE2OTMyOTM2MzQsImlhdCI6MTY5MzI5MzkzNH0.n9HvwQDA99eoCfkivB20m8byubN-_dcllBdsC9raOYs'
      const options = {
      userID: '6960562805',
      token: tk,
    };
    try {
      const data = await OpenIMSDKRN.login(options, uuid());
      console.log(data);
    }
    catch (error) {
      console.error('Error login:', error); // Log the error
    }
  };

  const GetLoginStatus = async () => {
    const data = await OpenIMSDKRN.getLoginStatus(null);
    console.log(data);
  };

  const GetCveSplit = async () => {
    const options = {
      offset:0,
      count:1,
    }
    const data = await OpenIMSDKRN.getConversationListSplit(options, uuid());
    console.log(data);
  };

  const GetUsersInfo = async () => {
    try {
      const data = await OpenIMSDKRN.getUsersInfo(['6960562805'], uuid());
      console.log(data);
    }catch (error) {
      console.error('Error GetUsersInfo:', error); // Log the error
    }
  };

  const CreateTextMsg = async () => {
    try {
      const data = await OpenIMSDKRN.createTextMessage('rn text msg', uuid());
      console.log(data);
      setText(data);
    }catch (error) {
      console.error('Error CreateTextMsg:', error); // Log the error
    }
    
  };
  const CreateSoundMessageByURL = async () => {
    const soundinfo = {
      soundPath: '',
      duration: 6,
      uuid: 'uuid',
      sourceUrl: '',
      dataSize: 1024,
      soundType: 'mp3',
    }
    try {
      const data = await OpenIMSDKRN.createSoundMessageByURL(soundinfo, uuid());
      console.log(data);
    }catch (error) {
      console.error('Error CreateSoundMessageByURL:', error); // Log the error
    }
  }
  const getGroupMemberListByJoinTimeFilter = async () =>{
    const options = {
      groupID: '',
      offset: 0,
      count: 20,
      joinTimeBegin: 0,
      joinTimeEnd: 0,
      filterUserIDList: ['userID'],
    }
    try {
      const data = await OpenIMSDKRN.getGroupMemberListByJoinTimeFilter(options, uuid());
      console.log(data);
    }catch (error) {
      console.error('Error getGroupMemberListByJoinTimeFilter:', error); // Log the error
    }
  }
  const SendMsg = async () => {
    const offlinePushInfo = {
      title: 'you have a new message',
      desc: 'new message',
      ex: '',
      iOSPushSound: '+1',
      iOSBadgeCount: true,
    }
    const options = {
      message:text,
      recvID:'7440671006',
      groupID:'',
      offlinePushInfo
    }
    try {
      const data = await OpenIMSDKRN.sendMessage(
        options,
        uuid()
      );
      console.log(data);
      setText(data);
    }catch (error) {
      console.error('Error SendMsg:', error); // Log the error
    }
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
      <Button onPress={CreateSoundMessageByURL} title="createSoundMessageByURL" />
      <Button onPress={getGroupMemberListByJoinTimeFilter} title="getGroupMemberListByJoinTimeFilter" />
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
