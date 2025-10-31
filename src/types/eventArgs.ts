import { OpenIMEventBaseErrorType } from 'src/errors/OpenIMEventError';
import { OpenIMEvent, OpenIMEventName } from '../constants/OpenIMEvents';
import {
  BlackUserItem,
  ConversationInputStatus,
  ConversationItem,
  FriendApplicationItem,
  FriendUserItem,
  GroupApplicationItem,
  GroupItem,
  GroupMemberItem,
  MessageItem,
  ReceiptInfo,
  RevokedInfo,
  SelfUserInfo,
  UserOnlineState,
} from './entity';

/**
 * Event callback argument type map
 *
 * - Key: event name
 * - Value: tuple of callback parameter types
 *
 * #### Examples:
 * 
 * For `[OpenIMEvent.OnConnectSuccess]: []`
 * the generated listener signature is:
 * ```
 * OpenIMSDK.on(OpenIMEvent.OnConnectSuccess, () => {})
 * ```
 *
 * For `[OpenIMEvent.OnSelfInfoUpdated]: [selfUserInfo: SelfUserInfo]`
 * the generated listener signature is:
 * ```
 * OpenIMSDK.on(OpenIMEvent.OnSelfInfoUpdated, (selfUserInfo: SelfUserInfo) => {})
 * ```
 */
export type EventCallbackArgsMap = {
  [OpenIMEvent.OnConnectSuccess]: [];
  [OpenIMEvent.OnConnecting]: [];
  [OpenIMEvent.OnConnectFailed]: [error: OpenIMEventBaseErrorType];
  [OpenIMEvent.OnKickedOffline]: [];
  [OpenIMEvent.OnSelfInfoUpdated]: [selfUserInfo: SelfUserInfo];
  [OpenIMEvent.OnUserStatusChanged]: [userStatus: UserOnlineState];
  [OpenIMEvent.OnUserTokenExpired]: [];
  [OpenIMEvent.OnUserTokenInvalid]: [];

  [OpenIMEvent.OnRecvNewMessage]: [message: MessageItem];
  [OpenIMEvent.OnRecvNewMessages]: [messages: MessageItem[]];
  [OpenIMEvent.OnRecvOfflineNewMessage]: [message: MessageItem];
  [OpenIMEvent.OnRecvOnlineOnlyMessage]: [message: MessageItem];
  [OpenIMEvent.OnRecvOfflineNewMessages]: [messages: MessageItem[]];
  [OpenIMEvent.OnMsgDeleted]: [message: MessageItem]; // FIXME: Type may be inaccurate, Golang core returns LocalChatLog type which has fewer properties than MessageItem here
  [OpenIMEvent.OnRecvC2CReadReceipt]: [receipts: ReceiptInfo[]];
  [OpenIMEvent.OnNewRecvMessageRevoked]: [revokedInfo: RevokedInfo];

  [OpenIMEvent.OnConversationChanged]: [conversations: ConversationItem[]];
  [OpenIMEvent.OnInputStatusChanged]: [inputStatus: ConversationInputStatus];
  [OpenIMEvent.OnNewConversation]: [conversations: ConversationItem[]];
  [OpenIMEvent.OnSyncServerFailed]: [];
  [OpenIMEvent.OnSyncServerFinish]: [];
  [OpenIMEvent.OnSyncServerStart]: [isSyncing: boolean];
  [OpenIMEvent.OnSyncServerProgress]: [progress: number];
  [OpenIMEvent.OnTotalUnreadMessageCountChanged]: [totalUnread: number];

  [OpenIMEvent.OnBlackAdded]: [blackUser: BlackUserItem];
  [OpenIMEvent.OnBlackDeleted]: [blackUser: BlackUserItem];
  [OpenIMEvent.OnFriendApplicationAccepted]: [application: FriendApplicationItem];
  [OpenIMEvent.OnFriendApplicationAdded]: [application: FriendApplicationItem];
  [OpenIMEvent.OnFriendApplicationDeleted]: [application: FriendApplicationItem];
  [OpenIMEvent.OnFriendApplicationRejected]: [application: FriendApplicationItem];
  [OpenIMEvent.OnFriendInfoChanged]: [friend: FriendUserItem];
  [OpenIMEvent.OnFriendAdded]: [friend: FriendUserItem];
  [OpenIMEvent.OnFriendDeleted]: [friend: FriendUserItem];

  [OpenIMEvent.OnGroupApplicationAccepted]: [application: GroupApplicationItem];
  [OpenIMEvent.OnGroupApplicationRejected]: [application: GroupApplicationItem];
  [OpenIMEvent.OnGroupApplicationAdded]: [application: GroupApplicationItem];
  [OpenIMEvent.OnGroupApplicationDeleted]: [application: GroupApplicationItem];
  [OpenIMEvent.OnGroupInfoChanged]: [group: GroupItem];
  [OpenIMEvent.OnGroupMemberInfoChanged]: [member: GroupMemberItem];
  [OpenIMEvent.OnGroupMemberAdded]: [member: GroupMemberItem];
  [OpenIMEvent.OnGroupMemberDeleted]: [member: GroupMemberItem];
  [OpenIMEvent.OnJoinedGroupAdded]: [group: GroupItem];
  [OpenIMEvent.OnJoinedGroupDeleted]: [group: GroupItem];
  [OpenIMEvent.OnGroupDismissed]: [group: GroupItem];
  [OpenIMEvent.SendMessageProgress]: [info: { progress: number; message: MessageItem }];
  [OpenIMEvent.UploadComplete]: [payload: { data: { fileSize: number; streamSize: number; storageSize: number; operationID: string } }];
  [OpenIMEvent.OnRecvCustomBusinessMessage]: [data: any]; // FIXME: Type is unknown.
  [OpenIMEvent.UploadOnProgress]: [payload: { current: number; size: number, operationID: string }];
};

export type ArgsOfEvent<E extends OpenIMEventName> = E extends keyof EventCallbackArgsMap
  ? EventCallbackArgsMap[E]
  : never;
