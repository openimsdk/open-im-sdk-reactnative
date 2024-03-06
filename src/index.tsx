import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
import {
  SelfUserInfo,
  FullUserItemWithCache,
  UserOnlineState,
  BlackUserItem,
  FriendApplicationItem,
  FriendshipInfo,
  FullUserItem,
  SearchedFriendsInfo,
  GroupApplicationItem,
  GroupItem,
  GroupMemberItem,
  ConversationItem,
  AdvancedGetMessageResult,
  CardElem,
  MessageItem,
  SearchMessageResult,
} from './types/entity';
import { LoginStatus, MessageReceiveOptType } from './types/enum';
import {
  AccessFriendParams,
  AccessGroupParams,
  AddBlackParams,
  AtMsgParams,
  ChangeGroupMemberMuteParams,
  ChangeGroupMuteParams,
  CreateGroupParams,
  CustomMsgParams,
  FaceMessageParams,
  FileMsgParams,
  FindMessageParams,
  GetAdvancedHistoryMsgParams,
  GetGroupMemberByTimeParams,
  GetOneConversationParams,
  GetUserInfoWithCacheParams,
  ImageMsgParams,
  InitOptions,
  InsertGroupMsgParams,
  InsertSingleMsgParams,
  JoinGroupParams,
  LocationMsgParams,
  LoginParams,
  MergerMsgParams,
  OpreateGroupParams,
  OpreateMessageParams,
  PinConversationParams,
  QuoteMsgParams,
  RemarkFriendParams,
  SearchFriendParams,
  SearchGroupMemberParams,
  SearchGroupParams,
  SearchLocalParams,
  SendMsgParams,
  SetBurnDurationParams,
  SetConversationDraftParams,
  SetConversationPrivateParams,
  SetConversationRecvOptParams,
  SetGroupinfoParams,
  SetMessageLocalExParams,
  SoundMsgParams,
  SplitConversationParams,
  TransferGroupParams,
  TypingUpdateParams,
  UpdateMemberInfoParams,
  UploadFileParams,
  VideoMsgParams,
  getGroupMembersInfoParams,
} from './types/params';

