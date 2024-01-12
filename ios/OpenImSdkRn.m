#import "OpenImSdkRn.h"
#import "SendMessageCallbackProxy.h"
#import "UploadFileCallbackProxy.h"

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
  return @[
  @"onConnectSuccess",
  @"onConnecting",
  @"onConnectFailed",
  @"onKickedOffline",
  @"onSelfInfoUpdated",
  @"onUserStatusChanged",
  @"onUserTokenExpired",
  @"onRecvNewMessages",
  @"onRecvOfflineNewMessages",
  @"onMsgDeleted" ,
  @"onRecvC2CReadReceipt",
  @"onRecvMessageRevoked",
  @"onRecvGroupReadReceipt",
  @"onRecvNewMessage",
  @"onRecvOfflineNewMessage",
  @"onRecvOnlineOnlyMessage",
  @"onRecvMessageExtensionsAdded",
  @"onRecvMessageExtensionsChanged",
  @"onRecvMessageExtensionsDeleted",
  
  @"onConversationChanged",
  @"onConversationUserInputStatusChanged",
  @"onNewConversation",
  @"onSyncServerFailed",
  @"onSyncServerFinish",
  @"onSyncServerStart",
  @"onTotalUnreadMessageCountChanged",
  
  @"onBlackAdded",
  @"onBlackDeleted",
  @"onFriendApplicationAccepted",
  @"onFriendApplicationAdded",
  @"onFriendApplicationDeleted",
  @"onFriendApplicationRejected",
  @"onFriendInfoChanged",
  @"onFriendAdded",
  @"onFriendDeleted",

  @"onGroupApplicationAccepted",
  @"onGroupApplicationRejected",
  @"onGroupApplicationAdded",
  @"onGroupApplicationDeleted",
  @"onGroupInfoChanged",
  @"onGroupMemberInfoChanged",
  @"onGroupMemberAdded",
  @"onGroupMemberDeleted",
  @"onJoinedGroupAdded",
  @"onJoinedGroupDeleted",
  @"onGroupDismissed",
  @"SendMessageProgress",
//   @"onInvitationCancelled",
//   @"onInvitationTimeout",
//   @"onInviteeAccepted",
//   @"onInviteeAcceptedByOtherDevice",
//   @"onInviteeRejected",
//   @"onInviteeRejectedByOtherDevice",
//   @"onReceiveNewInvitation",
//   @"onHangUp",
  @"uploadComplete",
  @"onReceiveNewMessages",
  @"onReceiveOfflineNewMessages",
  @"onRecvCustomBusinessMessage",
  @"uploadOnProgress"
  ];
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

- (void)pushEvent:(NSString *)eventName errCode:(NSNumber *)errCode errMsg:(NSString *)errMsg data:(id)data {
    NSDictionary *param = @{
        @"errMsg": errMsg,
        @"errCode": errCode,
        @"data": data
    };
    [self sendEventWithName:eventName body:param];
}

- (NSDictionary *)parseJsonStr2Dict:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error while parsing JSON: %@", error.localizedDescription);
        return nil;
    }
    NSDictionary *data = (NSDictionary *)jsonObject;
    return data;
}

- (NSArray *)parseJsonStr2Array:(NSString *)jsonStr {
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"Error while parsing JSON: %@", error.localizedDescription);
        return nil;
    }
    NSArray *data = (NSArray *)jsonObject;
    return data;
}

// 创建随机operation ID
- (NSString *)generateRandomOpid
{
    // Generate a unique identifier as operationID
    NSString *uniqueId = [[NSUUID UUID] UUIDString];
    return uniqueId;
}

RCT_EXPORT_METHOD(initSDK:(NSDictionary *)config operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    BOOL flag = Open_im_sdkInitSDK(self,operationID,[config json]);
     Open_im_sdkSetUserListener(self);
     Open_im_sdkSetConversationListener(self);
     Open_im_sdkSetFriendListener(self);
     Open_im_sdkSetGroupListener(self);
     Open_im_sdkSetAdvancedMsgListener(self);
    //  Open_im_sdkSetSignalingListener(self);
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

RCT_EXPORT_METHOD(login:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];

      // Generate random operationID if not provided

    Open_im_sdkLogin(proxy, operationID, [options valueForKey:@"userID"], [options valueForKey:@"token"]);
}

RCT_EXPORT_METHOD(logout:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    Open_im_sdkLogout(proxy,operationID);
}

RCT_EXPORT_METHOD(setAppBackgroundStatus:(BOOL)isBackground operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkSetAppBackgroundStatus(proxy, operationID, isBackground);
}

RCT_EXPORT_METHOD(networkStatusChange:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkNetworkStatusChanged(proxy, operationID);
}

RCT_EXPORT_METHOD(getLoginStatus:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    long status = Open_im_sdkGetLoginStatus(operationID);
    
    resolver(@(status));
}

RCT_EXPORT_METHOD(getLoginUserID:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString* uid = Open_im_sdkGetLoginUserID();
    resolver(uid);
}
//User
RCT_EXPORT_METHOD(getUsersInfo:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUsersInfo(proxy,operationID,[uidList json]);
}
RCT_EXPORT_METHOD(getUsersInfoFromSrv:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUsersInfoFromSrv(proxy,operationID,[uidList json]);
}
RCT_EXPORT_METHOD(getUsersInfoWithCache:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSArray *userIDList = options[@"userIDList"];
    NSString *groupID = options[@"groupID"];
    Open_im_sdkGetUsersInfoWithCache(proxy, operationID, [userIDList json], groupID);
}

RCT_EXPORT_METHOD(setSelfInfo:(NSDictionary *)info operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetSelfInfo(proxy,operationID,[info json]);
}
RCT_EXPORT_METHOD(setSelfInfoEx:(NSDictionary *)info operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetSelfInfoEx(proxy,operationID,[info json]);
}
RCT_EXPORT_METHOD(getSelfUserInfo:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSelfUserInfo(proxy, operationID);
}

