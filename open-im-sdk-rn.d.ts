declare module 'open-im-sdk-rn' {
  // Define interfaces for method options
  export interface InitSDKOptions {
    
  }

  export interface LoginOptions {
    userID: string;
    token: string;
  }

  export interface UserInfoOptions {
    userIDList: string[];
    groupID?: string;
  }

  export interface SetSelfInfoOptions {
    info: any; // Define the structure according to the expected input
  }

  export interface UserStatusOptions {
    uidList: string[];
  }

  export interface SubscribeUsersStatusOptions {
    userIDList: string[];
  }

  // Define methods
  export function initSDK(config: any, operationID: string): Promise<void>;
  export function setUserListener(): void;
  export function login(options: LoginOptions, operationID: string): Promise<void>;
  export function logout(operationID: string): Promise<void>;
  export function setAppBackgroundStatus(isBackground: boolean, operationID: string): Promise<void>;
  export function networkStatusChange(operationID: string): Promise<void>;
  export function getLoginStatus(operationID: string): Promise<number>;
  export function getLoginUserID(): Promise<string>;
  export function getUsersInfo(uidList: string[], operationID: string): Promise<any[]>;
  export function getUsersInfoFromSrv(uidList: string[], operationID: string): Promise<any[]>;
  export function getUsersInfoWithCache(options: UserInfoOptions, operationID: string): Promise<any[]>;
  export function setSelfInfo(options: SetSelfInfoOptions, operationID: string): Promise<void>;
  export function setSelfInfoEx(options: SetSelfInfoOptions, operationID: string): Promise<void>;
  export function getSelfUserInfo(operationID: string): Promise<any>;
  export function getUserStatus(options: UserStatusOptions, operationID: string): Promise<any[]>;
  export function subscribeUsersStatus(options: SubscribeUsersStatusOptions, operationID: string): Promise<void>;
  export function unsubscribeUsersStatus(options: SubscribeUsersStatusOptions, operationID: string): Promise<void>;
  export function getSubscribeUsersStatus(operationID: string): Promise<any[]>;

  export interface GetConversationListSplitOptions {
    offset: number;
    count: number;
  }

  export interface GetOneConversationOptions {
    sessionType: number;
    sourceID: string;
  }

  export interface SetConversationDraftOptions {
    conversationID: string;
    draftText: string;
  }

  export function setConversationListener(): void;
  export function getAllConversationList(operationID: string): Promise<any[]>;
  export function getConversationListSplit(options: GetConversationListSplitOptions, operationID: string): Promise<any[]>;
  export function getOneConversation(options: GetOneConversationOptions, operationID: string): Promise<any>;
  export function getMultipleConversation(conversationIDList: string[], operationID: string): Promise<any[]>;
  export function setGlobalRecvMessageOpt(opt: number, operationID: string): Promise<void>;
  export function hideAllConversations(operationID: string): Promise<void>;
  export function hideConversation(conversationID: string, operationID: string): Promise<void>;
  export function getConversationRecvMessageOpt(conversationIDList: string[], operationID: string): Promise<any[]>;
  export function setConversationDraft(options: SetConversationDraftOptions, operationID: string): Promise<void>;
 export interface SetConversationExOptions {
    conversationID: string;
    ex: string;
  }

  export interface SetConversationIsMsgDestructOptions {
    conversationID: string;
    isMsgDestruct: boolean;
  }

  export interface SetConversationMsgDestructTimeOptions {
    conversationID: string;
    msgDestructTime: number;
  }

  export interface SetConversationPrivateChatOptions {
    conversationID: string;
    isPrivate: boolean;
  }

  export interface SetConversationBurnDurationOptions {
    conversationID: string;
    burnDuration: number;
  }

  export interface SetConversationRecvMessageOptOptions {
    conversationID: string;
    opt: number;
  }

  export interface CreateAdvancedTextMessageOptions {
    messageEntityList: any[]; // Specify the actual type if known
    text: string;
  }

  export interface CreateTextAtMessageOptions {
    message?: any; // Specify the actual type if known
    text: string;
    atUserIDList: string[];
    atUsersInfo: string[];
  }

  export interface CreateLocationMessageOptions {
    description: string;
    longitude: number;
    latitude: number;
  }

  // Define methods
  export function setConversationEx(options: SetConversationExOptions, operationID: string): Promise<void>;
  export function setConversationIsMsgDestruct(options: SetConversationIsMsgDestructOptions, operationID: string): Promise<void>;
  export function resetConversationGroupAtType(conversationID: string, operationID: string): Promise<void>;
  export function pinConversation(options: SetConversationExOptions, operationID: string): Promise<void>; // Reuse SetConversationExOptions if the structure is same
  export function pinFriends(setFriendsParams: string, operationID: string): Promise<void>;
  export function setConversationMsgDestructTime(options: SetConversationMsgDestructTimeOptions, operationID: string): Promise<void>;
  export function setConversationPrivateChat(options: SetConversationPrivateChatOptions, operationID: string): Promise<void>;
  export function setConversationBurnDuration(options: SetConversationBurnDurationOptions, operationID: string): Promise<void>;
  export function setConversationRecvMessageOpt(options: SetConversationRecvMessageOptOptions, operationID: string): Promise<void>;
  export function getTotalUnreadMsgCount(operationID: string): Promise<number>;
  export function getAtAllTag(operationID: string): Promise<string>;
  export function createAdvancedTextMessage(options: CreateAdvancedTextMessageOptions, operationID: string): Promise<string>;
  export function createTextAtMessage(options: CreateTextAtMessageOptions, operationID: string): Promise<string>;
  export function createTextMessage(textMsg: string, operationID: string): Promise<string>;
  export function createLocationMessage(options: CreateLocationMessageOptions, operationID: string): Promise<string>;
  export function createCustomMessage(options: SetConversationExOptions, operationID: string): Promise<string>; // Reuse SetConversationExOptions if the structure is same
export interface CreateImageMessageByURLOptions {
    sourcePicture: any; // Replace with actual type
    bigPicture: any; // Replace with actual type
    snapshotPicture: any; // Replace with actual type
    sourcePath: string;
  }

  export interface CreateSoundMessageOptions {
    soundPath: string;
    duration: number;
  }

  export interface CreateVideoMessageOptions {
    videoPath: string;
    videoType: string;
    duration: number;
    snapshotPath: string;
  }

  export interface CreateFileMessageOptions {
    filePath: string;
    fileName: string;
  }

  export interface CreateMergerMessageOptions {
    messageList: any[]; // Specify the actual type if known
    title: string;
    summaryList: string[];
  }

  export interface CreateFaceMessageOptions {
    index: number;
    dataStr: string;
  }

  export interface ForwardMessageOptions {
    message: any; // Specify the actual type if known
  }

  // Define methods
  export function createImageMessageByURL(options: CreateImageMessageByURLOptions, operationID: string): Promise<string>;
  export function createSoundMessage(options: CreateSoundMessageOptions, operationID: string): Promise<string>;
  export function createSoundMessageFromFullPath(options: CreateSoundMessageOptions, operationID: string): Promise<string>;
  export function createSoundMessageByURL(soundInfo: any, operationID: string): Promise<string>; // Replace any with the actual type
  export function createVideoMessage(options: CreateVideoMessageOptions, operationID: string): Promise<string>;
  export function createVideoMessageFromFullPath(options: CreateVideoMessageOptions, operationID: string): Promise<string>;
  export function createVideoMessageByURL(videoInfo: any, operationID: string): Promise<string>; // Replace any with the actual type
  export function createFileMessage(options: CreateFileMessageOptions, operationID: string): Promise<string>;
  export function createFileMessageFromFullPath(options: CreateFileMessageOptions, operationID: string): Promise<string>;
  export function createFileMessageByURL(fileInfo: any, operationID: string): Promise<string>; // Replace any with the actual type
  export function createMergerMessage(options: CreateMergerMessageOptions, operationID: string): Promise<string>;
  export function createFaceMessage(options: CreateFaceMessageOptions, operationID: string): Promise<string>;
  export function createForwardMessage(options: ForwardMessageOptions, operationID: string): Promise<string>;

  export interface CreateImageMessageByURLOptions {
    sourcePicture: any; // Replace with the correct type
    bigPicture: any; // Replace with the correct type
    snapshotPicture: any; // Replace with the correct type
    sourcePath: string;
  }

  export interface CreateSoundMessageOptions {
    soundPath: string;
    duration: number;
  }

  export interface CreateVideoMessageOptions {
    videoPath: string;
    videoType: string;
    duration: number;
    snapshotPath: string;
  }

  export interface CreateFileMessageOptions {
    filePath: string;
    fileName: string;
  }

  export interface CreateMergerMessageOptions {
    messageList: string[];
    title: string;
    summaryList: string[];
  }

  export interface CreateFaceMessageOptions {
    index: number;
    dataStr: string;
  }

  export interface CreateForwardMessageOptions {
    message: any; // Replace with the correct type
  }

  export interface GetConversationIDBySessionTypeOptions {
    sourceID: string;
    sessionType: number;
  }

  export interface SendMessageOptions {
    message: string;
    recvID: string;
    groupID: string;
    offlinePushInfo: any; // Replace with the correct type
  }

  // Define methods
  export function createImageMessageByURL(options: CreateImageMessageByURLOptions, operationID: string): Promise<string>;
  export function createSoundMessage(options: CreateSoundMessageOptions, operationID: string): Promise<string>;
  export function createSoundMessageFromFullPath(options: CreateSoundMessageOptions, operationID: string): Promise<string>;
  export function createSoundMessageByURL(soundInfo: any, operationID: string): Promise<string>; // Replace 'any' with the correct type
  export function createVideoMessage(options: CreateVideoMessageOptions, operationID: string): Promise<string>;
  export function createVideoMessageFromFullPath(options: CreateVideoMessageOptions, operationID: string): Promise<string>;
  export function createVideoMessageByURL(videoInfo: any, operationID: string): Promise<string>; // Replace 'any' with the correct type
  export function createFileMessage(options: CreateFileMessageOptions, operationID: string): Promise<string>;
  export function createFileMessageFromFullPath(options: CreateFileMessageOptions, operationID: string): Promise<string>;
  export function createFileMessageByURL(fileInfo: any, operationID: string): Promise<string>; // Replace 'any' with the correct type
  export function createMergerMessage(options: CreateMergerMessageOptions, operationID: string): Promise<string>;
  export function createFaceMessage(options: CreateFaceMessageOptions, operationID: string): Promise<string>;
  export function createForwardMessage(options: CreateForwardMessageOptions, operationID: string): Promise<string>;
  export function getConversationIDBySessionType(options: GetConversationIDBySessionTypeOptions, operationID: string): Promise<string>;
  export function sendMessage(options: SendMessageOptions, operationID: string): Promise<void>;
  export function sendMessageNotOss(options: SendMessageOptions, operationID: string): Promise<void>;
  export function findMessageList(findOptions: any, operationID: string): Promise<any[]>; // Replace 'any' with the correct type
  export function getAdvancedHistoryMessageList(findOptions: any, operationID: string): Promise<any[]>; // Replace 'any' with the correct type
  export function getAdvancedHistoryMessageListReverse(options: any, operationID: string): Promise<any[]>; // Replace 'any' with the correct type
export interface RevokeMessageOptions {
    conversationID: string;
    clientMsgID: string;
  }

  export interface TypingStatusUpdateOptions {
    recvID: string;
    msgTip: string;
  }

  export interface MarkMessagesAsReadByMsgIDOptions {
    conversationID: string;
    clientMsgIDList: string[];
  }

  export interface DeleteMessageOptions {
    conversationID: string;
    clientMsgID: string;
  }

  export interface InsertMessageToLocalStorageOptions {
    message: any; // Replace with correct type
    recvID: string;
    sendID: string;
  }

  export interface SearchLocalMessagesOptions {
    // Define the structure of the search parameters
  }

  export interface SetMessageLocalExOptions {
    conversationID: string;
    clientMsgID: string;
    localEx: string;
  }

  export interface CheckFriendOptions {
    userIDList: string[];
  }

  export interface AddFriendOptions {
    // Define the structure of the add friend parameters
  }

  export interface SetFriendsExOptions {
    friendIDs: string;
    Ex: string;
  }

  // Define methods
  export function revokeMessage(options: RevokeMessageOptions, operationID: string): Promise<void>;
  export function searchConversation(searchParams: string, operationID: string): Promise<any>; // Replace 'any' with correct type
  export function typingStatusUpdate(options: TypingStatusUpdateOptions, operationID: string): Promise<void>;
  export function markConversationMessageAsRead(conversationID: string, operationID: string): Promise<void>;
  export function markMessagesAsReadByMsgID(options: MarkMessagesAsReadByMsgIDOptions, operationID: string): Promise<void>;
  export function deleteMessageFromLocalStorage(options: DeleteMessageOptions, operationID: string): Promise<void>;
  export function deleteMessage(options: DeleteMessageOptions, operationID: string): Promise<void>;
  export function deleteAllMsgFromLocalAndSvr(operationID: string): Promise<void>;
  export function deleteAllMsgFromLocal(operationID: string): Promise<void>;
  export function clearConversationAndDeleteAllMsg(conversationID: string, operationID: string): Promise<void>;
  export function deleteConversationAndDeleteAllMsg(conversationID: string, operationID: string): Promise<void>;
  export function insertSingleMessageToLocalStorage(options: InsertMessageToLocalStorageOptions, operationID: string): Promise<void>;
  export function insertGroupMessageToLocalStorage(options: InsertMessageToLocalStorageOptions, operationID: string): Promise<void>;
  export function searchLocalMessages(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function setMessageLocalEx(options: SetMessageLocalExOptions, operationID: string): Promise<void>;
  export function getSpecifiedFriendsInfo(userIDList: string[], operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getFriendList(operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getFriendListPage(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function searchFriends(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function checkFriend(options: CheckFriendOptions, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function addFriend(options: any, operationID: string): Promise<void>;
  export function setFriendRemark(userIDRemark: string, operationID: string): Promise<void>;
  export function setFriendsEx(options: SetFriendsExOptions, operationID: string): Promise<void>;
  export function deleteFriend(friendUserID: string, operationID: string): Promise<void>;
  export function getFriendApplicationListAsRecipient(operationID: string): Promise<any[]>; // Replace 'any' with correct type

  export interface GroupOptions {
    joinSource: number; // Assuming it's a number based on `joinSource.intValue`
    groupID: string; // Group ID as a string
    reqMsg: string; // Request message as a string
    ex: string; // Additional string parameter, purpose based on SDK documentation
  }

  export interface GroupMemberOptions {
    // Define the structure for group member options
  }

  export interface GroupMemberListByJoinTimeFilterOptions {
    // Define the structure for group member list by join time filter options
  }

  export interface SpecifiedGroupMembersInfoOptions {
    // Define the structure for specified group members info options
  }

  export interface KickGroupMemberOptions {
    // Define the structure for kick group member options
  }

  export interface TransferGroupOwnerOptions {
    // Define the structure for transfer group owner options
  }

  export interface InviteUserToGroupOptions {
    // Define the structure for invite user to group options
  }

  // Define methods
  export function getFriendApplicationListAsApplicant(operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function acceptFriendApplication(userIDHandleMsg: any, operationID: string): Promise<void>; // Replace 'any' with correct type for userIDHandleMsg
  export function refuseFriendApplication(userIDHandleMsg: any, operationID: string): Promise<void>; // Replace 'any' with correct type for userIDHandleMsg
  export function addBlack(blackUserID: string, ex: string, operationID: string): Promise<void>;
  export function getBlackList(operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function removeBlack(removeUserID: string, operationID: string): Promise<void>;
  export function setFriendListener(): void;
  export function setGroupListener(): void;
  export function createGroup(ginfo: any, operationID: string): Promise<void>; // Replace 'any' with correct type for ginfo
  export function joinGroup(options: GroupOptions, operationID: string): Promise<void>;
  export function quitGroup(gid: string, operationID: string): Promise<void>;
  export function dismissGroup(groupID: string, operationID: string): Promise<void>;
  export function changeGroupMute(options: GroupOptions, operationID: string): Promise<void>;
  export function setGroupMemberRoleLevel(options: any, operationID: string): Promise<void>;
  export function setGroupMemberInfo(data: any, operationID: string): Promise<void>; // Replace 'any' with correct type for data
  export function getJoinedGroupList(operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getSpecifiedGroupsInfo(groupIDList: string[], operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function searchGroups(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type for options
  export function setGroupInfo(jsonGroupInfo: any, operationID: string): Promise<void>; // Replace 'any' with correct type for jsonGroupInfo
  export function setGroupVerification(options: GroupOptions, operationID: string): Promise<void>;
  export function setGroupLookMemberInfo(options: GroupOptions, operationID: string): Promise<void>;
  export function setGroupApplyMemberFriend(options: GroupOptions, operationID: string): Promise<void>;
  export function getGroupMemberList(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getGroupMemberOwnerAndAdmin(groupID: string, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getInputStates(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type for options
  export function getGroupMemberListByJoinTimeFilter(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getSpecifiedGroupMembersInfo(options: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function kickGroupMember(options: any, operationID: string): Promise<void>;
  export function transferGroupOwner(options: any, operationID: string): Promise<void>;
  export function inviteUserToGroup(options: any, operationID: string): Promise<void>;
export interface GroupApplicationOptions {
    // Define the structure for group application options
  }

  export interface SearchGroupMembersOptions {
    // Define the structure for search group members options
  }

  export interface SetGroupMemberNicknameOptions {
    // Define the structure for set group member nickname options
  }

  export interface UploadFileOptions {
    // Define the structure for upload file options
  }

  // Define methods
  export function getGroupApplicationListAsRecipient(operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function getGroupApplicationListAsApplicant(operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function acceptGroupApplication(options: any, operationID: string): Promise<void>;
  export function refuseGroupApplication(options: any, operationID: string): Promise<void>;
  export function setGroupMemberNickname(options: any, operationID: string): Promise<void>;
  export function searchGroupMembers(searchOptions: any, operationID: string): Promise<any[]>; // Replace 'any' with correct type
  export function isJoinGroup(groupID: string, operationID: string): Promise<boolean>;
  export function addAdvancedMsgListener(): void;
  export function unInitSDK(operationID: string): Promise<void>;
  export function updateFcmToken(options: any, operationID: string): Promise<void>; // Replace 'any' with correct type for options
  export function setAppBadge(appUnreadCount: number, operationID: string): Promise<void>;
  export function uploadLogs(data: any[], operationID: string): Promise<void>; // Replace 'any' with correct type for data
  export function getSdkVersion(): Promise<string>;
  export function uploadFile(reqData: any, operationID: string): Promise<void>;

}
