import * as React from 'react';
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn'
import { StyleSheet, View, Button } from 'react-native';
import { useEffect, useState } from 'react';
import RNFS from 'react-native-fs';
// const OpenIMEmitter = new NativeEventEmitter(OpenIMSDKRN);

export default function App() {
  const [text,setText] = useState("");

  useEffect(()=>{
    Listener()
  },[])

  const Listener = () => {
    OpenIMEmitter.addListener("onConnectSuccess",(v)=>{
      console.log(v);
    })
    OpenIMEmitter.addListener("onConversationChanged",(v)=>{
     console.log("cve changed:::");
      console.log(v);
    })
    OpenIMEmitter.addListener("onRecvNewMessage",v=>{
      console.log("rec new msg:::");
      console.log(v);
    })
    OpenIMEmitter.addListener("SendMessageProgress",v=>{
      console.log("send msg progress:::");
      console.log(v);
    })
  }

  const Init = async () => {
   await RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp')
    const options = {
      platform: 2,
      ipApi:"http://47.112.160.66:10000",
      ipWs:"ws://47.112.160.66:17778",
      dbDir:RNFS.DocumentDirectoryPath + '/tmp'
    }
    const data = await OpenIMSDKRN.initSDK(options)
    console.log(data);
  }

  const Login = async() => {
   const tk = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVSUQiOiJ0ZXN0YWRkIiwiUGxhdGZvcm0iOiJBbmRyb2lkIiwiZXhwIjoxNjQxNDUzOTQ4LCJuYmYiOjE2NDA4NDkxNDgsImlhdCI6MTY0MDg0OTE0OH0.3x-PIH1QX--W1fGWq9u9PwIj4ux3KxMBDUaONYXBbCA"
    const data = await OpenIMSDKRN.login("testadd",tk)
    console.log(data);
  }

  const GetUsersInfo = async() => {
   const data = await OpenIMSDKRN.getUsersInfo(["17396220460"])
   console.log(data);
  }

  const CreateTextMsg = async() => {
   const msg = await OpenIMSDKRN.createTextMessage("rn text msg")
   console.log(msg);
   setText(msg);
  }

  const SendMsg = async() => {
   const data = await OpenIMSDKRN.sendMessage(text,"17396220460","",false)
   console.log("send msg promise data::::",data);
  }
  return (
    <View style={styles.container}>
           <Button onPress={Init} title="Init" />
           <Button onPress={Login} title="Login" />
           <Button onPress={GetUsersInfo} title="GetUsersInfo" />
           <Button onPress={CreateTextMsg} title="CreateTextMsg" />
           <Button onPress={SendMsg} title="SendMsg" />
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