RCT_EXPORT_METHOD(getUserStatus:(NSArray *)uidList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetUserStatus(proxy, operationID,[uidList json]);
}

RCT_EXPORT_METHOD(subscribeUsersStatus:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSubscribeUsersStatus(proxy, operationID, [userIDList json]);
}

RCT_EXPORT_METHOD(unsubscribeUsersStatus:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkUnsubscribeUsersStatus(proxy, operationID, [userIDList json]);
}

RCT_EXPORT_METHOD(getSubscribeUsersStatus:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSubscribeUsersStatus(proxy, operationID);
}

//Conversation & Message

RCT_EXPORT_METHOD(setConversationListener)
{
    Open_im_sdkSetConversationListener(self);
}

RCT_EXPORT_METHOD(getAllConversationList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetAllConversationList(proxy,operationID);
}

RCT_EXPORT_METHOD(getConversationListSplit:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetConversationListSplit(proxy,operationID,[[options valueForKey:@"offset"] longValue], [[options valueForKey:@"count"] longValue]);
}

RCT_EXPORT_METHOD(getOneConversation:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetOneConversation(proxy,operationID, [[options valueForKey:@"sessionType"] intValue], [options valueForKey:@"sourceID"]);
}

RCT_EXPORT_METHOD(getMultipleConversation:(NSArray *)conversationIDList operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetMultipleConversation(proxy, operationID,  [conversationIDList json]);
}

RCT_EXPORT_METHOD(setGlobalRecvMessageOpt:(NSInteger)opt operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkSetGlobalRecvMessageOpt(proxy, operationID, opt);
}
RCT_EXPORT_METHOD(hideAllConversations:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkHideAllConversations(proxy, operationID);
}


