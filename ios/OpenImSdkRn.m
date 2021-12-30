#import "OpenImSdkRn.h"
#import "SendMessageCallbackProxy.h"

@implementation NSDictionary (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@implementation NSArray (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@implementation NSString (Extensions)

- (NSString *)json {
    return [NSString stringWithFormat:@"\"%@\"",self];
}

@end


@implementation OpenIMSDKRN

bool hasListeners;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onConnectSuccess",@"onConnecting",@"onConnectFailed",@"onKickedOffline",@"onSelfInfoUpdated",@"onUserTokenExpired",
  @"onRecvC2CReadReceipt",@"onRecvMessageRevoked",@"onRecvNewMessage",@"onConversationChanged",@"onNewConversation",@"onSyncServerFailed",@"onSyncServerFinish",@"onSyncServerStart",@"onTotalUnreadMessageCountChanged",@"onBlackListAdd",@"onBlackListDeleted",@"onFriendApplicationListAccept",@"onFriendApplicationListAdded",@"onFriendApplicationListDeleted",@"onFriendApplicationListReject",@"onFriendInfoChanged",@"onFriendListAdded",@"onFriendListDeleted",@"onMemberEnter",@"onMemberInvited",@"onMemberKicked",@"onMemberLeave",@"onReceiveJoinApplication",@"SendMessageProgress"];
}

// 在添加第一个监听函数时触发
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (void)pushEvent:(NSString *) eventName errCode:(NSNumber *) errCode errMsg:(NSString *) errMsg data:(NSString *) data{
    NSDictionary *param = @{
        @"errMsg":errMsg,
        @"errCode": errCode,
        @"data":data
    };
    [self sendEventWithName:eventName body:param];
}

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)config resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL flag = Open_im_sdkInitSDK([config json], self);
     Open_im_sdkSetConversationListener(self);
     Open_im_sdkSetFriendListener(self);
     Open_im_sdkSetGroupListener(self);
     Open_im_sdkAddAdvancedMsgListener(self);
    Open_im_sdkSetSdkLog(1);
    if (flag) {
        resolve(@"init success");
    }else{
        reject(@"-1",@"please check params and dir",nil);
    }
}

RCT_EXPORT_METHOD(login:(NSString *)uid token:(NSString *)token resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogin(uid, token, proxy);
}

RCT_EXPORT_METHOD(logout:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogout(proxy);
}

RCT_EXPORT_METHOD(getLoginStatus:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    long status = Open_im_sdkGetLoginStatus();
    resolver(@(status));
}

RCT_EXPORT_METHOD(getUsersInfo:(NSArray *)uidList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUsersInfo([uidList json], proxy);
}

RCT_EXPORT_METHOD(setSelfInfo:(NSDictionary *)info resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetSelfInfo([info json], proxy);
}

RCT_EXPORT_METHOD(setConversationListener)
{
    Open_im_sdkSetConversationListener(self);
}

RCT_EXPORT_METHOD(getAllConversationList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetAllConversationList(proxy);
}

RCT_EXPORT_METHOD(getConversationListSplit:(NSNumber *)offset count:(NSNumber *)count resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetConversationListSplit(proxy, (long)offset, (long)count);
}

RCT_EXPORT_METHOD(markSingleMessageHasRead:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkSingleMessageHasRead(proxy, uid);
}

RCT_EXPORT_METHOD(markGroupMessageHasRead:(NSString *)gid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkGroupMessageHasRead(proxy, gid);
}

RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetTotalUnreadMsgCount(proxy);
}

RCT_EXPORT_METHOD(pinConversation:(NSString *)cveid isPin:(BOOL)isPin resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkPinConversation(cveid, isPin, proxy);
}

RCT_EXPORT_METHOD(setConversationDraft:(NSString *)cveid draft:(NSString *)draft resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationDraft(cveid, draft, proxy);
}

RCT_EXPORT_METHOD(deleteConversation:(NSString *)cveid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteConversation(cveid, proxy);
}

RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)cveids resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetMultipleConversation([cveids json], proxy);
}

RCT_EXPORT_METHOD(getOneConversation:(NSString *)sourceId sessionType:(NSNumber *)sessionType resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetOneConversation(sourceId, (long)sessionType, proxy);
}

RCT_EXPORT_METHOD(getConversationID:(NSString *)sourceId sessionType:(NSNumber *)sessionType resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *str = Open_im_sdkGetConversationIDBySessionType(sourceId, (long)sessionType);
    resolver(str);
}

RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSArray *)cveids status:(NSNumber *)status resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationRecvMessageOpt(proxy, [cveids json], (long)status);
}

RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSArray *)cveids resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetConversationRecvMessageOpt(proxy, [cveids json]);
}

RCT_EXPORT_METHOD(setFriendListener)
{
    Open_im_sdkSetFriendListener(self);
}

RCT_EXPORT_METHOD(getFriendList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendList(proxy);
}

RCT_EXPORT_METHOD(getFriendApplicationList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendApplicationList(proxy);
}

RCT_EXPORT_METHOD(addFriend:(NSDictionary *)reqParams resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAddFriend(proxy, [reqParams json]);
}

RCT_EXPORT_METHOD(getFriendsInfo:(NSArray *)uidList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendsInfo(proxy, [uidList json]);
}

RCT_EXPORT_METHOD(setFriendInfo:(NSDictionary *)friendInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetFriendInfo([friendInfo json], proxy);
}

RCT_EXPORT_METHOD(refuseFriendApplication:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRefuseFriendApplication(proxy, [uid json]);
}

RCT_EXPORT_METHOD(acceptFriendApplication:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAcceptFriendApplication(proxy, [uid json]);
}

RCT_EXPORT_METHOD(deleteFromFriendList:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteFromFriendList([uid json],proxy);
}

RCT_EXPORT_METHOD(checkFriend:(NSArray *)uidList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCheckFriend(proxy, [uidList json]);
}

RCT_EXPORT_METHOD(deleteFromBlackList:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteFromBlackList(proxy, [uid json]);
}

RCT_EXPORT_METHOD(getBlackList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetBlackList(proxy);
}

RCT_EXPORT_METHOD(addToBlackList:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAddToBlackList(proxy, [uid json]);
}

RCT_EXPORT_METHOD(setGroupListener)
{
    Open_im_sdkSetGroupListener(self);
}

RCT_EXPORT_METHOD(inviteUserToGroup:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInviteUserToGroup(gid, reason, [reason json], proxy);
}

RCT_EXPORT_METHOD(kickGroupMember:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkKickGroupMember(gid, reason, [reason json], proxy);
}

RCT_EXPORT_METHOD(getGroupMembersInfo:(NSString *)gid uidList:(NSArray *)uidList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupMembersInfo(gid, [uidList json], proxy);
}

RCT_EXPORT_METHOD(getGroupMemberList:(NSString *)gid filter:(NSNumber *)filter next:(NSNumber *)next resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupMemberList(gid, [filter intValue], [next intValue], proxy);
}

RCT_EXPORT_METHOD(getJoinedGroupList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetJoinedGroupList(proxy);
}

RCT_EXPORT_METHOD(createGroup:(NSDictionary *)ginfo mList:(NSArray *)mList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCreateGroup([ginfo json], [mList json], proxy);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSDictionary *)ginfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetGroupInfo([ginfo json], proxy);
}

RCT_EXPORT_METHOD(getGroupsInfo:(NSArray *)gids resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupsInfo([gids json], proxy);
}

RCT_EXPORT_METHOD(joinGroup:(NSString *)gid reason:(NSString *)reason resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkJoinGroup(gid, reason, proxy);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkQuitGroup(gid, proxy);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSString *)gid uid:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkTransferGroupOwner(gid, uid, proxy);
}

RCT_EXPORT_METHOD(getGroupApplicationList:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupApplicationList(proxy);
}

RCT_EXPORT_METHOD(acceptGroupApplication:(NSDictionary *)gainfo reason:(NSString *)reason resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAcceptGroupApplication([gainfo json], reason, proxy);
}

RCT_EXPORT_METHOD(refuseGroupApplication:(NSDictionary *)gainfo reason:(NSString *)reason resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRefuseGroupApplication([gainfo json], reason, proxy);
}

RCT_EXPORT_METHOD(addAdvancedMsgListener)
{
    Open_im_sdkAddAdvancedMsgListener(self);
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)msg recid:(NSString *)recid gid:(NSString *)gid online:(BOOL)online resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy, msg, recid, gid, online);
}

RCT_EXPORT_METHOD(getHistoryMessageList:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetHistoryMessageList(proxy, [options json]);
}

RCT_EXPORT_METHOD(revokeMessage:(NSDictionary *)msg resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRevokeMessage(proxy, [msg json]);
}

RCT_EXPORT_METHOD(deleteMessageFromLocalStorage:(NSDictionary *)msg resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteMessageFromLocalStorage(proxy, [msg json]);
}

RCT_EXPORT_METHOD(insertSingleMessageToLocalStorage:(NSDictionary *)msg recv:(NSString *)recv sender:(NSString *)sender resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInsertSingleMessageToLocalStorage(proxy, [msg json], recv, sender);
}