const LINKING_ERROR =
  `The package 'open-im-sdk-rn' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const OpenIMSDKRN: OpenIMSDKRNInterface = NativeModules.OpenIMSDKRN
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

export default OpenIMSDKRN;

interface OpenIMSDKRNInterface {
  addListener: (eventType: string) => void;
  removeListeners: (count: number) => void;

  // login
  initSDK: (params: InitOptions, operationID?: string) => Promise<unknown>;
  login: (params: LoginParams, operationID?: string) => Promise<unknown>;
  logout: (operationID?: string) => Promise<unknown>;
  getLoginStatus: (operationID?: string) => Promise<LoginStatus>;
  getLoginUserID: (operationID?: string) => Promise<string>;
  uploadFile: (
    params: UploadFileParams,
    operationID?: string
  ) => Promise<{
    url: string;
  }>;

  // user
  getSelfUserInfo: (operationID?: string) => Promise<SelfUserInfo>;
  setSelfInfo: (
    params: Partial<SelfUserInfo>,
    operationID?: string
  ) => Promise<unknown>;
  getUsersInfoWithCache: (
    params: GetUserInfoWithCacheParams,
    operationID?: string
  ) => Promise<FullUserItemWithCache[]>;
  subscribeUsersStatus: (
    params: string[],
    operationID?: string
  ) => Promise<UserOnlineState>;
  unsubscribeUsersStatus: (
    params: string[],
    operationID?: string
  ) => Promise<unknown>;
  getSubscribeUsersStatus: (operationID?: string) => Promise<UserOnlineState[]>;
  setAppBackgroundStatus: (
    params: boolean,
    operationID?: string
  ) => Promise<unknown>;
  networkStatusChanged: (operationID?: string) => Promise<unknown>;
  setGlobalRecvMessageOpt: (
    params: MessageReceiveOptType,
    operationID?: string
  ) => Promise<unknown>;

  // friend relationShip
  acceptFriendApplication: (
    params: AccessFriendParams,
    operationID?: string
  ) => Promise<unknown>;
  addBlack: (params: AddBlackParams, operationID?: string) => Promise<unknown>;
  addFriend: (params: string, operationID?: string) => Promise<unknown>;
  checkFriend: (
    params: string[],
    operationID?: string
  ) => Promise<FriendshipInfo[]>;
  deleteFriend: (params: string, operationID?: string) => Promise<unknown>;
  getBlackList: (operationID?: string) => Promise<BlackUserItem[]>;
  getFriendApplicationListAsApplicant: (
    operationID?: string
  ) => Promise<FriendApplicationItem[]>;
  getFriendApplicationListAsRecipient: (
    operationID?: string
  ) => Promise<FriendApplicationItem[]>;
  getFriendList: (operationID?: string) => Promise<FullUserItem[]>;
  getSpecifiedFriendsInfo: (
    params: string[],
    operationID?: string
  ) => Promise<FullUserItem[]>;
  refuseFriendApplication: (
    params: AccessFriendParams,
    operationID?: string
  ) => Promise<unknown>;
  removeBlack: (params: string, operationID?: string) => Promise<unknown>;
  searchFriends: (
    params: SearchFriendParams,
    operationID?: string
  ) => Promise<SearchedFriendsInfo[]>;
  setFriendRemark: (
    params: RemarkFriendParams,
    operationID?: string
  ) => Promise<unknown>;

  // group
  createGroup: (
    params: CreateGroupParams,
    operationID?: string
  ) => Promise<GroupItem>;
  joinGroup: (
    params: JoinGroupParams,
    operationID?: string
  ) => Promise<unknown>;
  inviteUserToGroup: (
    params: OpreateGroupParams,
    operationID?: string
  ) => Promise<unknown>;
  getJoinedGroupList: (operationID?: string) => Promise<GroupItem[]>;
  searchGroups: (
    params: SearchGroupParams,
    operationID?: string
  ) => Promise<GroupItem[]>;
  getSpecifiedGroupsInfo: (
    params: string[],
    operationID?: string
  ) => Promise<GroupItem[]>;
  setGroupInfo: (
    params: SetGroupinfoParams,
    operationID?: string
  ) => Promise<unknown>;
  getGroupApplicationListAsRecipient: (
    operationID?: string
  ) => Promise<GroupApplicationItem[]>;
  getGroupApplicationListAsApplicant: (
    operationID?: string
  ) => Promise<GroupApplicationItem[]>;
  acceptGroupApplication: (
    params: AccessGroupParams,
    operationID?: string
  ) => Promise<unknown>;
  refuseGroupApplication: (
    params: AccessGroupParams,
    operationID?: string
  ) => Promise<unknown>;
  getGroupMemberList: (operationID?: string) => Promise<GroupMemberItem[]>;
  getSpecifiedGroupMembersInfo: (
    params: getGroupMembersInfoParams,
    operationID?: string
  ) => Promise<GroupMemberItem[]>;
  searchGroupMembers: (
    params: SearchGroupMemberParams,
    operationID?: string
  ) => Promise<GroupMemberItem[]>;
  setGroupMemberInfo: (
    params: UpdateMemberInfoParams,
    operationID?: string
  ) => Promise<unknown>;
  getGroupMemberOwnerAndAdmin: (
    params: string,
    operationID?: string
  ) => Promise<GroupMemberItem[]>;
  getGroupMemberListByJoinTimeFilter: (
    params: GetGroupMemberByTimeParams,
    operationID?: string
  ) => Promise<GroupMemberItem[]>;
  kickGroupMember: (
    params: OpreateGroupParams,
    operationID?: string
  ) => Promise<unknown>;
  changeGroupMemberMute: (
    params: ChangeGroupMemberMuteParams,
    operationID?: string
  ) => Promise<unknown>;
  changeGroupMute: (
    params: ChangeGroupMuteParams,
    operationID?: string
  ) => Promise<unknown>;
  transferGroupOwner: (
    params: TransferGroupParams,
    operationID?: string
  ) => Promise<unknown>;
  dismissGroup: (params: string, operationID?: string) => Promise<unknown>;
  quitGroup: (params: string, operationID?: string) => Promise<unknown>;

  // conversation & message
  getAllConversationList: (operationID?: string) => Promise<ConversationItem[]>;
  getConversationListSplit: (
    params: SplitConversationParams,
    operationID?: string
  ) => Promise<ConversationItem[]>;
  getOneConversation: (
    params: GetOneConversationParams,
    operationID?: string
  ) => Promise<ConversationItem>;
  getMultipleConversation: (
    params: string,
    operationID?: string
  ) => Promise<ConversationItem[]>;
  getConversationIDBySessionType: (
    params: GetOneConversationParams,
    operationID?: string
  ) => Promise<ConversationItem>;
  getTotalUnreadMsgCount: (operationID?: string) => Promise<number>;
  markConversationMessageAsRead: (
    params: string,
    operationID?: string
  ) => Promise<unknown>;
  setConversationDraft: (
    params: SetConversationDraftParams,
    operationID?: string
  ) => Promise<unknown>;
  pinConversation: (
    params: PinConversationParams,
    operationID?: string
  ) => Promise<unknown>;
  setConversationRecvMessageOpt: (
    params: SetConversationRecvOptParams,
    operationID?: string
  ) => Promise<unknown>;
  setConversationPrivateChat: (
    params: SetConversationPrivateParams,
    operationID?: string
  ) => Promise<unknown>;
  setConversationBurnDuration: (
    params: SetBurnDurationParams,
    operationID?: string
  ) => Promise<unknown>;
  resetConversationGroupAtType: (
    params: string,
    operationID?: string
  ) => Promise<unknown>;
  hideConversation: (params: string, operationID?: string) => Promise<unknown>;
  hideAllConversation: (operationID?: string) => Promise<unknown>;
  clearConversationAndDeleteAllMsg: (
    params: string,
    operationID?: string
  ) => Promise<unknown>;
  deleteConversationAndDeleteAllMsg: (
    params: string,
    operationID?: string
  ) => Promise<unknown>;

  createTextMessage: (
    params: string,
    operationID?: string
  ) => Promise<MessageItem>;
  createTextAtMessage: (
    params: AtMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createImageMessageByURL: (
    params: ImageMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createSoundMessageByURL: (
    params: SoundMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createVideoMessageByURL: (
    params: VideoMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createFileMessageByURL: (
    params: FileMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createMergerMessage: (
    params: MergerMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createForwardMessage: (
    params: MessageItem,
    operationID?: string
  ) => Promise<MessageItem>;
  createLocationMessage: (
    params: LocationMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createQuoteMessage: (
    params: QuoteMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createCardMessage: (
    params: CardElem,
    operationID?: string
  ) => Promise<MessageItem>;
  createCustomMessage: (
    params: CustomMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  createFaceMessage: (
    params: FaceMessageParams,
    operationID?: string
  ) => Promise<MessageItem>;
  sendMessage: (
    params: SendMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  sendMessageNotOss: (
    params: SendMsgParams,
    operationID?: string
  ) => Promise<MessageItem>;
  typingStatusUpdate: (
    params: TypingUpdateParams,
    operationID?: string
  ) => Promise<unknown>;
  revokeMessage: (
    params: OpreateMessageParams,
    operationID?: string
  ) => Promise<unknown>;
  deleteMessage: (
    params: OpreateMessageParams,
    operationID?: string
  ) => Promise<unknown>;
  deleteMessageFromLocalStorage: (
    params: OpreateMessageParams,
    operationID?: string
  ) => Promise<unknown>;
  deleteAllMsgFromLocal: (operationID?: string) => Promise<unknown>;
  deleteAllMsgFromLocalAndSvr: (operationID?: string) => Promise<unknown>;
  searchLocalMessages: (
    params: SearchLocalParams,
    operationID?: string
  ) => Promise<SearchMessageResult>;
  getAdvancedHistoryMessageList: (
    params: GetAdvancedHistoryMsgParams,
    operationID?: string
  ) => Promise<AdvancedGetMessageResult>;
  getAdvancedHistoryMessageListReverse: (
    params: GetAdvancedHistoryMsgParams,
    operationID?: string
  ) => Promise<AdvancedGetMessageResult>;
  findMessageList: (
    params: FindMessageParams[],
    operationID?: string
  ) => Promise<MessageItem[]>;
  insertGroupMessageToLocalStorage: (
    params: InsertGroupMsgParams,
    operationID?: string
  ) => Promise<unknown>;
  insertSingleMessageToLocalStorage: (
    params: InsertSingleMsgParams,
    operationID?: string
  ) => Promise<unknown>;
  setMessageLocalEx: (
    params: SetMessageLocalExParams,
    operationID?: string
  ) => Promise<unknown>;
}