RCT_EXPORT_METHOD(hideConversation:(NSString *)conversationID operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkHideConversation(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(getConversationRecvMessageOpt:(NSArray *)conversationIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetConversationRecvMessageOpt(proxy, operationID, [conversationIDList json]);
}
RCT_EXPORT_METHOD(hideAllConversations:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
    Open_im_sdkHideAllConversations(proxy, operationID);
}

RCT_EXPORT_METHOD(setConversationDraft:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *conversationID = [options valueForKey:@"conversationID"];
    NSString *draftText = [options valueForKey:@"draftText"];
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    if (conversationID == nil || draftText == nil) {
        NSString *errorMessage = @"Missing conversationID or draftText";
        NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: errorMessage};
        NSError *error = [NSError errorWithDomain:@"YourErrorDomain" code:0 userInfo:errorInfo];
        rejecter(@"MISSING_ARGUMENTS", errorMessage, error);
        return;
    }
     
    // Assuming `Open_im_sdkSetConversationDraft` is a valid function
    Open_im_sdkSetConversationDraft(proxy,operationID, conversationID, draftText);
    
    resolver(@"Draft set successfully");
}
RCT_EXPORT_METHOD(setConversationEx:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *conversationID = options[@"conversationID"];
    NSString *ex = options[@"ex"];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkSetConversationEx(proxy, operationID, conversationID, ex);
}

RCT_EXPORT_METHOD(setConversationIsMsgDestruct:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *conversationID = options[@"conversationID"];
    BOOL isMsgDestruct = [options[@"isMsgDestruct"] boolValue];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkSetConversationIsMsgDestruct(proxy, operationID, conversationID, isMsgDestruct);
}

RCT_EXPORT_METHOD(resetConversationGroupAtType:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkResetConversationGroupAtType(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(pinConversation:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkPinConversation(proxy,operationID, [options valueForKey:@"conversationID"], [[options valueForKey:@"isPinned"] boolValue]);
}
RCT_EXPORT_METHOD(pinFriends:(NSString *)setFriendsParams operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkPinFriends(proxy, operationID, setFriendsParams);
}

RCT_EXPORT_METHOD(setConversationMsgDestructTime:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *conversationID = options[@"conversationID"];
    int msgDestructTime = [options[@"msgDestructTime"] intValue];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkSetConversationMsgDestructTime(proxy, operationID, conversationID, msgDestructTime);
}

RCT_EXPORT_METHOD(setConversationPrivateChat:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkSetConversationPrivateChat(proxy,operationID, [options valueForKey:@"conversationID"], [[options valueForKey:@"isPrivate"] boolValue] );
}

RCT_EXPORT_METHOD(setConversationBurnDuration:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkSetConversationBurnDuration(proxy,operationID,[options valueForKey:@"conversationID"], [[options valueForKey:@"burnDuration"] intValue]);
}

RCT_EXPORT_METHOD(setConversationRecvMessageOpt:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkSetConversationRecvMessageOpt(proxy, operationID , [options valueForKey:@"conversationID"], [[options valueForKey:@"opt"] longValue]);
}

RCT_EXPORT_METHOD(getTotalUnreadMsgCount:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetTotalUnreadMsgCount(proxy, operationID);
}
RCT_EXPORT_METHOD(getAtAllTag:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{

        
    NSString *atAllTag = Open_im_sdkGetAtAllTag(operationID);
    resolver(atAllTag);
}

RCT_EXPORT_METHOD(createAdvancedTextMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSArray *messageEntityList = options[@"messageEntityList"];
    NSString *messageEntityListJson = [messageEntityList json];
    NSString *text = options[@"text"];
    
     
    
    NSString *result = Open_im_sdkCreateAdvancedTextMessage(operationID, text, messageEntityListJson);
    resolver(result);
}

RCT_EXPORT_METHOD(createTextAtMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *messageJson = @"";
    NSDictionary *message = options[@"message"];
    if (message != nil) {
        messageJson = [self dictionaryToJson:message];
    }
    NSString *text = options[@"text"];
    NSArray *atUserIDList = options[@"atUserIDList"];
    NSString *atUserIDListStr = [atUserIDList componentsJoinedByString:@","];
    NSArray *atUsersInfo = options[@"atUsersInfo"];
    NSString *atUsersInfoStr = [atUsersInfo componentsJoinedByString:@","];
    
     
    
    NSString *result = Open_im_sdkCreateTextAtMessage(operationID, text, atUserIDListStr, atUsersInfoStr, messageJson);
    resolver(result);
}

- (NSString *)dictionaryToJson:(NSDictionary *)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

RCT_EXPORT_METHOD(createTextMessage:(NSString *)textMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = Open_im_sdkCreateTextMessage(operationID,textMsg);
    resolver(result);
}

RCT_EXPORT_METHOD(createLocationMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateLocationMessage(operationID,options[@"description"], [options[@"longitude"] doubleValue],[options[@"latitude"] doubleValue]);
    resolver(result);
}

RCT_EXPORT_METHOD(createCustomMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateCustomMessage(operationID,options[@"data"], options[@"extension"] ,options[@"description"]);
    resolver(result);
}

RCT_EXPORT_METHOD(createQuoteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateQuoteMessage(operationID,options[@"text"],options[@"message"]);
    resolver(result);
}

RCT_EXPORT_METHOD(createAdvancedQuoteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateAdvancedQuoteMessage(operationID,options[@"text"] ,options[@"message"],options[@"messageEntityList"]);
    resolver(result);
}
RCT_EXPORT_METHOD(createCardMessage:(NSDictionary *)cardElem operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateCardMessage(operationID,[self dictionaryToJson:cardElem]);
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessage:(NSString *)imagePath operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    NSString *result = Open_im_sdkCreateImageMessage(operationID,imagePath);
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessageFromFullPath:(NSString *)imagePath operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateImageMessageFromFullPath(operationID,imagePath);
    resolver(result);
}

RCT_EXPORT_METHOD(createImageMessageByURL:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *sourcePicture = [self dictionaryToJson:options[@"sourcePicture"]];
    NSString *bigPicture = [self dictionaryToJson:options[@"bigPicture"]];
    NSString *snapshotPicture = [self dictionaryToJson:options[@"snapshotPicture"]];
    NSString *sourcePath = options[@"sourcePath"]; 
    
    NSString *result = Open_im_sdkCreateImageMessageByURL(operationID, sourcePath, sourcePicture, bigPicture, snapshotPicture);
    resolver(result);
}

RCT_EXPORT_METHOD(createSoundMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateSoundMessage(operationID,options[@"soundPath"],[options[@"duration"] integerValue]);
    resolver(result);
}
RCT_EXPORT_METHOD(createSoundMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *soundPath = [options objectForKey:@"soundPath"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    
     
    
    NSString *result = Open_im_sdkCreateSoundMessageFromFullPath(operationID, soundPath, (long)duration);
    resolver(result);
}

RCT_EXPORT_METHOD(createSoundMessageByURL:(NSDictionary *)soundInfo operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    
     
    
    NSString *result = Open_im_sdkCreateSoundMessageByURL(operationID, [soundInfo json]);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoPath = [options objectForKey:@"videoPath"];
    NSString *videoType = [options objectForKey:@"videoType"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *snapshotPath = [options objectForKey:@"snapshotPath"];
    
     
    
    NSString *result = Open_im_sdkCreateVideoMessage(operationID, videoPath, videoType, (long)duration, snapshotPath);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *videoPath = [options objectForKey:@"videoPath"];
    NSString *videoType = [options objectForKey:@"videoType"];
    NSInteger duration = [[options objectForKey:@"duration"] integerValue];
    NSString *snapshotPath = [options objectForKey:@"snapshotPath"];
    
     
    
    NSString *result = Open_im_sdkCreateVideoMessageFromFullPath(operationID, videoPath, videoType, (long)duration, snapshotPath);
    resolver(result);
}

RCT_EXPORT_METHOD(createVideoMessageByURL:(NSDictionary *)videoInfo operationID:(NSString *)operationID  resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    
     
    
    NSString *result = Open_im_sdkCreateVideoMessageByURL(operationID, [videoInfo json]);
    resolver(result);
}

RCT_EXPORT_METHOD(createFileMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *filePath = [options objectForKey:@"filePath"];
    NSString *fileName = [options objectForKey:@"fileName"];
    
     
    
    NSString *result = Open_im_sdkCreateFileMessage(operationID, filePath, fileName);
    resolver(result);
}
RCT_EXPORT_METHOD(createFileMessageFromFullPath:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *filePath = options[@"filePath"];
    NSString *fileName = options[@"fileName"];
    
     
    
    NSString *result = Open_im_sdkCreateFileMessageFromFullPath(operationID, filePath, fileName);
    resolver(result);
}

RCT_EXPORT_METHOD(createFileMessageByURL:(NSDictionary *)fileInfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
     
    
    NSString *result = Open_im_sdkCreateFileMessageByURL(operationID, [fileInfo json]);
    resolver(result);
}

RCT_EXPORT_METHOD(createMergerMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *messageList = [options[@"messageList"] description];
    NSString *title = options[@"title"];
    NSString *summaryList = [options[@"summaryList"] description];
    
     
    
    NSString *result = Open_im_sdkCreateMergerMessage(operationID, messageList, title, summaryList);
    resolver(result);
}

RCT_EXPORT_METHOD(createFaceMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSNumber *index = options[@"index"];
    NSString *dataStr = options[@"dataStr"];
    
     
    
    NSString *result = Open_im_sdkCreateFaceMessage(operationID, [index intValue], dataStr);
    resolver(result);
}

RCT_EXPORT_METHOD(createForwardMessage:(NSDictionary *)message operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *result = Open_im_sdkCreateForwardMessage(operationID, [self readableMapToString:message]);
    resolver(result);
}

- (NSString *)readableMapToString:(NSDictionary *)map
{
    // Convert NSDictionary to JSON string
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:0 error:&error];
    if (!jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

RCT_EXPORT_METHOD(getConversationIDBySessionType:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
   NSString *sourceID = options[@"sourceID"];
   NSNumber *sessionType = options[@"sessionType"];
   NSString *result = Open_im_sdkGetConversationIDBySessionType(operationID, sourceID, sessionType.intValue);
   resolver(result);
}

RCT_EXPORT_METHOD(sendMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = options[@"message"];
    NSString *recid = options[@"recvID"];
    NSString *gid = options[@"groupID"];
    NSDictionary *offlinePushInfo = options[@"offlinePushInfo"];
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessage(proxy,operationID, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(sendMessageNotOss:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *msg = options[@"message"];
    NSString *recid = options[@"recvID"];
    NSString *gid = options[@"groupID"];
    NSDictionary *offlinePushInfo = options[@"offlinePushInfo"];
    RNSendMessageCallbackProxy * proxy = [[RNSendMessageCallbackProxy alloc] initWithMessage:msg module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkSendMessageNotOss(proxy,operationID, msg, recid, gid, [offlinePushInfo json]);
}

RCT_EXPORT_METHOD(findMessageList:(NSDictionary *)findOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [self dictionaryToJson:findOptions];
    
     
    
    Open_im_sdkFindMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageList:(NSDictionary *)findOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *findOptionsJson = [self dictionaryToJson:findOptions];
    
     
    
    Open_im_sdkGetAdvancedHistoryMessageList(proxy, operationID, findOptionsJson);
}

RCT_EXPORT_METHOD(getAdvancedHistoryMessageListReverse:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    
     
    
    Open_im_sdkGetAdvancedHistoryMessageListReverse(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(revokeMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];
    Open_im_sdkRevokeMessage(proxy, operationID, conversationID, clientMsgID);
}
RCT_EXPORT_METHOD(searchConversation:(NSString *)searchParams operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkSearchConversation(proxy, operationID, searchParams);
}

RCT_EXPORT_METHOD(typingStatusUpdate:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *recvID = options[@"recvID"];
    NSString *msgTip = options[@"msgTip"];
    Open_im_sdkTypingStatusUpdate(proxy, operationID, recvID, msgTip);
}

RCT_EXPORT_METHOD(markConversationMessageAsRead:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkMarkConversationMessageAsRead(proxy,operationID, conversationID);
}

RCT_EXPORT_METHOD(markMessagesAsReadByMsgID:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSArray *clientMsgIDList = options[@"clientMsgIDList"];
    Open_im_sdkMarkMessagesAsReadByMsgID(proxy,operationID, conversationID, [clientMsgIDList json]);
}

RCT_EXPORT_METHOD(deleteMessageFromLocalStorage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"]; 
    NSString *clientMsgID = options[@"clientMsgID"];
    Open_im_sdkDeleteMessageFromLocalStorage(proxy, operationID, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(deleteMessage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];
    Open_im_sdkDeleteMessage(proxy, operationID, conversationID, clientMsgID);
}

RCT_EXPORT_METHOD(deleteAllMsgFromLocalAndSvr:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteAllMsgFromLocalAndSvr(proxy, operationID);
}

RCT_EXPORT_METHOD(deleteAllMsgFromLocal:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteAllMsgFromLocal(proxy, operationID);
}

RCT_EXPORT_METHOD(clearConversationAndDeleteAllMsg:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkClearConversationAndDeleteAllMsg(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(deleteConversationAndDeleteAllMsg:(NSString *)conversationID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkDeleteConversationAndDeleteAllMsg(proxy, operationID, conversationID);
}

RCT_EXPORT_METHOD(insertSingleMessageToLocalStorage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *message = options[@"message"];
    NSString *recvID = options[@"recvID"];
    NSString *sendID = options[@"sendID"];
    Open_im_sdkInsertSingleMessageToLocalStorage(proxy, operationID, [message json], recvID, sendID);
}

RCT_EXPORT_METHOD(insertGroupMessageToLocalStorage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSDictionary *message = options[@"message"];
    NSString *recvID = options[@"recvID"];
    NSString *sendID = options[@"sendID"];
    Open_im_sdkInsertGroupMessageToLocalStorage(proxy, operationID, [message json], recvID, sendID);
}

RCT_EXPORT_METHOD(searchLocalMessages:(NSDictionary *)searchParam operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSearchLocalMessages(proxy, operationID, [searchParam json]);
}

RCT_EXPORT_METHOD(setMessageLocalEx:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *conversationID = options[@"conversationID"];
    NSString *clientMsgID = options[@"clientMsgID"];
    NSString *localEx = options[@"localEx"];
    Open_im_sdkSetMessageLocalEx(proxy, operationID, conversationID, clientMsgID, localEx);
}

RCT_EXPORT_METHOD(getSpecifiedFriendsInfo:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkGetSpecifiedFriendsInfo(proxy, operationID, [userIDList json]);
}

RCT_EXPORT_METHOD(getFriendList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetFriendList(proxy, operationID);
}

RCT_EXPORT_METHOD(getFriendListPage:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    
    Open_im_sdkGetFriendListPage(proxy, operationID, [offset intValue], [count intValue]);
}

RCT_EXPORT_METHOD(searchFriends:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    
     
    
    Open_im_sdkSearchFriends(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(checkFriend:(NSArray *)userIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDListString = [userIDList componentsJoinedByString:@","];
    
     
    
    Open_im_sdkCheckFriend(proxy, operationID, userIDListString);
}

RCT_EXPORT_METHOD(addFriend:(NSDictionary *)paramsReq operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *paramsReqJson = [self dictionaryToJson:paramsReq];
    
     
    
    Open_im_sdkAddFriend(proxy, operationID, paramsReqJson);
}

RCT_EXPORT_METHOD(setFriendRemark:(NSString *)userIDRemark operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkSetFriendRemark(proxy, operationID, userIDRemark);
}

RCT_EXPORT_METHOD(setFriendsEx:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *friendIDs = options[@"friendIDs"];
    NSString *ex = options[@"Ex"];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkSetFriendsEx(proxy, operationID, friendIDs, ex);
}


RCT_EXPORT_METHOD(deleteFriend:(NSString *)friendUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkDeleteFriend(proxy, operationID, friendUserID);
}
RCT_EXPORT_METHOD(getFriendApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetFriendApplicationListAsRecipient(proxy, operationID);
}

RCT_EXPORT_METHOD(getFriendApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetFriendApplicationListAsApplicant(proxy, operationID);
}

RCT_EXPORT_METHOD(acceptFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [self dictionaryToJson:userIDHandleMsg];
    
     
    
    Open_im_sdkAcceptFriendApplication(proxy, operationID, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(refuseFriendApplication:(NSDictionary *)userIDHandleMsg operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *userIDHandleMsgJson = [self dictionaryToJson:userIDHandleMsg];
    
     
    
    Open_im_sdkRefuseFriendApplication(proxy, operationID, userIDHandleMsgJson);
}

RCT_EXPORT_METHOD(addBlack:(NSString *)blackUserID ex:(NSString *)ex operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkAddBlack(proxy, operationID, blackUserID,ex);
}

RCT_EXPORT_METHOD(getBlackList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetBlackList(proxy, operationID);
}

RCT_EXPORT_METHOD(removeBlack:(NSString *)removeUserID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkRemoveBlack(proxy, operationID, removeUserID);
}

RCT_EXPORT_METHOD(setFriendListener)
{
    Open_im_sdkSetFriendListener(self);
}

RCT_EXPORT_METHOD(setGroupListener)
{
    Open_im_sdkSetGroupListener(self);
}

// MARK: - Group
RCT_EXPORT_METHOD(createGroup:(NSDictionary *)ginfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkCreateGroup(proxy,operationID,[ginfo json]);
}

RCT_EXPORT_METHOD(joinGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSNumber *joinSource = [options objectForKey:@"joinSource"];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSString *reqMsg = [options objectForKey:@"reqMsg"];
    NSString *ex = [options objectForKey:@"ex"];
     
    
    Open_im_sdkJoinGroup(proxy, operationID, groupID, reqMsg, joinSource.intValue,ex);
}

RCT_EXPORT_METHOD(quitGroup:(NSString *)gid operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkQuitGroup(proxy, operationID, gid);
}

RCT_EXPORT_METHOD(dismissGroup:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkDismissGroup(proxy, operationID, groupID);
}

RCT_EXPORT_METHOD(changeGroupMute:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = [options objectForKey:@"groupID"];
    NSNumber *isMute = [options objectForKey:@"isMute"];
    
     
    
    Open_im_sdkChangeGroupMute(proxy, operationID, groupID, isMute.boolValue);
}

RCT_EXPORT_METHOD(setGroupMemberRoleLevel:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *userID = options[@"userID"];
    NSInteger roleLevel = [options[@"roleLevel"] integerValue];
    
     
    
    Open_im_sdkSetGroupMemberRoleLevel(proxy, operationID, groupID, userID, roleLevel);
}

RCT_EXPORT_METHOD(setGroupMemberInfo:(NSDictionary *)data operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *dataJson = [self dictionaryToJson:data];
    
     
    
    Open_im_sdkSetGroupMemberInfo(proxy, operationID, dataJson);
}

RCT_EXPORT_METHOD(getJoinedGroupList:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetJoinedGroupList(proxy, operationID);
}

RCT_EXPORT_METHOD(getSpecifiedGroupsInfo:(NSArray *)groupIDList operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupIDListJson = [groupIDList json];
    
     
    
    Open_im_sdkGetSpecifiedGroupsInfo(proxy, operationID, groupIDListJson);
}

RCT_EXPORT_METHOD(searchGroups:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *optionsJson = [self dictionaryToJson:options];
    
     
    
    Open_im_sdkSearchGroups(proxy, operationID, optionsJson);
}

RCT_EXPORT_METHOD(setGroupInfo:(NSDictionary *)jsonGroupInfo operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *jsonGroupInfoJson = [self dictionaryToJson:jsonGroupInfo];
    
     
    
    Open_im_sdkSetGroupInfo(proxy, operationID, jsonGroupInfoJson);
}

RCT_EXPORT_METHOD(setGroupVerification:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *verification = options[@"verification"];
    
     
    
    Open_im_sdkSetGroupVerification(proxy, operationID, groupID, [verification intValue]);
}

RCT_EXPORT_METHOD(setGroupLookMemberInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *rule = options[@"rule"];
    
     
    
    Open_im_sdkSetGroupLookMemberInfo(proxy, operationID, groupID, [rule intValue]);
}

RCT_EXPORT_METHOD(setGroupApplyMemberFriend:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *rule = options[@"rule"];
    
     
    
    Open_im_sdkSetGroupApplyMemberFriend(proxy, operationID, groupID, [rule intValue]);
}

RCT_EXPORT_METHOD(getGroupMemberList:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *filter = options[@"filter"];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    
     
    
    Open_im_sdkGetGroupMemberList(proxy, operationID, groupID, [filter intValue], [offset intValue], [count intValue]);
}

RCT_EXPORT_METHOD(getGroupMemberOwnerAndAdmin:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetGroupMemberOwnerAndAdmin(proxy, operationID, groupID);
}
RCT_EXPORT_METHOD(getInputStates:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *conversationID = options[@"conversationID"];
    NSString *userID = options[@"userID"];

    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolve rejecter:reject];

    Open_im_sdkGetInputStates(proxy, operationID, conversationID, userID);
}

RCT_EXPORT_METHOD(getGroupMemberListByJoinTimeFilter:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSNumber *offset = options[@"offset"];
    NSNumber *count = options[@"count"];
    NSNumber *joinTimeBegin = options[@"joinTimeBegin"];
    NSNumber *joinTimeEnd = options[@"joinTimeEnd"];
    NSArray *filterUserIDList = options[@"filterUserIDList"];
    
     
    
    Open_im_sdkGetGroupMemberListByJoinTimeFilter(proxy, operationID, groupID, [offset intValue], [count intValue], [joinTimeBegin intValue], [joinTimeEnd intValue], [filterUserIDList json]);
}

RCT_EXPORT_METHOD(getSpecifiedGroupMembersInfo:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [userIDList json];
    
     
    
    Open_im_sdkGetSpecifiedGroupMembersInfo(proxy, operationID, groupID, userIDListJson);
}

RCT_EXPORT_METHOD(kickGroupMember:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [userIDList json];
    
     
    
    Open_im_sdkKickGroupMember(proxy, operationID, groupID, reason, userIDListJson);
}

RCT_EXPORT_METHOD(transferGroupOwner:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"groupID"];
    NSString *uid = options[@"newOwnerUserID"];
     
    
    Open_im_sdkTransferGroupOwner(proxy, operationID, gid, uid);
}

RCT_EXPORT_METHOD(inviteUserToGroup:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *reason = options[@"reason"];
    NSArray *userIDList = options[@"userIDList"];
    NSString *userIDListJson = [userIDList json];
    
     
    
    Open_im_sdkInviteUserToGroup(proxy, operationID, groupID, reason, userIDListJson);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsRecipient:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetGroupApplicationListAsRecipient(proxy, operationID);
}

RCT_EXPORT_METHOD(getGroupApplicationListAsApplicant:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkGetGroupApplicationListAsApplicant(proxy, operationID);
}

RCT_EXPORT_METHOD(acceptGroupApplication:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"groupID"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    
     
    
    Open_im_sdkAcceptGroupApplication(proxy, operationID, gid, fromUserID, handleMsg);
}

RCT_EXPORT_METHOD(refuseGroupApplication:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *gid = options[@"groupID"];
    NSString *fromUserID = options[@"fromUserID"];
    NSString *handleMsg = options[@"handleMsg"];
    
     
    
    Open_im_sdkRefuseGroupApplication(proxy, operationID, gid, fromUserID, handleMsg);
}

RCT_EXPORT_METHOD(setGroupMemberNickname:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *groupID = options[@"groupID"];
    NSString *userID = options[@"userID"];
    NSString *groupMemberNickname = options[@"groupMemberNickname"];
    
     
    
    Open_im_sdkSetGroupMemberNickname(proxy, operationID, groupID, userID, groupMemberNickname);
}

RCT_EXPORT_METHOD(searchGroupMembers:(NSDictionary *)searchOptions operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSString *searchOptionsJson = [self dictionaryToJson:searchOptions];
    
     
    
    Open_im_sdkSearchGroupMembers(proxy, operationID, searchOptionsJson);
}
RCT_EXPORT_METHOD(isJoinGroup:(NSString *)groupID operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    
     
    
    Open_im_sdkIsJoinGroup(proxy, operationID, groupID);
}

RCT_EXPORT_METHOD(addAdvancedMsgListener)
{
    Open_im_sdkSetAdvancedMsgListener(self);
}
RCT_EXPORT_METHOD(setCustomBusinessListener)
{
    Open_im_sdkSetCustomBusinessListener(self);
}
// MARK: - Third
RCT_EXPORT_METHOD(unInitSDK:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    Open_im_sdkUnInitSDK(operationID);
}

RCT_EXPORT_METHOD(updateFcmToken:(NSDictionary *)options operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    NSArray *userIDList = options[@"userIDList"];
    NSInteger expiredTime = [options[@"expiredTime"] integerValue];
    Open_im_sdkUpdateFcmToken(proxy, operationID, [userIDList json], expiredTime);
}

RCT_EXPORT_METHOD(setAppBadge:(int32_t)appUnreadCount operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy *proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    Open_im_sdkSetAppBadge(proxy, operationID, appUnreadCount);
}

RCT_EXPORT_METHOD(uploadLogs:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    RNUploadLogCallbackProxy * uploadProxy = [[RNUploadLogCallbackProxy alloc] initWithOpid:operationID module:self resolver:resolver rejecter:rejecter];
    OPen_im_sdkUploadLog(proxy,operationID,uploadProxy);
}


RCT_EXPORT_METHOD(getSdkVersion: resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    NSString *version = Open_im_sdkGetSdkVersion();
    resolver(version);
}

RCT_EXPORT_METHOD(uploadFile:(NSDictionary *)reqData operationID:(NSString *)operationID resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    RNCallbackProxy * proxy = [[RNCallbackProxy alloc] initWithCallback:resolver rejecter:rejecter];
    RNUploadFileCallbackProxy * uploadProxy = [[RNUploadFileCallbackProxy alloc] initWithOpid:operationID module:self resolver:resolver rejecter:rejecter];
    Open_im_sdkUploadFile(proxy,operationID, [reqData json],uploadProxy);
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
    NSDictionary *data = [self parseJsonStr2Dict:userInfo];
    [self pushEvent:@"onSelfInfoUpdated" errCode:@(0) errMsg:@"" data:data];
}

- (void)onUserStatusChanged:(NSString * _Nullable)statusMap {
    NSDictionary *data = [self parseJsonStr2Dict:statusMap];
    [self pushEvent:@"onUserStatusChanged" errCode:@(0) errMsg:@"" data:data];
}


// MARK: - Open_im_sdk_callbackOnBatchMsgListener

- (void)onRecvNewMessages:(NSString * _Nullable)messageList {
    NSArray *messageListArray = [self parseJsonStr2Array:messageList];
    [self pushEvent:@"onRecvNewMessages" errCode:@(0) errMsg:@"" data:messageListArray];
}
- (void)onRecvOfflineNewMessages:(NSString* _Nullable)messageList {
    NSArray *messageListArray = [self parseJsonStr2Array:messageList];
    [self pushEvent:@"onRecvOfflineNewMessages" errCode:@(0) errMsg:@"" data:messageListArray];
}
// MARK: - Open_im_sdkIMSDKAdvancedMsgListener
- (void)onMsgDeleted:(NSString* _Nullable)message {
    NSDictionary *messageDict = [self parseJsonStr2Dict:message];
    [self pushEvent:@"onMsgDeleted" errCode:@(0) errMsg:@"" data:messageDict];
}

- (void)onNewRecvMessageRevoked:(NSString *)messageRevoked {
    NSDictionary *messageRevokedDict = [self parseJsonStr2Dict:messageRevoked];
    [self pushEvent:@"onNewRecvMessageRevoked" errCode:@(0) errMsg:@"" data:messageRevokedDict];
}

- (void)onRecvC2CReadReceipt:(NSString* _Nullable)msgReceiptList {
    NSArray *msgReceiptListArray = [self parseJsonStr2Array:msgReceiptList];
    [self pushEvent:@"onRecvC2CReadReceipt" errCode:@(0) errMsg:@"" data:msgReceiptListArray];
}

 - (void)onRecvMessageRevoked:(NSString* _Nullable)msgId {
     [self pushEvent:@"onRecvMessageRevoked" errCode:@(0) errMsg:@"" data:msgId];
 }

 - (void)onRecvNewMessage:(NSString* _Nullable)message {
    NSDictionary *messageDict = [self parseJsonStr2Dict:message];
     [self pushEvent:@"onRecvNewMessage" errCode:@(0) errMsg:@"" data:messageDict];
 }

- (void)onRecvGroupReadReceipt:(NSString * _Nullable)groupMsgReceiptList {
    NSArray *msgReceiptListArray = [self parseJsonStr2Array:groupMsgReceiptList];
    [self pushEvent:@"onRecvGroupReadReceipt" errCode:@(0) errMsg:@"" data:msgReceiptListArray];
}
- (void)onRecvMessageExtensionsAdded:(NSString * _Nullable)msgID reactionExtensionList:(NSString * _Nullable)reactionExtensionList {
    NSArray *msgReceiptListArray = [self parseJsonStr2Array:reactionExtensionList];
    [self pushEvent:@"onRecvMessageExtensionsAdded" errCode:@(0) errMsg:@"" data:msgReceiptListArray];
}


- (void)onRecvMessageExtensionsChanged:(NSString * _Nullable)msgID reactionExtensionList:(NSString * _Nullable)reactionExtensionList {
    NSArray *msgReceiptListArray = [self parseJsonStr2Array:reactionExtensionList];
    [self pushEvent:@"onRecvMessageExtensionsChanged" errCode:@(0) errMsg:@"" data:msgReceiptListArray];
}


- (void)onRecvMessageExtensionsDeleted:(NSString * _Nullable)msgID reactionExtensionKeyList:(NSString * _Nullable)reactionExtensionKeyList {
    NSArray *msgReceiptListArray = [self parseJsonStr2Array:reactionExtensionKeyList];
    [self pushEvent:@"onRecvMessageExtensionsDeleted" errCode:@(0) errMsg:@"" data:msgReceiptListArray];
}

//- (void)onRecvNewMessage:(NSString * _Nullable)message {
//    NSArray *messageListArray = [self parseJsonStr2Array:message];
//    [self pushEvent:@"onRecvNewMessage" errCode:@(0) errMsg:@"" data:messageListArray];
//}


- (void)onRecvOfflineNewMessage:(NSString * _Nullable)message {
    NSArray *messageListArray = [self parseJsonStr2Array:message];
    [self pushEvent:@"onRecvOfflineNewMessage" errCode:@(0) errMsg:@"" data:messageListArray];
}
- (void)onRecvOnlineOnlyMessage:(NSString * _Nullable)message {
    NSArray *messageListArray = [self parseJsonStr2Array:message];
    [self pushEvent:@"onRecvOnlineOnlyMessage" errCode:@(0) errMsg:@"" data:messageListArray];
}



// MARK: - Open_im_sdkOnFriendshipListener


- (void)onBlackAdded:(NSString * _Nullable)blackInfo {
    NSDictionary *blackInfoDict = [self parseJsonStr2Dict:blackInfo];
    [self pushEvent:@"onBlackAdded" errCode:@(0) errMsg:@"" data:blackInfoDict];
}

- (void)onBlackDeleted:(NSString * _Nullable)blackInfo {
    NSDictionary *blackInfoDict = [self parseJsonStr2Dict:blackInfo];
    [self pushEvent:@"onBlackDeleted" errCode:@(0) errMsg:@"" data:blackInfoDict];
}

- (void)onFriendAdded:(NSString * _Nullable)friendInfo {
    NSDictionary *friendInfoDict = [self parseJsonStr2Dict:friendInfo];
    [self pushEvent:@"onFriendAdded" errCode:@(0) errMsg:@"" data:friendInfoDict];
}

- (void)onFriendApplicationAccepted:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationAccepted" errCode:@(0) errMsg:@"" data:friendApplicationDict];
}

- (void)onFriendApplicationAdded:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationAdded" errCode:@(0) errMsg:@"" data:friendApplicationDict];
}

- (void)onFriendApplicationDeleted:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationDeleted" errCode:@(0) errMsg:@"" data:friendApplicationDict];
}

- (void)onFriendApplicationRejected:(NSString * _Nullable)friendApplication {
    NSDictionary *friendApplicationDict = [self parseJsonStr2Dict:friendApplication];
    [self pushEvent:@"onFriendApplicationRejected" errCode:@(0) errMsg:@"" data:friendApplicationDict];
}

- (void)onFriendDeleted:(NSString * _Nullable)friendInfo {
    NSDictionary *friendInfoDict = [self parseJsonStr2Dict:friendInfo];
    [self pushEvent:@"onFriendDeleted" errCode:@(0) errMsg:@"" data:friendInfoDict];
}

- (void)onFriendInfoChanged:(NSString * _Nullable)friendInfo {
    NSDictionary *friendInfoDict = [self parseJsonStr2Dict:friendInfo];
    [self pushEvent:@"onFriendInfoChanged" errCode:@(0) errMsg:@"" data:friendInfoDict];
}

// MARK: - Open_im_sdkOnConversationListener

- (void)onConversationChanged:(NSString* _Nullable)conversationList {
    NSArray *conversationListArray = [self parseJsonStr2Array:conversationList];
    [self pushEvent:@"onConversationChanged" errCode:@(0) errMsg:@"" data:conversationListArray];
}

- (void)onConversationUserInputStatusChanged:(NSString* _Nullable)conversationList {
    NSArray *conversationListArray = [self parseJsonStr2Array:conversationList];
    [self pushEvent:@"onConversationUserInputStatusChanged" errCode:@(0) errMsg:@"" data:conversationListArray];
}

- (void)onNewConversation:(NSString* _Nullable)conversationList {
    NSArray *conversationListArray = [self parseJsonStr2Array:conversationList];
    [self pushEvent:@"onNewConversation" errCode:@(0) errMsg:@"" data:conversationListArray];
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
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationAccepted" errCode:@(0) errMsg:@"" data:groupApplicationDict];
}

- (void)onGroupApplicationAdded:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationAdded" errCode:@(0) errMsg:@"" data:groupApplicationDict];
}

- (void)onGroupApplicationDeleted:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationDeleted" errCode:@(0) errMsg:@"" data:groupApplicationDict];
}

- (void)onGroupApplicationRejected:(NSString * _Nullable)groupApplication {
    NSDictionary *groupApplicationDict = [self parseJsonStr2Dict:groupApplication];
    [self pushEvent:@"onGroupApplicationRejected" errCode:@(0) errMsg:@"" data:groupApplicationDict];
}

- (void)onGroupInfoChanged:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onGroupInfoChanged" errCode:@(0) errMsg:@"" data:groupInfoDict];
}

- (void)onGroupMemberAdded:(NSString * _Nullable)groupMemberInfo {
    NSDictionary *groupMemberInfoDict = [self parseJsonStr2Dict:groupMemberInfo];
    [self pushEvent:@"onGroupMemberAdded" errCode:@(0) errMsg:@"" data:groupMemberInfoDict];
}

- (void)onGroupMemberDeleted:(NSString * _Nullable)groupMemberInfo {
    NSDictionary *groupMemberInfoDict = [self parseJsonStr2Dict:groupMemberInfo];
    [self pushEvent:@"onGroupMemberDeleted" errCode:@(0) errMsg:@"" data:groupMemberInfoDict];
}

- (void)onGroupMemberInfoChanged:(NSString * _Nullable)groupMemberInfo {
    NSDictionary *groupMemberInfoDict = [self parseJsonStr2Dict:groupMemberInfo];
    [self pushEvent:@"onGroupMemberInfoChanged" errCode:@(0) errMsg:@"" data:groupMemberInfoDict];
}

- (void)onJoinedGroupAdded:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onJoinedGroupAdded" errCode:@(0) errMsg:@"" data:groupInfoDict];
}

- (void)onJoinedGroupDeleted:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onJoinedGroupDeleted" errCode:@(0) errMsg:@"" data:groupInfoDict];
}

- (void)onGroupDismissed:(NSString * _Nullable)groupInfo {
    NSDictionary *groupInfoDict = [self parseJsonStr2Dict:groupInfo];
    [self pushEvent:@"onGroupDismissed" errCode:@(0) errMsg:@"" data:groupInfoDict];
}


// MARK: - Open_im_sdk_callbackOnSignalingListener

//  - (void)onInvitationCancelled:(NSString* _Nullable)invitationCancelledCallback{
//      [self pushEvent:@"onInvitationCancelled" errCode:@(0) errMsg:@"" data:invitationCancelledCallback];
//  }
//  - (void)onInvitationTimeout:(NSString* _Nullable)invitationTimeoutCallback{
//      [self pushEvent:@"onInvitationTimeout" errCode:@(0) errMsg:@"" data:invitationTimeoutCallback];
//  }
//  - (void)onInviteeAccepted:(NSString* _Nullable)inviteeAcceptedCallback{
//      [self pushEvent:@"onInviteeAccepted" errCode:@(0) errMsg:@"" data:inviteeAcceptedCallback];
//  }
//  - (void)onInviteeAcceptedByOtherDevice:(NSString* _Nullable)inviteeAcceptedCallback{
//      [self pushEvent:@"onInviteeAcceptedByOtherDevice" errCode:@(0) errMsg:@"" data:inviteeAcceptedCallback];
//  }
//  - (void)onInviteeRejected:(NSString* _Nullable)inviteeRejectedCallback{
//      [self pushEvent:@"onInviteeRejected" errCode:@(0) errMsg:@"" data:inviteeRejectedCallback];
//  }
//  - (void)onInviteeRejectedByOtherDevice:(NSString* _Nullable)inviteeRejectedCallback{
//      [self pushEvent:@"onInviteeRejectedByOtherDevice" errCode:@(0) errMsg:@"" data:inviteeRejectedCallback];
//  }
//  - (void)onReceiveNewInvitation:(NSString* _Nullable)receiveNewInvitationCallback{
//      [self pushEvent:@"onReceiveNewInvitation" errCode:@(0) errMsg:@"" data:receiveNewInvitationCallback];
//  }
//  - (void)onHangUp:(NSString* _Nullable)hangUpCallback{
//      [self pushEvent:@"onHangUp" errCode:@(0) errMsg:@"" data:hangUpCallback];
//  }

// - (void)onRoomParticipantConnected:(NSString * _Nullable)onRoomParticipantConnectedCallback {
    
// }
// - (void)onRoomParticipantDisconnected:(NSString * _Nullable)onRoomParticipantDisconnectedCallback {
// }

// MARK: - Open_im_sdk_callbackOnBatchMsgListener
    - (void)onReceiveNewMessages:(NSString* _Nullable)receiveNewMessagesCallback{
     [self pushEvent:@"onReceiveNewMessages" errCode:@(0) errMsg:@"" data:receiveNewMessagesCallback];
    }
    - (void)onReceiveOfflineNewMessages:(NSString* _Nullable)receiveOfflineNewMessages{
        [self pushEvent:@"onReceiveOfflineNewMessages" errCode:@(0) errMsg:@"" data:receiveOfflineNewMessages];
    }
    // MARK: - Open_im_sdk_callbackSetCustomBusinessListener
- (void)onRecvCustomBusinessMessage:(NSString* _Nullable)receiveCustomBusinessMessage{
        [self pushEvent:@"onRecvCustomBusinessMessage" errCode:@(0) errMsg:@"" data:receiveCustomBusinessMessage];
    }
@end