RCT_EXPORT_METHOD(findMessages:(NSArray *)mids resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkFindMessages(proxy, [mids json]);
}

RCT_EXPORT_METHOD(markC2CMessageAsRead:(NSString *)uid mids:(NSArray *)mids resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkC2CMessageAsRead(proxy, uid, [mids json]);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSString *)uid tip:(NSString *)tip resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    Open_im_sdkTypingStatusUpdate(uid, tip);
}

RCT_EXPORT_METHOD(createTextMessage:(NSString *)text resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateTextMessage(text);
    resolver(msg);
}

RCT_EXPORT_METHOD(createTextAtMessage:(NSString *)text ats:(NSArray *)ats resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateTextAtMessage(text, [ats json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)path resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessage(path);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)path resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessageFromFullPath(path);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSDictionary *)sourcePicture bigPicture:(NSDictionary *)bigPicture snapshotPicture:(NSDictionary *)snapshotPicture resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessageByURL([sourcePicture json],[bigPicture json],[snapshotPicture json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessage:(NSString *)path duration:(NSNumber *)duration resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessage(path, (int64_t)duration);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSString *)path duration:(NSNumber *)duration resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessageFromFullPath(path, (int64_t)duration);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSDictionary *)soundBaseInfo resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessageByURL([soundBaseInfo json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessage:(NSString *)path type:(NSString *)type duration:(NSNumber *)duration snapshotPath:(NSString *)snapshotPath resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessage(path, type, (int64_t)duration, snapshotPath);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSString *)path type:(NSString *)type duration:(NSNumber *)duration snapshotPath:(NSString *)snapshotPath resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessageFromFullPath(path, type, (int64_t)duration, snapshotPath);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSDictionary *)info resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessageByURL([info json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createFileMessage:(NSString *)path name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessage(path, name);
    resolver(msg);
}


RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSString *)path name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessageFromFullPath(path, name);
    resolver(msg);
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSDictionary *)info resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessageByURL([info json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createMergerMessage:(NSArray *)msgList title:(NSString *)title summaryList:(NSArray *)summaryList resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateMergerMessage([msgList json], title, [summaryList json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createForwardMessage:(NSDictionary *)fmsg resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateForwardMessage([fmsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createLocationMessage:(double)latitude longitude:(double)longitude desc:(NSString *)desc resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateLocationMessage(desc, longitude, latitude);
    resolver(msg);
}

RCT_EXPORT_METHOD(createCustomMessage:(NSString *)data ex:(NSString *)ex desc:(NSString *)desc resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateCustomMessage(data, ex, desc);
    resolver(msg);
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSString *)text qmsg:(NSDictionary *)qmsg resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateQuoteMessage(text, [qmsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createCardMessage:(NSString *)content resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateCardMessage(content);
    resolver(msg);
}

RCT_EXPORT_METHOD(forceSyncMsg)
{
    Open_im_sdkForceSyncMsg();
}


RCT_EXPORT_METHOD(clearC2CHistoryMessage:(NSString *)uid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearC2CHistoryMessage(proxy, uid);
}

RCT_EXPORT_METHOD(clearGroupHistoryMessage:(NSString *)gid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearGroupHistoryMessage(proxy, gid);
}






// MARK: - Open_im_sdkIMSDKListener

- (void)onConnectFailed:(long)ErrCode ErrMsg:(NSString* _Nullable)ErrMsg {
    [self pushEvent:@"onConnectFailed" errCode:@(ErrCode) errMsg:ErrMsg data:@"connectFailed"];
}

- (void)onConnectSuccess {
    [self pushEvent:@"onConnectSuccess" errCode:@(0) errMsg:@"" data:@"connectSuccess"];
}

- (void)onConnecting {
    [self pushEvent:@"onConnecting" errCode:@(0) errMsg:@"" data:@"connecting"];
}

- (void)onKickedOffline {
    [self pushEvent:@"onKickedOffline" errCode:@(0) errMsg:@"" data:@"kickedOffline"];
}

- (void)onSelfInfoUpdated:(NSString* _Nullable)userInfo {
    [self pushEvent:@"onSelfInfoUpdated" errCode:@(0) errMsg:@"" data:userInfo];
}

- (void)onUserTokenExpired {
    [self pushEvent:@"onUserTokenExpired" errCode:@(0) errMsg:@"" data:@"userTokenExpired"];
}


 // MARK: - Open_im_sdkIMSDKAdvancedMsgListener

 - (void)onRecvC2CReadReceipt:(NSString* _Nullable)msgReceiptList {
     [self pushEvent:@"onRecvC2CReadReceipt" errCode:@(0) errMsg:@"" data:msgReceiptList];
 }

 - (void)onRecvMessageRevoked:(NSString* _Nullable)msgId {
     [self pushEvent:@"onRecvMessageRevoked" errCode:@(0) errMsg:@"" data:msgId];
 }

 - (void)onRecvNewMessage:(NSString* _Nullable)message {
     [self pushEvent:@"onRecvNewMessage" errCode:@(0) errMsg:@"" data:message];
 }


 // MARK: - Open_im_sdkOnFriendshipListener


 - (void)onBlackListAdd:(NSString* _Nullable)info {
     [self pushEvent:@"onBlackListAdd" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onBlackListDeleted:(NSString* _Nullable)info {
     [self pushEvent:@"onBlackListDeleted" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendApplicationListAccept:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendApplicationListAccept" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendApplicationListAdded:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendApplicationListAdded" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendApplicationListDeleted:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendApplicationListDeleted" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendApplicationListReject:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendApplicationListReject" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendInfoChanged:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendInfoChanged" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendListAdded:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendListAdded" errCode:@(0) errMsg:@"" data:info];
 }

 - (void)onFriendListDeleted:(NSString* _Nullable)info {
     [self pushEvent:@"onFriendListDeleted" errCode:@(0) errMsg:@"" data:info];
 }


 // MARK: - Open_im_sdkOnConversationListener

 - (void)onConversationChanged:(NSString* _Nullable)conversationList {
     [self pushEvent:@"onConversationChanged" errCode:@(0) errMsg:@"" data:conversationList];
 }

 - (void)onNewConversation:(NSString* _Nullable)conversationList {
     [self pushEvent:@"onNewConversation" errCode:@(0) errMsg:@"" data:conversationList];
 }

 - (void)onSyncServerFailed {
     [self pushEvent:@"onSyncServerFailed" errCode:@(0) errMsg:@"" data:@"syncServerFailed"];
 }

 - (void)onSyncServerFinish {
     [self pushEvent:@"onSyncServerFinish" errCode:@(0) errMsg:@"" data:@"syncServerFinish"];
 }

 - (void)onSyncServerStart {
     [self pushEvent:@"onSyncServerStart" errCode:@(0) errMsg:@"" data:@"syncServerStart"];
 }

 - (void)onTotalUnreadMessageCountChanged:(int32_t)totalUnreadCount {
     [self pushEvent:@"onTotalUnreadMessageCountChanged" errCode:@(0) errMsg:@"" data:[NSString stringWithFormat:@"%d",totalUnreadCount]];
 }


 // MARK: - Open_im_sdkOnGroupListener

 - (void)onApplicationProcessed:(NSString* _Nullable)groupId opUser:(NSString* _Nullable)opUser AgreeOrReject:(int32_t)AgreeOrReject opReason:(NSString* _Nullable)opReason {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"opUser": opUser,
         @"agreeOrReject":@(AgreeOrReject),
         @"opReason":opReason
     };
     [self pushEvent:@"onApplicationProcessed" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onGroupCreated:(NSString* _Nullable)groupId {
     NSDictionary *data = @{
         @"groupId":groupId
     };
     [self pushEvent:@"onGroupCreated" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onGroupInfoChanged:(NSString* _Nullable)groupId groupInfo:(NSString* _Nullable)groupInfo {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"groupInfo":groupInfo
     };
     [self pushEvent:@"onGroupInfoChanged" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onMemberEnter:(NSString* _Nullable)groupId memberList:(NSString* _Nullable)memberList {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"memberList":memberList
     };
     [self pushEvent:@"onMemberEnter" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onMemberInvited:(NSString* _Nullable)groupId opUser:(NSString* _Nullable)opUser memberList:(NSString* _Nullable)memberList {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"opUser": opUser,
         @"memberList":memberList
     };
     [self pushEvent:@"onMemberInvited" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onMemberKicked:(NSString* _Nullable)groupId opUser:(NSString* _Nullable)opUser memberList:(NSString* _Nullable)memberList {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"opUser": opUser,
         @"memberList":memberList
     };
     [self pushEvent:@"onMemberKicked" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onMemberLeave:(NSString* _Nullable)groupId member:(NSString* _Nullable)member {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"member": member
     };
     [self pushEvent:@"onMemberLeave" errCode:@(0) errMsg:@"" data:[data json]];
 }

 - (void)onReceiveJoinApplication:(NSString* _Nullable)groupId member:(NSString* _Nullable)member opReason:(NSString* _Nullable)opReason {
     NSDictionary *data = @{
         @"groupId":groupId,
         @"member": member,
         @"opReason":opReason
     };
     [self pushEvent:@"onReceiveJoinApplication" errCode:@(0) errMsg:@"" data:[data json]];
 }


@end
