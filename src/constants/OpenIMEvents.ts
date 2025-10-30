export const OpenIMEvent = {
  OnConnectSuccess: 'onConnectSuccess',
  OnConnecting: 'onConnecting',
  OnConnectFailed: 'onConnectFailed',
  OnKickedOffline: 'onKickedOffline',
  OnSelfInfoUpdated: 'onSelfInfoUpdated',
  OnUserStatusChanged: 'onUserStatusChanged',
  OnUserTokenExpired: 'onUserTokenExpired',
  OnUserTokenInvalid: 'onUserTokenInvalid',

  OnRecvNewMessage: 'onRecvNewMessage',
  OnRecvNewMessages: 'onRecvNewMessages',
  OnRecvOfflineNewMessage: 'onRecvOfflineNewMessage',
  OnRecvOnlineOnlyMessage: 'onRecvOnlineOnlyMessage',
  OnRecvOfflineNewMessages: 'onRecvOfflineNewMessages',
  OnMsgDeleted: 'onMsgDeleted',
  OnRecvC2CReadReceipt: 'onRecvC2CReadReceipt',
  OnNewRecvMessageRevoked: 'onNewRecvMessageRevoked',
  // OnRecvMessageRevoked: 'onRecvMessageRevoked', // iOS only
  // OnRecvMessageExtensionsAdded: 'onRecvMessageExtensionsAdded', // iOS only
  // OnRecvMessageExtensionsChanged: 'onRecvMessageExtensionsChanged', // iOS only
  // OnRecvMessageExtensionsDeleted: 'onRecvMessageExtensionsDeleted', // iOS only

  OnConversationChanged: 'onConversationChanged',
  OnInputStatusChanged: 'onInputStatusChanged',
  OnNewConversation: 'onNewConversation',
  OnSyncServerFailed: 'onSyncServerFailed',
  OnSyncServerFinish: 'onSyncServerFinish',
  OnSyncServerStart: 'onSyncServerStart',
  OnSyncServerProgress: 'onSyncServerProgress',
  OnTotalUnreadMessageCountChanged: 'onTotalUnreadMessageCountChanged',

  OnBlackAdded: 'onBlackAdded',
  OnBlackDeleted: 'onBlackDeleted',
  OnFriendApplicationAccepted: 'onFriendApplicationAccepted',
  OnFriendApplicationAdded: 'onFriendApplicationAdded',
  OnFriendApplicationDeleted: 'onFriendApplicationDeleted',
  OnFriendApplicationRejected: 'onFriendApplicationRejected',
  OnFriendInfoChanged: 'onFriendInfoChanged',
  OnFriendAdded: 'onFriendAdded',
  OnFriendDeleted: 'onFriendDeleted',

  OnGroupApplicationAccepted: 'onGroupApplicationAccepted',
  OnGroupApplicationRejected: 'onGroupApplicationRejected',
  OnGroupApplicationAdded: 'onGroupApplicationAdded',
  OnGroupApplicationDeleted: 'onGroupApplicationDeleted',
  OnGroupInfoChanged: 'onGroupInfoChanged',
  OnGroupMemberInfoChanged: 'onGroupMemberInfoChanged',
  OnGroupMemberAdded: 'onGroupMemberAdded',
  OnGroupMemberDeleted: 'onGroupMemberDeleted',
  OnJoinedGroupAdded: 'onJoinedGroupAdded',
  OnJoinedGroupDeleted: 'onJoinedGroupDeleted',
  OnGroupDismissed: 'onGroupDismissed',
  SendMessageProgress: 'SendMessageProgress',
  UploadComplete: 'uploadComplete',
  OnRecvCustomBusinessMessage: 'onRecvCustomBusinessMessage',
  UploadOnProgress: 'uploadOnProgress',
  // OnReceiveNewMessages: 'onReceiveNewMessages', // iOS only
  // OnReceiveOfflineNewMessages: 'onReceiveOfflineNewMessages', // iOS only
} as const;

export type OpenIMEventName = typeof OpenIMEvent[keyof typeof OpenIMEvent];
