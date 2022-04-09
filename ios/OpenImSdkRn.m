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
  @"onRecvC2CReadReceipt",@"onRecvMessageRevoked",@"onRecvNewMessage",@"onConversationChanged",@"onNewConversation",@"onSyncServerFailed",@"onSyncServerFinish",@"onSyncServerStart",@"onTotalUnreadMessageCountChanged",@"onBlackAdded",@"onBlackDeleted",@"onFriendApplicationAccepted",@"onFriendApplicationAdded",@"onFriendApplicationDeleted",@"onFriendApplicationRejected",@"onFriendInfoChanged",@"onFriendAdded",@"onFriendDeleted",@"onGroupApplicationAccepted",@"onGroupApplicationRejected",@"onGroupApplicationAdded",@"onGroupApplicationDeleted",@"onGroupInfoChanged",@"onGroupMemberInfoChanged",@"onGroupMemberAdded",@"onGroupMemberDeleted",@"onJoinedGroupAdded",@"onJoinedGroupDeleted",@"SendMessageProgress"];
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

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)config opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL flag = Open_im_sdkInitSDK(self,opid,[config json]);
     Open_im_sdkSetUserListener(self);
     Open_im_sdkSetConversationListener(self);
     Open_im_sdkSetFriendListener(self);
     Open_im_sdkSetGroupListener(self);
     Open_im_sdkSetAdvancedMsgListener(self);
    if (flag) {
        resolve(@"init success");
    }else{
        reject(@"-1",@"please check params and dir",nil);
    }
}

RCT_EXPORT_METHOD(setUserListener)
{
    Open_im_sdkSetUserListener(self);
}

RCT_EXPORT_METHOD(login:(NSString *)uid token:(NSString *)token opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogin(proxy,opid,uid, token);
}

RCT_EXPORT_METHOD(logout:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkLogout(proxy,opid);
}

RCT_EXPORT_METHOD(getLoginStatus:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    long status = Open_im_sdkGetLoginStatus();
    resolver(@(status));
}

RCT_EXPORT_METHOD(getLoginUser:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString* uid = Open_im_sdkGetLoginUser();
    resolver(uid);
}

RCT_EXPORT_METHOD(getUsersInfo:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUsersInfo(proxy,opid,[uidList json]);
}

RCT_EXPORT_METHOD(setSelfInfo:(NSDictionary *)info opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetSelfInfo(proxy,opid,[info json]);
}

RCT_EXPORT_METHOD(getSelfUserInfo:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSelfUserInfo(proxy, opid);
}

RCT_EXPORT_METHOD(setConversationListener)
{
    Open_im_sdkSetConversationListener(self);
}

RCT_EXPORT_METHOD(getAllConversationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetAllConversationList(proxy,opid);
}

RCT_EXPORT_METHOD(getConversationListSplit:(nonnull NSNumber *)offset count:(nonnull NSNumber *)count opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetConversationListSplit(proxy,opid,[offset longValue], [count longValue]);
}


RCT_EXPORT_METHOD(markGroupMessageHasRead:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkGroupMessageHasRead(proxy,opid, gid);
}

RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetTotalUnreadMsgCount(proxy,opid);
}

RCT_EXPORT_METHOD(pinConversation:(NSString *)cveid isPin:(BOOL)isPin opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkPinConversation(proxy,opid,cveid, isPin);
}

RCT_EXPORT_METHOD(setConversationDraft:(NSString *)cveid draft:(NSString *)draft opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationDraft(proxy,opid,cveid, draft);
}

RCT_EXPORT_METHOD(deleteConversation:(NSString *)cveid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteConversation(proxy,opid,cveid);
}

RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)cveids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetMultipleConversation(proxy,opid,[cveids json]);
}

RCT_EXPORT_METHOD(getOneConversation:(NSString *)sourceId sessionType:(nonnull NSNumber *)sessionType opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetOneConversation(proxy,opid, [sessionType longValue],sourceId);
}

RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSString *)sourceId sessionType:(nonnull NSNumber *)sessionType resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *str = Open_im_sdkGetConversationIDBySessionType(sourceId,[sessionType longValue]);
    resolver(str);
}

RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSArray *)cveids status:(nonnull NSNumber *)status opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetConversationRecvMessageOpt(proxy,opid, [cveids json], [status longValue]);
}

RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSArray *)cveids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetConversationRecvMessageOpt(proxy,opid, [cveids json]);
}

RCT_EXPORT_METHOD(setFriendListener)
{
    Open_im_sdkSetFriendListener(self);
}

RCT_EXPORT_METHOD(getFriendList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetFriendList(proxy,opid);
}

RCT_EXPORT_METHOD(getRecvFriendApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetRecvFriendApplicationList(proxy,opid);
}

RCT_EXPORT_METHOD(getSendFriendApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSendFriendApplicationList(proxy,opid);
}

RCT_EXPORT_METHOD(addFriend:(NSDictionary *)reqParams opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAddFriend(proxy,opid, [reqParams json]);
}

RCT_EXPORT_METHOD(getDesignatedFriendsInfo:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetDesignatedFriendsInfo(proxy,opid, [uidList json]);
}

RCT_EXPORT_METHOD(setFriendRemark:(NSDictionary *)friendInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetFriendRemark(proxy,opid,[friendInfo json]);
}

RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRefuseFriendApplication(proxy,opid, [userIDHandleMsg json]);
}

RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAcceptFriendApplication(proxy,opid, [userIDHandleMsg json]);
}

RCT_EXPORT_METHOD(deleteFriend:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteFriend(proxy, opid, uid);
}

RCT_EXPORT_METHOD(checkFriend:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCheckFriend(proxy,opid, [uidList json]);
}

RCT_EXPORT_METHOD(removeBlack:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRemoveBlack(proxy, opid, uid);
}

RCT_EXPORT_METHOD(getBlackList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetBlackList(proxy,opid);
}

RCT_EXPORT_METHOD(addBlack:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAddBlack(proxy, opid, uid);
}

RCT_EXPORT_METHOD(setGroupListener)
{
    Open_im_sdkSetGroupListener(self);
}

RCT_EXPORT_METHOD(inviteUserToGroup:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInviteUserToGroup(proxy,opid,gid, reason, [uidList json]);
}

RCT_EXPORT_METHOD(kickGroupMember:(NSString *)gid reason:(NSString *)reason uidList:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkKickGroupMember(proxy,opid,gid, reason, [uidList json]);
}

RCT_EXPORT_METHOD(getGroupMembersInfo:(NSString *)gid uidList:(NSArray *)uidList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupMembersInfo(proxy,opid, gid, [uidList json]);
}

RCT_EXPORT_METHOD(getGroupMemberList:(NSString *)gid filter:(nonnull NSNumber *)filter offset:(nonnull NSNumber *)offset count:(nonnull NSNumber *)count opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupMemberList(proxy,opid, gid, [filter intValue], [offset intValue],[count intValue]);
}

RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetJoinedGroupList(proxy,opid);
}

RCT_EXPORT_METHOD(createGroup:(NSDictionary *)ginfo mList:(NSArray *)mList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCreateGroup(proxy,opid,[ginfo json], [mList json]);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSString *)gid ginfo:(NSDictionary *)ginfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetGroupInfo(proxy,opid,gid,[ginfo json]);
}

RCT_EXPORT_METHOD(getGroupsInfo:(NSArray *)gids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetGroupsInfo(proxy,opid,[gids json]);
}

RCT_EXPORT_METHOD(joinGroup:(NSString *)gid reason:(NSString *)reason opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkJoinGroup(proxy,opid,gid, reason);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkQuitGroup(proxy,opid,gid);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSString *)gid uid:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkTransferGroupOwner(proxy,opid,gid, uid);
}

RCT_EXPORT_METHOD(getRecvGroupApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetRecvGroupApplicationList(proxy,opid);
}

RCT_EXPORT_METHOD(getSendGroupApplicationList:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSendGroupApplicationList(proxy,opid);
}

RCT_EXPORT_METHOD(acceptGroupApplication:(NSString *)gid fuid:(NSString *)fuid handleMsg:(NSString *)handleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAcceptGroupApplication(proxy,opid,gid,fuid,handleMsg);
}

