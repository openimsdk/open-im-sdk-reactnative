import React, { useState, useRef } from 'react';
import OpenIMSDKRN, { OpenIMEmitter } from '@openim/rn-client-sdk';
import RNFS from 'react-native-fs';
import { Button, StyleSheet, View, ScrollView, Text, Platform } from 'react-native';
import { MessageItem } from 'src/types/entity';
import { GroupAtType, MessageReceiveOptType, ViewType } from 'src/types/enum';

function App(): React.JSX.Element {
  RNFS.mkdir(RNFS.DocumentDirectoryPath + '/tmp');
  const [logs, setLogs] = useState<string[]>([]);
  const scrollViewRef = useRef<ScrollView>(null);

  // 添加日志的辅助函数
  const addLog = (type: string, ...args: any[]) => {
    const timestamp = new Date().toLocaleTimeString();
    const message = args.map(arg => 
      typeof arg === 'object' ? JSON.stringify(arg, null, 2) : String(arg)
    ).join(' ');
    const logEntry = `[${timestamp}] [${type}] ${message}`;
    
    setLogs(prev => [...prev, logEntry]);

    // 同时输出到控制台
    if (type === 'ERROR') {
      console.error(...args);
    } else if (type === 'WARN') {
      console.warn(...args);
    } else if (type === 'INFO') {
      console.info(...args);
    } else {
      console.log(...args);
    }
  };

  const clearLogs = () => {
    setLogs([]);
  };
  const init = async () => {
    const apiAddr = Platform.OS === 'android' ? 'http://10.0.2.2:10002' : 'http://127.0.0.1:10002';
    const wsAddr = Platform.OS === 'android' ? 'ws://10.0.2.2:10001' : 'ws://127.0.0.1:10001';
    try {
      await OpenIMSDKRN.initSDK(
        {
          apiAddr,
          wsAddr,
          dataDir: RNFS.DocumentDirectoryPath + '/tmp',
          logFilePath: RNFS.DocumentDirectoryPath + '/tmp',
          logLevel: 5,
          isLogStandardOutput: true,
        },
        '34567'
      );
      addLog('LOG', 'initSDK success');
    } catch (error) {
      addLog('ERROR', 'initSDK error', error);
    }
  };

  const iosLogin = async () => {
    try {
      await OpenIMSDKRN.login(
        {
          userID: '11111112',
          token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiIxMTExMTExMiIsIlBsYXRmb3JtSUQiOjEsImV4cCI6MTc2ODc5OTYzMSwiaWF0IjoxNzYxMDIzNjI2fQ.NN9rlojfv6oMeW74x_hcNoI-DjiKltWfNFP1lxKd578'
        },
        '648468'
      );
      const status = await OpenIMSDKRN.getLoginStatus('778w');
      addLog('LOG', 'iosLogin status:', status);
    } catch (error) {
      addLog('ERROR', 'login error', error);
    }
  };

  const androidLogin = async () => {
    try {
      await OpenIMSDKRN.login(
        {
          userID: '1',
          token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiIxIiwiUGxhdGZvcm1JRCI6MiwiZXhwIjoxNzY4OTY0MDE5LCJpYXQiOjE3NjExODgwMTR9.L1TDkObGNoQfhA7ml16CxbayyY3b9e9FnNVDrRU-YKI'
        },
        new Date().getTime().toString()
      );
      const status = await OpenIMSDKRN.getLoginStatus('234243');
      addLog('LOG', 'androidLogin status:', status);
    } catch (error) {
      addLog('ERROR', 'login error', error);
    }
  };

  const logout = async () => {
    try {
      await OpenIMSDKRN.logout('811312');
      addLog('LOG', 'logout success');
    } catch (error) {
      addLog('ERROR', 'logout error', error);
    }
  };

  const getSpecificFriendInfo = async () => {
    try {
      const res = await OpenIMSDKRN.getSpecifiedFriendsInfo(
        {
          userIDList: ['123'],
        },
        'hrtyy45t'
      );
      addLog('INFO', 'getSpecificFriendInfo', res);
    } catch (error) {
      addLog('ERROR', 'Error getSpecificFriendInfo:', error);
    }
  };

  const sendTextMsg = async () => {
    try {
      const message = await OpenIMSDKRN.createTextMessage(
        'sendTextMsg',
        'hrtyy45t'
      );
      addLog('INFO', 'createTextMessage', typeof message, message);
      await sendMsg(message);
      addLog('INFO', 'sendTextMsg success');
    } catch (error) {
      addLog('ERROR', 'Error createTextMessage:', error);
    }
  };

  const sendCardMsg = async () => {
    try {
      const message = await OpenIMSDKRN.createCardMessage(
        {
          userID: '123',
          nickname: 'kevin1',
          faceURL: '',
          ex: '',
        },
        'hrtyy45t'
      );
      addLog('INFO', 'createCardMessage', message);
      await sendMsg(message);
    } catch (error) {
      addLog('ERROR', 'Error createCardMessage:', error);
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
      addLog('INFO', 'createLocationMessage', message);
      // await sendMsg(message);
    } catch (error) {
      addLog('ERROR', 'Error createLocationMessage:', error);
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
      addLog('INFO', 'sendGroupMsg', typeof res, res);
    } catch (error) {
      addLog('ERROR', 'Error sendGroupMsg:', error);
    }
  };

  const sendMsg = async (message: MessageItem) => {
    try {
      const res = await OpenIMSDKRN.sendMessage(
        {
          recvID: '123',
          groupID: '',
          message,
        },
        'hrtyy45t'
      );
      addLog('INFO', 'sendMessage', typeof res, res);
    } catch (error) {
      addLog('ERROR', 'Error sendMsg:', error);
    }
  };

  const getMessageList = async () => {
    const { messageList } = await OpenIMSDKRN.getAdvancedHistoryMessageList(
      {
        count: 20,
        startClientMsgID: '',
        // conversationID: 'si_11111112_123',
        conversationID: 'si_1_123',
        viewType: ViewType.History,
      },
      'hrtyy45t'
    );
    addLog('INFO', 'getAdvancedHistoryMessageList', messageList);
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
      addLog('INFO', 'getConversationListSplit', res);
    } catch (error) {
      addLog('ERROR', 'Error getConversationListSplit:', error);
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
      addLog('INFO', 'getConversationIDBySessionType', res);
    } catch (error) {
      addLog('ERROR', 'Error getConversationIDBySessionType:', error);
    }
  };

  const getUserInfo = async () => {
    try {
      const data = await OpenIMSDKRN.getSelfUserInfo('operationID');
      addLog('LOG', 'getSelfUserInfo', data);
    } catch (error) {
      addLog('ERROR', 'Error getSelfUserInfo', error);
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
      addLog('INFO', 'setSelfInfo');
    } catch (error) {
      addLog('ERROR', 'Error setSelfInfo:', error);
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
      addLog('INFO', 'createTextAtMessage', typeof message, message);
      await sendGroupMsg(message);
    } catch (error) {
      addLog('ERROR', 'Error createTextAtMessage:', error);
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
      addLog('INFO', 'joinGroup');
    } catch (error) {
      addLog('ERROR', 'Error joinGroup', error);
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
      addLog('INFO', 'pinConversation');
    } catch (error) {
      addLog('ERROR', 'Error pinConversation', error);
    }
  };

  OpenIMEmitter.addListener('onConnecting', () => {
    addLog('WARN', 'onConnecting');
  });

  OpenIMEmitter.addListener('onConnectSuccess', () => {
    addLog('WARN', 'onConnectSuccess');
  });

  OpenIMEmitter.addListener('onConnectFailed', (res) => {
    addLog('WARN', 'onConnectFailed', res);
  });

  OpenIMEmitter.addListener('onUserTokenExpired', () => {
    addLog('WARN', 'onUserTokenExpired');
  });

  OpenIMEmitter.addListener('onRecvNewMessages', (data: MessageItem[]) => {
    addLog('WARN', 'onRecvNewMessages', data);
  });

  OpenIMEmitter.addListener('onSelfInfoUpdated', (data) => {
    addLog('WARN', 'onSelfInfoUpdated', data);
  });

  // OpenIMEmitter.addListener('onConversationChanged', (res) => {
  //   addLog('WARN', 'onConversationChanged', typeof res, res);
  // });

  const createQuoteMessage = async () => {
    const res = await OpenIMSDKRN.getAdvancedHistoryMessageList(
      {
        count: 1,
        startClientMsgID: '',
        conversationID: 'si_11111112_123',
        // conversationID: 'si_1_123',
        viewType: ViewType.History,
      },
      'hrtyy45t'
    );
    try {
      const message = await OpenIMSDKRN.createQuoteMessage(
        {
          text: 'createQuoteMessage test',
          message: res.messageList[0] as MessageItem,
        },
        '3412'
      );
      addLog('INFO', 'createQuoteMessage', typeof message, message);
    }
    catch (error) {
      addLog('ERROR', 'Error createQuoteMessage:', error);
    }
  };

  // const getGroupApplicationListAsApplicant = async () => {
  //   try {
  //     const res = await OpenIMSDKRN.getGroupApplicationListAsApplicant(
  //       'hrtyy45t',
  //       {
  //         groupIDs: ['1944501993'],
  //         handleResults: [323424],
  //         offset: 0,
  //         count: 10,
  //       },
  //     );
  //     addLog('INFO', 'getGroupApplicationListAsApplicant', res);
  //   } catch (error) {
  //     addLog('ERROR', 'Error getGroupApplicationListAsApplicant:', error);
  //   }
  // };

  // const getGroupApplicationListAsRecipient = async () => {
  //   try {
  //     const res = await OpenIMSDKRN.getGroupApplicationListAsRecipient(
  //       'hrtyy45t',
  //       {
  //         groupIDs: ["23423"],
  //         handleResults: [153131],
  //         offset: 0,
  //         count: 10,
  //       }
  //     );
  //     addLog('INFO', 'getGroupApplicationListAsRecipient', res);
  //   } catch (error) {
  //     addLog('ERROR', 'Error getGroupApplicationListAsRecipient:', error);
  //   }
  // };

  // const getFriendApplicationListAsApplicant = async () => {
  //   try {
  //     const res = await OpenIMSDKRN.getFriendApplicationListAsApplicant(
  //       'hrtyy45t',
  //       {
  //         offset: 0,
  //         count: 10,
  //       }
  //     );
  //     addLog('INFO', 'getFriendApplicationListAsApplicant', res);
  //   } catch (error) {
  //     addLog('ERROR', 'Error getFriendApplicationListAsApplicant:', error);
  //   }
  // };

  // const getFriendApplicationListAsRecipient = async () => {
  //   try {
  //     const res = await OpenIMSDKRN.getFriendApplicationListAsRecipient(
  //       'hrtyy45t',
  //       {
  //         handleResults: [2132],
  //         offset: 0,
  //         count: 10,
  //       }
  //     );
  //     addLog('INFO', 'getFriendApplicationListAsRecipient', res);
  //   } catch (error) {
  //     addLog('ERROR', 'Error getFriendApplicationListAsRecipient:', error);
  //   }
  // };


  const setConversation = async () => {
    try {
      await OpenIMSDKRN.setConversation({
        conversationID: 'si_1_123',
        recvMsgOpt: MessageReceiveOptType.Normal,
        groupAtType: GroupAtType.AtNormal,
        burnDuration: 0,
        msgDestructTime: 0,
        isPinned: false,
        isPrivateChat: false,
        isMsgDestruct: false,
        ex: '{}',
      }, 'hrtyy45t');
    }
    catch (error) {
      addLog('ERROR', 'Error setConversation:', error);
    }
  };

  const createFileMessageFromFullPath = async () => {
    const filePath = RNFS.DocumentDirectoryPath + '/tmp/file.txt';
    RNFS.writeFile(filePath, 'Hello, world!', 'utf8');
    try {
      const message = await OpenIMSDKRN.createFileMessageFromFullPath(
        {
          filePath: filePath,
          fileName: 'file.txt',
        },
        'hrtyy45t'
      );
      addLog('INFO', 'createFileMessageFromFullPath', typeof message, message);
    }
    catch (error) {
      addLog('ERROR', 'Error createFileMessageFromFullPath:', error);
    }
  };

  const changeGroupMemberMute = async () => {
    try {
      await OpenIMSDKRN.changeGroupMemberMute(
        {
          groupID: '1944501993',
          userID: '123',
          mutedSeconds: 1000,
        },
        'hrtyy45t'
      );
      addLog('INFO', 'changeGroupMemberMute');
    }
    catch (error) {
      addLog('ERROR', 'Error changeGroupMemberMute:', error);
    }
  };

  const isJoinGroup = async () => {
    try {
      const res = await OpenIMSDKRN.isJoinGroup('1944501993', 'hrtyy45t');
      addLog('INFO', 'isJoinGroup', res);
    }
    catch (error) {
      addLog('ERROR', 'Error isJoinGroup:', error);
    }
  };

  const setAppBadge = async () => {
    try {
      await OpenIMSDKRN.setAppBadge(100, 'hrtyy45t');
      addLog('INFO', 'setAppBadge');
    }
    catch (error) {
      addLog('ERROR', 'Error setAppBadge:', error);
    }
  };

  const updateFcmToken = async () => {
    try {
      await OpenIMSDKRN.updateFcmToken('fcmToken', 1000, 'hrtyy45t');
      addLog('INFO', 'updateFcmToken');
    }
    catch (error) {
      addLog('ERROR', 'Error updateFcmToken:', error);
    }
  };

  const uploadLogs = async () => {
    addLog("1057")
    try {
      await OpenIMSDKRN.uploadLogs({ line: 1 }, 'hrtyy45t');
      addLog('INFO', 'uploadLogs');
    } catch (error) {
      addLog('ERROR', 'Error uploadLogs:', error);
    }
  };

  const logsFunc = async () => {
    try {
      const keyAndValue: string[] = ['abc', '2132'];
      await OpenIMSDKRN.logs({ logLevel: 5, file: '{"abc": 4}', line: 1, msgs: '{"abc": 3}', err: '{"abc": 2}', keyAndValue: keyAndValue }, 'hrtyy45t');
      addLog('INFO', 'logs');
    } catch (error) {
      addLog('ERROR', 'Error logs:', error);
    }
  };

  const unInitSDK = async () => {
    try {
      OpenIMSDKRN.unInitSDK('hrtyy45t').then(() => {
        addLog('INFO', 'unInitSDK success');
      }).catch((error) => {
        addLog('ERROR', 'Error unInitSDK:', error);
      });
      addLog('INFO', 'unInitSDK');
    } catch (error) {
      addLog('ERROR', 'Error unInitSDK:', error);
    }
  };

  const getFriendApplicationUnhandledCount = async () => {
    try {
      const res = await OpenIMSDKRN.getFriendApplicationUnhandledCount({
        time: 0,
      }, 'hrtyy45t');
      addLog('INFO', 'getFriendApplicationUnhandledCount', res);
    } catch (error) {
      addLog('ERROR', 'Error getFriendApplicationUnhandledCount:', error);
    }
  };

  const getGroupApplicationUnhandledCount = async () => {
    try {
      const res = await OpenIMSDKRN.getGroupApplicationUnhandledCount({
        time: 0,
      }, 'hrtyy45t');
      addLog('INFO', 'getGroupApplicationUnhandledCount', res);
    } catch (error) {
      addLog('ERROR', 'Error getGroupApplicationUnhandledCount:', error);
    }
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.buttonsContainer} horizontal={false}>
        <Button title="清除日志" onPress={clearLogs} color="red" />
        <Button title="init" onPress={init} />
        <Button title="iosLogin" onPress={iosLogin} />
        <Button title="androidLogin" onPress={androidLogin} />
        <Button title="logout" onPress={logout} />
        <Button title='getFriendApplicationUnhandledCount' onPress={getFriendApplicationUnhandledCount} />
        <Button title='getGroupApplicationUnhandledCount' onPress={getGroupApplicationUnhandledCount} />
        <Button title='uploadLogs' onPress={uploadLogs} />
        <Button title='logs' onPress={logsFunc} />
        <Button title='unInitSDK' onPress={unInitSDK} />
        <Button title='updateFcmToken' onPress={updateFcmToken} />
        <Button title='setAppBadge' onPress={setAppBadge} />
        <Button title="isJoinGroup" onPress={isJoinGroup} />
        <Button title="changeGroupMemberMute" onPress={changeGroupMemberMute} />
        <Button title="createFileMessageFromFullPath" onPress={createFileMessageFromFullPath} />
        <Button title="setConversation" onPress={setConversation} />
        {/* <Button title="getGroupApplicationListAsApplicant" onPress={getGroupApplicationListAsApplicant} />
        <Button title="getGroupApplicationListAsRecipient" onPress={getGroupApplicationListAsRecipient} />
        <Button title="getFriendApplicationListAsApplicant" onPress={getFriendApplicationListAsApplicant} />
        <Button title="getFriendApplicationListAsRecipient" onPress={getFriendApplicationListAsRecipient} /> */}
        <Button title="createQuoteMessage" onPress={createQuoteMessage} />
        <Button title="sendTextMsg" onPress={sendTextMsg} />
        <Button title="sendCardMsg" onPress={sendCardMsg} />
        <Button title="getSpecificFriendInfo" onPress={getSpecificFriendInfo} />
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
      </ScrollView>
      
      <View style={styles.logContainer}>
        <Text style={styles.logTitle}>调试日志：</Text>
        <ScrollView 
          ref={scrollViewRef}
          style={styles.logScrollView}
          onContentSizeChange={() => scrollViewRef.current?.scrollToEnd({ animated: true })}
        >
          {logs.map((log, index) => (
            <Text key={index} style={styles.logText} selectable>
              {log}
            </Text>
          ))}
          {logs.length === 0 && (
            <Text style={styles.emptyLogText}>暂无日志</Text>
          )}
        </ScrollView>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 50,
    backgroundColor: '#f5f5f5',
  },
  buttonsContainer: {
    flex: 1,
    maxHeight: 250,
    paddingHorizontal: 10,
  },
  logContainer: {
    flex: 1,
    backgroundColor: '#1e1e1e',
    margin: 10,
    borderRadius: 8,
    padding: 10,
  },
  logTitle: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  logScrollView: {
    flex: 1,
  },
  logText: {
    color: '#e0e0e0',
    fontSize: 14,
    fontFamily: 'monospace',
    marginBottom: 5,
    lineHeight: 18,
  },
  emptyLogText: {
    color: '#888888',
    fontSize: 14,
    textAlign: 'center',
    marginTop: 20,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

export default App;
