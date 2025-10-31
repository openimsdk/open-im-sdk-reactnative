import Emitter from './emitter';
import { OpenIMApiError } from './errors/OpenIMApiError';
import NativeOpenIMSDK from './OpenIMSDK.native';
import type { CardElem, MessageItem, SelfUserInfo } from './types/entity';
import type { MessageReceiveOptType } from './types/enum';
import {
  AccessFriendParams,
  AccessGroupParams,
  AddBlackParams,
  AddFriendParams,
  AtMsgParams,
  ChangeGroupMemberMuteParams,
  ChangeGroupMuteParams,
  ChangeInputStatesParams,
  CreateGroupParams,
  CustomMsgParams,
  FaceMessageParams,
  FileMsgByPathParams,
  FileMsgParams,
  FindMessageParams,
  GetAdvancedHistoryMsgParams,
  GetFriendApplicationListAsApplicantParams,
  GetFriendApplicationListAsRecipientParams,
  GetGroupApplicationListAsApplicantParams,
  GetGroupApplicationListAsRecipientParams,
  GetGroupMemberByTimeParams,
  GetGroupMemberParams,
  GetGroupMembersInfoParams,
  GetInputStatesParams,
  GetOneConversationParams,
  GetSelfApplicationUnhandledCountParams,
  GetSpecifiedFriendsParams,
  ImageMsgParams,
  InitOptions,
  InsertGroupMsgParams,
  InsertSingleMsgParams,
  JoinGroupParams,
  LocationMsgParams,
  LoginParams,
  LogsParams,
  MergerMsgParams,
  OffsetParams,
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
  SetConversationParams,
  SetConversationPrivateParams,
  SetConversationRecvOptParams,
  SetGroupinfoParams,
  SetMessageLocalExParams,
  SoundMsgByPathParams,
  SoundMsgParams,
  SplitConversationParams,
  TransferGroupParams,
  TypingUpdateParams,
  UpdateFriendsParams,
  UpdateMemberInfoParams,
  UploadFileParams,
  UploadLogsParams,
  VideoMsgByPathParams,
  VideoMsgParams,
} from './types/params';
import id from './utils/id';

class OpenIMSDK extends Emitter {
  private static instance: OpenIMSDK;

  private constructor() {
    super();
  }

  static getInstance(): OpenIMSDK {
    if (!OpenIMSDK.instance) {
      OpenIMSDK.instance = new OpenIMSDK();
    }
    return OpenIMSDK.instance;
  }

  private async invoke<T extends (...args: any[]) => any, R = ReturnType<T>>(
    nativeMethod: T,
    args: Parameters<T>
  ): Promise<R extends Promise<any> ? Awaited<R> : R> {
    try {
      const result = nativeMethod(...args);
      if (result instanceof Promise) {
        return await result;
      }
      return result;
    } catch (error: any) {
      /**
       * Native-layer rejection (via the React Native bridge):
       * When the native side calls Promise.reject, the JS side receives an object shaped as:
       * {
       *   code: number;
       *   message: string;
       *   userInfo: object;
       *   nativeStackIOS: string; // iOS only
       *   domain: string;         // iOS only
       *   nativeStackAndroid: string; // Android only
       * }
       * See com.facebook.react.bridge.PromiseImpl (Android) for details.
       *
       * This handler wraps all errors into the OpenIMApiError class (code, message) to
       * standardize error formats and make it easy for the business layer to determine
       * error sources based on the OpenIMApiError class.
       */
      throw new OpenIMApiError(error.code, error.message);
    }
  }