RCT_EXPORT_METHOD(refuseGroupApplication:(NSString *)gid fuid:(NSString *)fuid handleMsg:(NSString *)handleMsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRefuseGroupApplication(proxy,opid,gid,fuid,handleMsg);
}

RCT_EXPORT_METHOD(addAdvancedMsgListener)
{
    Open_im_sdkSetAdvancedMsgListener(self);
}

RCT_EXPORT_METHOD(sendMessage:(NSString *)msg recid:(NSString *)recid gid:(NSString *)gid offlinePushInfo:(NSDictionary *)offlinePushInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy,opid, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(sendMessageNotOss:(NSString *)msg recid:(NSString *)recid gid:(NSString *)gid offlinePushInfo:(NSDictionary *)offlinePushInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessageNotOss(proxy,opid, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(getHistoryMessageList:(NSDictionary *)options opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetHistoryMessageList(proxy,opid, [options json]);
}

RCT_EXPORT_METHOD(revokeMessage:(NSDictionary *)msg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkRevokeMessage(proxy,opid, [msg json]);
}

RCT_EXPORT_METHOD(deleteMessageFromLocalStorage:(NSDictionary *)msg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteMessageFromLocalStorage(proxy,opid, [msg json]);
}

RCT_EXPORT_METHOD(insertSingleMessageToLocalStorage:(NSDictionary *)msg recv:(NSString *)recv sender:(NSString *)sender opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInsertSingleMessageToLocalStorage(proxy,opid, [msg json], recv, sender);
}

RCT_EXPORT_METHOD(insertGroupMessageToLocalStorage:(NSDictionary *)msg gid:(NSString *)gid sender:(NSString *)sender opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkInsertGroupMessageToLocalStorage(proxy,opid, [msg json], gid, sender);
}


RCT_EXPORT_METHOD(searchLocalMessages:(NSArray *)params opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSearchLocalMessages(proxy,opid, [params json]);
}

RCT_EXPORT_METHOD(markC2CMessageAsRead:(NSString *)uid mids:(NSArray *)mids opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkC2CMessageAsRead(proxy,opid, uid, [mids json]);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSString *)uid tip:(NSString *)tip opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkTypingStatusUpdate(proxy,opid,uid, tip);
}

RCT_EXPORT_METHOD(createTextMessage:(NSString *)text opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateTextMessage(opid,text);
    resolver(msg);
}

RCT_EXPORT_METHOD(createTextAtMessage:(NSString *)text ats:(NSArray *)ats opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateTextAtMessage(opid,text, [ats json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)path opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessage(opid,path);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)path opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessageFromFullPath(opid,path);
    resolver(msg);
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSDictionary *)sourcePicture bigPicture:(NSDictionary *)bigPicture snapshotPicture:(NSDictionary *)snapshotPicture opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateImageMessageByURL(opid,[sourcePicture json],[bigPicture json],[snapshotPicture json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessage:(NSString *)path duration:(nonnull NSNumber *)duration opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessage(opid,path, [duration intValue]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSString *)path duration:(nonnull NSNumber *)duration opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessageFromFullPath(opid,path, [duration intValue]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSDictionary *)soundBaseInfo opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateSoundMessageByURL(opid,[soundBaseInfo json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessage:(NSString *)path type:(NSString *)type duration:(nonnull NSNumber *)duration snapshotPath:(NSString *)snapshotPath opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessage(opid,path, type, [duration intValue], snapshotPath);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSString *)path type:(NSString *)type duration:(nonnull NSNumber *)duration snapshotPath:(NSString *)snapshotPath opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessageFromFullPath(opid,path, type, [duration intValue], snapshotPath);
    resolver(msg);
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSDictionary *)info opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateVideoMessageByURL(opid,[info json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createFileMessage:(NSString *)path name:(NSString *)name opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessage(opid,path, name);
    resolver(msg);
}


RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSString *)path name:(NSString *)name opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessageFromFullPath(opid,path, name);
    resolver(msg);
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSDictionary *)info opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateFileMessageByURL(opid,[info json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createMergerMessage:(NSArray *)msgList title:(NSString *)title summaryList:(NSArray *)summaryList opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateMergerMessage(opid,[msgList json], title, [summaryList json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createForwardMessage:(NSDictionary *)fmsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateForwardMessage(opid,[fmsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createLocationMessage:(double)latitude longitude:(double)longitude desc:(NSString *)desc opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateLocationMessage(opid,desc, longitude, latitude);
    resolver(msg);
}

RCT_EXPORT_METHOD(createCustomMessage:(NSString *)data ex:(NSString *)ex desc:(NSString *)desc opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateCustomMessage(opid,data, ex, desc);
    resolver(msg);
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSString *)text qmsg:(NSDictionary *)qmsg opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateQuoteMessage(opid,text, [qmsg json]);
    resolver(msg);
}

RCT_EXPORT_METHOD(createCardMessage:(NSString *)content opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = Open_im_sdkCreateCardMessage(opid,content);
    resolver(msg);
}

RCT_EXPORT_METHOD(clearC2CHistoryMessage:(NSString *)uid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearC2CHistoryMessage(proxy,opid, uid);
}

RCT_EXPORT_METHOD(clearGroupHistoryMessage:(NSString *)gid opid:(NSString *)opid resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearGroupHistoryMessage(proxy,opid, gid);
}






// MARK: - Open_im_sdkIMSDKListener

- (void)onConnectSuccess {
    [self pushEvent:@"onConnectSuccess" errCode:@(0) errMsg:@"" data:@"connectSuccess"];
}

- (void)onConnecting {
    [self pushEvent:@"onConnecting" errCode:@(0) errMsg:@"" data:@"connecting"];
}

- (void)onKickedOffline {
    [self pushEvent:@"onKickedOffline" errCode:@(0) errMsg:@"" data:@"kickedOffline"];
}

- (void)onUserTokenExpired {
    [self pushEvent:@"onUserTokenExpired" errCode:@(0) errMsg:@"" data:@"userTokenExpired"];
}

- (void)onConnectFailed:(int32_t)errCode errMsg:(NSString * _Nullable)errMsg {
    [self pushEvent:@"onConnectFailed" errCode:@(errCode) errMsg:errMsg data:@"connectFailed"];
}


 // MARK: - Open_im_sdkUserListener

- (void)onSelfInfoUpdated:(NSString* _Nullable)userInfo {
    [self pushEvent:@"onSelfInfoUpdated" errCode:@(0) errMsg:@"" data:userInfo];
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


- (void)onBlackAdded:(NSString * _Nullable)blackInfo {
    [self pushEvent:@"onBlackAdded" errCode:@(0) errMsg:@"" data:blackInfo];
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    [self pushEvent:@"onBlackDeleted" errCode:@(0) errMsg:@"" data:blackInfo];
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    [self pushEvent:@"onFriendAdded" errCode:@(0) errMsg:@"" data:friendInfo];
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationAccepted" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendApplicationAdded:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationAdded" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationDeleted" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    [self pushEvent:@"onFriendApplicationRejected" errCode:@(0) errMsg:@"" data:friendApplication];
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    [self pushEvent:@"onFriendDeleted" errCode:@(0) errMsg:@"" data:friendInfo];
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    [self pushEvent:@"onFriendInfoChanged" errCode:@(0) errMsg:@"" data:friendInfo];
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
- (void)onGroupApplicationAccepted:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationAccepted" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationAdded" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationDeleted" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    [self pushEvent:@"onGroupApplicationRejected" errCode:@(0) errMsg:@"" data:groupApplication];
}

- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    [self pushEvent:@"onGroupInfoChanged" errCode:@(0) errMsg:@"" data:groupInfo];
}

- (void)onGroupMemberAdded:(NSString * _Nullable)groupMemberInfo {
    [self pushEvent:@"onGroupMemberAdded" errCode:@(0) errMsg:@"" data:groupMemberInfo];
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    [self pushEvent:@"onGroupMemberDeleted" errCode:@(0) errMsg:@"" data:groupMemberInfo];
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    [self pushEvent:@"onGroupMemberInfoChanged" errCode:@(0) errMsg:@"" data:groupMemberInfo];
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    [self pushEvent:@"onJoinedGroupAdded" errCode:@(0) errMsg:@"" data:groupInfo];
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    [self pushEvent:@"onJoinedGroupDeleted" errCode:@(0) errMsg:@"" data:groupInfo];
}



@end
