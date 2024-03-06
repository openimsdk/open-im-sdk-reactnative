export enum MessageReceiveOptType {
  Nomal = 0,
  NotReceive = 1,
  NotNotify = 2,
}
export enum AllowType {
  Allowed = 0,
  NotAllowed = 1,
}
export enum GroupType {
  Group = 2,
  WorkingGroup = 2,
}
export enum GroupJoinSource {
  Invitation = 2,
  Search = 3,
  QrCode = 4,
}
export enum GroupMemberRole {
  Nomal = 20,
  Admin = 60,
  Owner = 100,
}
export enum GroupVerificationType {
  ApplyNeedInviteNot = 0,
  AllNeed = 1,
  AllNot = 2,
}
export enum MessageStatus {
  Sending = 1,
  Succeed = 2,
  Failed = 3,
}
export enum Platform {
  iOS = 1,
  Android = 2,
  Windows = 3,
  MacOSX = 4,
  Web = 5,
  Linux = 7,
  AndroidPad = 8,
  iPad = 9,
}
export enum LogLevel {
  Debug = 5,
  Info = 4,
  Warn = 3,
  Error = 2,
  Fatal = 1,
  Panic = 0,
}
export enum ApplicationHandleResult {
  Unprocessed = 0,
  Agree = 1,
  Reject = -1,
}
export enum MessageType {
  TextMessage = 101,
  PictureMessage = 102,
  VoiceMessage = 103,
  VideoMessage = 104,
  FileMessage = 105,
  AtTextMessage = 106,
  MergeMessage = 107,
  CardMessage = 108,
  LocationMessage = 109,
  CustomMessage = 110,
  TypingMessage = 113,
  QuoteMessage = 114,
  FaceMessage = 115,
  FriendAdded = 1201,
  OANotification = 1400,

  GroupCreated = 1501,
  MemberQuit = 1504,
  GroupOwnerTransferred = 1507,
  MemberKicked = 1508,
  MemberInvited = 1509,
  MemberEnter = 1510,
  GroupDismissed = 1511,
  GroupMemberMuted = 1512,
  GroupMemberCancelMuted = 1513,
  GroupMuted = 1514,
  GroupCancelMuted = 1515,
  GroupAnnouncementUpdated = 1519,
  GroupNameUpdated = 1520,
  BurnMessageChange = 1701,

  // notification
  RevokeMessage = 2101,
}
export enum SessionType {
  Single = 1,
  Group = 3,
  WorkingGroup = 3,
  Notification = 4,
}
export enum GroupStatus {
  Nomal = 0,
  Baned = 1,
  Dismissed = 2,
  Muted = 3,
}
export enum GroupAtType {
  AtNormal = 0,
  AtMe = 1,
  AtAll = 2,
  AtAllAtMe = 3,
  AtGroupNotice = 4,
}
export enum GroupMemberFilter {
  All = 0,
  Owner = 1,
  Admin = 2,
  Nomal = 3,
  AdminAndNomal = 4,
  AdminAndOwner = 5,
}
export enum Relationship {
  isBlack = 0,
  isFriend = 1,
}
export enum LoginStatus {
  Logout = 1,
  Logging = 2,
  Logged = 3,
}
export enum OnlineState {
  Online = 1,
  Offline = 0,
}
export enum GroupMessageReaderFilter {
  Readed = 0,
  UnRead = 1,
}