  // login
  initSDK(params: InitOptions, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.initSDK, [params, operationID]);
  }

  login(params: LoginParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.login, [params, operationID]);
  }

  logout(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.logout, [operationID]);
  }

  getLoginStatus(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getLoginStatus, [operationID]);
  }

  getLoginUserID(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getLoginUserID, [operationID]);
  }

  uploadFile(params: UploadFileParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.uploadFile, [params, operationID]);
  }

  // user
  getUsersInfo(userIDList: string[], operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getUsersInfo, [userIDList, operationID]);
  }

  getSelfUserInfo(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getSelfUserInfo, [operationID]);
  }

  setSelfInfo(params: Partial<SelfUserInfo>, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setSelfInfo, [params, operationID]);
  }

  subscribeUsersStatus(params: string[], operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.subscribeUsersStatus, [params, operationID]);
  }

  unsubscribeUsersStatus(params: string[], operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.unsubscribeUsersStatus, [params, operationID]);
  }

  getSubscribeUsersStatus(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getSubscribeUsersStatus, [operationID]);
  }

  setAppBackgroundStatus(params: boolean, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setAppBackgroundStatus, [params, operationID]);
  }

  networkStatusChanged(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.networkStatusChanged, [operationID]);
  }

  /**
   * @deprecated Use setSelfInfo instead.
   */
  setGlobalRecvMessageOpt(params: MessageReceiveOptType, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setGlobalRecvMessageOpt, [params, operationID]);
  }

  // friend relationship
  acceptFriendApplication(params: AccessFriendParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.acceptFriendApplication, [params, operationID]);
  }

  addBlack(params: AddBlackParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.addBlack, [params, operationID]);
  }

  addFriend(params: AddFriendParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.addFriend, [params, operationID]);
  }

  checkFriend(params: string[], operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.checkFriend, [params, operationID]);
  }

  deleteFriend(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.deleteFriend, [params, operationID]);
  }

  getBlackList(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getBlackList, [operationID]);
  }

  // TODO:
  getFriendApplicationListAsApplicant(
    operationID: string = id(),
    req: GetFriendApplicationListAsApplicantParams = { offset: 0, count: 20 },
  ) {
    return this.invoke(NativeOpenIMSDK.getFriendApplicationListAsApplicant, [operationID, req]);
  }

  // TODO:
  getFriendApplicationListAsRecipient(
    operationID: string = id(),
    req: GetFriendApplicationListAsRecipientParams = { handleResults: [], offset: 0, count: 20 },
  ) {
    return this.invoke(NativeOpenIMSDK.getFriendApplicationListAsRecipient, [operationID, req]);
  }

  getFriendApplicationUnhandledCount(
    req: GetSelfApplicationUnhandledCountParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getFriendApplicationUnhandledCount, [req, operationID]);
  }

  getFriendList(filterBlack: boolean, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getFriendList, [filterBlack, operationID]);
  }

  getFriendListPage(
    params: OffsetParams & { filterBlack?: boolean },
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getFriendListPage, [params, operationID]);
  }

  getSpecifiedFriendsInfo(params: GetSpecifiedFriendsParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getSpecifiedFriendsInfo, [params, operationID]);
  }

  updateFriends(params: UpdateFriendsParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.updateFriends, [params, operationID]);
  }

  refuseFriendApplication(params: AccessFriendParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.refuseFriendApplication, [params, operationID]);
  }

  removeBlack(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.removeBlack, [params, operationID]);
  }

  searchFriends(params: SearchFriendParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.searchFriends, [params, operationID]);
  }

  setFriendRemark(params: RemarkFriendParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setFriendRemark, [params, operationID]);
  }

  // group
  createGroup(params: CreateGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createGroup, [params, operationID]);
  }

  joinGroup(params: JoinGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.joinGroup, [params, operationID]);
  }

  inviteUserToGroup(params: OpreateGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.inviteUserToGroup, [params, operationID]);
  }

  getJoinedGroupList(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getJoinedGroupList, [operationID]);
  }

  getJoinedGroupListPage(params: OffsetParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getJoinedGroupListPage, [params, operationID]);
  }

  searchGroups(params: SearchGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.searchGroups, [params, operationID]);
  }

  getSpecifiedGroupsInfo(params: string[], operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getSpecifiedGroupsInfo, [params, operationID]);
  }

  setGroupInfo(params: SetGroupinfoParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setGroupInfo, [params, operationID]);
  }

  // TODO:
  getGroupApplicationListAsRecipient(
    operationID: string = id(),
    req: GetGroupApplicationListAsRecipientParams = { groupIDs: [], handleResults: [], offset: 0, count: 20 },
  ) {
    return this.invoke(NativeOpenIMSDK.getGroupApplicationListAsRecipient, [operationID, req]);
  }

  // TODO:
  getGroupApplicationListAsApplicant(
    operationID: string = id(),
    req: GetGroupApplicationListAsApplicantParams = { groupIDs: [], handleResults: [], offset: 0, count: 20 },
  ) {
    return this.invoke(NativeOpenIMSDK.getGroupApplicationListAsApplicant, [operationID, req]);
  }

  getGroupApplicationUnhandledCount(
    req: GetSelfApplicationUnhandledCountParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getGroupApplicationUnhandledCount, [req, operationID]);
  }

  acceptGroupApplication(params: AccessGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.acceptGroupApplication, [params, operationID]);
  }

  refuseGroupApplication(params: AccessGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.refuseGroupApplication, [params, operationID]);
  }

  getGroupMemberList(params: GetGroupMemberParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getGroupMemberList, [params, operationID]);
  }

  getSpecifiedGroupMembersInfo(
    params: GetGroupMembersInfoParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getSpecifiedGroupMembersInfo, [params, operationID]);
  }

  getUsersInGroup(params: GetGroupMembersInfoParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getUsersInGroup, [params, operationID]);
  }

  searchGroupMembers(params: SearchGroupMemberParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.searchGroupMembers, [params, operationID]);
  }

  setGroupMemberInfo(params: UpdateMemberInfoParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setGroupMemberInfo, [params, operationID]);
  }

  getGroupMemberOwnerAndAdmin(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getGroupMemberOwnerAndAdmin, [params, operationID]);
  }

  getGroupMemberListByJoinTimeFilter(
    params: GetGroupMemberByTimeParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getGroupMemberListByJoinTimeFilter, [params, operationID]);
  }

  kickGroupMember(params: OpreateGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.kickGroupMember, [params, operationID]);
  }

  changeGroupMemberMute(params: ChangeGroupMemberMuteParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.changeGroupMemberMute, [params, operationID]);
  }

  changeGroupMute(params: ChangeGroupMuteParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.changeGroupMute, [params, operationID]);
  }

  transferGroupOwner(params: TransferGroupParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.transferGroupOwner, [params, operationID]);
  }

  dismissGroup(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.dismissGroup, [params, operationID]);
  }

  quitGroup(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.quitGroup, [params, operationID]);
  }

  isJoinGroup(groupID: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.isJoinGroup, [groupID, operationID]);
  }

  // conversation & message
  getAllConversationList(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getAllConversationList, [operationID]);
  }

  getConversationListSplit(params: SplitConversationParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getConversationListSplit, [params, operationID]);
  }

  getOneConversation(params: GetOneConversationParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getOneConversation, [params, operationID]);
  }

  getMultipleConversation(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getMultipleConversation, [params, operationID]);
  }

  getConversationIDBySessionType(params: GetOneConversationParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getConversationIDBySessionType, [params, operationID]);
  }

  getTotalUnreadMsgCount(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getTotalUnreadMsgCount, [operationID]);
  }

  markConversationMessageAsRead(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.markConversationMessageAsRead, [params, operationID]);
  }

  setConversation(params: SetConversationParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setConversation, [params, operationID]);
  }

  setConversationDraft(params: SetConversationDraftParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setConversationDraft, [params, operationID]);
  }

  pinConversation(params: PinConversationParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.pinConversation, [params, operationID]);
  }

  setConversationRecvMessageOpt(
    params: SetConversationRecvOptParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.setConversationRecvMessageOpt, [params, operationID]);
  }

  setConversationPrivateChat(
    params: SetConversationPrivateParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.setConversationPrivateChat, [params, operationID]);
  }

  setConversationBurnDuration(params: SetBurnDurationParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setConversationBurnDuration, [params, operationID]);
  }

  resetConversationGroupAtType(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.resetConversationGroupAtType, [params, operationID]);
  }

  hideConversation(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.hideConversation, [params, operationID]);
  }

  hideAllConversation(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.hideAllConversation, [operationID]);
  }

  clearConversationAndDeleteAllMsg(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.clearConversationAndDeleteAllMsg, [params, operationID]);
  }

  deleteConversationAndDeleteAllMsg(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.deleteConversationAndDeleteAllMsg, [params, operationID]);
  }

  createImageMessageFromFullPath(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createImageMessageFromFullPath, [params, operationID]);
  }

  createVideoMessageFromFullPath(params: VideoMsgByPathParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createVideoMessageFromFullPath, [params, operationID]);
  }

  createSoundMessageFromFullPath(params: SoundMsgByPathParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createSoundMessageFromFullPath, [params, operationID]);
  }

  createFileMessageFromFullPath(params: FileMsgByPathParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createFileMessageFromFullPath, [params, operationID]);
  }

  createTextMessage(params: string, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createTextMessage, [params, operationID]);
  }

  createTextAtMessage(params: AtMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createTextAtMessage, [params, operationID]);
  }

  createImageMessageByURL(params: ImageMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createImageMessageByURL, [params, operationID]);
  }

  createSoundMessageByURL(params: SoundMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createSoundMessageByURL, [params, operationID]);
  }

  createVideoMessageByURL(params: VideoMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createVideoMessageByURL, [params, operationID]);
  }

  createFileMessageByURL(params: FileMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createFileMessageByURL, [params, operationID]);
  }

  createMergerMessage(params: MergerMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createMergerMessage, [params, operationID]);
  }

  createForwardMessage(params: MessageItem, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createForwardMessage, [params, operationID]);
  }

  createLocationMessage(params: LocationMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createLocationMessage, [params, operationID]);
  }

  createQuoteMessage(params: QuoteMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createQuoteMessage, [params, operationID]);
  }

  createCardMessage(params: CardElem, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createCardMessage, [params, operationID]);
  }

  createCustomMessage(params: CustomMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createCustomMessage, [params, operationID]);
  }

  createFaceMessage(params: FaceMessageParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.createFaceMessage, [params, operationID]);
  }

  sendMessage(params: SendMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.sendMessage, [params, operationID]);
  }

  sendMessageNotOss(params: SendMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.sendMessageNotOss, [params, operationID]);
  }

  typingStatusUpdate(params: TypingUpdateParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.typingStatusUpdate, [params, operationID]);
  }

  changeInputStates(params: ChangeInputStatesParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.changeInputStates, [params, operationID]);
  }

  getInputStates(params: GetInputStatesParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.getInputStates, [params, operationID]);
  }

  revokeMessage(params: OpreateMessageParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.revokeMessage, [params, operationID]);
  }

  deleteMessage(params: OpreateMessageParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.deleteMessage, [params, operationID]);
  }

  deleteMessageFromLocalStorage(params: OpreateMessageParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.deleteMessageFromLocalStorage, [params, operationID]);
  }

  deleteAllMsgFromLocal(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.deleteAllMsgFromLocal, [operationID]);
  }

  deleteAllMsgFromLocalAndSvr(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.deleteAllMsgFromLocalAndSvr, [operationID]);
  }

  searchLocalMessages(params: SearchLocalParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.searchLocalMessages, [params, operationID]);
  }

  getAdvancedHistoryMessageList(
    params: GetAdvancedHistoryMsgParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getAdvancedHistoryMessageList, [params, operationID]);
  }

  getAdvancedHistoryMessageListReverse(
    params: GetAdvancedHistoryMsgParams,
    operationID: string = id()
  ) {
    return this.invoke(NativeOpenIMSDK.getAdvancedHistoryMessageListReverse, [params, operationID]);
  }

  findMessageList(params: FindMessageParams[], operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.findMessageList, [params, operationID]);
  }

  insertGroupMessageToLocalStorage(params: InsertGroupMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.insertGroupMessageToLocalStorage, [params, operationID]);
  }

  insertSingleMessageToLocalStorage(params: InsertSingleMsgParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.insertSingleMessageToLocalStorage, [params, operationID]);
  }

  setMessageLocalEx(params: SetMessageLocalExParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setMessageLocalEx, [params, operationID]);
  }

  uploadLogs(params: UploadLogsParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.uploadLogs, [params, operationID]);
  }

  logs(params: LogsParams, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.logs, [params, operationID]);
  }

  unInitSDK(operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.unInitSDK, [operationID]);
  }

  updateFcmToken(fcmToken: string, expireTime: number, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.updateFcmToken, [fcmToken, expireTime, operationID]);
  }

  setAppBadge(appUnreadCount: number, operationID: string = id()) {
    return this.invoke(NativeOpenIMSDK.setAppBadge, [appUnreadCount, operationID]);
  }
}

const openIMSDK = OpenIMSDK.getInstance();

export default openIMSDK;
