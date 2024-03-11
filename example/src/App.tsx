import React from 'react';
import OpenIMSDKRN, { OpenIMEmitter } from 'open-im-sdk-rn';
import RNFS from 'react-native-fs';
import { Button, StyleSheet, View } from 'react-native';
import { MessageItem } from 'src/types/entity';

function App(): React.JSX.Element {
  RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp');
  const init = async () => {
    // platformID ios 1 android 2
    try {
      await OpenIMSDKRN.initSDK(
        {
          platformID: 2,
          apiAddr: 'http://192.168.2.16:10002',
          wsAddr: 'ws://192.168.2.16:10001',
          dataDir: RNFS.DocumentDirectoryPath + '/tmp',
          logLevel: 5,
          isLogStandardOutput: true,
        },
        'hrtyy45t'
      );
      console.log('initSDK success');
    } catch (error) {
      console.log('initSDK error');
    }
  };

  const iosLogin = async () => {
    try {
      await OpenIMSDKRN.login(  
        {
          userID: '3742375535',
          token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiIzNzQyMzc1NTM1IiwiUGxhdGZvcm1JRCI6MSwiZXhwIjoxNzE3NTY4ODQyLCJuYmYiOjE3MDk3OTI1NDIsImlhdCI6MTcwOTc5Mjg0Mn0.xPPgeXysWhqnvp5Xk5qFERqRRuPLTCq7kDP0wPElu9I',
        },
        'hrtyy45t'
      );
      console.log(await OpenIMSDKRN.getLoginStatus('hrtyy45t'));
    } catch (error) {
      console.error('login error', error);
    }
  };

  const androidLogin = async () => {
    try {
      await OpenIMSDKRN.login(
        {
          userID: '3742375535',
          token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiIzNzQyMzc1NTM1IiwiUGxhdGZvcm1JRCI6MiwiZXhwIjoxNzE3NjYwODg1LCJuYmYiOjE3MDk4ODQ1ODUsImlhdCI6MTcwOTg4NDg4NX0.0yPd2G78HLsvAldMHPLancm4BTMfefOItUwLqYmJxu8',
        },
        'hrtyy45t'
      );
      console.log(await OpenIMSDKRN.getLoginStatus('hrtyy45t'));
    } catch (error) {
      console.error('login error', error);
    }
  };

  const sendTextMsg = async () => {
    try {
      const message = await OpenIMSDKRN.createTextMessage(
        'sendTextMsg',
        'hrtyy45t'
      );
      console.info('createTextMessage', typeof message, message);
      await sendMsg(message);
    } catch (error) {
      console.error('Error createCardMessage:', error);
    }
  };

  const sendCardMsg = async () => {
    try {
      const message = await OpenIMSDKRN.createCardMessage(
        {
          userID: '6265276311',
          nickname: 'kevin1',
          faceURL: '',
          ex: '',
        },
        'hrtyy45t'
      );
      console.info('createCardMessage', message);
      await sendMsg(message);
    } catch (error) {
      console.error('Error createCardMessage:', error);
    }
  };

  const sendLocationMsg = async () => {
    try {
      const message = await OpenIMSDKRN.createLocationMessage(
        {
          description: 'location',
          longitude: 22.2,
          latitude: 33.3,
        },
        'hrtyy45t'
      );
      console.info('createLocationMessage', message);
      await sendMsg(message);
    } catch (error) {
      console.error('Error createLocationMessage:', error);
    }
  };

  const sendGroupMsg = async (message: MessageItem) => {
    try {
      const res = await OpenIMSDKRN.sendMessage(
        {
          recvID: '',
          groupID: '1944501993',
          message,
        },
        'hrtyy45t'
      );
      console.info('sendGroupMsg', typeof res, res);
    } catch (error) {
      console.error('Error sendGroupMsg:', error);
    }
  };

  const sendMsg = async (message: MessageItem) => {
    try {
      const res = await OpenIMSDKRN.sendMessage(
        {
          recvID: '6265276311',
          groupID: '',
          message,
        },
        'hrtyy45t'
      );
      console.info('sendMessage', typeof res, res);
    } catch (error) {
      console.error('Error sendMsg:', error);
    }
  };

  const getMessageList = async () => {
    const { messageList } = await OpenIMSDKRN.getAdvancedHistoryMessageList(
      {
        lastMinSeq: 0,
        count: 20,
        startClientMsgID: '',
        conversationID: 'si_3742375535_6265276311',
      },
      'hrtyy45t'
    );
    console.info('getAdvancedHistoryMessageList', messageList);
  };

  const getConversationListSplit = async () => {
    try {
      const res = await OpenIMSDKRN.getConversationListSplit(
        {
          offset: 0,
          count: 10,
        },
        'hrtyy45t'
      );
      console.info('getConversationListSplit', res);
    } catch (error) {
      console.error('Error getConversationListSplit:', error);
    }
  };

  const getConversationIDBySessionType = async () => {
    try {
      const res = await OpenIMSDKRN.getConversationIDBySessionType(
        {
          sourceID: '3742375535',
          sessionType: 3,
        },
        'hrtyy45t'
      );
      console.info('getConversationIDBySessionType', res);
    } catch (error) {
      console.error('Error getConversationIDBySessionType:', error);
    }
  };

  const getUserInfo = async () => {
    try {
      const data = await OpenIMSDKRN.getSelfUserInfo('operationID');
      console.log('getSelfUserInfo', data);
    } catch (error) {
      console.error('Error getSelfUserInfo', error);
    }
  };

  const updateInfo = async () => {
    try {
      await OpenIMSDKRN.setSelfInfo(
        {
          nickname: 'k0',
          faceURL: '',
          ex: '',
        },
        'hrtyy45t'
      );
      console.info('setSelfInfo');
    } catch (error) {
      console.error('Error getConversationListSplit:', error);
    }
  };

  const at = async () => {
    try {
      const message = await OpenIMSDKRN.createTextAtMessage(
        {
          text: '123 @6265276311 123',
          atUserIDList: ['6265276311'],
          atUsersInfo: [
            {
              atUserID: '6265276311',
              groupNickname: 'kevin1',
            },
          ],
        },
        'hrtyy45t'
      );
      console.info('createTextAtMessage', typeof message, message);
      await sendGroupMsg(message);
    } catch (error) {
      console.error('Error createTextAtMessage:', error);
    }
  };

  const joinGroup = async () => {
    try {
      await OpenIMSDKRN.joinGroup(
        {
          groupID: '2602656113',
          reqMsg: 'join',
          joinSource: 2,
        },
        'hrtyy45t'
      );
      console.info('joinGroup');
    } catch (error) {
      console.error('Error joinGroup');
    }
  };

  const pinConversation = async (isPinned: boolean) => {
    OpenIMSDKRN.setConversationBurnDuration;
    try {
      await OpenIMSDKRN.pinConversation(
        {
          conversationID: 'si_3742375535_6265276311',
          isPinned,
        },
        'hrtyy45t'
      );
      console.info('pinConversation');
    } catch (error) {
      console.error('Error pinConversation');
    }
  };

  OpenIMEmitter.addListener('onConnecting', () => {
    console.warn('onConnecting');
  });

  OpenIMEmitter.addListener('onConnectSuccess', () => {
    console.warn('onConnectSuccess');
  });

  OpenIMEmitter.addListener('onConnectFailed', (res) => {
    console.warn('onConnectFailed', res);
  });

  OpenIMEmitter.addListener('onUserTokenExpired', () => {
    console.warn('onUserTokenExpired');
  });

  OpenIMEmitter.addListener('onRecvNewMessages', (data: MessageItem[]) => {
    console.warn('onRecvNewMessages', data);
  });

  OpenIMEmitter.addListener('onSelfInfoUpdated', (data) => {
    console.warn('onSelfInfoUpdated', data);
  });

  OpenIMEmitter.addListener('onConversationChanged', (res) => {
    console.warn('onConversationChanged', typeof res, res);
  });

  return (
    <View style={styles.container}>
      <Button title="init" onPress={init} />
      <Button title="iosLogin" onPress={iosLogin} />
      <Button title="androidLogin" onPress={androidLogin} />
      <Button title="sendTextMsg" onPress={sendTextMsg} />
      <Button title="sendCardMsg" onPress={sendCardMsg} />
      <Button title="getMessageList" onPress={getMessageList} />
      <Button
        title="getConversationListSplit"
        onPress={getConversationListSplit}
      />
      <Button title="getUserInfo" onPress={getUserInfo} />
      <Button title="updateInfo" onPress={updateInfo} />
      <Button title="at" onPress={at} />
      <Button title="sendLocationMsg" onPress={sendLocationMsg} />
      <Button
        title="getConversationIDBySessionType"
        onPress={getConversationIDBySessionType}
      />
      <Button title="joinGroup" onPress={joinGroup} />
      <Button title="pinConversation" onPress={() => pinConversation(true)} />
      <Button
        title="dePinConversation"
        onPress={() => pinConversation(false)}
      />
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

export default App;
